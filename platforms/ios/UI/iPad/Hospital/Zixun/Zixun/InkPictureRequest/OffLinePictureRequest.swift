//
//  OffLinePictureRequest.swift
//  meim
//
//  Created by 刘伟 on 2017/12/6.
//

import Foundation

class OffLinePictureRequest : ICRequest {
    ///请求参数定义
    
    ///请求开始
    override func willStart() -> Bool {
        
        let profile = PersonalProfile.current()
        //params["user_id"] = profile.userID;
        
        //self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "123", params: [params])
        
        return true
    }
    
    ///请求结果回调
    override func didFinishOnMainThread(){
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
    }

}
