//
//  BSWILLManager.swift
//  meim
//
//  Created by jimmy on 2017/10/29.
//

import UIKit
import WILLDevices
import WacomLicensing

class BSWILLManager: NSObject
{
    open static let shared: BSWILLManager = BSWILLManager()
    open var discoveredDevices = [InkDeviceInfo]()
    
    let inkWatcher = InkDeviceWatcher()
    var connectingInkDevice: InkDevice? {
        willSet{
            print("newValue = \(newValue)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in

                ///获取电池电量
                newValue?.deviceBatteryStateChanged = { (level, charging) in
                    print("willSet level = \(level) - charging = \(charging)")
                    let inkDevicePowerChangeNotiName = Notification.Name.init(rawValue: "inkDevicePowerChangeNotiName")
                    NotificationCenter.default.post(name: inkDevicePowerChangeNotiName, object: self, userInfo: ["level":level])
                }
            }
        }
        
        didSet {
            ///获取电池电量
            connectingInkDevice?.deviceBatteryStateChanged = { (level, charging) in
                print("BS level = \(level) - charging = \(charging)")
                let inkDevicePowerChangeNotiName = Notification.Name.init(rawValue: "inkDevicePowerChangeNotiName")
                NotificationCenter.default.post(name: inkDevicePowerChangeNotiName, object: self, userInfo: ["level":level])
            }
        }
    }
    
    let licenseString = "eyJhbGciOiJSUzUxMiJ9.eyJpc3MiOiJsbXMiLCJhdWQiOiJ3ZXMiLCJleHAiOjE1Nzc4MzY4MDAsImlhdCI6MTUwMTU4MDU4Nywic3ViIjoiV0lMTCIsInJpZ2h0cyI6WyJDRExfQUNDRVNTIiwiQ0RMX0xJVkVfU1RSRUFNSU5HIiwiQ0RMX1RISVJEUEFSVFlfUEVOUyJdLCJnaXZlbl9uYW1lIjoiV2lsbCAiLCJmYW1pbHlfbmFtZSI6IlRlc3QiLCJlbWFpbCI6ImRldmVsb3BlcnNAd2Fjb20uY29tIiwidHlwZSI6ImV2YWwiLCJsaWNfbmFtZSI6IldJTEwgRGV2aWNlcyBTYW1wbGUiLCJsaWNfdWlkIjoiZDhjMzE2MGE1ZDE1M2FmODA2MjU2ZmNiOWU4ODgwM2VjNWM2OGE0ODU0MmEwZGU2YjU3MGZiYTAyYmE4ODZlMSIsImFwcHNfaW9zIjpbIk5BIl19.CJJiYFVSl26xva1sMywCrCy1vQSIzhYam5Kks5JyTuGCp8aD6v4lXQ6Pci8A7moOCByiQFMF0z22Oa7XOQHm4lq_rfVxrl9IpyuRNyjPEQkUrLLVxpj0x-xmlhJ3xc3cTzyVk-VcA7ErxmVJfaYocYnFIiGvb9hdNvq2MH-LUGa8aXdF-4aKlWqqGuL_k8pKR3JuAHDZ3LJr0ioHkzuK-oA2FmVMDeg-VWdlvYG_LeuKyh45W4MC-IKmjkrTi9jFAj_pp2mi0aUU6bxV4XeNHGQP9zTUTTVZAiY5WNJIROdjDU6vOHhHM829bPhi5Lx_K5JXQ6CSsY4al0EDnUIxmA"

    typealias FindDeviceHandler = ([InkDeviceInfo]) -> Void
    var findDeviceHandler : FindDeviceHandler?

    var defaultDeviceID : String
    {
        set
        {
            //defaultDeviceID = newValue
            //print("链接成功拿到设备ID =\(newValue)")
            UserDefaults.standard.set(newValue, forKey: "CDLDefaultDeviceID")
            UserDefaults.standard.synchronize()
            
        }
        
        get
        {
            if let deviceID = UserDefaults.standard.string(forKey: "CDLDefaultDeviceID")
            {
                return deviceID;
            }
            
            return ""
        }
    }
    func Log(_ value: String) {
        print("[Log] " + value)
    }
    private override init()
    {
        super.init()

        do
        {
            try LicenseValidator.sharedInstance.initLicense(licenseString)
        }
        catch let e as LicenseValidationException {
            Log("License validation error: " + e.description)
        } catch let e as LicenseRuntimeError {
            Log("License runtime error: " + e.localizedDescription)
        } catch {
            Log("Unkown license error")
        }
        inkWatcher.delegate = self
    }
    
    open func startScan()
    {
        discoveredDevices = []
        connectingInkDevice = nil
        inkWatcher.reset()
        inkWatcher.start()
    }
    
    open func stopScan()
    {
        inkWatcher.stop()
    }
    
    open func searchDevice(result: @escaping FindDeviceHandler)
    {
        self.findDeviceHandler = result
    }
    
    open func connectDefaultDevice(finished : @escaping (Bool, String)->(Void))
    {
        print("connectDefaultDevice\(defaultDeviceID)")
        if defaultDeviceID.characters.count > 0
        {
            connectDevice(deviceID: defaultDeviceID, finished: finished)
        }
        else
        {
            finished(false, "")
        }
    }
    
    open func connectDevice(deviceID : String, finished : @escaping (Bool, String)->(Void))
    {
        let devices = discoveredDevices.filter{ $0.deviceID == deviceID }
        print("discoveredDevices = \(discoveredDevices)")//
        if devices.count > 0
        {
            connectDevice(deviceInfo: devices[0], finished: finished)
        }
    }
    
    open func connectDevice(deviceInfo info : InkDeviceInfo, finished : @escaping (Bool, String)->(Void))
    {
        
        do {
            inkWatcher.stop()
            discoveredDevices.removeAll()
            //com.born.boss.1251
            //CDLTestApp
            connectingInkDevice = try InkDeviceManager.connectToDevice(info, appID: "com.born.boss.1251", deviceStatusChangedHandler: { [weak self] (oldStatus, newStatus) -> (Void) in
                let message :String
                var connected :Bool = false
                
                print("newStatus=\(newStatus.description)")
                switch newStatus {
                case .notConnected, .busy:
                    PersisitentTool.shared.connect()
                    return
                case .idle:
                    message = "Device connected"
                    self?.connectingInkDevice?.deviceStatusChanged = nil
                    connected = true
                    self?.defaultDeviceID = info.deviceID
                    
                    ///持久化存储InkDeviceInfo的name deviceID
                    print("-----------InkDeviceInfo--------------")
                    print("name = \(info.name)")
                    print("deviceID = \(info.deviceID)")
                    print("type = \(info.type.rawValue)")
                    print("discovered = \(info.discovered)")
                    print("description = \(info.description)")
                    print("--------------------------------------")
                    
                    /**
                     
                     -----------InkDeviceInfo--------------
                     name = Bamboo Folio
                     deviceID = 1DFB12A9-1D1D-DEF4-8A83-054A5FE8B323
                     type = DeviceType
                     discovered = 2017-11-27 00:16:08 +0000
                     description = Device Name: Bamboo Folio Device ID: 1DFB12A9-1D1D-DEF4-8A83-054A5FE8B323 Type: Bamboo Slate or Folio Discovered: 2017-11-27 00:16:08 +0000
                     --------------------------------------
                     
                     */
                     ///持久化
                    UserDefaults.standard.set(info.name, forKey: "InkDeviceName")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(info.deviceID, forKey: "InkDevicedeviceID")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(info.discovered, forKey: "InkDeviceDiscovered")
                    UserDefaults.standard.synchronize()
                    
//                    UserDefaults.standard.set(info.type, forKey: "InkDevicetype")
//                    UserDefaults.standard.synchronize()
//                    UserDefaults.standard.set(info.discovered, forKey: "InkDevicediscovered")
//                    UserDefaults.standard.synchronize()
//                    UserDefaults.standard.set(info.description, forKey: "InkDevicedescription")
//                    UserDefaults.standard.synchronize()
                    
                    
                case .syncing:
                    message = "Device syncing"
                case .connecting:
                    message = "Device connecting"
                case .expectingButtonTapToConfirmConnection:
                    message = "Tap device button to confirm connection"
                case .expectingButtonTapToReconnect:
                    message = "Tap device button to reconnect"
                case .holdButtonToEnterUserConfirmationMode:
                    message = "Hold button to enter user confirmation mode"
                case .acknowledgeConnectionCofirmationTimeout:
                    message = "Tap device button to acknowledge user timeout"
                case .failedToConnect:
                    message = "Failed to connect to device. Restarting scan."
                    //self?.inkWatcher.start()
                case .failedToPair:
                    message = "Failed to pair to device. Restarting scan."
                    //self?.inkWatcher.start()
                case .failedToAuthorize:
                    message = "Failed to authorize device. Restarting scan."
                    //self?.inkWatcher.start()
                }
                print("链接结果=\(connected) -- \(message)")
                finished(connected, message)
            })
        }
        catch let e {
           
            ///点一下连接上了 判断是否要清UserDefault设备数据
            if needClickFlag {
                self.deleteUserDefaultInkDeviceData()
                self.showAlert()
                //inkDeviceDidReDisConnectedNotification
                let inkDeviceDidReDisConnectedNoti = Notification.Name.init(rawValue: "inkDeviceDidReDisConnectedNotification")
                NotificationCenter.default.post(name: inkDeviceDidReDisConnectedNoti, object: self, userInfo: nil)
                
                self.perform(#selector(reSetNeedClickFlag), with: nil, afterDelay: 7)
            }
            
            print("连接走到catch = \(e.localizedDescription)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                
                PersisitentTool.shared.connect()
                
//                let connectDeviceCatchNotiName = Notification.Name.init(rawValue: "connectDeviceCatchNotiName")
//                NotificationCenter.default.post(name: connectDeviceCatchNotiName, object: self, userInfo: nil)
                
            }
        }
    }
    
    func deleteUserDefaultInkDeviceData() {
        UserDefaults.standard.removeObject(forKey: "InkDeviceName")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "InkDevicedeviceID")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "InkDeviceDiscovered")
        UserDefaults.standard.synchronize()
    }
    
    func reSetNeedClickFlag() {
        needClickFlag = false
    }
    
    func showAlert() {
        let alertVC : UIAlertController = UIAlertController.init(title: "请重新配对", message: "您的设备可能被其他设备连接", preferredStyle: .alert)
        let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            
        }
        alertVC.addAction(comfirmAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
        
        //self.present(alertVC, animated: true, completion: nil)
    }
    
    /// Updates the ink device on the rootVC
    func updateInkDevice() {
        if connectingInkDevice != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                ///把当前连接的设备传出去
//                self?.rootVC?.currentInkDevice = self?.connectingInkDevice
//                self?.navigationController?.popToRootViewController(animated: true)
                
            }
        }
    }
 
}

extension BSWILLManager: InkDeviceWatcherDelegate
{
    /// A new `InkDevice` was detected by the ink watcher
    ///
    /// - Parameters:
    ///   - watcher: The watcher that detected the device
    ///   - device: The device info that discovered
    func deviceAdded(_ watcher: InkDeviceWatcher, device: InkDeviceInfo)
    {
        //print("device=\(device)") //长按手写本才有
        discoveredDevices.append(device)
        self.findDeviceHandler?(discoveredDevices)
    }
    
    /// A previously discovered device has been disconnected.
    ///
    /// - Parameters:
    ///   - watcher: The watcher that dected the device
    ///   - device: The device that was discovered
    func deviceRemoved(_ watcher: InkDeviceWatcher, device: InkDeviceInfo)
    {
        discoveredDevices = discoveredDevices.filter { $0 != device }
        self.findDeviceHandler?(discoveredDevices)
    }
}



