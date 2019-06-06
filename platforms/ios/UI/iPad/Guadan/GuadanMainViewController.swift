//
//  GuadanMainViewController.swift
//  meim
//
//  Created by jimmy on 2017/7/25.
//
//

import UIKit

class GuadanMainViewController: ICCommonViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var tableView : UITableView!
///  9月份新修改 设置导航栏左侧按钮
    var mineButton : SpecialButton?
    var finishedButton : SpecialButton?
    
    var searchBar : UISearchBar?
    var guadanList : [CDHGuadan] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        /// 9月份新修改 设置导航栏左侧按钮
        setUpNaviRightButton()
        
        setHeaderView()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.refresh()
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    func refresh()
    {
        CBLoadingView.share().show()
        let request = FetchGuadanListRequest()
        request.params["myself"] = self.mineButton?.isSelected
        if (self.finishedButton?.isSelected)!
        {
            request.params["state"] = "done"
        }
        request.keyword = self.searchBar?.text ?? ""
        request.execute()
        request.finished = {[weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
            {
                if request.keyword.characters.count > 0
                {
                    if let result = request.searchResult.array as? [CDHGuadan]
                    {
                        self?.guadanList = result
                    }
                    else
                    {
                        self?.guadanList = []
                    }
                    
                    self?.tableView.reloadData()
                }
                else
                {
                    self?.reloadData()
                }
                
                self?.tableView.mj_header.endRefreshing()
                CBLoadingView.share().hide()
            }
        }
    }
    
    func reloadData(_ keyword : String? = nil)
    {
        self.guadanList = BSCoreDataManager.current().fetchAllGuadan(keyword)
        self.tableView.reloadData()
    }
    func setUpNaviRightButton()
    {
        mineButton = SpecialButton.initWithTitle("我开单的", andRect: CGRect.init(x: self.view.frame.size.width - 64*2-50, y: 25, width: 64, height: 26), andCanClick: true) {
            self.refresh()
        }
        //self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: mineButton!)]
        //self.navigationController?.view.addSubview(mineButton!)
        
        finishedButton = SpecialButton.initWithTitle("已完成的", andRect: CGRect.init(x: self.view.frame.size.width-64-30, y: 25, width: 64, height: 26), andCanClick: true) {
            self.refresh()
        }
        //self.navigationController?.view.addSubview(finishedButton!)
    }
    
    func setHeaderView()
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 725, height: 64))
        headerView.backgroundColor = UIColor.clear
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 20, width: 725, height: 44))
        self.searchBar?.backgroundImage = #imageLiteral(resourceName: "pad_background_white_color.png")
        self.searchBar?.returnKeyType = .search
        self.searchBar?.placeholder = "请输入"
        self.searchBar?.delegate = self
        headerView.addSubview(self.searchBar!)
        self.tableView.tableHeaderView = headerView
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.guadanList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuadanTableViewCell") as! GuadanTableViewCell
        cell.guadan = self.guadanList[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 79
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let guadan = self.guadanList[indexPath.row]
        if guadan.state == "已开单"
        {
            CBMessageView(title: "已开单的单据不能再开单了").show()
            return
        }
        
        CBLoadingView.share().show()
        
        let request = BSFetchMemberDetailRequestN(memberID: guadan.member_id)
        request?.finished = {[weak self] (params) in
            CBLoadingView.share().hide()
            if let result = params?["rc"] as? Int, result == 0
            {
                if let member = BSCoreDataManager.current().findEntity("CDMember", withValue: guadan.member_id, forKey: "memberID") as? CDMember
                {
                    self?.goProjectView(guadan, member: member)
                }
                else
                {
                    CBMessageView(title: "没有找到该会员").show()
                }
            }
            else
            {
                CBMessageView(title: params?["rm"] as! String).show()
            }
        }
        request?.execute()
    }
    
    func goProjectView(_ guadan : CDHGuadan, member : CDMember!)
    {
        var memberCard : CDMemberCard? = nil
        if let cards = member.card?.array as? [CDMemberCard], let cardID = guadan.card_id
        {
            for card in cards
            {
                if card.cardID == cardID
                {
                    memberCard = card
                    break
                }
            }
        }
        
        if let operate = BSCoreDataManager.current().findEntity("CDPosOperate", withValue: guadan.guadan_id, forKey: "orderID") as? CDPosOperate
        {
            BSCoreDataManager.current().delete(operate)
        }
        
        let vc = PadProjectViewController(memberCard: memberCard, couponCard: nil, handno: nil)
        vc.guadan = guadan
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20;
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return UIView(frame: .zero)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.reloadData(searchBar.text)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        self.refresh()
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    
}
