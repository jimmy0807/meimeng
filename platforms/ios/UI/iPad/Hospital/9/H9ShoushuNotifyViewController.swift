//
//  H9ShoushuNotifyViewController.swift
//  meim
//
//  Created by jimmy on 2017/8/3.
//
//

import UIKit

class H9ShoushuNotifyViewController: ICCommonViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tabImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var isReadTab = false
    
    var notifyList : [CDH9Notify] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 90;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.reloadData()
        self.doRequest()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.doRequest()
        })
    }
    
    func doRequest()
    {
        let request = FetchH9NotifyRequest()
        request.finished = {[weak self] (dict) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
            {
                self?.reloadData()
                self?.tableView.mj_header.endRefreshing()
            }
        }
        request.execute()
    }
    
    func reloadData()
    {
        self.notifyList = BSCoreDataManager.current().fetchH9Notify(self.isReadTab ? "read" : "unread")
        self.tableView.reloadData()
        if ( !self.isReadTab )
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:kUpdateH9NotifyNotification), object: nil, userInfo:["count":self.notifyList.count] )
        }
    }
    
    @IBAction func didUnReadPressed(_ sender : UIButton)
    {
        self.tabImage.image = #imageLiteral(resourceName: "h_9_notify_0.png")
        self.isReadTab = false
        self.reloadData()
    }
    
    @IBAction func didReadedPressed(_ sender : UIButton)
    {
        self.tabImage.image = #imageLiteral(resourceName: "h_9_notify_1.png")
        self.isReadTab = true
        self.reloadData()
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return notifyList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "H9ShoushuNotifyTableViewCell") as! H9ShoushuNotifyTableViewCell
        cell.notify = notifyList[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 22))
        view.backgroundColor = UIColor.clear

        return view
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let notify = notifyList[indexPath.row]
        if let memberID = notify.member_id
        {
            CBLoadingView.share().show()
            
            let request = FetchHOnePatientRequest()
            request.memberID = memberID
            request.execute()
            request.finished = { [weak self](params) in
                CBLoadingView.share().hide()
                if let result = params?["rc"] as? Int, result == 0
                {
                    self?.goMember(memberID as! Int)
                }
                else
                {
                    CBMessageView(title: params?["rm"] as! String).show()
                }
            }
        }
    }
    
    func goMember(_ memberID : Int)
    {
        let tableViewStoryboard = UIStoryboard(name: "HPatientBoard", bundle: nil)
        if let member = BSCoreDataManager.current().findEntity("CDMember", withValue: memberID, forKey: "memberID") as? CDMember
        {
            let vc = tableViewStoryboard.instantiateViewController(withIdentifier: "binglika") as! HPatientBinglikaViewController
            vc.member = member
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let rowAction = UITableViewRowAction(style: .normal, title: "已读") {[weak self] (action, indexPath) in
            let notify = self?.notifyList[indexPath.row]
            let request = EditH9NotifyRequest()
            request.params["event_ids"] = "\(notify?.notify_id ?? 0)"
            request.execute()
            
            notify?.state = "read"
            self?.reloadData()
        }
        rowAction.backgroundColor = RGB(r: 248, g: 46, b: 52)
        
        return [rowAction];
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if isReadTab
        {
            return false
        }
        
        return true
    }
}
