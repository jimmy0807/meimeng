//
//  WenZhenViewController.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/17.
//

import UIKit

class WenZhenViewController: ICCommonViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchView:UIView!
    @IBOutlet weak var filterView:UIView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var weiwenzhenButton:UIButton!
    @IBOutlet weak var yiwenzhenButton:UIButton!
    @IBOutlet weak var doneButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    var searchBar:UISearchBar!
    var showArray:NSArray!
    var allArray:NSArray!
    var state = "draft"
    var myButtonHighlighted = false
    var weiwenzhenButtonHighlighted = false
    var wenzhenzhongButtonHighlighted = false
    var doneButtonHighlighted = false
    var cancelButtonHighlighted = false

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
        showArray = NSArray()
        allArray = NSArray()
        self.registerNofitification(forMainThread: kFetchWashHandResponse)

        filterView.isHidden = false
        searchView.isHidden = true
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            let request = FetchWashHandRequest()
            request.workID = PersonalProfile.current().yimeiWorkFlowArray[0] as! NSNumber
            request.execute()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let request = FetchWashHandRequest()
        request.workID = PersonalProfile.current().yimeiWorkFlowArray[0] as! NSNumber
        request.execute()
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kFetchWashHandResponse )
        {
            self.tableView.mj_header.endRefreshing()
            if (filterView.isHidden)
            {
                allArray = BSCoreDataManager.current().fetchAllWashHand(withID: PersonalProfile.current().yimeiWorkFlowArray[0] as? NSNumber, keyword: nil, isDone: doneButtonHighlighted) as NSArray
                let newArray = NSMutableArray()
                for dict in allArray {
                    if let name = (dict as! CDPosWashHand).member_name, name.contains(find: searchBar.text!)
                    {
                        newArray.add(dict)
                    }
                    if let mobile = (dict as! CDPosWashHand).member_mobile, mobile.contains(find: searchBar.text!)
                    {
                        newArray.add(dict)
                    }
                    
//                    if ((dict as! CDPosWashHand).member_name?.contains(find: searchBar.text!))! || ((dict as! CDPosWashHand).member_mobile?.contains(find: searchBar.text!))!
//                    {
//                        newArray.add(dict)
//                    }
                    showArray = newArray

                }
                
                tableView.reloadData()
            }
            else
            {
                allArray = BSCoreDataManager.current().fetchAllWashHand(withID: PersonalProfile.current().yimeiWorkFlowArray[0] as? NSNumber, keyword: nil, isDone: doneButtonHighlighted) as NSArray
                showArray = allArray
                guolv()
                tableView.reloadData()
            }
        }
    }
    
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
        let cell = WenzhenTableViewCell(style: .default, reuseIdentifier: "WenzhenCell")//YaofangTableViewCell(style: .default, reuseIdentifier: "YaofangTableViewCell")
        cell.backgroundColor = UIColor.white
        cell.member = NSDictionary()
        cell.wash = showArray[indexPath.row] as! CDPosWashHand
        cell.initCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detailView = WenZhenDetailViewController(nibName: "WenZhenDetailViewController", bundle: nil)
        detailView.wash = showArray[indexPath.row] as! CDPosWashHand
        //detailView.memberId = (showArray[indexPath.row] as! NSDictionary).object(forKey: "prescription_id") as! NSNumber
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    func didWenzhenSearched(searchText:String)
    {
        let request = FetchWashHandRequest()
        request.workID = PersonalProfile.current().yimeiWorkFlowArray[0] as! NSNumber
        request.keyword = searchText
        
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
            filterView.isHidden = false
            searchView.isHidden = true
            showArray = allArray
            guolv()
            tableView.reloadData()
        case 1:
            filterView.isHidden = true
            searchView.isHidden = false
            showArray = NSArray()
            tableView.reloadData()
        default:
            return
        }
    }
    
    //MARK: - searchBar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.didWenzhenSearched(searchText: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //self.didWenzhenSearched(searchText: searchBar.text!)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.didWenzhenSearched(searchText: searchBar.text!)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    //MARK: - filter
    @IBAction func didMyButtonPressed(_ sender : UIButton)
    {
        myButtonHighlighted = !myButtonHighlighted
        if myButtonHighlighted
        {
            sender.backgroundColor = RGB(r: 96, g: 211, b: 212)
            sender.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            sender.backgroundColor = UIColor.clear
            sender.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
    }
    
    @IBAction func didYiwenzhenButtonPressed(_ sender : UIButton)
    {
        wenzhenzhongButtonHighlighted = !wenzhenzhongButtonHighlighted
        weiwenzhenButtonHighlighted = false
        doneButtonHighlighted = false
        cancelButtonHighlighted = false
        if wenzhenzhongButtonHighlighted
        {
            sender.backgroundColor = RGB(r: 96, g: 211, b: 212)
            sender.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            sender.backgroundColor = UIColor.clear
            sender.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if weiwenzhenButtonHighlighted
        {
            weiwenzhenButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            weiwenzhenButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            weiwenzhenButton.backgroundColor = UIColor.clear
            weiwenzhenButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if doneButtonHighlighted
        {
            doneButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            doneButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            doneButton.backgroundColor = UIColor.clear
            doneButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if cancelButtonHighlighted
        {
            cancelButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            cancelButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            cancelButton.backgroundColor = UIColor.clear
            cancelButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        filterArray()
    }
    
    @IBAction func didWeiwenzhenButtonPressed(_ sender : UIButton)
    {
        weiwenzhenButtonHighlighted = !weiwenzhenButtonHighlighted
        wenzhenzhongButtonHighlighted = false
        doneButtonHighlighted = false
        cancelButtonHighlighted = false
        if wenzhenzhongButtonHighlighted
        {
            yiwenzhenButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            yiwenzhenButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            yiwenzhenButton.backgroundColor = UIColor.clear
            yiwenzhenButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if weiwenzhenButtonHighlighted
        {
            sender.backgroundColor = RGB(r: 96, g: 211, b: 212)
            sender.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            sender.backgroundColor = UIColor.clear
            sender.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if doneButtonHighlighted
        {
            doneButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            doneButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            doneButton.backgroundColor = UIColor.clear
            doneButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if cancelButtonHighlighted
        {
            cancelButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            cancelButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            cancelButton.backgroundColor = UIColor.clear
            cancelButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        filterArray()
    }
    
    @IBAction func didDoneButtonPressed(_ sender : UIButton)
    {
        doneButtonHighlighted = !doneButtonHighlighted
        wenzhenzhongButtonHighlighted = false
        weiwenzhenButtonHighlighted = false
        cancelButtonHighlighted = false
        if wenzhenzhongButtonHighlighted
        {
            yiwenzhenButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            yiwenzhenButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            yiwenzhenButton.backgroundColor = UIColor.clear
            yiwenzhenButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if weiwenzhenButtonHighlighted
        {
            weiwenzhenButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            weiwenzhenButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            weiwenzhenButton.backgroundColor = UIColor.clear
            weiwenzhenButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if doneButtonHighlighted
        {
            sender.backgroundColor = RGB(r: 96, g: 211, b: 212)
            sender.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            sender.backgroundColor = UIColor.clear
            sender.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if cancelButtonHighlighted
        {
            cancelButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            cancelButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            cancelButton.backgroundColor = UIColor.clear
            cancelButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        filterArray()
    }
    
    @IBAction func didCancelButtonPressed(_ sender : UIButton)
    {
        cancelButtonHighlighted = !cancelButtonHighlighted
        wenzhenzhongButtonHighlighted = false
        weiwenzhenButtonHighlighted = false
        doneButtonHighlighted = false
        if wenzhenzhongButtonHighlighted
        {
            yiwenzhenButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            yiwenzhenButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            yiwenzhenButton.backgroundColor = UIColor.clear
            yiwenzhenButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if weiwenzhenButtonHighlighted
        {
            weiwenzhenButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            weiwenzhenButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            weiwenzhenButton.backgroundColor = UIColor.clear
            weiwenzhenButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if doneButtonHighlighted
        {
            doneButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            doneButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            doneButton.backgroundColor = UIColor.clear
            doneButton.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        if cancelButtonHighlighted
        {
            sender.backgroundColor = RGB(r: 96, g: 211, b: 212)
            sender.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            sender.backgroundColor = UIColor.clear
            sender.setTitleColor(RGB(r: 149, g: 171, b: 171), for: .normal)
        }
        filterArray()
    }
    
    func guolv()
    {
        let newArray = NSMutableArray()
        for dict in allArray {
            if weiwenzhenButtonHighlighted
            {
                if (dict as! CDPosWashHand).activity_state == "draft" || (dict as! CDPosWashHand).activity_state == "waiting"
                {
                    newArray.add(dict)
                }
            }
            if wenzhenzhongButtonHighlighted
            {
                if (dict as! CDPosWashHand).activity_state == "doing"
                {
                    newArray.add(dict)
                }
            }
            if doneButtonHighlighted
            {
                if (dict as! CDPosWashHand).activity_state == "done"
                {
                    newArray.add(dict)
                }
            }
            if cancelButtonHighlighted
            {
                if (dict as! CDPosWashHand).activity_state == "cancel"
                {
                    newArray.add(dict)
                }
            }
            if !weiwenzhenButtonHighlighted && !wenzhenzhongButtonHighlighted && !doneButtonHighlighted && !cancelButtonHighlighted
            {
                newArray.add(dict)
            }
        }
        showArray = newArray
        tableView.reloadData()
    }
    
    func filterArray()
    {
        let request = FetchWashHandRequest()
        request.workID = PersonalProfile.current().yimeiWorkFlowArray[0] as! NSNumber
        if doneButtonHighlighted
        {
            request.bFetchDone = true
        }
        request.execute()
    }
}
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
