//
//  H9AnPaiRightEventView.swift
//  meim
//
//  Created by jimmy on 2017/8/3.
//
//

import UIKit

class H9AnPaiRightEventView: UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noEventLabel : UILabel!
    var eventList : [CDH9SSAPEvent]! = []
    
    var didEditEventButtonPressed : ((_ event : CDH9SSAPEvent)->Void)?
    var didEventItemButtonPressed : ((_ event : CDH9SSAPEvent)->Void)?
    
//    var ssap : CDH9SSAP?
//    {
//        didSet
//        {
//            self.tableView.reloadData()
//            if let count = ssap?.event?.count, count > 0
//            {
//                self.noEventLabel.isHidden = true
//            }
//            else
//            {
//                self.noEventLabel.isHidden = false
//            }
//        }
//    }
    
    var year_month_day : String?
    {
        didSet
        {
            self.reloadData()
            if let year_month_day = self.year_month_day
            {
                let request = FetchH9SSAPDetailRequest()
                request.year_month_day = year_month_day
                request.execute()
                request.finished = {[weak self] dict in
                    self?.reloadData()
                }
            }
        }
    }
    
    func reloadData()
    {
        self.eventList = BSCoreDataManager.current().fetchH9SSAPDetail(year_month_day)
        self.tableView.reloadData()
        if eventList.count > 0
        {
            self.noEventLabel.isHidden = true
        }
        else
        {
            self.noEventLabel.isHidden = false
        }

    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.tableView.estimatedRowHeight = 140;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return eventList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "H9AnPaiRightEventTableViewCell") as! H9AnPaiRightEventTableViewCell
        cell.event = eventList[indexPath.row]

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if eventList.count > 0
        {
            return 22
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 22))
        view.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(frame: CGRect(x: 68, y: 0, width: 1, height: 22))
        imageView.backgroundColor = RGB(r: 216, g: 229, b: 210)
        view.addSubview(imageView)
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.didEventItemButtonPressed?(eventList[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let event = eventList[indexPath.row]
        let rowAction = UITableViewRowAction(style: .normal, title: "取消") {(action, indexPath) in
            CBLoadingView.share().show()
//            var params : Dictionary<String,Any> = [:]
//            params["is_cancel"] = true
//            params["user_id"] = PersonalProfile.current().userID
//            params["operate_line_id"] = event.operate_line_id
            let params = NSMutableDictionary()
            params.setValue(true, forKey: "is_cancel")
            params.setValue(PersonalProfile.current().userID, forKey: "user_id")
            params.setValue(event.operate_line_id, forKey: "operate_line_id")
            let request = H9ShoushuEditRequest()
            request.params = params //as! NSMutableDictionary
            request.execute()
            request.finished = { params in
                CBLoadingView.share().hide()
                if let result = params?["rc"] as? Int, result == 0
                {
                    event.state = "cancel"
                    event.state_name = "已取消"
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                else
                {
                    CBMessageView(title: params?["rm"] as! String).show()
                }
            }
        }
        rowAction.backgroundColor = RGB(r: 248, g: 46, b: 52)
        
        let rowAction2 = UITableViewRowAction(style: .normal, title: "变更") {[weak self] (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = UIColor.clear
            tableView.reloadRows(at: [indexPath], with: .none)
            self?.goEventEdit(indexPath)
        }
        rowAction2.backgroundColor = RGB(r: 253, g: 207, b: 0)
        
        return [rowAction,rowAction2];
    }
    
    func goEventEdit(_ indexPath: IndexPath)
    {
        self.didEditEventButtonPressed?(eventList[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        let event = eventList[indexPath.row]
        if event.state == "cancel"
        {
            return false
        }
        
        return true
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = RGB(r: 224, g: 230, b: 230)
    }
    
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    {
        if let path = indexPath
        {
            let cell = tableView.cellForRow(at: path)
            cell?.backgroundColor = UIColor.clear
        }
    }
}
