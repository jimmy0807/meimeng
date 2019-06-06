//
//  FetchH9NotifyRequest.swift
//  meim
//
//  Created by jimmy on 2017/8/4.
//
//

import UIKit

class FetchH9NotifyRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "get_medical_events", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        if let resultList = resultDict?["data"] as? [NSDictionary]
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchH9Notify(nil))
            for (index, params) in resultList.enumerated()
            {
                let notify = BSCoreDataManager.current().insertEntity("CDH9Notify") as! CDH9Notify
                notify.notify_id = params.numberValue(forKey: "id")
                notify.doctor_id = params.numberValue(forKey: "doctor_id")
                notify.member_id = params.numberValue(forKey: "member_id")
                notify.user_id = params.numberValue(forKey: "user_id")
                notify.name = params.stringValue(forKey: "name")
                notify.planning_time = params.stringValue(forKey: "planning_time")
                notify.state = params.stringValue(forKey: "state")
                notify.state_name = params.stringValue(forKey: "state_name")
                notify.title = params.stringValue(forKey: "title")
                
                notify.sort_index = index as NSNumber
            }
            BSCoreDataManager.current().save()
        }
        
        self.finished?(dict)
    }
}
