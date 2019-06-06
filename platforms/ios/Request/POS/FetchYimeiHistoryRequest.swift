//
//  FetchYimeiHistoryRequest.swift
//  meim
//
//  Created by jimmy on 2017/6/28.
//
//

import UIKit

class FetchYimeiHistoryRequest: ICRequest
{
    var keyword : String = ""
    var searchResult = NSMutableOrderedSet()
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        if keyword.characters.count > 0
        {
            params["keyword"] = keyword;
        }
        
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "pos_history_operate_list", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        if keyword.characters.count == 0
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchYimeiHistory(byKeyword: nil))
        }

        if let resultList = resultDict?["data"] as? [NSDictionary]
        {
            for (index, params) in resultList.enumerated()
            {
                let h = BSCoreDataManager.current().uniqueEntity(forName: "CDYimeiHistory", withValue: params.numberValue(forKey: "id"), forKey: "operate_id") as! CDYimeiHistory
                h.amount = params.stringValue(forKey: "amount")
                h.create_date = params.stringValue(forKey: "create_date")
                h.operate_id = params.numberValue(forKey: "id")
                h.state = params.stringValue(forKey: "state")
                h.member_id = params.numberValue(forKey: "member_id")
                h.name = params.stringValue(forKey: "name")
                h.member_name = params.stringValue(forKey: "member_name")
                h.is_checkout = params.numberValue(forKey: "is_checkout")
                h.is_post_checkout = params.numberValue(forKey: "is_post_checkout")
                h.nameLetter = ChineseToPinyin.pinyin(fromChiniseString: h.member_name!)
                h.nameFirstLetter = ChineseToPinyin.pinyinFirstLetterString(h.member_name!).uppercased()
                h.sort_index = index as NSNumber
                
                if keyword.characters.count > 0
                {
                    searchResult.add(h)
                }
            }
            
            BSCoreDataManager.current().save()
        }
        
        self.finished?(dict)
    }
}
