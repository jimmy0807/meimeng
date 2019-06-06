//
//  FetchHQiantaiFenzhenRoomRequest.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

class FetchHQiantaiFenzhenRoomRequest: ICRequest
{
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "fenzhen_rooms", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllZixunRoom())
            
            if let resultList = resuntDict["data"] as? [NSDictionary]
            {
                for (index, params) in resultList.enumerated()
                {
                    let room = BSCoreDataManager.current().insertEntity("CDZixunRoom") as! CDZixunRoom
                    room.room_id = params.numberValue(forKey: "id")
                    room.state = params.stringValue(forKey: "state_name")
                    room.wait_message = params.stringValue(forKey: "message")
                    room.name = params.stringValue(forKey: "name")
                    room.sort_index = index as NSNumber
                    room.is_recycle = params.numberValue(forKey: "is_special")
                    room.director_employee_id = params.numberValue(forKey: "director_employee_id")
                    room.director_employee_name = params.stringValue(forKey: "director_employee_id_name")
                    room.designers_id = params.numberValue(forKey: "designers_id")
                    room.designers_name = params.stringValue(forKey: "designers_id_name")
                    room.member_name = params.stringValue(forKey: "member_name")
                    room.member_id = params.numberValue(forKey: "member_id")
                    room.image_url = params.stringValue(forKey: "image_url")
                    room.start_date = params.stringValue(forKey: "start_date")
                    room.member_type = params.stringValue(forKey: "member_type")
                    
//                    if let customers = params.arrayValue(forKey: "customers") as? [NSDictionary]
//                    {
//                        for customer in customers
//                        {
//                            let c = BSCoreDataManager.current().insertEntity("CDZixunRoomPerson") as! CDZixunRoomPerson
//                            c.director_employee_id = customer.numberValue(forKey: "director_employee_id")
//                            c.director_employee_name = customer.stringValue(forKey: "director_employee_id_name")
//                            c.designers_id = customer.numberValue(forKey: "designers_id")
//                            c.designers_name = customer.stringValue(forKey: "designers_id_name")
//                            c.member_name = customer.stringValue(forKey: "member_name")
//                            c.member_id = customer.numberValue(forKey: "member_id")
//                            c.image_url = customer.stringValue(forKey: "image_url")
//                            c.start_date = customer.stringValue(forKey: "start_date")
//                            c.state = customer.stringValue(forKey: "state")
//                            c.member_type = customer.stringValue(forKey: "member_type")
//                            c.room = room
//                        }
//                    }
                }
                
                BSCoreDataManager.current().save()
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kFetchZixunRoomResponse), object: nil)
    }
}
