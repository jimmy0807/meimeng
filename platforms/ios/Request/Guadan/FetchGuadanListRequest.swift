//
//  FetchGuadanListRequest.swift
//  meim
//
//  Created by jimmy on 2017/7/26.
//
//

import UIKit

class FetchGuadanListRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    var keyword : String = ""
    var searchResult = NSMutableOrderedSet()
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        params["user_id"] = profile.userID;
        if keyword.characters.count > 0
        {
            params["keyword"] = keyword;
        }

        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "pos_order_list", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        if keyword.characters.count == 0
        {
            BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllGuadan(nil))
        }
        
        if let resultList = resultDict?["data"] as? [NSDictionary]
        {
            for (index, params) in resultList.enumerated()
            {
                let guadan = BSCoreDataManager.current().uniqueEntity(forName: "CDHGuadan", withValue: params.numberValue(forKey: "id"), forKey: "guadan_id") as! CDHGuadan
                //guadan.guadan_id = params.numberValue(forKey: "id")
                guadan.designers_id = params.numberValue(forKey: "designers_id")
                guadan.designers_name = params.stringValue(forKey: "designers_name")
                guadan.doctor_id = params.numberValue(forKey: "doctor_id")
                guadan.doctor_name = params.stringValue(forKey: "doctor_name")
                guadan.employee_id = params.numberValue(forKey: "employee_id")
                guadan.employee_name = params.stringValue(forKey: "employee_name")
                guadan.member_id = params.numberValue(forKey: "member_id")
                guadan.member_name = params.stringValue(forKey: "member_name")
                guadan.nameLetter = ChineseToPinyin.pinyin(fromChiniseString: guadan.member_name!)
                guadan.nameFirstLetter = ChineseToPinyin.pinyinFirstLetterString(guadan.member_name!).uppercased()
                guadan.note = params.stringValue(forKey: "note")
                guadan.display_note = params.stringValue(forKey: "display_note")
                guadan.state = params.stringValue(forKey: "state")
                guadan.no = params.stringValue(forKey: "no")
                guadan.remark = params.stringValue(forKey: "remark")
                guadan.card_id = params.numberValue(forKey: "card_id")
                guadan.departments_id = params.numberValue(forKey: "departments_id")
                guadan.departments_name = params.stringValue(forKey: "departments_name")
                guadan.director_employee_id = params.numberValue(forKey: "director_employee_id")
                guadan.director_employee_name = params.stringValue(forKey: "director_employee_name")
                guadan.sort_index = index as NSNumber
                
                if let products = params.arrayValue(forKey: "product_ids") as? [NSDictionary]
                {
                    for params in products
                    {
                        let guadanP = BSCoreDataManager.current().insertEntity("CDHGuadanProduct") as! CDHGuadanProduct
                        guadanP.product_id = params.numberValue(forKey: "product_id")
                        guadanP.itemID = params.numberValue(forKey: "id")
                        guadanP.qty = params.numberValue(forKey: "qty")
                        guadanP.pad_order_id = params.numberValue(forKey: "pad_order_id")
                        guadanP.line_id = params.numberValue(forKey: "lines_id")
                        
                        if let line = guadanP.line_id as? Int, line > 0
                        {
                            guadanP.card_item = guadan
                        }
                        else
                        {
                            guadanP.item = guadan
                        }
                    }
                }
                
                if keyword.characters.count > 0
                {
                    searchResult.add(guadan)
                }
            }
            
            BSCoreDataManager.current().save()
        }
        
        self.finished?(dict)
    }
}
