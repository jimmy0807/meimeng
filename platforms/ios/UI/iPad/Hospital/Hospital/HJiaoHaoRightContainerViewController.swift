//
//  HJiaoHaoRightContainerViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/30.
//
//

import UIKit

class HJiaoHaoRightContainerViewController: ICCommonViewController
{
    var rightVC : HJiaoHaoRightViewController?
    var editFinished : ((Void)->Void)?
    
    @IBOutlet weak var titleLabel : UILabel!
    
    var jiaohao : CDHJiaoHao?
    {
        didSet
        {
            self.rightVC?.jiaohao = jiaohao
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.titleLabel.text = self.jiaohao?.customer_name
        self.registerNofitification(forMainThread: kBSPrinterSuccessResponse)
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kBSPrinterSuccessResponse )
        {
            self.view.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is HJiaoHaoRightViewController
        {
            self.rightVC = segue.destination as? HJiaoHaoRightViewController
            self.rightVC?.jiaohao = jiaohao
        }
    }
    
    @IBAction func didCancelButtonPressed(_ sender : UIButton)
    {
        self.view.removeFromSuperview()
        BSCoreDataManager.current().rollback()
    }
    
    @IBAction func didOkButtonPressed(_ sender : UIButton)
    {
        if let cancel = self.jiaohao?.willCancel, cancel == true
        {
            let alert = UIAlertController(title: nil, message: "确定要取消吗?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                self.sendModifyRequest()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            sendModifyRequest()
        }
    }
    
    @IBAction func didPrintButtonPressed(_ sender : UIButton)
    {
        if let url = PersonalProfile.current().printUrl , url.characters.count > 0
        {
            let request = BSPrintPosOperateRequestNew()
            self.jiaohao?.print_url = url
            request.jiaohao = self.jiaohao
            request.execute()
        }
        else
        {
            let printSet = PrintSettingView()
            printSet.show()
//            let alert = UIAlertController(title: nil, message: "请在后台配置打印机地址", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
//
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func sendModifyRequest()
    {
        CBLoadingView.share().show()
        let request = JumpWorkFlowRequest()
        if let cancel = self.jiaohao?.willCancel, cancel == true
        {
            request.params["is_cancel"] = true
        }
        if let doctorID = self.jiaohao?.doctor_id
        {
            request.params["doctor_id"] = doctorID
        }
        if let peitaiNurseID = self.jiaohao?.peitai_nurse_id
        {
            request.params["peitai_nurse_id"] = peitaiNurseID
        }
        if let xunhuiNurseID = self.jiaohao?.xunhui_nurse_id
        {
            request.params["xunhui_nurse_id"] = xunhuiNurseID
        }
        if let anesthetistId = self.jiaohao?.anesthetist_id
        {
            request.params["anesthetist_id"] = anesthetistId
        }
        if let departmentID = self.jiaohao?.departments_id
        {
            request.params["departments_id"] = departmentID
        }
        
        if let member_type = self.jiaohao?.member_type,member_type.characters.count > 0
        {
            request.params["member_type"] = member_type
        }
        
        if let queueno = self.jiaohao?.queue_no, queueno.characters.count > 0
        {
            request.params["queue_no"] = queueno
        }
        
        request.params["member_id"] = self.jiaohao?.customer_id
        request.params["operate_id"] = self.jiaohao?.jiaohao_id
        request.params["operate_activity_id"] = self.jiaohao?.current_workflow_activity_id
        request.params["operate_employee_ids"] = self.jiaohao?.operate_employee_ids
        
        request.execute()
        request.finished = { [weak self](params) in
            CBLoadingView.share().hide()
            if let result = params?["rc"] as? Int, result == 0
            {
                CBMessageView(title: "修改成功").show()
                self?.editFinished?()
                self?.view.removeFromSuperview()
            }
            else
            {
                CBMessageView(title: params?["rm"] as! String).show()
            }
        }
    }
}
