
import UIKit

class HZixunUpdate2: ICRequest
{
    var params : Dictionary<String,Any> = [:]
    
    override func willStart() -> Bool
    {
        let profile = PersonalProfile.current()
        
        params["user_id"] = profile.userID;
        self.sendRpcXmlCommand("/xmlrpc/2/ds_api", method: "zhixun_update", params: [params])
        
        return true
    }
    
    override func didFinishOnMainThread()
    {
        let resultDict = BNXmlRpc.dictionary(withXmlRpc: resultStr)
        let dict = self.generateDsApiResponse(resultDict) as! Dictionary<String, Any>
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue:kHZixunStartResponse), object: nil, userInfo:dict)
        
        self.finished?(dict)
        print("HZixunUpdate2-finished")
    }
}

