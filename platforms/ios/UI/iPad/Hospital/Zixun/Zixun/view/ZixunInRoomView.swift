//
//  ZixunInRoomView.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

class ZixunInRoomView: UIView, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var emptyIconImageView : UIImageView!
    
    var didZixunItemPressed : ((_ item : CDZixun) -> Void)?
    var zixunList : [CDZixun] = []
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        searchBar.backgroundImage = UIImage(named: "pad_background_white_color")?.imageResizable(withCapInsets: UIEdgeInsetsMake(12, 12, 12, 12))
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.registerNofitification(forMainThread: kFetchZixunResponse)
        self.reloadData()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            FetchQiantaiZixunRequest().execute()
        })
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kFetchZixunResponse )
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
            {
                self.reloadData()
                self.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    func reloadData(_ keyword : String? = nil)
    {
        self.zixunList = BSCoreDataManager.current().fetchAllZixun(withType: "waiting", keyword: keyword, memberID: nil, zixunID: nil)
        self.tableView.reloadData()
        self.emptyIconImageView.isHidden = self.zixunList.count > 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.zixunList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZixunInRoomTableViewCell") as! ZixunInRoomTableViewCell
        cell.zixun = self.zixunList[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 95
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
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
 
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.reloadData(searchBar.text)
    }
}
