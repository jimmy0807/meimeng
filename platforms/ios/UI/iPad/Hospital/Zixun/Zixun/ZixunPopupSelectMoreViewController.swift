//
//  ZixunPopupSelectMoreViewController.swift
//  meim
//
//  Created by jimmy on 2017/7/12.
//
//

import UIKit

class ZixunPopupSelectMoreViewController: ICCommonViewController,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView : UITableView!
    var zixun : CDZixun?
    var questionList = [NSDictionary]()
    
    var goMemberVc : ((Void) -> Void)?
    var goQuestionDetail : ((_ questionID : Int) -> Void)?
    
    enum Section : Int
    {
        case Info
        case Test
        case Count
    }
    
    enum RowInfo: Int
    {
        case ShopAS
        case Member
        case Count
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let request = FetchZixunQuestionTypeRequest()
        request.execute()
        request.getQuestionList = {[weak self] list in
            self?.questionList = list
            self?.tableView.reloadData()
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.questionList.count == 0
        {
            return 1
        }
        
        return Section.Count.rawValue
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == Section.Info.rawValue
        {
            return RowInfo.Count.rawValue
        }
        else if section == Section.Test.rawValue
        {
            return self.questionList.count
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZixunPopupSelectMoreCell") as! ZixunPopupSelectMoreCell
        if indexPath.section == Section.Info.rawValue
        {
            if indexPath.row == RowInfo.ShopAS.rawValue
            {
                cell.titleLabel.text = "医院介绍APP"
            }
            else if indexPath.row == RowInfo.Member.rawValue
            {
                cell.titleLabel.text = "会员详情"
            }
        }
        else
        {
            cell.titleLabel.text = self.questionList[indexPath.row].stringValue(forKey: "name")
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == Section.Info.rawValue
        {
            if indexPath.row == RowInfo.ShopAS.rawValue
            {
                if let url = URL(string: "shopas://")
                {
                    if #available(iOS 10, *)
                    {
                        
                    }
                    
                    if UIApplication.shared.canOpenURL(url)
                    {
                        UIApplication.shared.openURL(url)
                    }
                    else
                    {
                        if let url = URL(string: "https://itunes.apple.com/app/id932235641?l=zh&ls=1&mt=8")
                        {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
            else if indexPath.row == RowInfo.Member.rawValue
            {
                self.goMemberVc?()
            }
        }
        else
        {
            self.goQuestionDetail?(self.questionList[indexPath.row].numberValue(forKey: "id") as! Int)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == Section.Test.rawValue
        {
            return 30
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        view.backgroundColor = RGB(r: 143, g: 176, b: 178)
        
        let label = UILabel(frame: CGRect(x: 25, y: 0, width: 200, height: 30))
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "肌肤评测"
        view.addSubview(label)
        
        return view
    }
}
