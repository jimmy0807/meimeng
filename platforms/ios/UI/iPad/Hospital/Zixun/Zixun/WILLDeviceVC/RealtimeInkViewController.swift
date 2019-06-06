 //
//  RealtimeInkViewController.swift
//  WILLDevicesSample
//
//  Created by Joss Giffard-Burley on 17/07/2017.
//  Copyright © 2017 Wacom. All rights reserved.
//

import UIKit
import WILLDevices
import WILLDevicesCore
import WILLInk
import CoreBluetooth

class RealtimeInkViewController: ICCommonViewController,CBCentralManagerDelegate,canGoToRealTimeProtocol {
   
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    var inkStores = [InkStroke]()
    
    var bluetoothManager = CBCentralManager()
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
            
        case CBManagerState.poweredOn:
            print("蓝牙已打开")
        
        case CBManagerState.unauthorized:
            print("这个应用程序是无权使用蓝牙低功耗")
        case CBManagerState.poweredOff:
            print("蓝牙已关闭")
            dealBlueToothClose()
        default:
            print("中央管理器没有改变状态")
        }
    }
    
    func dealBlueToothClose() {
        
        if bezierPathArr.count > 0 {
            ///当前写了内容
            let alertVC : UIAlertController = UIAlertController.init(title: "连接丢失 保存当前进度？", message: "", preferredStyle: .alert)
            let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                
                let RealTimeButtonDidPressedNoti = Notification.Name.init(rawValue: "RealTimeButtonDidPressedNoti")

                NotificationCenter.default.post(name: RealTimeButtonDidPressedNoti, object: nil, userInfo: ["bezierPathArr":self.bezierPathArr])
                
                self.bezierPathArr.removeAll()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
                
            }
            alertVC.addAction(comfirmAction)
            self.present(alertVC, animated: true, completion: nil)
            
        }
        else {
            ///当前没写内容
            let noConnectmsg = CBMessageView.init(title: "连接丢失")
            noConnectmsg?.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
   
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        FileTransferManger.shared.willGoToRealTimeFlag = false
        PersisitentTool.shared.needJoinRealTimeMode = false
        
        guard let s = realtimeService else {
            print("realtimeService fal;se reitnr ")
            
            if hasReceiveCanGoToRealTimeNoti == false {
                
                self.navigationController?.popViewController(animated: true)
                return;
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("cancelButtonPressed asyncAfter")
                
                PersisitentTool.shared.joinDownLoadMode()
            }
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        
        print("cancelButtonPressed : \(hasReceiveCanGoToRealTimeNoti)")
        if hasReceiveCanGoToRealTimeNoti == false {
            FileTransferManger.shared.willGoToRealTimeFlag = false
            PersisitentTool.shared.needJoinRealTimeMode = false
            self.navigationController?.popViewController(animated: true)
            return;
        }
        //Stop service and dispose
       
        
        do {
            print("关闭实时模式")
            try s.end()
        } catch (let e) {
            //AppDelegate.postNotification("Error", bodyText: "Error closing ink serivce:\(e.localizedDescription)")
            print("关闭实时模式异常=\(e.localizedDescription)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("cancelButtonPressed asyncAfter")
            PersisitentTool.shared.joinDownLoadMode()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishedButtonPressed(_ sender: Any) {
        ///如果进入时还在转圈 这时候点了“完成”按钮 那么要看是否收到进入实时模式的通知
        if hasReceiveCanGoToRealTimeNoti == false {
            FileTransferManger.shared.willGoToRealTimeFlag = false
            PersisitentTool.shared.needJoinRealTimeMode = false
            return
        }
        else {
            
            FileTransferManger.shared.willGoToRealTimeFlag = false
            PersisitentTool.shared.needJoinRealTimeMode = false
            //Stop service and dispose
            guard let s = realtimeService else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            do {
                print("关闭实时模式")
                try s.end()
            } catch (let e) {
                //AppDelegate.postNotification("Error", bodyText: "Error closing ink serivce:\(e.localizedDescription)")
                print("关闭实时模式异常=\(e.localizedDescription)")
            }
            
            realtimeWriteFinished()
            bezierPathArr.removeAll()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                PersisitentTool.shared.joinDownLoadMode()
            }

        }
        
    }
    
    func realtimeWriteFinished() {
        
        print("realtimeWriteFinished")
        if bezierPathArr.count == 0 {
            //没写任何内容
            //let noWriteMsg = CBMessageView.init(title: "没有书写任何内容")
            //noWriteMsg?.show()
            
        } else {
            
            //let imgString = dealBezierPathArr(bezierPathArr: bezierPathArr)
            //发通知告诉zixunRightContentVC刷新CollectionView
            let RealTimeButtonDidPressedNoti = Notification.Name.init(rawValue: "RealTimeButtonDidPressedNoti")
            //imgString是"\(tag)"形式
            NotificationCenter.default.post(name: RealTimeButtonDidPressedNoti, object: nil, userInfo: ["bezierPathArr":self.bezierPathArr])
            
            
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func dealBezierPathArr(bezierPathArr:[UIBezierPath]) -> String{
       
        ///filetotalArr里面的文件数是累加的
        let cellImg = self.creatCellImage(bezierPathsArr: bezierPathArr)
        let tag:NSInteger = NSInteger(NSDate().timeIntervalSince1970)
        let url = URL(string: "\(tag)")
        //print("拆分结束后url = \(url)")
        SDWebImageManager.shared().saveImage(toCache: cellImg, for: url)
        
        ///把bezierPathArr里面的path转成Points数组存进UserDefault 因为UserDefault不支持UIbezierPath类型
        BezierPathManager.sharedInstance().saveBezierPathArr(toPointsStr2: bezierPathArr, andImgKey: "ink-\(tag)")
        
        ///保存图片creatDate
        UserDefaults.standard.set(self.dateConvertString(date: Date()), forKey: "imgCreatDate-\(tag)")
        UserDefaults.standard.synchronize()
        
        return "\(tag)"
       
    }
    func dateConvertString(date:Date) -> String {
        
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年MM月dd日"
        
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    func creatCellImage(bezierPathsArr : [UIBezierPath]) -> UIImage {
        
        ///绘制手写本内容: 因为这里下载的是大图尺寸 所以先画到一个UIImageView上 再缩放成小图添加到cell上
        let bigImageView:UIImageView = UIImageView.init(frame: CGRect.init(x: 270, y: 80, width: 490, height: 693))
        
        bigImageView.image = UIImage.init(named: "ink_moban2.jpg")
        
        ///把写字板里的笔迹放到UIView上
        if let sublayers = bigImageView.layer.sublayers {
            for l in sublayers {
                if l is CAShapeLayer {
                    l.removeFromSuperlayer()
                }
            }
        }
        //let currentBezierPathsArr = FileTransferManger.shared.filetotalArr[indexPath.row]
        for bezPath in bezierPathsArr {
            //LW新增 调整笔迹粗细
            bezPath.lineWidth = 6
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezPath.cgPath
            shapeLayer.position = CGPoint.zero
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            
            //LW新增 调整笔迹粗细
            shapeLayer.lineWidth = 6
            
            bigImageView.layer.addSublayer(shapeLayer)
            
        }
        
        ///UIView转UIImage
        UIGraphicsBeginImageContextWithOptions(bigImageView.bounds.size, false, 0.0 )
        bigImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return img
    }
    
    ///定义一个UIBezierPath数组保存实时模式下所有的path
    var bezierPathArr = [UIBezierPath]()
    
    //========================================================================================================
    // MARK: Properties
    //========================================================================================================
    
    /// The connected ink device
    var inkDevice: InkDevice?
    
    @IBOutlet weak var drawingView: UIView!
    
    var renderView: RenderingView!
    
    /// The realtime inking service provided by the device
    var realtimeService: RealTimeInkService?
    
    public var deviceWidth: CGFloat = 100.0
    public var deviceHeight: CGFloat = 100.0
    
    //used to work out if we need to rotate the device
    public var deviceType: DeviceType = .unknown
    
    /// is our input device a smart pad type?
    public var smartpadDevice = true
    
    /// The list of devices that have the sensor 90 to portrait
    private let rotatedDevices: [DeviceType] = [
        .bambooPro,
        .bambooSlateOrFolio
    ]
    
    //========================================================================================================
    // MARK: UIView Methods
    //========================================================================================================
    func startRealTimeMode() {
        //提示“点一下开始”
        let clickToStartView = ClickToStartView.loadNibNamed("ClickToStartView")
        let keyWindow = UIApplication.shared.keyWindow!
        clickToStartView?.frame = keyWindow.bounds
        //keyWindow.addSubview(clickToStartView!)
        
        if BSWILLManager.shared.connectingInkDevice != nil {
            
        }
        
        ///先关闭下载模式
        FileTransferManger.shared.stopDownload()
        
        ///设置一下头部
        self.headerView.layer.shadowOffset=CGSize.init(width: 0, height: 3)
        self.headerView.layer.shadowRadius=3;
        self.headerView.layer.shadowOpacity=0.1;
        self.headerView.layer.shadowColor=UIColor.black.cgColor
        
        ///必要参数
        inkDevice = BSWILLManager.shared.connectingInkDevice
        deviceWidth = 21000
        deviceHeight = 14800
        
        //print("self.inkDevice=\(self.inkDevice)")
        
        BSWILLManager.shared.connectingInkDevice?.buttonPressed = {() in
            print("实时模式情况下点击了按钮")
            
            self.realtimeWriteFinished()
            self.bezierPathArr.removeAll()

        }
   
    }
    
    func attemptToStartRealTimeService() {
        //Attempt to start the ink service
        do {
            try self.realtimeService = self.inkDevice?.getService(.realtimeInk) as? RealTimeInkService
            //print("实时模式realtimeService = \(self.inkDevice)")
            //print("实时模式realtimeService = \(self.realtimeService)")
            
        }
        catch (let e) {
            
            print("尝试开始实时模式Failed = \(e.localizedDescription)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.realtimeService = nil
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    ///延时隐藏转圈
    func delayHidden() {
        guard self.navigationController?.topViewController == self else
        {
            print("delayHidden return ")
            return;
        }
        print("delayHidden")
        joinRealTimeMode()
        startRealTimeService()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    ///判断是否接收到进入实时模式的通知
    var hasReceiveCanGoToRealTimeNoti : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        ///是否要进入实时模式通知
        //let canGoToRealTimeNotification = Notification.Name.init(rawValue: "canGoToRealTimeNotification")
        //self.registerNofitification(forMainThread: canGoToRealTimeNotification.rawValue)

        if BSWILLManager.shared.connectingInkDevice?.deviceStatus == .idle {
            
            FileTransferManger.shared.willGoToRealTimeFlag = true
            //转圈等待
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.view.bringSubview(toFront: self.headerView)
            
        } else {
            
        }
        finishButton.isEnabled = false
    }
    var noReceiveAnyNotiTimer = Timer()
    ///如果3s内未接收到canGoToRealTimeNoti  就自己调用下canGoToRealTimeNoti函数
    override func viewDidLoad() {
        
        //        noReceiveAnyNotiTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (t) in
        //            if !self.hasReceiveCanGoToRealTimeNoti {
        //                self.canGoToRealTimeNoti()
        //            }
        //        })
        
        //创建一个中央对象
        print("viewsssss:%@",self)
        //self.bluetoothManager = CBCentralManager(delegate: self, queue: nil)
        FileTransferManger.shared.delegate = self
  
    }
    
    func canGoToRealTime() {
        
        hasReceiveCanGoToRealTimeNoti = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delayHidden()
            self.finishButton.isEnabled = true
        }
        //self.perform(#selector(delayHidden), with: nil, afterDelay: 2)
        
        BSWILLManager.shared.connectingInkDevice?.buttonPressed = {() in
            print("实时界面buttonPressed")
            ///保存一下当前内容 换一张
            let RealTimeButtonDidPressedNoti = Notification.Name.init(rawValue: "RealTimeButtonDidPressedNoti")
            //imgString是"\(tag)"形式
            NotificationCenter.default.post(name: RealTimeButtonDidPressedNoti, object: nil, userInfo: ["bezierPathArr":self.bezierPathArr])
            
            self.bezierPathArr.removeAll()
            
            ///重新初始化renderView
            self.renderView.removeFromSuperview()
            
            self.joinRealTimeMode()
            
            self.startRealTimeService()
        }
        
    }
    
    func joinRealTimeMode() {
        setUpRealTimeParams()
        attemptToStartRealTimeService()
        
    }
    func setUpRealTimeParams() {
        ///先关闭下载模式
        //FileTransferManger.shared.stopDownload()
        
        ///必要参数
        self.inkDevice = BSWILLManager.shared.connectingInkDevice
        deviceWidth = 29700
        deviceHeight = 21000
    
    }
    
    
    ///解决给renderView设置图片尺寸问题
    func imageResize(img:UIImage , newSize:CGSize) -> UIImage {
        let scale : CGFloat = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        img.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage;
        
    }

    override func viewDidAppear(_ animated: Bool) {
//        if !PersisitentTool.shared.hasRetConnectedDevice {
//            let pleaseConnectMsg = CBMessageView.init(title: "请先连接设备")
//            pleaseConnectMsg?.show()
//            self.navigationController?.popViewController(animated: true)
//        }
        
        PersisitentTool.shared.needJoinRealTimeMode = true
      
    }
    
    func startRealTimeService() {
        //Start the realtime service
        renderView = RenderingView(frame: drawingView.bounds)
        //renderView.image = UIImage.init(named: "ink_moban2.jpg")!
        renderView.backgroundColor = UIColor.clear
        drawingView.addSubview(renderView)
        
        print("Render view bounds: \(NSStringFromCGRect(renderView.bounds))")
        do {
            print("viewsssss realtimeService:%@",self)
            realtimeService?.dataReceiver = self //Receive the point data
            let screenWidth = drawingView.bounds.size.width
            let screenHeight = drawingView.bounds.size.height
            if smartpadDevice {
                //For bamboo device, the data should be rotated
                if rotatedDevices.contains(deviceType) {
                    let xScale = screenWidth / deviceHeight
                    let yScale = screenHeight / deviceWidth
                    let scale = fmin(xScale, yScale) //So we have 1:1 scale
                    let rotationAngle = (-CGFloat.pi/2.0) + .pi
                    realtimeService?.transform = CGAffineTransform(scaleX: scale, y: scale).rotated(by: rotationAngle).concatenating(CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: fmin(screenWidth, screenHeight), ty: 0))
                } else {
                    
                    //                                        let xScale = screenWidth / deviceWidth
                    //                                        let yScale = screenHeight / deviceHeight
                    //                                        let scale = fmin(xScale, yScale) //So we have 1:1 scale
                    //
                    //                                        realtimeService?.transform = CGAffineTransform(scaleX: scale, y: scale)
                    
                    //  print("do....\(Thread.current)")
                    let xScale = screenWidth / deviceHeight
                    let yScale = screenHeight / deviceWidth
                    let scale = fmin(xScale, yScale) //So we have 1:1 scale
                    //  print("realtime - \(screenWidth)- \(screenHeight)")
                    //  print("realtime - \(deviceWidth)- \(deviceHeight)- \(scale)")
                    //realtime - 21600.0- 14800.0- 0.0320833333333333
                    let rotationAngle = (-CGFloat.pi/2.0) + .pi
                    realtimeService?.transform = CGAffineTransform(scaleX: scale, y: scale).rotated(by: rotationAngle).concatenating(CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: fmin(screenWidth, screenHeight), ty: 0))
                    
                }
                
            }
            else { //Set the UIView for input to be the rendering view
                realtimeService?.transform = CGAffineTransform.identity
                realtimeService?.inputView = drawingView
            }
            
            try realtimeService?.start(provideRawData: true)
            
            
        }
        catch (let e) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                //self?.navigationController?.popViewController(animated: true)
            }
        }
        //self.perform(#selector(self.test), with: self, afterDelay: 3)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          NotificationCenter.default.removeObserver(self)

    }

    deinit {
        print("yuyuiopp[")
    }
    
    //canGoToRealTimeNoti
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if notification.name.rawValue == "canGoToRealTimeNotification" {
            print("canGoToRealTimeNoti")
            
            
        }
    }
}

//========================================================================================================
// MARK: CDL Stroke Receiver
//========================================================================================================

extension RealtimeInkViewController: StrokeDataReceiver {
    
    func strokeBegan(penID: Data, inputDeviceType: ToolType, inkColor: UIColor, pathChunk: WCMFloatVector) {
        print("实时模式strokeBegan")
        renderView.addStrokePart(pathChunk, isEnd: false)
    }
    
    func strokeMoved(pathChunk: WCMFloatVector) {
        print("实时模式strokeMoved")
        renderView.addStrokePart(pathChunk, isEnd: false)
    }
    
    func strokeEnded(pathChunk: WCMFloatVector?, inkStroke: InkStroke, cancelled: Bool) {
        print("实时模式strokeEnded")
        renderView?.addStrokePart(pathChunk, isEnd: true)
        //LW新增
        //inkStroke.width = 3
        inkStores.append(inkStroke)
        //FileTransferManger.shared.downloadedDocuments.append(inkStroke as InkDocument)
        
        if let bez = inkStroke.bezierPath {
            print("inkStroke.bezierPath = \(inkStroke.width)")///手写笔起落会走一次这里
            //LW新增
            //bez.lineWidth = 3
            bezierPathArr.append(bez)
            //renderView.addStrokeBezier(bez)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bez.cgPath
            shapeLayer.position = CGPoint.zero
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            //shapeLayer.lineWidth = 6

            renderView.layer.addSublayer(shapeLayer)
        }
    }
    
    func hoverStrokeReceived(path: [RawPoint]) {
        print("实时模式(\(path.count) hover points received")
        //print("path = \(path)")
    }
    
    func pointsLost(count: Int) {
        print("** LOST \(count) points")
    }
    
    func newLayerAdded() {
        print("New layer")
    }
    
    
   
}

 
