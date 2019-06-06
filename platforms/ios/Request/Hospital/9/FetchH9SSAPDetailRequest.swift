//
//  FetchH9SSAPDetailRequest.swift
//  meim
//
//  Created by jimmy on 2017/8/7.
//
//

import UIKit

class FetchH9SSAPDetailRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    var year_month_day : String = ""
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        params["user_id"] = profile.userID
        params["year_month_day"] = year_month_day
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "get_operate_plan_detail", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        if let resultList = resultDict?["data"] as? [NSDictionary]
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchH9SSAPDetail(year_month_day))
            for (index, params) in resultList.enumerated()
            {
                let ssap = BSCoreDataManager.current().insertEntity("CDH9SSAPEvent") as! CDH9SSAPEvent
                ssap.year_month_day = year_month_day
                ssap.product_id = params.numberValue(forKey: "product_id")
                ssap.note = params.stringValue(forKey: "note")
                ssap.operate_time = params.stringValue(forKey: "operate_time")
                ssap.operate_id = params.numberValue(forKey: "operate_id")
                ssap.operate_line_id = params.numberValue(forKey: "operate_line_id")
                ssap.member_id = params.numberValue(forKey: "member_id")
                ssap.product_name = params.stringValue(forKey: "product_name")
                ssap.state = params.stringValue(forKey: "state")
                ssap.state_name = params.stringValue(forKey: "state_name")
                ssap.sort_index = (index + 1) as NSNumber
            }
            
            BSCoreDataManager.current().save()
        }
        
        self.finished?(dict)
    }
}
