//
//  FetchZongkongLiyuanRequest.swift
//  meim
//
//  Created by jimmy on 2017/6/21.
//
//

import UIKit


class FetchZongkongLiyuanRequest: ICRequest
{
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "control_list", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            if let resultList = resuntDict["data"] as? [NSDictionary]
            {
                BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllZongkongLiyuanPersons())
                
                for (index, params) in resultList.enumerated()
                {
                    let person = BSCoreDataManager.current().insertEntity("CDZongkongLiyuanPerson") as! CDZongkongLiyuanPerson
                    person.sort_index = index as NSNumber
                    person.name = params.stringValue(forKey: "name")
                    person.billed_time = params.stringValue(forKey: "billed_time")
                    person.leave_time = params.stringValue(forKey: "leave_time")
                    person.image_url = params.stringValue(forKey: "image_url")
                    person.mobile = params.stringValue(forKey: "mobile")
                    person.member_type = params.stringValue(forKey: "member_type")
                    person.time = params.stringValue(forKey: "time")
                    
                    if let items = params.arrayValue(forKey: "info") as? [NSDictionary]
                    {
                        for param in items
                        {
                            let item = BSCoreDataManager.current().insertEntity("CDZongkongLiyuanItem") as! CDZongkongLiyuanItem
                            item.person = person
                            item.title = param.stringValue(forKey: "title")
                            item.content = param.stringValue(forKey: "content")
                            item.time = param.stringValue(forKey: "time")
                        }
                    }
                }
                
                BSCoreDataManager.current().save()
                
                self.finished?(nil)
            }
        }
    }
}
