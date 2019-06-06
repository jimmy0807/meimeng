//
//  FetchZixunQuestionRequest.swift
//  meim
//
//  Created by jimmy on 2017/6/7.
//
//

import UIKit

class FetchZixunQuestionRequest: ICRequest
{
    var filterID : Int?
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        params["questionnaire_id"] = filterID
        
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "get_questionnaire_info", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            if let dict = resuntDict["data"] as? Dictionary<String, Any>
            {
                BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllQuestion())
                BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllQuestionResult())
                
                let questionnaire = dict["questionnaire"] as! Dictionary<String, Any>
                if let questions = questionnaire["questions"] as? [NSDictionary]
                {
                    for (_,params) in questions.enumerated()
                    {
                        let question = BSCoreDataManager.current().insertEntity("CDQuestion") as! CDQuestion
                        question.is_first = params.numberValue(forKey: "is_first")
                        question.question_id = params.numberValue(forKey: "question_id")
                        question.no_question_id = params.numberValue(forKey: "no_question_id")
                        question.no_result_id = params.numberValue(forKey: "no_result_id")
                        question.yes_question_id = params.numberValue(forKey: "yes_question_id")
                        question.yes_result_id = params.numberValue(forKey: "yes_result_id")
                        question.question_no = params.stringValue(forKey: "question_no")
                        question.question = params.stringValue(forKey: "question")
                    }
                }
                
                if let results = dict["results"] as? [NSDictionary]
                {
                    for (_,params) in results.enumerated()
                    {
                        let questionResult = BSCoreDataManager.current().insertEntity("CDQuestionResult") as! CDQuestionResult
                        questionResult.company_id = params.numberValue(forKey: "company_id")
                        questionResult.name = params.stringValue(forKey: "name")
                        questionResult.recommend = params.stringValue(forKey: "recommend")
                        questionResult.result_id = params.numberValue(forKey: "id")
                        
                        if let items = params["products"] as? [NSDictionary]
                        {
                            for (_,p) in items.enumerated()
                            {
                                let item = BSCoreDataManager.current().insertEntity("CDQuestionResultItem") as! CDQuestionResultItem
                                item.itemID = p.numberValue(forKey: "id")
                                item.name = p.stringValue(forKey: "name")
                                item.question = questionResult
                            }
                        }
                    }
                }
                
                BSCoreDataManager.current().save()
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kFetchQuestionResponse), object: nil)
    }
}
