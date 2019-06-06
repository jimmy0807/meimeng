//
//  FetchZongkongShoushuRoomRequest.swift
//  meim
//
//  Created by jimmy on 2017/6/20.
//
//

import UIKit

class FetchZongkongShoushuRoomRequest: ICRequest
{
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "zhenshi_list", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllZongkongRoom())
            
            if let resultList = resuntDict["data"] as? NSDictionary
            {
                let workflow = resultList["workflow"] as? [NSDictionary]
                let department = resultList["department"] as? [NSDictionary]
                
                if let w = workflow, let d = department
                {
                    let maxCount = max(w.count, d.count)
                    for i in 0 ..< maxCount
                    {
                        var params : NSDictionary = [:]
                        if i < w.count
                        {
                            params = w[i]
                        }
                        else
                        {
                            params = ["type":"empty"]
                        }
                        
                        insertRoom(params, sortIndex: i * 2)
                        
                        if i < d.count
                        {
                            params = d[i]
                        }
                        else
                        {
                            params = ["type":"empty"]
                        }
                        
                        insertRoom(params, sortIndex: i * 2 + 1)
                    }
                }
                
                BSCoreDataManager.current().save()
                
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue:kFetchZixunRoomResponse), object: nil)
            }
        }
        
        self.finished?(nil)
    }
    
    func insertRoom(_ params : NSDictionary, sortIndex index : Int) -> Void
    {
        let room = BSCoreDataManager.current().insertEntity("CDZongkongShoushuRoom") as! CDZongkongShoushuRoom
        room.name = params.stringValue(forKey: "name")
        room.room_id = params.numberValue(forKey: "id")
        room.sort_index = index as NSNumber
        room.state = params.stringValue(forKey: "state")
        room.wait_message = params.stringValue(forKey: "waiting_count_name")
        room.doing_count = params.numberValue(forKey: "doing_count")
        room.state_name = params.stringValue(forKey: "state_name")
        room.waiting_count = params.numberValue(forKey: "doing_cnt")
        room.image_url = params.stringValue(forKey: "image_url")
        room.shejishi = params.stringValue(forKey: "designers_id_name")
        room.doctor_name = params.stringValue(forKey: "doctor_id_name")
        room.member_name = params.stringValue(forKey: "member_name")
        room.start_date = params.stringValue(forKey: "start_date")
        room.type = params.stringValue(forKey: "type")
    }
}
