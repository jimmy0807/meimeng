//
//  HJiaoHaoRightViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/30.
//
//

import UIKit

class HJiaoHaoRightViewController: ICTableViewController
{
    var selectVC : SeletctListViewController?
    @IBOutlet weak var keshiLabel : UILabel!
    @IBOutlet weak var doctorLabel : UILabel!
    @IBOutlet weak var operatorLabel : UILabel!
    @IBOutlet weak var peitaiNurseLabel : UILabel!
    @IBOutlet weak var xunhuiNurseLabel : UILabel!
    @IBOutlet weak var mazuishiLabel : UILabel!
    @IBOutlet weak var currentWorkflowLabel : UILabel!
    @IBOutlet weak var isCancelLabel : UILabel!
    @IBOutlet weak var customerTypeLabel : UILabel!
    @IBOutlet weak var queueLabel : UITextField!
        
    var jiaohao : CDHJiaoHao?
    {
        didSet
        {
            if let jiaohao = self.jiaohao
            {
                let request = FetchHJiahaoDetailRequest(jiaohao)
                request.execute()
                request.finished = {[weak self] _ in
                    self?.reloadData()
                    CBLoadingView.share().hide()
                }
                CBLoadingView.share().show()
            }
        }
    }
    
    func reloadData()
    {
        if let jiaohao = self.jiaohao
        {
            self.doctorLabel.text = jiaohao.doctor_name
            self.peitaiNurseLabel.text = jiaohao.peitai_nurse_name
            self.xunhuiNurseLabel.text = jiaohao.xunhui_nurse_name
            self.mazuishiLabel.text = jiaohao.anesthetist_name

            if let departmentID = jiaohao.departments_id
            {
                let keshiArray = BSCoreDataManager.current().fetchALLKeshi() as! [CDKeShi]
                
                for keshi in keshiArray
                {
                    if keshi.keshi_id == departmentID
                    {
                        self.keshiLabel.text = keshi.name
                    }
                }
            }
            
            if let workflowArray = jiaohao.flow?.array as? [CDHJiaoHaoWorkflow], let currentID = jiaohao.current_workflow_activity_id
            {
                reloadHeader(workflowArray)
                
                for flow in workflowArray
                {
                    if flow.workflow_id == currentID
                    {
                        self.currentWorkflowLabel.text = flow.name
                    }
                }
            }
            
            if let array = self.jiaohao?.operate_employee_ids?.components(separatedBy: ",")
            {
                var nameArray : [String] = []
                for id in array
                {
                    if let intVar = Int(id)
                    {
                        if let staff = BSCoreDataManager.current().findEntity("CDStaff", withValue: intVar as NSNumber, forKey: "staffID") as? CDStaff
                        {
                            nameArray.append(staff.name ?? "")
                        }
                    }
                }
                self.operatorLabel.text = nameArray.joined(separator: ",")
            }
            
            self.customerTypeLabel.text = (jiaohao.member_type ?? "").uppercased()
            self.queueLabel.text = jiaohao.queue_no
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20;
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return UIView(frame: CGRect.zero)
    }
    
    @IBAction func didKeshiButtonPressed(_ sender : UIButton)
    {
        let keshiArray = BSCoreDataManager.current().fetchALLKeshi() as! [CDKeShi]
        
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        
        self.selectVC?.countOfTheList = {
            return keshiArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let keshi = keshiArray[index]
            return keshi.name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let keshi = keshiArray[index]
            self?.jiaohao?.departments_id = keshi.keshi_id
            self?.keshiLabel.text = keshi.name
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didDoctorButtonPressed(_ sender : UIButton)
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let doctorArray = BSCoreDataManager.current().fetchDoctorStaffs(withShopID: PersonalProfile.current().bshopId)
        
        self.selectVC?.countOfTheList = {
            return doctorArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let doctor = doctorArray[index]
            return doctor.name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let doctor = doctorArray[index]
            
            self?.jiaohao?.doctor_id = doctor.staffID
            self?.jiaohao?.doctor_name = doctor.name
            self?.doctorLabel.text = doctor.name
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didPeitaiButtonPressed(_ sender : UIButton)
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let nurseArray = BSCoreDataManager.current().fetchOperateStaffs(withShopID: PersonalProfile.current().bshopId)
        
        self.selectVC?.countOfTheList = {
            return nurseArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let nurse = nurseArray[index]
            return nurse.name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let nurse = nurseArray[index]
            
            self?.jiaohao?.peitai_nurse_id = nurse.staffID
            self?.jiaohao?.peitai_nurse_name = nurse.name
            self?.peitaiNurseLabel.text = nurse.name
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didXunhuiNurseButtonPressed(_ sender : UIButton)
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let nurseArray = BSCoreDataManager.current().fetchOperateStaffs(withShopID: PersonalProfile.current().bshopId)
        
        self.selectVC?.countOfTheList = {
            return nurseArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let nurse = nurseArray[index]
            return nurse.name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let nurse = nurseArray[index]
            
            self?.jiaohao?.xunhui_nurse_id = nurse.staffID
            self?.jiaohao?.xunhui_nurse_name = nurse.name
            self?.xunhuiNurseLabel.text = nurse.name
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didMazuishiButtonPressed(_ sender : UIButton)
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let doctorArray = BSCoreDataManager.current().fetchDoctorStaffs(withShopID: PersonalProfile.current().bshopId)
        
        self.selectVC?.countOfTheList = {
            return doctorArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let doctor = doctorArray[index]
            return doctor.name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let doctor = doctorArray[index]
            
            self?.jiaohao?.anesthetist_id = doctor.staffID
            self?.jiaohao?.anesthetist_name = doctor.name
            self?.mazuishiLabel.text = doctor.name
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didOperatorButtonPressed(_ sender : UIButton)
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        self.selectVC?.multiSelect = true
        
        let doctorArray = BSCoreDataManager.current().fetchOperateStaffs(withShopID: PersonalProfile.current().bshopId)
        var set = Set<Int>()
        if let array = self.jiaohao?.operate_employee_ids?.components(separatedBy: ",")
        {
            for id in array
            {
                if let intVar = Int(id)
                {
                    set.insert(intVar)
                }
            }
        }
        
        self.selectVC?.countOfTheList = {
            return doctorArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let doctor = doctorArray[index]
            return doctor.name
        }

        self.selectVC?.isSelected = {index in
            let d = doctorArray[index]
            
            if set.contains(d.staffID as! Int)
            {
                return true
            }
            
            return false
        }
        
        self.selectVC?.multiSelectFinish = {[weak self] indexSet in
            if let array = indexSet?.array as? [Int]
            {
                set = Set<Int>()
                let orderArray = array.sorted(by: {$0 > $1} )
                var nameArray : [String] = []
                var idsArray : [String] = []
                for index in orderArray
                {
                    let staff = doctorArray[index]
                    nameArray.append(staff.name ?? "")
                    idsArray.append(String("\((staff.staffID as? Int) ?? 0)"))
                    set.insert(index)
                }
                
                self?.operatorLabel.text = nameArray.joined(separator: ",")
                self?.jiaohao?.operate_employee_ids = idsArray.joined(separator: ",")
            }
        }

        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didCurrentWorkflowButtonPressed(_ sender : UIButton)
    {
        if let workflowArray = self.jiaohao?.flow?.array as? [CDHJiaoHaoWorkflow]
        {
            self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
            self.selectVC?.noSort = true
            self.selectVC?.countOfTheList = {
                return workflowArray.count
            }
            
            self.selectVC?.nameAtIndex = { index in
                let flow = workflowArray[index]
                return flow.name
            }
            
            self.selectVC?.selectAtIndex = {[weak self] index in
                let flow = workflowArray[index]
                
                self?.jiaohao?.current_workflow_activity_id = flow.workflow_id
                self?.currentWorkflowLabel.text = flow.name
            }
            
            UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
            self.selectVC?.showWithAnimation();
        }
    }
    
    @IBAction func didMemberTypeButtonPressed(_ sender : UIButton)
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        self.selectVC?.noSort = true
        
        let typeArray = ["WIP", "VIP", "PT", "DJ", "DD", "DL", "YG","DQ"]
        
        self.selectVC?.countOfTheList = {
            return typeArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            return typeArray[index]
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let type = typeArray[index]
            self?.customerTypeLabel.text = type;
            self?.jiaohao?.member_type = type.lowercased()
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didCancelSwichButtonPressed(_ sender : UISwitch)
    {
        self.jiaohao?.willCancel = sender.isOn as NSNumber
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.jiaohao?.queue_no = textField.text
    }
    
    func reloadHeader(_ flows : [CDHJiaoHaoWorkflow])
    {
        let startY = 25
        let count = flows.count
        
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 70 * count + startY))
        self.view.addSubview(bgView)
        self.tableView.tableHeaderView = bgView
        let bgImageView = UIImageView(frame: CGRect(x: 20, y: -1, width: 300, height: 70 * count + startY))
        bgImageView.image = #imageLiteral(resourceName: "pos_cell_bg_b.png").stretchableImage(withLeftCapWidth: 20, topCapHeight: 20)
        bgView.addSubview(bgImageView)
        
        for (index, flow) in flows.enumerated()
        {
            let itemView = UIView(frame: CGRect(x: 20, y: startY + index * 70, width: 300, height: 70))
            bgView.addSubview(itemView)
            
            if let state = flow.state
            {
                let lineImageView = UIImageView()
                if index == 0
                {
                    lineImageView.frame = CGRect(x: 26, y: 3, width: 1, height: 67)
                }
                else if index == count - 1
                {
                    lineImageView.frame = CGRect(x: 26, y: 0, width: 1, height: 8)
                }
                else
                {
                    lineImageView.frame = CGRect(x: 26, y: 0, width: 1, height: 70)
                }
                lineImageView.backgroundColor = RGB(r: 226, g: 226, b: 226)
                itemView.addSubview(lineImageView)
                
                let iconImageView = UIImageView(frame: CGRect(x: 18, y: 3, width: 17, height: 17))
                itemView.addSubview(iconImageView)
                
                let titleLabel = UILabel(frame: CGRect(x: 45, y: 0, width: 250, height: 18))
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                titleLabel.textColor = RGB(r: 58, g: 58, b: 58)
                itemView.addSubview(titleLabel)

                let detailLabel = UILabel(frame: CGRect(x: 45, y: 25, width: 250, height: 18))
                detailLabel.font = UIFont.systemFont(ofSize: 12)
                detailLabel.textColor = RGB(r: 143, g: 143, b: 143)
                itemView.addSubview(detailLabel)
                
                if state == "waiting" || state == "draft"
                {
                    titleLabel.text = "\(flow.name ?? "") - 未开始"
                    iconImageView.image = #imageLiteral(resourceName: "jiaohao_notstart.png")
                }
                else if state == "doing"
                {
                    titleLabel.text = "\(flow.name ?? "") - 进行中"
                    iconImageView.image = #imageLiteral(resourceName: "jiaohao_current.png")
                }
                else if state == "done"
                {
                    titleLabel.text = "\(flow.name ?? "") - 已完成"
                    iconImageView.image = #imageLiteral(resourceName: "jiaohao_finished.png")
                }
                
                detailLabel.text = flow.operate_time
            }
        }
    }
}
