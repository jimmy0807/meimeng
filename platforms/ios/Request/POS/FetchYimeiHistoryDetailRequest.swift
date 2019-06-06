//
//  FetchYimeiHistoryDetailRequest.swift
//  meim
//
//  Created by jimmy on 2017/6/28.
//
//

import UIKit

class FetchYimeiHistoryDetailRequest: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    var history : CDYimeiHistory?
    var operate_id : NSNumber?

    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        params["user_id"] = profile.userID;
        if (self.operate_id == nil)
        {
            params["operate_id"] = history?.operate_id
        }
        else
        {
            params["operate_id"] = self.operate_id
        }
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "pos_history_operate_detail", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        if let params = resultDict?["data"] as? NSDictionary
        {
            if let h = self.history
            {
                h.state = params.stringValue(forKey: "state")
                h.create_date = params.stringValue(forKey: "create_date")
                h.note = params.stringValue(forKey: "note")
                h.amount = params.stringValue(forKey: "amount")
                h.create_name = params.stringValue(forKey: "create_name")
                h.member_name = params.stringValue(forKey: "member_name")
                //h.member_id = params.numberValue(forKey: "member_id")
                h.nameLetter = ChineseToPinyin.pinyin(fromChiniseString: h.member_name!)
                h.nameFirstLetter = ChineseToPinyin.pinyinFirstLetterString(h.member_name!).uppercased()
                h.type = params.stringValue(forKey: "type")
                h.remark = params.stringValue(forKey: "remark")
                h.statements = params.stringValue(forKey: "statements")
                h.card_id = params.numberValue(forKey: "card_id")
                h.progre_status = params.stringValue(forKey: "progre_status")
                h.is_cancel_operate = params.numberValue(forKey: "is_cancel_operate")
                h.is_update_add_operate = params.numberValue(forKey: "is_update_add_operate")
                h.is_checkout = params.numberValue(forKey: "is_checkout")//是否已经结账
                h.is_post_checkout = params.numberValue(forKey: "is_post_checkout")//是否是挂单
                BSCoreDataManager.current().delete(h.buy_item?.array)
                h.buy_item = NSMutableOrderedSet()
                for dict in params.arrayValue(forKey: "products") as! [NSDictionary]
                {
                    let item = BSCoreDataManager.current().insertEntity("CDYimeiHistoryBuyItem") as! CDYimeiHistoryBuyItem
                    item.itemID = dict.numberValue(forKey: "id")
                    item.price_unit = dict.stringValue(forKey: "price_unit")
                    item.qty = dict.numberValue(forKey: "qty")
                    item.name_template = dict.stringValue(forKey: "name_template")
                    item.history = h
                }
                
                BSCoreDataManager.current().delete(h.consume_item?.array)
                h.consume_item = NSMutableOrderedSet()
                for dict in params.arrayValue(forKey: "consumes") as! [NSDictionary]
                {
                    let item = BSCoreDataManager.current().insertEntity("CDYimeiHistoryConsumeItem") as! CDYimeiHistoryConsumeItem
                    item.itemID = dict.numberValue(forKey: "id")
                    item.qty = dict.numberValue(forKey: "consume_qty")
                    item.name_template = dict.stringValue(forKey: "name_template")
                    item.history = h
                }
            }
            else
            {
                let h = BSCoreDataManager.current().uniqueEntity(forName: "CDYimeiHistory", withValue: params.numberValue(forKey: "id"), forKey: "operate_id") as! CDYimeiHistory
                h.amount = params.stringValue(forKey: "amount")
                h.create_date = params.stringValue(forKey: "create_date")
                h.operate_id = params.numberValue(forKey: "id")
                h.state = params.stringValue(forKey: "state")
                h.member_id = params.numberValue(forKey: "member_id")
                h.name = params.stringValue(forKey: "name")
                h.member_name = params.stringValue(forKey: "member_name")
                h.nameLetter = ChineseToPinyin.pinyin(fromChiniseString: h.member_name!)
                h.nameFirstLetter = ChineseToPinyin.pinyinFirstLetterString(h.member_name!).uppercased()
                
                h.state = params.stringValue(forKey: "state")
                h.create_date = params.stringValue(forKey: "create_date")
                h.note = params.stringValue(forKey: "note")
                h.amount = params.stringValue(forKey: "amount")
                h.create_name = params.stringValue(forKey: "create_name")
                h.member_name = params.stringValue(forKey: "member_name")
                //h.member_id = params.numberValue(forKey: "member_id")
                h.nameLetter = ChineseToPinyin.pinyin(fromChiniseString: h.member_name!)
                h.nameFirstLetter = ChineseToPinyin.pinyinFirstLetterString(h.member_name!).uppercased()
                h.type = params.stringValue(forKey: "type")
                h.remark = params.stringValue(forKey: "remark")
                h.statements = params.stringValue(forKey: "statements")
                h.card_id = params.numberValue(forKey: "card_id")
                h.progre_status = params.stringValue(forKey: "progre_status")
                h.is_cancel_operate = params.numberValue(forKey: "is_cancel_operate")
                h.is_update_add_operate = params.numberValue(forKey: "is_update_add_operate")
                h.is_checkout = params.numberValue(forKey: "is_checkout")//是否已经结账
                h.is_post_checkout = params.numberValue(forKey: "is_post_checkout")//是否是挂单
                BSCoreDataManager.current().delete(h.buy_item?.array)
                h.buy_item = NSMutableOrderedSet()
                for dict in params.arrayValue(forKey: "products") as! [NSDictionary]
                {
                    let item = BSCoreDataManager.current().insertEntity("CDYimeiHistoryBuyItem") as! CDYimeiHistoryBuyItem
                    item.itemID = dict.numberValue(forKey: "id")
                    item.price_unit = dict.stringValue(forKey: "price_unit")
                    item.qty = dict.numberValue(forKey: "qty")
                    item.name_template = dict.stringValue(forKey: "name_template")
                    item.history = h
                }
                
                BSCoreDataManager.current().delete(h.consume_item?.array)
                h.consume_item = NSMutableOrderedSet()
                for dict in params.arrayValue(forKey: "consumes") as! [NSDictionary]
                {
                    let item = BSCoreDataManager.current().insertEntity("CDYimeiHistoryConsumeItem") as! CDYimeiHistoryConsumeItem
                    item.itemID = dict.numberValue(forKey: "id")
                    item.qty = dict.numberValue(forKey: "consume_qty")
                    item.name_template = dict.stringValue(forKey: "name_template")
                    item.history = h
                }
            }
            
            BSCoreDataManager.current().save()
        }
        
        self.finished?(dict)
    }
}
