//
//  YimeiHistoryDetailViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/27.
//
//

import UIKit

class YimeiHistoryDetailViewController: ICCommonViewController
{
    @IBOutlet weak var leftView : YimeiHistoryDetailLeftView!
    @IBOutlet weak var rightView : YimeiHistoryDetailRightView!
    var rightDetailTableVC : YimeiHistoryDetailRightRemarkViewController!
    
    var history : CDYimeiHistory!
    var operate_id : NSNumber!
    var member_id :NSNumber!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.leftView.didDeletePressed = {[weak self] item in
            let alert = UIAlertController(title: nil, message: "确定要删除吗? 删除后不能恢复", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                let request = BSDeleteOperateItemRequest()
                request.operateID = item.history?.operate_id
                request.params = ["comsume_line_id": item.itemID as Any, "operate_id": item.history?.operate_id as Any]
                request.execute()
                request.finished = {[weak self] dict in
                    if let result = dict?["rc"] as? Int, result == 0
                    {
                        CBMessageView(title: "修改成功").show()
                        self?.fetchData()
                        //self?.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        CBMessageView(title: dict?["rm"] as! String).show()
                    }
                }
            }))
            self?.present(alert, animated: true, completion: nil)
        }
        
        self.reloadData()
        
        //BSFetchMemberCardDetailRequest(memberCardID: self.history.card_id).execute()
        if (self.history != nil)
        {
            if let memberID = self.history.member_id
            {
                BSFetchMemberDetailRequestN(memberID: memberID).execute()
            }
        }
        else
        {
            if let memberID = self.member_id
            {
                BSFetchMemberDetailRequestN(memberID: memberID).execute()
            }
        }
        
        self.registerNofitification(forMainThread: kEidtPosOperateResponse)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.fetchData()
    }
    
    func fetchData()
    {
        CBLoadingView.share().show()
        let request = FetchYimeiHistoryDetailRequest()
        if (self.history != nil)
        {
            request.history = self.history
        }
        if (self.operate_id != nil)
        {
            request.operate_id = self.operate_id
        }
        request.execute()
        request.finished = {[weak self] _ in
            self?.reloadData()
            CBLoadingView.share().hide()
        }
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kEidtPosOperateResponse )
        {
            if let result = notification.userInfo?["rc"] as? Int, result == 0
            {
                CBMessageView(title: "修改成功").show()
            }
            else
            {
                CBMessageView(title: notification.userInfo?["rm"] as! String).show()
            }
        }
    }
    
    func reloadData()
    {
        self.leftView.history = self.history
        self.rightView.history = self.history
        self.rightDetailTableVC.history = self.history
    }
    
    @IBAction func didCancelButtonPressed(_ sender : UIButton)
    {
        guard  let note = self.history?.note, note.characters.count > 0 else {
            let alert = UIAlertController(title: nil, message: "请填写财务备注", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "我知道了", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    
        let alert = UIAlertController(title: nil, message: "确定要撤销单据吗?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            let request = BSPosOperateCancelRequest()
            request.params = ["note": self.history?.note as Any, "operate_id": self.history?.operate_id as Any]
            request.operateID = self.history?.operate_id
            request.execute()
            request.finished = {[weak self] dict in
                if let result = dict?["rc"] as? Int, result == 0
                {
                    CBMessageView(title: "修改成功").show()
                    self?.history.state = "cancel"
                    BSCoreDataManager.current().save()
                    self?.navigationController?.popViewController(animated: true)
                }
                else
                {
                    CBMessageView(title: dict?["rm"] as! String).show()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didBackButtonPressed(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didNotOperateButtonPressed(_ sender : UIButton)
    {
        let alert = UIAlertController(title: nil, message: "确定今天不再操作该单据吗?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            self.doNotOperate()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func doNotOperate()
    {
        let request = JumpWorkFlowRequest()
        request.params["is_cancel"] = true
        request.params["operate_id"] = history.operate_id
        request.execute()
        request.finished = { [weak self](params) in
            if let result = params?["rc"] as? Int, result == 0
            {
                CBMessageView(title: "修改成功").show()
                self?.navigationController?.popViewController(animated: true)
            }
            else
            {
                CBMessageView(title: params?["rm"] as! String).show()
            }
        }
    }
    
    @IBAction func didAddItemButtonPressed(_ sender : UIButton)
    {
        if let progre_status = self.history.progre_status, progre_status == "done"
        {
            CBMessageView(title: "已完成的单据，无法添加项目").show()
            return
        }
        
        let memberCard : CDMemberCard? = BSCoreDataManager.current().findEntity("CDMemberCard", withValue: self.history.card_id, forKey: "cardID") as? CDMemberCard
        let vc = PadProjectViewController(memberCard: memberCard, couponCard: nil, handno: nil)
        vc.isGuadan = self.history.is_post_checkout?.boolValue ?? false
        vc.isGuadanAddItem = true//实为isAddItem，isGuadanAddItem由两者一同判断
//        if self.history.is_checkout?.boolValue ?? false && vc.isGuadan
//        {
//            vc.isGuadanAddItem = true
//        }
//        else
//        {
//            vc.isGuadanAddItem = false
//        }
        vc.orignalOperateID = self.history.operate_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is YimeiHistoryDetailRightRemarkViewController
        {
            self.rightDetailTableVC = segue.destination as! YimeiHistoryDetailRightRemarkViewController
        }
    }
    
    deinit {
        print("12")
    }
}
