//
//  BingfangApplyCheckOutRequest.swift
//  meim
//
//  Created by 波恩公司 on 2018/5/7.
//

import UIKit

class BingfangApplyCheckOutRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "apply_hospitalized_check_out", params: [params])
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        self.finished?(dict)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ApplyCheckOutResponse"), object: nil, userInfo:resultDict)
    }
}

