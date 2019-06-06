//
//  ZixunAddRequest.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/27.
//

import UIKit

class ZixunAddRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "zhixun_add", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kAddZixunRoomResponse), object: nil, userInfo:resultDict)
    }
}

