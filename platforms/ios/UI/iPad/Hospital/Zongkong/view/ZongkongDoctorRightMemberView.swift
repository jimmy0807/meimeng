//
//  ZongkongDoctorRightMemberView.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/10.
//

import UIKit

class ZongkongDoctorRightMemberView: UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView : UITableView!
    
    var memberListCurrent : [CDZongkongDoctorCustomer] = []
    var memberListPaidui : [CDZongkongDoctorCustomer] = []
    
    var doctor: CDZongkongDoctorPerson?
    {
        didSet
        {
            if let doctor = self.doctor
            {
                self.memberListCurrent = (doctor.current_customers?.array ?? []) as! [CDZongkongDoctorCustomer]
                self.memberListPaidui = (doctor.paidui_customers?.array ?? []) as! [CDZongkongDoctorCustomer]
                self.tableView.reloadData()
                
                let request = FetchZongkongDoctorDetailRequest()
                request.zongkongDoctor = doctor
                request.finished = {[weak self] params in
                    self?.memberListCurrent = (doctor.current_customers?.array ?? []) as! [CDZongkongDoctorCustomer]
                    self?.memberListPaidui = (doctor.paidui_customers?.array ?? []) as! [CDZongkongDoctorCustomer]
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
            let request = FetchZongkongDoctorDetailRequest()
            request.zongkongDoctor = self?.doctor
            request.execute()
            request.finished = {[weak self] (params) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
                {
                    self?.memberListCurrent = (self?.doctor?.current_customers?.array ?? []) as! [CDZongkongDoctorCustomer]
                    self?.memberListPaidui = (self?.doctor?.paidui_customers?.array ?? []) as! [CDZongkongDoctorCustomer]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZongkongDoctorMemberTableViewCell") as! ZongkongDoctorMemberTableViewCell
        
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
        var str = ""
        if indexPath.section == 0
        {
            str = self.memberListCurrent[indexPath.row].remark ?? ""
        }
        else
        {
            str = self.memberListPaidui[indexPath.row].remark ?? ""
        }
        let strComponents = str.components(separatedBy: "\n")
        var lines = strComponents.count
        for s in strComponents
        {
            if (s.boundingRect(with: CGSize(), options: NSStringDrawingOptions.usesFontLeading, attributes: nil, context: nil).width > 243.0)
            {
                lines += 1
            }
        }
        return 90 + CGFloat(lines * 15)
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

