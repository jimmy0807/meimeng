//
//  FetchZongkongDoctorRequest.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/9.
//

import UIKit

class FetchZongkongDoctorRequest: ICRequest
{
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "fenzhen_doctors", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            if let resultList = resuntDict["data"] as? [NSDictionary]
            {
                BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllDoctorPerson())
                
                for (index, params) in resultList.enumerated()
                {
                    let person = BSCoreDataManager.current().insertEntity("CDZongkongDoctorPerson") as! CDZongkongDoctorPerson
                    person.sort_index = index as NSNumber
                    person.doctor_id = params.numberValue(forKey: "id")
                    person.name = params.stringValue(forKey: "name")
                    person.image_url = params.stringValue(forKey: "image_url")
                    person.waiting_cnt = params.numberValue(forKey: "waiting_cnt")
                    person.waiting_name = params.stringValue(forKey: "waiting_name")
                    person.doing_cnt = params.numberValue(forKey: "doing_cnt")
                    person.state_name = params.stringValue(forKey: "state_name")
                    person.start_date = params.stringValue(forKey: "start_date")
                    person.member_name = params.stringValue(forKey: "member_name")
                    person.designer_name = params.stringValue(forKey: "designer_name")

                }
                
                BSCoreDataManager.current().save()
                
                self.finished?(nil)
            }
        }
    }
}
