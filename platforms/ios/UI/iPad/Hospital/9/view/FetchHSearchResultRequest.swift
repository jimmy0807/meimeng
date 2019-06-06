//
//  FetchHSearchResultRequest.swift
//  meim
//
//  Created by 波恩公司 on 2017/9/25.
//
//

import UIKit

class FetchHSearchResultRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]

    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        params["user_id"] = profile.userID
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "filter_medical_operate_line", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        if let resultList = resultDict?["data"] as? [NSDictionary]
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchH9SSAPSearchResult())
            for (index, params) in resultList.enumerated()
            {
                let fr = BSCoreDataManager.current().insertEntity("CDHFetchResult") as! CDHFetchResult
                fr.shoushu_id = params.numberValue(forKey: "id")
                fr.note = params.stringValue(forKey: "note")
                fr.operate_date = params.stringValue(forKey: "operate_date")
                fr.operate_name = params.stringValue(forKey: "operate_name")
                fr.state = params.stringValue(forKey: "state")
                fr.state_name = params.stringValue(forKey: "state_name")
            }
            
            BSCoreDataManager.current().save()
        }
        
        self.finished?(dict)
    }
}
