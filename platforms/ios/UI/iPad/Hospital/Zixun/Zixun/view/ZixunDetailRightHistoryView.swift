//
//  ZixunDetailRightHistoryView.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit

class ZixunDetailRightHistoryView: UIView, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView : UITableView!
    
    var didZixunItemPressed : ((_ item : CDZixun) -> Void)?
    var tempZixunID : NSNumber?
    var tempMemberID : NSNumber?
    var zixunList : [CDZixun] = []
    var zixun : CDZixun?
    {
        didSet
        {
            
            self.tempMemberID = self.zixun?.member_id
            self.tempZixunID = NSNumber(value: 0)
            let request = FetchQiantaiZixunRequest()
            request.historyID = self.zixun?.member_id as? Int
            request.execute()
            
            self.reloadData()
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        self.reloadData()
    }
    
    func regNotification()
    {
        self.registerNofitification(forMainThread: kFetchZixunResponse)
        self.registerNofitification(forMainThread: kHZixunStartResponse)
    }
    
    func remNotification()
    {
        self.removeNotification(onMainThread: kFetchZixunResponse)
        self.removeNotification(onMainThread: kHZixunStartResponse)
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kFetchZixunResponse )
        {
            self.reloadData()
        }
        else if ( notification.name.rawValue == kHZixunStartResponse )
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2)
            {
                let request = FetchQiantaiZixunRequest()
                request.historyID = self.tempMemberID as? Int
                request.execute()
            }
        }
    }
    
    func reloadData(_ keyword : String? = nil)
    {
        if (self.zixun?.zixun_id != nil && self.zixun?.member_id != nil)
        {
            self.zixunList = BSCoreDataManager.current().fetchAllZixun(withType: nil, keyword: keyword, memberID: self.zixun?.member_id, zixunID: NSNumber(value: 0))
        }
        else
        {
            self.zixunList = BSCoreDataManager.current().fetchAllZixun(withType: nil, keyword: keyword, memberID: self.tempMemberID, zixunID: self.tempZixunID)
        }
        self.tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.zixunList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZixunHistoryTableViewCell") as! ZixunHistoryTableViewCell
        cell.zixun = self.zixunList[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 95
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let zixun = self.zixunList[indexPath.row];
        if zixun.zixun_id == self.zixun?.zixun_id
        {
            return;
        }
        
        self.didZixunItemPressed?(self.zixunList[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20;
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return UIView(frame: CGRect.zero)
    }
}
