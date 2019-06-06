//
//  PersistentInkDeviceInfo.swift
//  meim
//
//  Created by 刘伟 on 2017/11/27.
//

import Foundation
import WILLDevices

//class PersistentInkDeviceInfo : InkDeviceInfo {
//
//}

extension InkDeviceInfo {
//    /// The friendly name of the device
//    @objc public var name: String
//
//    /// The connection ID for the device
//    @objc public var deviceID: String
//
//    /// The device type
//    @objc public var type: WILLDevices.DeviceType
//
//    /// The time the device was discovered
//    @objc public var discovered: Date
//
//    /// A human readable description of the discovered device
//    override public var description: String { get }
    
    public var DeviceName : String {
        get{
            return self.name
        }
        set{
            name = newValue
        }
    }
    
    
    
    
    
    
}
