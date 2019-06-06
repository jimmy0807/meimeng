//
//  FetchBingfangRoomsRequest.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/26.
//

import UIKit

class FetchBingfangRoomsRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "hospitalized_rooms", params: [params])
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
        BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllBingfangRoom())
            
            if let resultList = resuntDict["data"] as? [NSDictionary]
            {
                for (index, params) in resultList.enumerated()
                {
                    let room = BSCoreDataManager.current().insertEntity("CDBingfangRoom") as! CDBingfangRoom
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
                    room.line_id = params.numberValue(forKey: "line_id")
                    room.hospitalized_id = params.numberValue(forKey: "hospitalized_id")
                    room.operate_id = params.numberValue(forKey: "operate_id")
                    room.ward_name = params.stringValue(forKey: "ward_name")
                }
                
                BSCoreDataManager.current().save()
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"BingfangRoomsFetchResponse"), object: nil, userInfo:nil)
    }
}

