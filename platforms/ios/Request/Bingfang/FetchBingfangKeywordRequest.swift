//
//  FetchBingfangKeywordRequest.swift
//  meim
//
//  Created by 波恩公司 on 2018/5/14.
//

import UIKit

class FetchBingfangKeywordRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "hospitalized_list", params: [params])
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllBingfangBook())
            
            if let resultList = resuntDict["data"] as? [NSDictionary]
            {
                for (index, params) in resultList.enumerated()
                {
                    let book = BSCoreDataManager.current().insertEntity("CDBingFangBook") as! CDBingFangBook
                    book.book_id = params.numberValue(forKey: "id")
                    book.image_url = params.stringValue(forKey: "image_url")
                    book.name = params.stringValue(forKey: "member_name")
                    book.member_type = params.stringValue(forKey: "member_type")
                    book.create_date = params.stringValue(forKey: "create_date")
                    book.start_date = params.stringValue(forKey: "check_in_date")
                    book.state = params.stringValue(forKey: "state")
                    book.member_id = params.numberValue(forKey: "member_id")
                    book.create_uid_name = params.stringValue(forKey: "create_uid_name")
                    book.queue_no = params.stringValue(forKey: "queue_no")
                    book.queue_no_name = params.stringValue(forKey: "queue_no_name")
                    book.nameLetter = ChineseToPinyin.pinyin(fromChiniseString: book.name!)
                    book.operate_id = params.numberValue(forKey: "operate_id")
                    book.nameFirstLetter = ChineseToPinyin.pinyinFirstLetterString(book.name!).uppercased()
                    book.consume_date = params.stringValue(forKey: "consume_date")
                    book.director_id = params.numberValue(forKey: "director_id")
                    book.doctor_name = params.stringValue(forKey: "doctors_name")
                    book.doctor_id = params.numberValue(forKey: "doctors_id")
                    book.nurse_name = params.stringValue(forKey: "nurse_name")
                    book.nurse_id = params.numberValue(forKey: "nurse_id")
                    book.nursing_level = params.stringValue(forKey: "nursing_level")
                    book.doctors_note = params.stringValue(forKey: "doctors_note")
                    book.designer_name = params.stringValue(forKey: "designer_director_name_name")
                    book.designer_id = params.numberValue(forKey: "designer_id")
                    book.room_id = params.numberValue(forKey: "room_id")
                    book.advisory_state = params.stringValue(forKey: "advisory_state")
                    book.sort_index = index as NSNumber
                }
                
                BSCoreDataManager.current().save()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"FetchBingfangBookKeywordResponse"), object: nil)
            }
        }
    }
}

