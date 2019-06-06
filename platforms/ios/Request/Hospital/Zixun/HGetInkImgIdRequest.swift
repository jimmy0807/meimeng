//
//  HGetInkImgIdRequest.swift
//  meim
//
//  Created by 刘伟 on 2018/1/12.
//

//import Foundation


import UIKit

class HGetInkImgIdRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "medical_advisory_image_add", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        var resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        resultDict!["image_url"] = params["image_url"]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kHGetInkImgIdResponse), object: nil, userInfo:resultDict)
        
        self.finished?(dict)
        
        
        
//        print("------------------------------")
//        print(params["image_url"])
//        print("HGetInkImgIdRequest-finished = \(resultDict)")
//        print("------------------------------")
//
//        //保存imgID:
//        print("移入前的ID = \(UserDefaults.standard.object(forKey: "imgID-\(String(describing: params["image_url"]))"))")
//
//        UserDefaults.standard.set(resultDict!["data"], forKey: "imgID-\(params["image_url"])")
//            //.string(forKey: "imgID-\(willDeleteImgUrl)")
//        print("移入后syn前的ID = \(UserDefaults.standard.object(forKey: "imgID-\(String(describing: params["image_url"]))"))")
//
//        UserDefaults.standard.synchronize()
        
        /**
         ------------------------------
         Optional("http://devimg.we-erp.com/14125e822ae7c525f3f652c2be44e3dc")
         HGetInkImgIdRequest-finished = Optional([AnyHashable("errmsg"): , AnyHashable("data"): 5442, AnyHashable("errcode"): 0])
         ------------------------------
         */
        print(UserDefaults.standard)
        print("移入后的ID = \(UserDefaults.standard.object(forKey: "imgID-\(String(describing: params["image_url"]))"))")
    }
}

