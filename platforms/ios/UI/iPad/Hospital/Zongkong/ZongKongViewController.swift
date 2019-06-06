//
//  ZongKongViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit

class ZongKongViewController: ICCommonViewController,UIAlertViewDelegate
{
    @IBOutlet weak var zixunView : QiantaiFenzhenCommonView!
    @IBOutlet weak var bingfangView : BingFangCommonView!
    @IBOutlet weak var shoushuView : ZongkongShoushuView!
    @IBOutlet weak var doctorView : ZongkongDoctorView!
    @IBOutlet weak var liyuanView : ZongkongLiyuanView!
    @IBOutlet weak var selectTimeView : QiantaiFenzhenEditRoomView!
    @IBOutlet weak var tabImage: UIImageView!
    var selectedMember : CDMember?
    var selectTimeVC : QiantaiFenzhenSelectTimeViewController!
    var zhuyuanView : UIView!
    var centerView : UIView!
    var huliLevel = 0
    var noteView : UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.zixunView.didItemMoveFinished = {[weak self] (room, book) in
            if let r = room.is_recycle, r.boolValue
            {
                let request = EditHQiantiFenzhenRoomRequest()
                request.params["reservation_id"] = book.book_id
                request.params["room_id"] = room.room_id
                request.execute()
            }
            else
            {
                self?.selectTimeView.show()
                self?.selectTimeVC.book = book
                self?.selectTimeView.edidRoomFinsihed = {
                    let info = self?.selectTimeVC.selectInfo
                    if info?.shejishi == 0
                    {
                        let v = UIAlertView(title: "", message: "请选择设计师", delegate: nil, cancelButtonTitle: "好的")
                        v.show()
                    }
                    else
                    {
                        let request = EditHQiantiFenzhenRoomRequest()
                        request.params["reservation_id"] = book.book_id
                        request.params["designers_id"] = info?.shejishi
                        request.params["director_employee_id"] = info?.shejizongjian
                        request.params["customer_state"] = info?.state
                        request.params["start_time"] = info?.date
                        request.params["room_id"] = room.room_id
                        request.execute()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"HideFenZhen"), object: nil)
                        self?.selectTimeVC.clear()
                    }
                }
            }
        }
        
        self.zixunView.didDaodianButtonPressed = {[weak self] (member) in
            self?.selectedMember = member
        }
        
        self.zixunView.wanshanxinxiButtonPressed = {[weak self] (member) in
            self?.wanshanxinxi(member)
        }

        self.bingfangView.didItemMoveFinished = {[weak self] (room, book) in
            print("room.is_recycle = \(String(describing: room.is_recycle))")
            if let r = room.is_recycle, r.boolValue
            {
                let request = EditHQiantiFenzhenRoomRequest()
                request.params["reservation_id"] = book.book_id
                request.params["room_id"] = room.room_id
                request.execute()
            }
            else
            {
                print("咨询室使用状态\(room.state)")
                self?.addZhuyuanView()
                //咨询室使用状态Optional("使用中")
                
                
                //                self?.selectTimeView.show()
                //                self?.selectTimeVC.book = book
                //                self?.selectTimeView.edidRoomFinsihed = {
                //                    let info = self?.selectTimeVC.selectInfo
                //                    let request = EditHQiantiFenzhenRoomRequest()
                //                    request.params["reservation_id"] = book.book_id
                //                    request.params["designers_id"] = info?.shejishi
                //                    request.params["director_employee_id"] = info?.shejizongjian
                //                    request.params["customer_state"] = info?.state
                //                    request.params["start_time"] = info?.date
                //                    request.params["room_id"] = room.room_id
                //                    request.execute()
                //
                //                    //                    if room.state == "使用中" {
                //                    //                        print("咨询室使用状态是 \(room.state)")
                //                    //                    }else {
                //                    //                        request.execute()
                //                    //                    }
                //                    self?.selectTimeVC.clear()
                //                }
            }
        }
        
        FetchHQiantaiFenzhenReservationsRequest().execute()
        FetchHQiantaiFenzhenRoomRequest().execute()
        
        self.registerNofitification(forMainThread: kEditZixunRoomResponse)
        self.registerNofitification(forMainThread: kQiantaiBookSignResponse)
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kEditZixunRoomResponse )
        {
            if let result = notification.userInfo?["rc"] as? Int, result == 0
            {
                
            }
            else
            {
                CBMessageView(title: notification.userInfo?["rm"] as! String).show()
            }
            
            FetchHQiantaiFenzhenReservationsRequest().execute()
            FetchHQiantaiFenzhenRoomRequest().execute()
        }
        else if ( notification.name.rawValue == kQiantaiBookSignResponse )
        {
            if let result = notification.userInfo?["rc"] as? Int, result == 0
            {
                let v = UIAlertView(title: "", message: "是否现在完善客户信息", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
                v.show()
            }
            else
            {
                CBMessageView(title: notification.userInfo?["rm"] as! String).show()
            }
            
            FetchHQiantaiFenzhenReservationsRequest().execute()
            FetchHQiantaiFenzhenRoomRequest().execute()
            
            CBLoadingView.share().hide()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            wanshanxinxi(self.selectedMember)
        }
    }
    
    func wanshanxinxi(_ member : CDMember?)
    {
        var viewController : PadMemberCreateViewController!
        if let m = member
        {
            if let name = member?.memberName, name.characters.count > 0
            {
                viewController = PadMemberCreateViewController(member: m)
            }
            else
            {
                CBLoadingView.share().show()
                let request = BSFetchMemberDetailRequest(member: m)
                request?.onlyMemberInfo = true
                request?.finished = { [weak self] dict in
                    CBLoadingView.share().hide()
                    if let name = m.memberName, name.characters.count > 0
                    {
                        self?.wanshanxinxi(m)
                    }
                    else
                    {
                        CBMessageView(title: "获取会员信息失败").show()
                    }
                }
                request?.execute()
                return
            }
        }
        else
        {
            viewController = PadMemberCreateViewController()
        }
        
        let maskView = PadMaskView(frame: self.view.bounds)
        self.view.addSubview(maskView)
        viewController.maskView = maskView
        maskView.navi = CBRotateNavigationController(rootViewController: viewController)
        maskView.navi.isNavigationBarHidden = true
        maskView.navi.view.frame = self.view.bounds
        maskView.addSubview(maskView.navi.view)
        maskView.show();
    }
    
    @IBAction func didCreateBookPressed(_ sender: UIButton)
    {
        let vc = PadBookMainViewController(nibName: "PadBookMainViewController", bundle: nil)
        vc.isCloseButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination.isKind(of: QiantaiFenzhenSelectTimeViewController.self)
        {
            self.selectTimeVC = segue.destination as! QiantaiFenzhenSelectTimeViewController
        }
    }
    
    @IBAction func viewSelectInSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.zixunView.isHidden = false
            self.shoushuView.isHidden = true
            self.doctorView.isHidden = true
            self.bingfangView.isHidden = true
        case 1:
            self.zixunView.isHidden = true
            self.shoushuView.isHidden = false
            self.doctorView.isHidden = true
            self.bingfangView.isHidden = true
            self.zixunView.roomView.closeDetail()
        case 2:
            self.zixunView.isHidden = true
            self.shoushuView.isHidden = true
            self.doctorView.isHidden = false
            self.bingfangView.isHidden = true
            self.zixunView.roomView.closeDetail()
        case 3:
            self.zixunView.isHidden = true
            self.shoushuView.isHidden = true
            self.doctorView.isHidden = true
            self.bingfangView.isHidden = false
            self.zixunView.roomView.closeDetail()
        default:
            return
        }
    }
    
    @IBAction func didZixunViewPressed(_ sender : UIButton)
    {
        self.zixunView.isHidden = false
        self.shoushuView.isHidden = true
        self.liyuanView.isHidden = true
        self.tabImage.image = #imageLiteral(resourceName: "zongkong_bg_0.png")
    }
    
    @IBAction func didShoushuViewPressed(_ sender : UIButton)
    {
        self.zixunView.isHidden = true
        self.shoushuView.isHidden = false
        self.liyuanView.isHidden = true
        self.tabImage.image = #imageLiteral(resourceName: "zongkong_bg_1.png")
    }
    
    @IBAction func didLiyuanViewPressed(_ sender : UIButton)
    {
        self.zixunView.isHidden = true
        self.shoushuView.isHidden = true
        self.liyuanView.isHidden = false
        self.tabImage.image = #imageLiteral(resourceName: "zongkong_bg_2.png")
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    func addZhuyuanView()
    {
        if (self.zhuyuanView == nil)
        {
            self.zhuyuanView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
            self.zhuyuanView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
            
            self.centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
            self.centerView.backgroundColor = UIColor.white
            let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
            naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
            self.centerView.addSubview(naviView)
            
            let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
            closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: UIControlState.normal)
            closeButton.addTarget(self, action:#selector(BingFangMainViewController.closeMask), for: UIControlEvents.touchUpInside)
            self.centerView.addSubview(closeButton)
            
            let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 72))
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.text = "安排病房"
            self.centerView.addSubview(titleLabel)
            
            let confirmButton = UIButton(frame: CGRect(x: 624, y: 0, width: 100, height: 72))
            confirmButton.setTitle("确定", for: UIControlState.normal)
            confirmButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            confirmButton.addTarget(self, action: #selector(BingFangMainViewController.confirm), for: UIControlEvents.touchUpInside)
            self.centerView.addSubview(confirmButton)
            
            let titleColor = RGB(r: 149, g: 171, b: 171)
            let borderColor = RGB(r: 220, g: 224, b: 224)
            
            let huliLabel = UILabel(frame: CGRect(x: 65, y: 100, width: 324, height: 22))
            huliLabel.text = "护理级别"
            huliLabel.font = UIFont.systemFont(ofSize: 16)
            huliLabel.textColor = titleColor
            self.centerView.addSubview(huliLabel)
            
            let huliView = UIView(frame: CGRect(x: 65, y: 135, width: 594, height: 60))
            huliView.layer.cornerRadius = 6
            huliView.layer.borderColor = borderColor.cgColor
            huliView.layer.borderWidth = 1
            let line1 = UIView(frame: CGRect(x: 198, y: 0, width: 1, height: 60))
            line1.backgroundColor = borderColor
            huliView.addSubview(line1)
            let line2 = UIView(frame: CGRect(x: 396, y: 0, width: 1, height: 60))
            line2.backgroundColor = borderColor
            huliView.addSubview(line2)
            huliView.tag = 10
            let chineseList = ["一级护理","二级护理","三级护理"]
            for i in 0..<3
            {
                let levelImage = UIImageView(frame: CGRect(x: 198*i+50, y: 21, width: 18, height: 18))
                levelImage.tag = i+100
                if (i == self.huliLevel)
                {
                    levelImage.image = UIImage(named: "pad_huli_level_\(i)_h")
                }
                else
                {
                    levelImage.image = UIImage(named: "pad_huli_level_\(i)_n")
                }
                huliView.addSubview(levelImage)
                
                let levelLabel = UILabel(frame: CGRect(x: 198*i+50, y: 0, width: 151, height: 60))
                levelLabel.text = chineseList[i]
                levelLabel.textAlignment = .center
                huliView.addSubview(levelLabel)
                
                let levelButton = UIButton(frame: CGRect(x: 198*i, y: 0, width: 198, height: 60))
                levelButton.tag = i
                levelButton.addTarget(self, action: #selector(BingFangMainViewController.levelSelected(_:)), for: UIControlEvents.touchUpInside)
                huliView.addSubview(levelButton)
            }
            
            self.centerView.addSubview(huliView)
            
            let nurseLabel = UILabel(frame: CGRect(x: 65, y: 220, width: 324, height: 22))
            nurseLabel.text = "负责护士"
            nurseLabel.font = UIFont.systemFont(ofSize: 16)
            nurseLabel.textColor = titleColor
            self.centerView.addSubview(nurseLabel)
            let nurseButton = UIButton(frame: CGRect(x: 65, y: 255, width: 594, height: 60))
            nurseButton.layer.cornerRadius = 6
            nurseButton.layer.borderColor = borderColor.cgColor
            nurseButton.layer.borderWidth = 1
            nurseButton.setTitle("请选择…", for: .normal)
            nurseButton.addTarget(self, action: #selector(BingFangMainViewController.nurseSelected), for: .touchUpInside)
            self.centerView.addSubview(nurseButton)
            
            let doctorLabel = UILabel(frame: CGRect(x: 65, y: 340, width: 324, height: 22))
            doctorLabel.text = "负责医生"
            doctorLabel.font = UIFont.systemFont(ofSize: 16)
            doctorLabel.textColor = titleColor
            self.centerView.addSubview(doctorLabel)
            let doctorButton = UIButton(frame: CGRect(x: 65, y: 375, width: 594, height: 60))
            doctorButton.layer.cornerRadius = 6
            doctorButton.layer.borderColor = borderColor.cgColor
            doctorButton.layer.borderWidth = 1
            doctorButton.setTitle("请选择…", for: .normal)
            doctorButton.setTitleColor(RGB(r: 37, g: 37, b: 37), for: .normal)
            doctorButton.addTarget(self, action: #selector(BingFangMainViewController.doctorSelected), for: .touchUpInside)
            self.centerView.addSubview(doctorButton)
            
            let dateLabel = UILabel(frame: CGRect(x: 65, y: 460, width: 324, height: 22))
            dateLabel.text = "住院日期"
            dateLabel.font = UIFont.systemFont(ofSize: 16)
            dateLabel.textColor = titleColor
            self.centerView.addSubview(dateLabel)
            let zhuyuanTime = UILabel(frame: CGRect(x: 65, y: 495, width: 594, height: 60))
            zhuyuanTime.text = "03-23 12:20"
            zhuyuanTime.textColor = RGB(r: 37, g: 37, b: 37)
            zhuyuanTime.textAlignment = .center
            zhuyuanTime.layer.cornerRadius = 6
            zhuyuanTime.layer.borderColor = borderColor.cgColor
            zhuyuanTime.layer.borderWidth = 1
            self.centerView.addSubview(zhuyuanTime)
            
            let noteLabel = UILabel(frame: CGRect(x: 65, y: 580, width: 324, height: 22))
            noteLabel.text = "主治医生意见"
            noteLabel.font = UIFont.systemFont(ofSize: 16)
            noteLabel.textColor = titleColor
            self.centerView.addSubview(noteLabel)
            noteView = UITextView(frame: CGRect(x: 65, y: 615, width: 594, height: 120))
            noteView.layer.cornerRadius = 6
            noteView.layer.borderColor = borderColor.cgColor
            noteView.layer.borderWidth = 1
            self.centerView.addSubview(noteView)
            
            self.zhuyuanView.addSubview(self.centerView)
            self.view.addSubview(self.zhuyuanView)
        }
        else
        {
            let huliView = self.centerView.viewWithTag(10)
            for i in 0..<3
            {
                let levelImage = huliView?.viewWithTag(i+100) as! UIImageView
                if (i == self.huliLevel)
                {
                    levelImage.image = UIImage(named: "pad_huli_level_\(i)_h")
                }
                else
                {
                    levelImage.image = UIImage(named: "pad_huli_level_\(i)_n")
                }
            }
        }
    }
    
    func closeMask()
    {
        if (self.zhuyuanView != nil)
        {
            self.zhuyuanView.removeFromSuperview()
        }
    }
    
    func confirm()
    {
        self.closeMask()
    }
    
    func levelSelected(_ sender : UIButton)
    {
        self.huliLevel = sender.tag
        self.addZhuyuanView()
    }
    
    func nurseSelected()
    {
        
    }
    
    func doctorSelected()
    {
        
    }
    
    func dateSelected()
    {
        
    }
}
