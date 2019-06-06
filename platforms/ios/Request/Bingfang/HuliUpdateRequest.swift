//
//  HuliUpdateRequest.swift
//  meim
//
//  Created by 波恩公司 on 2018/5/4.
//

import UIKit

class HuliUpdateRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "huli_update", params: [params])
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        self.finished?(dict)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"HuliUpdateResponse"), object: nil, userInfo:resultDict)
    }
}
