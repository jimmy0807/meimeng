//
//  FetchH9SSAPRequest.swift
//  meim
//
//  Created by jimmy on 2017/8/4.
//
//

import UIKit

class FetchH9SSAPRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    var year_month : String = ""
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        params["user_id"] = profile.userID
        params["year_month"] = year_month
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "get_operate_plan_list", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        if let resultList = resultDict?["data"] as? [Int]
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchH9SSAP(year_month))
            for (index, params) in resultList.enumerated()
            {
                let ssap = BSCoreDataManager.current().insertEntity("CDH9SSAP") as! CDH9SSAP
                ssap.year_month = year_month
                ssap.day = (index + 1) as NSNumber
                ssap.sort_index = (index + 1) as NSNumber
                ssap.count = params as NSNumber
            }
            
            BSCoreDataManager.current().save()
        }
        
        self.finished?(dict)
    }
}
