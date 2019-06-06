//
//  ApplicationPemissionManager.swift
//  ExandsMaintenance
//
//  Created by jimmy on 16/10/23.
//  Copyright © 2016年 Vintest. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ApplicationPemissionManager: NSObject
{
    open static func cameraEnable() -> Bool
    {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
       
        if status == .denied || status == .restricted
        {
            showAlert("应用无法访问您的相机\n请在设置里开启")
            return false
        }
        
        return true
    }
    
    open static func photoLibraryEnable() -> Bool
    {
        let status:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        if status == .denied || status == .restricted
        {
            showAlert("应用无法访问你的相册\n请在设置里开启")
            return false
        }
        
        return true
    }
    
    private static func showAlert(_ message: String)
    {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "立即开启", style: .default, handler: { (action) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true
            , completion: nil)
    }
}
