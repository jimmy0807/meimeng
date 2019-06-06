//
//  FetchZongkongShoushuRoomDetailRequest.swift
//  meim
//
//  Created by jimmy on 2017/7/11.
//
//

import UIKit

class FetchZongkongShoushuRoomDetailRequest: ICRequest
{
    var zongkongRoom : CDZongkongShoushuRoom?
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        params["id"] = zongkongRoom?.room_id
        params["type"] = zongkongRoom?.type
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "zhenshi_detail", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            BSCoreDataManager.current().delete(zongkongRoom?.current_customers?.array)
            BSCoreDataManager.current().delete(zongkongRoom?.paidui_customers?.array)
            zongkongRoom?.current_customers = NSOrderedSet()
            zongkongRoom?.paidui_customers = NSOrderedSet()
            
            if let customers = resuntDict["data"] as? [NSDictionary]
            {
                for customer in customers
                {
                    let c = BSCoreDataManager.current().insertEntity("CDZongkongShoushuCustomer") as! CDZongkongShoushuCustomer
                    c.director_employee_id = customer.numberValue(forKey: "director_employee_id")
                    c.director_employee_id_name = customer.stringValue(forKey: "director_employee_id_name")
                    c.designers_id = customer.numberValue(forKey: "designers_id")
                    c.designers_name = customer.stringValue(forKey: "designers_id_name")
                    c.name = customer.stringValue(forKey: "name")
                    c.id = customer.numberValue(forKey: "id")
                    c.image_url = customer.stringValue(forKey: "image_url")
                    c.start_date = customer.stringValue(forKey: "start_date")
                    c.time = customer.stringValue(forKey: "time")
                    c.start_date_time = customer.stringValue(forKey: "start_date_time")
                    c.product_name = customer.stringValue(forKey: "product_name")
                    c.state = customer.stringValue(forKey: "state")
                    c.member_type = customer.stringValue(forKey: "member_type")
                    c.doctor_id = customer.numberValue(forKey: "doctor_id")
                    c.doctor_name = customer.stringValue(forKey: "doctor_id_name")
                    c.remark = customer.stringValue(forKey: "remark")
                    c.image_url = customer.stringValue(forKey: "image_url")
                    
                    if let state = c.state, state == "doing"
                    {
                        c.current_room = zongkongRoom
                    }
                    else
                    {
                        c.paidui_room = zongkongRoom
                    }
                }
                BSCoreDataManager.current().save()
            
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue:kFetchZixunRoomResponse), object: nil)
            }
        }
        
        self.finished?(nil)
    }
}
