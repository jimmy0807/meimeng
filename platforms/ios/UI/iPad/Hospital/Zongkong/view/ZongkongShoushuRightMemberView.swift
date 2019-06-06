//
//  ZongkongShoushuRightMemberView.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit

class ZongkongShoushuRightMemberView: UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView : UITableView!

    var memberListCurrent : [CDZongkongShoushuCustomer] = []
    var memberListPaidui : [CDZongkongShoushuCustomer] = []
    
    var room: CDZongkongShoushuRoom?
    {
        didSet
        {
            if let room = self.room
            {
                self.memberListCurrent = (room.current_customers?.array ?? []) as! [CDZongkongShoushuCustomer]
                self.memberListPaidui = (room.paidui_customers?.array ?? []) as! [CDZongkongShoushuCustomer]
                self.tableView.reloadData()
                
                let request = FetchZongkongShoushuRoomDetailRequest()
                request.zongkongRoom = room
                request.finished = {[weak self] params in
                    self?.memberListCurrent = (room.current_customers?.array ?? []) as! [CDZongkongShoushuCustomer]
                    self?.memberListPaidui = (room.paidui_customers?.array ?? []) as! [CDZongkongShoushuCustomer]
                    self?.tableView.reloadData()
                }
                request.execute()
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            let request = FetchZongkongShoushuRoomDetailRequest()
            request.zongkongRoom = self?.room
            request.execute()
            request.finished = {[weak self] (params) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
                {
                    self?.memberListCurrent = (self?.room?.current_customers?.array ?? []) as! [CDZongkongShoushuCustomer]
                    self?.memberListPaidui = (self?.room?.paidui_customers?.array ?? []) as! [CDZongkongShoushuCustomer]
                    self?.tableView.reloadData()
                    self?.tableView.mj_header.endRefreshing()
                }
            }
        })
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return self.memberListCurrent.count
        }
        else if section == 1
        {
            return self.memberListPaidui.count
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZongkongShoushuMemberTableViewCell") as! ZongkongShoushuMemberTableViewCell
        
        if indexPath.section == 0
        {
            cell.customer = self.memberListCurrent[indexPath.row]
        }
        else
        {
            cell.customer = self.memberListPaidui[indexPath.row]
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 1 && self.memberListPaidui.count == 0
        {
            return 0
        }
        
        return 30
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        view.backgroundColor = RGB(r: 232, g: 239, b: 239)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 30))
        view.addSubview(titleLabel)
        titleLabel.textColor = RGB(r: 132, g: 157, b: 156)
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        if ( section == 0 )
        {
            titleLabel.text = "当前顾客"
        }
        else if ( section == 1 )
        { 
            titleLabel.text = "排队中"
        }
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
