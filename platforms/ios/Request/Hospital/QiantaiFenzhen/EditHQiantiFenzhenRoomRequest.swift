//
//  EditHQiantiFenzhenRoomRequest.swift
//  meim
//
//  Created by jimmy on 2017/6/5.
//
//

import UIKit

class EditHQiantiFenzhenRoomRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "fenzhen_update", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kEditZixunRoomResponse), object: nil, userInfo:dict)
    }
}
