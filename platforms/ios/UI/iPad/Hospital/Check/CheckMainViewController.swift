//
//  CheckMainViewController.swift
//  meim
//
//  Created by 波恩公司 on 2018/5/9.
//

import UIKit

class CheckMainViewController: ICCommonViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    
    @IBOutlet weak var searchView:UIView!
    @IBOutlet weak var control:UISegmentedControl!
    @IBOutlet weak var tableView:UITableView!
    var searchBar:UISearchBar!
    var totalArray:NSMutableArray!
    var showArray:NSArray!
    var state = "draft"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 722, height: 46))
        
        //searchBar.setSearchFieldBackgroundImage(UIImage(named: "pad_member_search_field")?.resizableImage(withCapInsets: UIEdgeInsetsMake(12, 12, 12, 12)), for: .normal)
        searchBar.setSearchFieldBackgroundImage(UIColor.clear.image(searchBar.bounds.size).resizableImage(withCapInsets: UIEdgeInsetsMake(12, 12, 12, 12)), for: .normal)
        searchBar.backgroundImage = UIColor.clear.image(searchBar.bounds.size)
        
        searchBar.contentMode = .center
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        searchBar.clipsToBounds = true
        self.searchView.addSubview(searchBar)
        totalArray = NSMutableArray()
        showArray = NSMutableArray()
        
        self.registerNofitification(forMainThread: "CheckFetchResponse")
        self.registerNofitification(forMainThread: "CheckFinishResponse")
        self.registerNofitification(forMainThread: "CheckUpdateResponse")
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.refresh()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    func refresh()
    {
        let request = FetchCheckRequest()
        //request.params["state"] = "draft"
        if state == "done"
        {
            request.params["state"] = state
        }
        request.execute()
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "CheckFetchResponse" )
        {
            print(notification.userInfo!["data"])
            if let array = notification.userInfo!["data"] as? NSArray
            {
                showArray = array
            }
            tableView.reloadData()
            tableView.mj_header.endRefreshing()
        }
        else if ( notification.name.rawValue == "CheckFinishResponse" )
        {
            self.searchBar.text = ""
            let request = FetchCheckRequest()
            request.params["state"] = state
            request.execute()
        }
        else if ( notification.name.rawValue == "CheckUpdateResponse" )
        {
            refresh()
        }
    }
    
    //MARK: - tableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CheckTableViewCell(style: .default, reuseIdentifier: "CheckTableViewCell")//tableView.dequeueReusableCell(withIdentifier: "CheckTableViewCell") as! CheckTableViewCell
        cell.backgroundColor = UIColor.white
        cell.member = showArray[indexPath.row] as! NSDictionary
        cell.initCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = CheckDetailViewController(nibName: "CheckDetailViewController", bundle: nil)
        detailView.operateId = (showArray[indexPath.row] as! NSDictionary).object(forKey: "id") as! NSNumber
        detailView.checkLineId = (showArray[indexPath.row] as! NSDictionary).object(forKey: "check_line_id") as! NSNumber
//        detailView.checkLineId =
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    func didCheckSearched(searchText:String)
    {
        let request = FetchCheckRequest()
        request.params["state"] = state
        request.params["keyword"] = searchText
        request.execute()
        //        showArray.removeAllObjects()
        //        let str = "12345"
        //        print(str.components(separatedBy: searchText))
        //        for room in totalArray
        //        {
        //            if str.components(separatedBy: searchText).count > 1
        //            {
        //                if(!showArray.contains(room))
        //                {
        //                    showArray.add(room)
        //                }
        //            }
        //        }
    }
    
    @IBAction func viewSelectInSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            state = "draft"
            refresh()
        case 1:
            state = "done"
            refresh()
        default:
            return
        }
    }
    
    //MARK: - searchBar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.didCheckSearched(searchText: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.didCheckSearched(searchText: searchBar.text!)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.didCheckSearched(searchText: searchBar.text!)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
}
