//
//  PersisitentTool.swift
//  meim
//
//  Created by 波恩公司 on 2017/11/24.
//

import Foundation
import WILLDevices

class PersisitentTool : NSObject {
    
    open static let shared: PersisitentTool = PersisitentTool()
    ///进入实时模式标志 默认进下载模式
    var needJoinRealTimeMode : Bool = false

    func connect() {
        //并且持久化的设备名字不能为空 才自动连接设备
        let InkDeviceName = UserDefaults.standard.string(forKey: "InkDeviceName")
        
        ///TODO :调试连接
//        let alertVC : UIAlertController = UIAlertController.init(title: InkDeviceName, message: "", preferredStyle: .alert)
//        let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
//
//
//
//        }
//        alertVC.addAction(comfirmAction)
//        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
        
        
        if InkDeviceName != nil {
            print("hasRetConnectedDevice = \(hasRetConnectedDevice.description)")
            ///test
            
           
            
            if !hasRetConnectedDevice {
                print("connect...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.connectDefaultDevice()
                }
            }
            
        }
    }
    var persistentInkDeviceInfo = InkDeviceInfo()
    ///是否连接了设备标志
    var hasRetConnectedDevice : Bool = false

    func connectDefaultDevice()  {
        print("connectDefaultDevice")
        ///获取持久化的数据 只需要保存name 和id 即可
        let InkDeviceName = UserDefaults.standard.string(forKey: "InkDeviceName")
        let InkDevicedeviceID = UserDefaults.standard.string(forKey: "InkDevicedeviceID")
        let InkDeviceDiscovered = UserDefaults.standard.object(forKey: "InkDeviceDiscovered")
        
        if InkDeviceName != nil {
            persistentInkDeviceInfo.name = InkDeviceName!
            persistentInkDeviceInfo.deviceID = InkDevicedeviceID!
            persistentInkDeviceInfo.type = DeviceType.bambooSlateOrFolio
            //persistentInkDeviceInfo.discovered = InkDeviceDiscovered as! Date
            persistentInkDeviceInfo.discovered = Date()
            
            //print("persistentInkDeviceInfo = \(InkDeviceName)")
            //print("persistentInkDeviceInfo = \(InkDevicedeviceID)")
            //print("persistentInkDeviceInfo = \(InkDeviceDiscovered)")
            //print("Date() = \(Date())")
        }
        
        BSWILLManager.shared.connectDevice(deviceInfo: persistentInkDeviceInfo) { (ret, message) -> (Void) in
            print("用persistentInkDeviceInfo连接 ret = \(ret) -- msg = \(message)")
            
            ///TODO : 调试连接
//        let alertVC : UIAlertController = UIAlertController.init(title: message, message: "", preferredStyle: .alert)
//        let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
//
//
//
//        }
//        alertVC.addAction(comfirmAction)
//        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
            
            self.hasRetConnectedDevice = false;
            
            if message == "Device connecting" {
                
            }
            else if message == "Tap device button to confirm connection" {
                
            }
            else if message == "Failed to connect to device. Restarting scan." {
                
            }
            else if message == "Device connected" {
                
                isInkDeviceConnected = true
                print("Device connected")
                
                ///已经重新连接已有设备了标志 避免反复重连
                self.hasRetConnectedDevice = true
                
                let inkDeviceHasConnectedNotiName = Notification.Name.init(rawValue: "inkDeviceHasConnectedNotiName")
                NotificationCenter.default.post(name: inkDeviceHasConnectedNotiName, object: self, userInfo: nil)
                
                
                if self.needJoinRealTimeMode == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                        
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: FileTransferManger.canGoToRealTimeNotification), object: self, userInfo: nil)
                        }
                    }
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                        if (self?.hasRetConnectedDevice)! {
                            
                            self?.joinDownLoadMode()
                        BSWILLManager.shared.connectingInkDevice?.deviceStatusChanged = { status in
                                self?.joinDownLoadMode()
                            }
                            
                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    BSWILLManager.shared.connectingInkDevice?.deviceStatusChanged = { status in
                        if self.needJoinRealTimeMode == true {
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: FileTransferManger.canGoToRealTimeNotification), object: self, userInfo: nil)
                            }
                        }
                        else
                        {
                            if (self.hasRetConnectedDevice) {
                                self.joinDownLoadMode()
                            }
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                        ///获取电池电量
                        BSWILLManager.shared.connectingInkDevice?.deviceBatteryStateChanged = { (level, charging) in
                            print(" persistent level = \(level) - charging = \(charging)")
                            ///level : Int
                            let inkDevicePowerChangeNotiName = Notification.Name.init(rawValue: "inkDevicePowerChangeNotiName")
                            NotificationCenter.default.post(name: inkDevicePowerChangeNotiName, object: self, userInfo: ["level":level])
                        }
                    }
                }
            }
        }
    }
    
    func joinDownLoadMode() {
        print("joinDownLoadMode158")
        self.setUpInkDownloadParams()
        
        FileTransferManger.shared.downloadFinished =  { (isfinished,currentBezierpathArr) -> () in
            
            print("下载完成了吗=\(isfinished)")

            if isfinished {
                
                //下载到离线区
                InkFileManager.shared.saveDownLoadOffLineImage(bezierPathArr: currentBezierpathArr)

            }
            
        }
        
    }
    func setUpInkDownloadParams() {
        ///设置下载功能的必要参数
        FileTransferManger.shared.inkDevice = BSWILLManager.shared.connectingInkDevice
        FileTransferManger.shared.deviceWidth = 29700
        FileTransferManger.shared.deviceHeight = 21000
        FileTransferManger.shared.hasDevice()
        FileTransferManger.shared.startDownload(tileSize: 490)
    }
    
    func setUpRealTimeParams() {
        ///先关闭下载模式
        FileTransferManger.shared.stopDownload()
//        ///必要参数
//        RealtimeInkViewController.shared.inkDevice = BSWILLManager.shared.connectingInkDevice
//        RealtimeInkViewController.shared.deviceWidth = 21600
//        RealtimeInkViewController.shared.deviceHeight = 14800
    }
    
    func joinRealTimeMode() {
        print("joinRealTimeMode")
        setUpRealTimeParams()
        //RealtimeInkViewController.shared.attemptToStartRealTimeService()    
    }
}
