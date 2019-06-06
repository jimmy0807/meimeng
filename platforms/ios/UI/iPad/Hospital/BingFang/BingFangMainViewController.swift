//
//  BingFangMainViewController.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/9.
//

import UIKit

class BingFangMainViewController: ICCommonViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var searchBar : UISearchBar!
    //@IBOutlet weak var selectTimeView : BingFangEditRoomView!
    @IBOutlet weak var commonView : BingFangCommonView!
    //var selectTimeVC : QiantaiFenzhenSelectTimeViewController!
    var selectedMember : CDMember?
    var zhuyuanView : UIView!
    var centerView : UIView!
    var huliLevel = 0
    var noteView : UITextView!
    var selectedTime = ""
    var selectedDate = Date()
    var selectVC : SeletctListViewController?
    var nurseName : String!
    var nurseId : NSNumber!
    var nurseButton : UIButton!
    var doctorName : String!
    var doctorId : NSNumber!
    var doctorButton : UIButton!
    var timeButton : UIButton!
    var currentBook : CDBingFangBook!
    var currentRoom : CDBingfangRoom!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.layer.borderColor = RGB(r: 237, g: 237, b: 237).cgColor
        searchBar.backgroundImage = UIImage(named: "pad_background_white_color")?.imageResizable(withCapInsets: UIEdgeInsetsMake(12, 12, 12, 12))
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "pad_member_search_field")?.imageResizable(withCapInsets: UIEdgeInsetsMake(12, 12, 12, 12)), for: .normal)
        
        self.commonView.didItemMoveFinished = {[weak self] (room, book) in
            print("\(room),\(room.room_id)")
            if room.member_id != nil && room.member_id?.intValue != 0
            {
                let v = UIAlertView(title: "", message: "该病房已有人", delegate: self, cancelButtonTitle: "好的")
                v.show()
            }
            
            self?.currentBook = book
            self?.currentRoom = room
            self?.addZhuyuanView()

//            if let r = room.is_recycle, r.boolValue
//            {
//                let request = WenZhenAnpaiRoomRequest()
////                operate_id
////                member_id
////                nursing_level
////                nurse_id
////                doctors_id
////                check_in_date
////                doctor_note
////                request.params["operate_id"] = book.book_id
////                request.params["member_id"] = room.room_id
//                request.execute()
//            }
//            else
//            {
//                print("咨询室使用状态\(room.state)")
//                self?.addZhuyuanView()
//                //咨询室使用状态Optional("使用中")
//
//
////                self?.selectTimeView.show()
////                self?.selectTimeVC.book = book
////                self?.selectTimeView.edidRoomFinsihed = {
////                    let info = self?.selectTimeVC.selectInfo
////                    let request = EditHQiantiFenzhenRoomRequest()
////                    request.params["reservation_id"] = book.book_id
////                    request.params["designers_id"] = info?.shejishi
////                    request.params["director_employee_id"] = info?.shejizongjian
////                    request.params["customer_state"] = info?.state
////                    request.params["start_time"] = info?.date
////                    request.params["room_id"] = room.room_id
////                    request.execute()
////
////                    //                    if room.state == "使用中" {
////                    //                        print("咨询室使用状态是 \(room.state)")
////                    //                    }else {
////                    //                        request.execute()
////                    //                    }
////                    self?.selectTimeVC.clear()
////                }
//            }
        }
        
//        self.commonView.didDaodianButtonPressed = {[weak self] (member) in
//            self?.selectedMember = member
//        }
        
//        self.commonView.wanshanxinxiButtonPressed = {[weak self] (member) in
//            self?.wanshanxinxi(member)
//        }
        
        
        
        self.registerNofitification(forMainThread: "BingfangFetchResponse")
        self.registerNofitification(forMainThread: "BingfangRoomsFetchResponse")
        self.registerNofitification(forMainThread: "WenZhenDidChanged")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FetchBingfangRequest().execute()
        FetchBingfangRoomsRequest().execute()
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
                //print(notification.userInfo!["rm"])
                //Optional(房间使用中无法进入)
                //填了时间 就不会有提示
                CBMessageView(title: notification.userInfo?["rm"] as! String).show()
            }
            
            FetchBingfangRoomsRequest().execute()
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
            
            FetchBingfangRoomsRequest().execute()
            
            CBLoadingView.share().hide()
        }
//        else if ( notification.name.rawValue == "BingfangRoomsFetchResponse" )
//        {
//
//        }
        else if ( notification.name.rawValue == "WenZhenDidChanged" )
        {
            FetchBingfangRequest().execute()
            FetchBingfangRoomsRequest().execute()
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
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.commonView.didSearchBarTextChanged(searchBar.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //if segue.destination is QiantaiFenzhenSelectTimeViewController 也可以
//        if segue.destination.isKind(of: QiantaiFenzhenSelectTimeViewController.self)
//        {
//            self.selectTimeVC = segue.destination as! QiantaiFenzhenSelectTimeViewController
//        }
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    func addZhuyuanView()
    {
        if currentBook.nursing_level == "level1"
        {
            self.huliLevel = 0
        }
        else if currentBook.nursing_level == "level2"
        {
            self.huliLevel = 1
        }
        else if currentBook.nursing_level == "level3"
        {
            self.huliLevel = 2
        }
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
            nurseButton = UIButton(frame: CGRect(x: 65, y: 255, width: 594, height: 60))
            nurseButton.layer.cornerRadius = 6
            nurseButton.layer.borderColor = borderColor.cgColor
            nurseButton.layer.borderWidth = 1
            if currentBook.nurse_name == ""
            {
                nurseButton.setTitle("请选择…", for: .normal)
            }
            else
            {
                nurseId = currentBook.nurse_id
                nurseButton.setTitle(currentBook.nurse_name, for: .normal)
            }
            nurseButton.setTitleColor(RGB(r: 37, g: 37, b: 37), for: .normal)
            nurseButton.addTarget(self, action: #selector(BingFangMainViewController.nurseSelected), for: .touchUpInside)
            self.centerView.addSubview(nurseButton)
            
            let doctorLabel = UILabel(frame: CGRect(x: 65, y: 340, width: 324, height: 22))
            doctorLabel.text = "负责医生"
            doctorLabel.font = UIFont.systemFont(ofSize: 16)
            doctorLabel.textColor = titleColor
            self.centerView.addSubview(doctorLabel)
            doctorButton = UIButton(frame: CGRect(x: 65, y: 375, width: 594, height: 60))
            doctorButton.layer.cornerRadius = 6
            doctorButton.layer.borderColor = borderColor.cgColor
            doctorButton.layer.borderWidth = 1
            if currentBook.doctor_name == ""
            {
                doctorButton.setTitle("请选择…", for: .normal)
            }
            else
            {
                doctorId = currentBook.doctor_id
                doctorButton.setTitle(currentBook.doctor_name, for: .normal)
            }
            doctorButton.setTitleColor(RGB(r: 37, g: 37, b: 37), for: .normal)
            doctorButton.addTarget(self, action: #selector(BingFangMainViewController.doctorSelected), for: .touchUpInside)
            self.centerView.addSubview(doctorButton)
            
            let dateLabel = UILabel(frame: CGRect(x: 65, y: 460, width: 324, height: 22))
            dateLabel.text = "住院日期"
            dateLabel.font = UIFont.systemFont(ofSize: 16)
            dateLabel.textColor = titleColor
            self.centerView.addSubview(dateLabel)
            timeButton = UIButton(frame: CGRect(x: 65, y: 495, width: 594, height: 60))
            if currentBook.start_date == ""
            {
                timeButton.setTitle("请选择…", for: .normal)
            }
            else
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: currentBook.start_date!)
                timeButton.setTitle(formatDate(date!), for: .normal)
            }
            timeButton.layer.cornerRadius = 6
            timeButton.layer.borderColor = borderColor.cgColor
            timeButton.layer.borderWidth = 1
            timeButton.setTitleColor(RGB(r: 37, g: 37, b: 37), for: .normal)
            timeButton.addTarget(self, action: #selector(self.selectTime), for: .touchUpInside)
            self.centerView.addSubview(timeButton)
            
            let noteLabel = UILabel(frame: CGRect(x: 65, y: 580, width: 324, height: 22))
            noteLabel.text = "主治医师意见"
            noteLabel.font = UIFont.systemFont(ofSize: 16)
            noteLabel.textColor = titleColor
            self.centerView.addSubview(noteLabel)
            noteView = UITextView(frame: CGRect(x: 65, y: 615, width: 594, height: 120))
            noteView.layer.cornerRadius = 6
            noteView.layer.borderColor = borderColor.cgColor
            noteView.layer.borderWidth = 1
            noteView.text = currentBook.doctors_note
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
            self.zhuyuanView = nil
        }
    }
    
    func confirm()
    {
        if doctorId == nil
        {
            let alert = UIAlertView(title: "请选择负责医生", message: nil, delegate: nil, cancelButtonTitle: "好的")
            alert.show()
            return
        }
        if nurseId == nil
        {
            let alert = UIAlertView(title: "请选择负责护士", message: nil, delegate: nil, cancelButtonTitle: "好的")
            alert.show()
            return
        }
        let request = WenZhenAnpaiRoomRequest()
        //                operate_id
        if huliLevel == 0
        {
            request.params["nursing_level"] = "level1"
        }
        else if huliLevel == 1
        {
            request.params["nursing_level"] = "level2"
        }
        else if huliLevel == 2
        {
            request.params["nursing_level"] = "level3"
        }
        request.params["nurse_id"] = nurseId
        request.params["doctors_id"] = doctorId
        request.params["check_in_date"] = formatDateToPost(selectedDate)
        request.params["doctors_note"] = noteView.text
        //request.params["operate_id"] = currentBook.book_id
        request.params["hospitalized_id"] = currentBook.book_id
        request.params["bed_id"] = currentRoom.room_id
        request.execute()
        self.closeMask()
    }
    
    func levelSelected(_ sender : UIButton)
    {
        self.huliLevel = sender.tag
        self.updateZhuyuanView()
    }
    
    func updateZhuyuanView()
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
    
    func nurseSelected()
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let nurseArray = BSCoreDataManager.current().fetchOperateStaffs(withShopID: PersonalProfile.current().bshopId)
        self.selectVC?.countOfTheList = {
            return nurseArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            return nurseArray[index].name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            self?.nurseId = nurseArray[index].staffID
            self?.nurseName = nurseArray[index].name
            self?.nurseButton.setTitle(self?.nurseName, for: .normal)
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    func doctorSelected()
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let doctorArray = BSCoreDataManager.current().fetchDoctorStaffs(withShopID: PersonalProfile.current().bshopId)
        self.selectVC?.countOfTheList = {
            return doctorArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            return doctorArray[index].name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            self?.doctorId = doctorArray[index].staffID
            self?.doctorName = doctorArray[index].name
            self?.doctorButton.setTitle(self?.doctorName, for: .normal)
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    func formatDate(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        return dateFormatter.string(from:date)
    }
    
    func formatDateToPost(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return dateFormatter.string(from:date)
    }
    
    func selectTime()
    {
        let datePicker = PadDatePickerView()
        datePicker.datePickerMode = .dateAndTime
        datePicker.selectFinished = {[weak self] (date) in
            self?.selectedDate = date!
            self?.selectedTime = (self?.formatDate(date!))!
            self?.timeButton.setTitle(self?.selectedTime, for: .normal)
        }
        //datePicker.addTarget(self, action: #selector(self.dateChanged(datePicker:)),for: .valueChanged)
        self.view.addSubview(datePicker)
    }
    
    func dateChanged(datePicker : UIDatePicker){
        selectedTime = formatDate(datePicker.date)
        timeButton.setTitle(selectedTime, for: .normal)
    }
    
    func dateSelected()
    {
        
    }
}

