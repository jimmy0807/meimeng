//
//  HZixunHouqigenjinRequest.swift
//  meim
//
//  Created by jimmy on 2017/6/22.
//
//

import UIKit

class HZixunHouqigenjinRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "zhixun_visit", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kHZixunHouqigenjinResponse), object: nil, userInfo:dict)
        
        self.finished?(dict)
    }
}
