//
//  FileTransferManger.swift
//  WILLDevicesSample
//
//  Created by 波恩公司 on 2017/11/16.
//  Copyright © 2017年 Wacom. All rights reserved.
//

import Foundation
import WILLDevices
import WILLDevicesCore
import WILLInk

//关闭进程需要按一下 如果用户按了 连接上了 那么needClickFlag置true
//然后如果在catch判断needClickFlag 如果是true就清空Userdefault
var needClickFlag : Bool = false


class FileTransferManger: NSObject {
    
    open static let shared: FileTransferManger = FileTransferManger()
    open static let canGoToRealTimeNotification = "canGoToRealTimeNotification"
    open static let inkDeviceDidReconnectedNotification = "inkDeviceDidReconnectedNotification"
    /// The list of downloaded documents from the device
    var downloadedDocuments = [InkDocument]()
    
    /// The connected ink device
    weak var inkDevice: InkDevice?
    
    /// The file transfer service provided by the device
    var fileService: FileTranserService?
    
    ///给个默认值
    public var deviceWidth: CGFloat = 100.0
    public var deviceHeight: CGFloat = 100.0
    
    /// Background download queue
    let downloadQueue = DispatchQueue(label: "download")
    
    /// Flag to stop spamming when we are polling for files 当我们轮询文件时，标记停止垃圾邮件
    internal var showFinishedPrompt = true
    
    /// Flag to see if we should be polling for new files
    internal var pollForNewFiles = true
    
    /// Should we rotate the recevied files to match orientation 我们是否应该旋转接收的文件以匹配方向
    internal var shouldRotateImages = true
    
    ///下载完成闭包回调
    typealias DownloadFinished = (Bool,[UIBezierPath]) ->()
    
    var downloadFinished : DownloadFinished?
    
    ///当前写的这次路径
    var currentBezierPathArr = [UIBezierPath]()
    
    ///设备中的文件数
    var filetotalArr = [[UIBezierPath]]()
    
    ///是否打开的是一个新咨询单 拦截一进咨询界面就开始下载以往设备里的图片 必须是确认下载了才保存
    var startNewZixunDan : Bool = false
    
    ///下载完成闭包回调
    typealias NewReciveInkFile = (String) ->()
    
    var newReciveInkFile : NewReciveInkFile?
    
    //TODO TEST 当前写的这次路径的rawPoints
    var currentRawPoints = [[RawPoint]]()
    
    public var willGoToRealTimeFlag : Bool = false
    
    public var fileDownloadingFlag : Bool = false
    
    override init() {
        
    }
    
    open func hasDevice(){
        ///验证设备是否连接 创建fileService
        if inkDevice == nil || (inkDevice?.deviceStatus ?? .notConnected) == .notConnected {
            //AppDelegate.postNotification("Error", bodyText: "InkDevice not connected")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.fileService = nil
                //self.navigationController?.popViewController(animated: true)
            }
        }
        //Attempt to start the ink service
        do {
            //print("self.fileService = \(self.fileService)")
            try self.fileService = self.inkDevice?.getService(.fileTransfer) as? FileTranserService
            //print("self.fileService2 = \(self.fileService)")

            
        } catch (let e) {
            //AppDelegate.postNotification("Error", bodyText: "Failed to start file transferservice:\(e.localizedDescription)")
            print("获取下载服务失败=\(e.localizedDescription)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //self.fileService = nil
                //self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    open func startDownload(tileSize:CGFloat){

        let tileSize = tileSize
        pollForNewFiles = true
        print("data Reciver = \(self.fileService?.dataReceiver)")
//        if self.fileService?.dataReceiver != nil {
//            return
//        }
        downloadQueue.async {
            do {
                
                self.fileService?.dataReceiver = self as FileDataReceiver //Receive the point data
                //Set the scale to match the render tile size.//设置比例以匹配渲染图块大小。
                let xScale = 490.0 / self.deviceHeight
                let yScale = 693.0 / self.deviceWidth
                let scale = fmin(xScale, yScale) //So we have 1:1 scale
                print("FileTransfer -\(tileSize)- \(self.deviceWidth)- \(self.deviceHeight)- \(scale)")
                //FileTransfer -484.0- 21600.0- 14800.0- 0.0224074074074074
                if self.shouldRotateImages {
                    let rotationAngle = (-CGFloat.pi/2.0) + .pi
                    self.fileService?.transform = CGAffineTransform(scaleX: scale, y: scale).rotated(by: rotationAngle).concatenating(CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: tileSize, ty: 0))
                } else {
                    self.fileService?.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
                
                try self.fileService?.start(provideRawData: true)
                
            } catch (let e) {
                print("设置FileDataReceiver失败=\(e.localizedDescription)")
                //The device is currently disconected
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ///这里可以知道设备电源关闭了 发一个通知告诉当前VC设备关闭
                    let setUpFileDataReceiverFaildNotiName = Notification.Name.init(rawValue: "setUpFileDataReceiverFaildNotiName")
                    NotificationCenter.default.post(name: setUpFileDataReceiverFaildNotiName, object: self, userInfo: nil)
                }
            }
        }
        //AppDelegate.postNotification("Starting file download", bodyText: "Getting files from device")
    }
    
    open func stopDownload(){
        //Stop service and dispose
        guard let s = fileService else {
            return
        }
        pollForNewFiles = false
        do {
            print("关闭下载模式")
            try s.end()
        } catch (let e) {
            //AppDelegate.postNotification("Error", bodyText: "Error closing ink serivce:\(e.localizedDescription)")
            print("关闭下载模式异常=\(e.localizedDescription)")
        }
    }
    
    func showMessage() {
        ///进入下载 显示MBProgressHUD表示当前正在下载
        //MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        
    }
    
    func hiddenMessage() {
        ///没有更多文件，关闭progressView
        //MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
    }
    
    
    var delegate : canGoToRealTimeProtocol?

}
///能进入实时模式的协议
protocol canGoToRealTimeProtocol {
    func canGoToRealTime()
}

//========================================================================================================
// MARK: File data delegate
//========================================================================================================

///在下载中或者实时模式以外 如果定时器5s未被停止掉 说明没有走这里 也就说明断开了连接
//        if !willGoToRealTimeFlag
//        {
//            isDeviceClosedTimer.invalidate()
//            isDeviceClosedTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (t) in
//                let connectDeviceCatchNotiName = Notification.Name.init(rawValue: "connectDeviceCatchNotiName")
//                NotificationCenter.default.post(name: connectDeviceCatchNotiName, object: self, userInfo: nil)
//            })
//        }

var isDeviceClosedTimer = Timer();

extension FileTransferManger: FileDataReceiver {
    
    func noMoreFiles() {

        
        if isInkDeviceConnected == false {
            //按一下连接成功
            isInkDeviceConnected = true
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: FileTransferManger.inkDeviceDidReconnectedNotification), object: self, userInfo: nil)
        }
        
        print("noMoreFiles FileTransferManger: " + "\(willGoToRealTimeFlag)")
        if showFinishedPrompt {
            //AppDelegate.postNotification("Complete", bodyText: "No more files to download from smartpad")
            print("No more files to download from smartpad")
            //连接上了并且没有文件待下载一定走这里
            fileDownloadingFlag = false
        }
        
        showFinishedPrompt = false
        try? fileService?.end()
        
        if willGoToRealTimeFlag
        {
            print("willGoToRealTimeFlag")
            
            DispatchQueue.main.async {
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: FileTransferManger.canGoToRealTimeNotification), object: self, userInfo: nil)
                self.delegate?.canGoToRealTime()
            }
        }
        else
        {
            downloadQueue.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                guard let s = self?.fileService else {
                    return
                }
                
                //If the service isn't started, start it
                DispatchQueue.main.async {
                    //if (self?.pollForNewFiles ?? false) {
                        if let flag = self?.willGoToRealTimeFlag, flag
                        {
                            print("FileTRANS if true")
                            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: FileTransferManger.canGoToRealTimeNotification), object: self, userInfo: nil)
                            self?.delegate?.canGoToRealTime()
                        }
                        else
                        {
                            print("FileTRANS if false")
                            try? s.start(provideRawData: true)
                        }
                    //}
                }
            }
        }
    }
    
    func receiveFile(fileData: InkDocument) -> FileDataReceiverStatus {
        fileDownloadingFlag = true
        //self.perform(#selector(showMessage), on: Thread.main, with: self, waitUntilDone: true)
        //Add the document to our list and update the collection view
        var documentIterator = fileData.getRoot().makeIterator()
        while documentIterator.hasNext() {
            guard let node = documentIterator.next() else {
                print("Error getting next node on document iterator!")
                break
            }
            
            if node is InkStroke, let bezPath = (node as! InkStroke).bezierPath {
                //let rawP = (node as! InkStroke).rawPoints
                //print((node as! InkStroke).blendMode.rawValue)//0
                //print("原始receiveFile\(bezPath.lineWidth,bezPath.lineCapStyle,bezPath.lineJoinStyle)")
               currentBezierPathArr.append(bezPath)
                
               //TODO TEST
               //currentRawPoints.append((node as! InkStroke).rawPoints!)
            }
        }
        
//        currentBezierPathArr表示一个文件下载好了回调出去
//        filetotalArr.append(currentBezierPathArr)
//        currentBezierPathArr.removeAll()//清空一下 避免下一张重复上一张里的笔迹
        
//        TODO TEST : RawPoints无法保存到UserDefaults
//        UserDefaults.standard.set(currentRawPoints, forKey: "RawPoints")
//        UserDefaults.standard.synchronize()
//        print(currentRawPoints)
    
        
        DispatchQueue.main.async {
            self.showFinishedPrompt = true
            print("New file received from device～～")
      
            self.downloadFinished!(true, self.currentBezierPathArr)
            self.currentBezierPathArr.removeAll()
            if self.newReciveInkFile != nil {
                self.newReciveInkFile!("New file received from device")

            }
        }
        
        ///下载完成
        //self.perform(#selector(hiddenMessage), on: Thread.main, with: self, waitUntilDone: true)
        
        //We return file saved. This causes the file to be deleted from the device
        return .fileSaved
    }
    
    func errorWhileDownloadingFile(_ error: Error) {
        print("Error during download:\(error.localizedDescription)")
    }
}
