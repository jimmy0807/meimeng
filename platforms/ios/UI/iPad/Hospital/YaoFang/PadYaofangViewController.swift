//
//  PadYaofangViewController.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/13.
//

import UIKit

class PadYaofangViewController: ICCommonViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
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
        
        self.registerNofitification(forMainThread: "YaofangFetchResponse")
        self.registerNofitification(forMainThread: "YaofangFinishResponse")
        
        let request = FetchYaofangRequest()
        request.params["state"] = "draft"
        request.execute()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            let request = FetchYaofangRequest()
            request.params["keyword"] = self.searchBar.text
            request.params["state"] = self.state
            request.execute()
        })
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "YaofangFetchResponse" )
        {
            tableView.mj_header.endRefreshing()
            print(notification.userInfo!["data"])
            if let array = notification.userInfo!["data"] as? NSArray
            {
                showArray = array
            }
            tableView.reloadData()
        }
        else if ( notification.name.rawValue == "YaofangFinishResponse" )
        {
            self.searchBar.text = ""
            let request = FetchYaofangRequest()
            request.params["state"] = state
            request.execute()
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
        let cell = YaofangTableViewCell(style: .default, reuseIdentifier: "YaofangTableViewCell")//tableView.dequeueReusableCell(withIdentifier: "YaofangTableViewCell") as! YaofangTableViewCell
        cell.backgroundColor = UIColor.white
        cell.member = showArray[indexPath.row] as! NSDictionary
        cell.initCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = YaofangDetailViewController(nibName: "YaofangDetailViewController", bundle: nil)
        detailView.memberId = (showArray[indexPath.row] as! NSDictionary).object(forKey: "prescription_id") as! NSNumber
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    func didYaofangSearched(searchText:String)
    {
        let request = FetchYaofangRequest()
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
            let request = FetchYaofangRequest()
            state = "draft"
            request.params["state"] = "draft"
            request.execute()
        case 1:
            let request = FetchYaofangRequest()
            state = "done"
            request.params["state"] = "done"
            request.execute()
        default:
            return
        }
    }
    
    //MARK: - searchBar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.didYaofangSearched(searchText: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.didYaofangSearched(searchText: searchBar.text!)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.didYaofangSearched(searchText: searchBar.text!)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
}
//MARK: - extension color
extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
