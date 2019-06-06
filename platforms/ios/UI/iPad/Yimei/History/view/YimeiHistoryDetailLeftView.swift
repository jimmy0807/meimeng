//
//  YimeiHistoryDetailLeftView.swift
//  meim
//
//  Created by jimmy on 2017/6/29.
//
//

import UIKit

class YimeiHistoryDetailLeftView: UIView, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var cancelLabel : UILabel!
    
    @IBOutlet weak var notOperateButton : UIButton!
    @IBOutlet weak var addProjectButton : UIButton!
    
    var didDeletePressed : ((_ item : CDYimeiHistoryConsumeItem) -> Void)?
    
    enum Section : Int
    {
        case Head
        case Buy
        case Consume
        case Count
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    var history : CDYimeiHistory?
    {
        didSet
        {
            self.tableView.reloadData()
            self.titleLabel.text = self.history?.name
            
            if history?.state == "cancel"
            {
                self.cancelLabel.isHidden = true
                self.cancelLabel.text = "已撤销"
            }
            else
            {
                self.cancelLabel.isHidden = false
                self.cancelLabel.text = "撤销单据"
            }
            
            if let progre_status = history?.progre_status, progre_status == "done"
            {
                self.notOperateButton.isHidden = true
                self.addProjectButton.isHidden = true
                
                self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.width, height: 684)
            }
            else if let cancel = history?.is_cancel_operate, cancel == true
            {
                self.addProjectButton.frame = CGRect(x: 0, y: 710, width: 420, height: 58)
            }
        }
    }

    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return Section.Count.rawValue
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == Section.Head.rawValue
        {
            return 1
        }
        else if section == Section.Buy.rawValue
        {
            return self.history?.buy_item?.count ?? 0
        }
        else
        {
            return self.history?.consume_item?.count ?? 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == Section.Head.rawValue
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YimeiHistoryDetailLeftTopTableViewCell") as! YimeiHistoryDetailLeftTopTableViewCell
            cell.history = self.history
            
            return cell
        }
        else if indexPath.section == Section.Buy.rawValue
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YimeiHistoryDetailProductTableViewCell") as! YimeiHistoryDetailProductTableViewCell
            cell.buyItem = self.history?.buy_item?[indexPath.row] as? CDYimeiHistoryBuyItem
            
            return cell
        }
        else if indexPath.section == Section.Consume.rawValue
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YimeiHistoryDetailProductTableViewCell") as! YimeiHistoryDetailProductTableViewCell
            cell.consumeItem = self.history?.consume_item?[indexPath.row] as? CDYimeiHistoryConsumeItem
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == Section.Head.rawValue
        {
            return 170
        }
        
        return 92
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let history = self.historyList[indexPath.row]
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "history_detail") as! YimeiHistoryDetailViewController
//        vc.history = history
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if indexPath.section == Section.Consume.rawValue
        {
            return true
        }
        
        return false
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if let history = self.history, let item = history.consume_item?[indexPath.row] as? CDYimeiHistoryConsumeItem
        {
            self.didDeletePressed?(item)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == Section.Head.rawValue
        {
            return 0
        }
        else if section == Section.Buy.rawValue
        {
            if self.history?.buy_item?.count ?? 0 > 0
            {
                return 30
            }
        }
        else if section == Section.Consume.rawValue
        {
            if self.history?.consume_item?.count ?? 0 > 0
            {
                return 30
            }
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = RGB(r: 180, g: 213, b: 218)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 30))
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        if section == Section.Buy.rawValue
        {
            titleLabel.text = "购买项目"
        }
        else if section == Section.Consume.rawValue
        {
            titleLabel.text = "消耗项目"
        }
        
        v.addSubview(titleLabel)
        
        return v
    }
}
