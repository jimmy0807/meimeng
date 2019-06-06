//
//  FetchQiantaiZixunRequest.swift
//  meim
//
//  Created by jimmy on 2017/6/5.
//
//

import UIKit

class FetchQiantaiZixunRequest: ICRequest
{
    var searchKeyWord : String?
    var filterType : String?
    var historyID : Int?
    var memberID : String?
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        var params : Dictionary<String,Any> = [:]
        params["user_id"] = profile.userID;
        
        if let keyword = self.searchKeyWord, !keyword.isEmpty
        {
            params["keyword"] = keyword;
        }
        
        if let h = historyID
        {
            params["member_id"] = h;
        }
        
        if let m = memberID
        {
            params["member_id"] = m;
        }
        
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "zhixun_list", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        var searchArray : [CDZixun]?
        if let keyword = self.searchKeyWord, !keyword.isEmpty
        {
            searchArray = []
        }
        
        if let resuntDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        {
            if let resultList = resuntDict["data"] as? [NSDictionary]
            {
                if searchArray == nil && historyID == nil
                {
                    BSCoreDataManager.current().delete(BSCoreDataManager.current().fetchAllZixun(withType: nil, keyword: nil, memberID: nil, zixunID:nil))
                }
                
                for (index,params) in resultList.enumerated()
                {
                    //print("咨询单\(params)")
                    let zixun =  BSCoreDataManager.current().uniqueEntity(forName: "CDZixun", withValue: params.numberValue(forKey: "id"), forKey: "zixun_id") as! CDZixun
                    zixun.advisory_start_date = params.stringValue(forKey: "advisory_start_date")
                    zixun.advisory_end_date = params.stringValue(forKey: "advisory_end_date")
                    zixun.doctor_name = params.stringValue(forKey: "doctor_name")
                    zixun.doctor_id = params.numberValue(forKey: "doctor_id")
                    zixun.image_url = params.stringValue(forKey: "image_url")
                    zixun.member_id = params.numberValue(forKey: "member_id")
                    zixun.member_name = params.stringValue(forKey: "member_name")
                    zixun.director_id = params.numberValue(forKey: "director_id")
                    zixun.director_name = params.stringValue(forKey: "director_name")
                    zixun.sex = params.stringValue(forKey: "sex")
                    zixun.create_date = params.stringValue(forKey: "create_date")
                    zixun.advice = params.stringValue(forKey: "advice")
                    zixun.product_names = params.stringValue(forKey: "product_names")
                    //zixun.product_ids = params.stringValue(forKey: "product_ids")
                    zixun.product_ids = params.stringValue(forKey: "product_ids")
                    zixun.select_product_ids = params.stringValue(forKey: "select_product_ids")
                    zixun.select_product_names = params.stringValue(forKey: "select_product_names")
                    zixun.operate_id = params.numberValue(forKey: "operate_id")
                    zixun.room_name = params.stringValue(forKey: "room_name")
                    zixun.state = params.stringValue(forKey: "state")
                    zixun.member_type = params.stringValue(forKey: "member_type")
                    zixun.no = params.stringValue(forKey: "no")
                    zixun.designer_name = params.stringValue(forKey: "designer_name")
                    zixun.designer_id = params.numberValue(forKey: "designer_id")
                    zixun.visit_id = params.numberValue(forKey: "visit_id")
                    zixun.condition = params.stringValue(forKey: "condition")
                    zixun.age = params.stringValue(forKey: "age")
                    zixun.xuexing = params.stringValue(forKey: "blood_type")
                    zixun.xingzuo = params.stringValue(forKey: "astro")
                    zixun.state_name = params.stringValue(forKey: "state_name")
                    zixun.room_id = params.numberValue(forKey: "room_id")
                    zixun.nameLetter = ChineseToPinyin.pinyin(fromChiniseString: zixun.member_name!)
                    zixun.nameFirstLetter = ChineseToPinyin.pinyinFirstLetterString(zixun.member_name!).uppercased()
                    zixun.customer_state_name = params.stringValue(forKey: "customer_state_name")
                    zixun.queue_no = params.stringValue(forKey: "queue_no")
                    zixun.client_date = params.stringValue(forKey: "client_date")
                    zixun.mobile = params.stringValue(forKey: "mobile")
                    zixun.sort_index = index as NSNumber
                    zixun.image_urls = params.stringValue(forKey: "image_urls")

                    let images = params.stringValue(forKey: "image_urls").components(separatedBy: ",")
                    for url in images
                    {
                        let yimeiImage = BSCoreDataManager.current().insertEntity("CDYimeiImage") as! CDYimeiImage
                        yimeiImage.url = url
                        yimeiImage.zixun = zixun
                    }
                    
                    if let state = zixun.state
                    {
                        if searchArray != nil || historyID != nil
                        {
                            
                        }
                        else
                        {
                            if ( state == "draft" )
                            {
                                zixun.zixun_local_type = "waiting"
                            }
                            else
                            {
                                zixun.zixun_local_type = "today"
                            }
                        }
                    }
                    
                    searchArray?.append(zixun)
                }
                
                BSCoreDataManager.current().save()
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kFetchZixunResponse), object: searchArray)
    }
}
