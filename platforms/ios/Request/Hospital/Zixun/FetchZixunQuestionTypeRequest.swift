//
//  FetchZixunQuestionTypeRequest.swift
//  meim
//
//  Created by jimmy on 2017/7/13.
//
//

import UIKit

class FetchZixunQuestionTypeRequest: ICRequest
{
    var getQuestionList : ((_ list : [NSDictionary]) -> Void)?
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "get_questionnaire_list", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        var returnList = [NSDictionary]()
        
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            if let dict = resuntDict["data"] as? Dictionary<String, Any>
            {
                if let questions = dict["questionnaire"] as? [NSDictionary]
                {
                    returnList = questions
                }
            }
        }
        
        self.getQuestionList?(returnList)
    }
}
