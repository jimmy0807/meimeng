//
//  FetchHJiahaoDetailRequest.swift
//  meim
//
//  Created by jimmy on 2017/7/3.
//
//

import UIKit

class FetchHJiahaoDetailRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    var jiaohao : CDHJiaoHao
    
    init(_ jiaohao : CDHJiaoHao)
    {
        self.jiaohao = jiaohao
    }
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        params["user_id"] = profile.userID
        params["operate_id"] = jiaohao.jiaohao_id
        
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "order_info_detail", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            if let dict = resuntDict["data"] as? NSDictionary
            {
                if let resultList = dict["detail"] as? [NSDictionary]
                {
                    BSCoreDataManager.current().delete(self.jiaohao.flow?.array)
                    for params in resultList
                    {
                        let f = BSCoreDataManager.current().insertEntity("CDHJiaoHaoWorkflow") as! CDHJiaoHaoWorkflow
                        f.name = params.stringValue(forKey: "name")
                        f.state = params.stringValue(forKey: "state")
                        f.workflow_id = params.numberValue(forKey: "id")
                        f.operate_time = params.stringValue(forKey: "operate_time")
                        f.jiaohao = self.jiaohao
                        //f.print_url = params.stringValue(forKey: "print_url")
                        //jiaohao.operate_employee_ids = [params stringValueForKey:@"operate_employee_ids"];
                    }
                }
                
                self.jiaohao.print_url = dict.stringValue(forKey: "print_url")
                self.jiaohao.operate_employee_ids = ""
                
                let c = dict.arrayValue(forKey: "operate_employee_ids")
                if let ids = c as? [[Int]]
                {
                    self.jiaohao.operate_employee_ids = ids.map{"\($0[0])"}.joined(separator:",")
                }
                
                BSCoreDataManager.current().save()
                
                self.finished?(nil)
            }
        }
    }
}
