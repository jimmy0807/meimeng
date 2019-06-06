//
//  FetchZongkongDoctorDetailRequest.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/10.
//

import UIKit

class FetchZongkongDoctorDetailRequest: ICRequest
{
    var zongkongDoctor : CDZongkongDoctorPerson?
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        params["doctor_id"] = zongkongDoctor?.doctor_id
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "fenzhen_doctors_detail", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            BSCoreDataManager.current().delete(zongkongDoctor?.current_customers?.array)
            BSCoreDataManager.current().delete(zongkongDoctor?.paidui_customers?.array)
            zongkongDoctor?.current_customers = NSOrderedSet()
            zongkongDoctor?.paidui_customers = NSOrderedSet()
            
            if let customers = resuntDict["data"] as? [NSDictionary]
            {
                for customer in customers
                {
                    let c = BSCoreDataManager.current().insertEntity("CDZongkongDoctorCustomer") as! CDZongkongDoctorCustomer
                    c.director_employee_name = customer.stringValue(forKey: "director_employee_name")
                    c.designers_name = customer.stringValue(forKey: "designers_name")
                    c.queue_no = customer.stringValue(forKey: "queue_no")
                    c.start_date = customer.stringValue(forKey: "start_date")
                    c.state = customer.stringValue(forKey: "state")
                    c.member_name = customer.stringValue(forKey: "member_name")
                    c.doctor_name = customer.stringValue(forKey: "doctor_id_name")
                    c.remark = customer.stringValue(forKey: "remark")
                    c.member_image_url = customer.stringValue(forKey: "member_image_url")
                    
                    if let state = c.state, state == "doing"
                    {
                        c.current_doctor = zongkongDoctor
                    }
                    else
                    {
                        c.paidui_doctor = zongkongDoctor
                    }
                }
                BSCoreDataManager.current().save()
                
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue:kFetchZixunRoomResponse), object: nil)
            }
        }
        
        self.finished?(nil)
    }
}

