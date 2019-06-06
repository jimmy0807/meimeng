//
//  YimeiHistoryViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/27.
//
//

import UIKit

class YimeiHistoryViewController: ICCommonViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var historyList : [CDYimeiHistory] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.backgroundImage = UIImage(named: "pad_background_white_color")?.imageResizable(withCapInsets: UIEdgeInsetsMake(12, 12, 12, 12))
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.registerNofitification(forMainThread: kFetchZixunResponse)
        self.refresh()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.refresh()
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.refresh()
        //self.reloadData(self.searchBar.text)
    }
    
    func refresh()
    {
        CBLoadingView.share().show()
        let request = FetchYimeiHistoryRequest()
        request.keyword = self.searchBar?.text ?? ""
        request.execute()
        request.finished = {[weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
            {
                if request.keyword.characters.count > 0
                {
                    if let result = request.searchResult.array as? [CDYimeiHistory]
                    {
                        self?.historyList = result
                    }
                    else
                    {
                        self?.historyList = []
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
        self.historyList = BSCoreDataManager.current().fetchYimeiHistory(byKeyword: keyword)
        self.tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.historyList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YimeiHistoryTableViewCell") as! YimeiHistoryTableViewCell
        cell.history = self.historyList[indexPath.row]

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 91
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let history = self.historyList[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "history_detail") as! YimeiHistoryDetailViewController
        vc.history = history
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return UIView(frame: CGRect.zero)
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
