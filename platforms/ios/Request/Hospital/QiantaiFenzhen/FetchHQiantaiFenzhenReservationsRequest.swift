//
//  FetchHQiantaiFenzhenReservationsRequest.swift
//  meim
//
//  Created by jimmy on 2017/5/31.
//
//

import UIKit

class FetchHQiantaiFenzhenReservationsRequest: ICRequest
{
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "fenzhen_reservations", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllZixunBook())
            
            if let resultList = resuntDict["data"] as? [NSDictionary]
            {
                for (index, params) in resultList.enumerated()
                {
                    let book = BSCoreDataManager.current().insertEntity("CDZixunBook") as! CDZixunBook
                    book.book_id = params.numberValue(forKey: "id")
                    book.image_url = params.stringValue(forKey: "image_url")
                    book.name = params.stringValue(forKey: "name")
                    book.member_type = params.stringValue(forKey: "member_type")
                    book.create_date = params.stringValue(forKey: "create_date")
                    book.start_date = params.stringValue(forKey: "start_date")
                    book.state = params.stringValue(forKey: "state")
                    book.member_id = params.numberValue(forKey: "member_id")
                    book.create_uid_name = params.stringValue(forKey: "create_uid_name")
                    book.queue_no = params.stringValue(forKey: "queue_no")
                    book.queue_no_name = params.stringValue(forKey: "queue_no_name")
                    book.nameLetter = ChineseToPinyin.pinyin(fromChiniseString: book.name!)
                    book.nameFirstLetter = ChineseToPinyin.pinyinFirstLetterString(book.name!).uppercased()
                    book.consume_date = params.stringValue(forKey: "consume_date")
                    book.director_id = params.numberValue(forKey: "director_id")
                    book.director_name = params.stringValue(forKey: "director_name")
                    book.designer_name = params.stringValue(forKey: "designer_name")
                    book.designer_id = params.numberValue(forKey: "designer_id")
                    book.room_id = params.numberValue(forKey: "room_id")
                    book.advisory_state = params.stringValue(forKey: "advisory_state")
                    book.sort_index = index as NSNumber
                }
                
                BSCoreDataManager.current().save()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:kFetchZixunBookResponse), object: nil)
            }
        }
    }
}
