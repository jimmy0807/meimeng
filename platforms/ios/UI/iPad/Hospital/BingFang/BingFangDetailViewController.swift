//
//  BingFangDetailViewController.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/12.
//

import UIKit

class BingFangDetailViewController: ICCommonViewController{//}, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var bingfangNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var xingzuoLabel: UILabel!
    @IBOutlet weak var xuexingLabel: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var customerStateLabel: UILabel!
    @IBOutlet weak var huliLevelLabel: UILabel!
    @IBOutlet weak var nurseLabel: UILabel!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var zhuyuanInfoView: BingfangZhuyuanInfoView!
    @IBOutlet weak var zhuyuanListView: BingfangZhuyuanListView!
    @IBOutlet weak var chakanBingliView: BingfangChakanBIngliView!
    @IBOutlet weak var bingfangZhuyuanInfoRightImage: UIImageView!
    @IBOutlet weak var bingfangZhuyuanListRightImage: UIImageView!
    @IBOutlet weak var bingfangChakanBingliRightImage: UIImageView!
    @IBOutlet weak var zhuyuanInfoLeftView: UIView!
    @IBOutlet weak var zhuyuanListLeftView: UIView!
    @IBOutlet weak var chakanBingliLeftView: UIView!
    @IBOutlet weak var applyCheckoutButton: UIButton!

    public var hospitalized_id : NSNumber!
    public var member_id : NSNumber!
    var baseInfoDict : NSDictionary!
    var checkoutView : UIView!
    var qingkuangTextView : UITextView!
    var qingkuangString = ""
    var yizhuTextView : UITextView!
    var yizhuString = ""
    var state = ""
    var selectVC : SeletctListViewController?
    var nurseId : NSNumber!
    var doctorId : NSNumber!
    var bedId : NSNumber!
    var operateId : NSNumber!

    override func viewDidLoad() {
        super.viewDidLoad()
        zhuyuanInfoView.isHidden = false
        zhuyuanListView.isHidden = true
        chakanBingliView.isHidden = true
        bingfangZhuyuanInfoRightImage.isHidden = false
        bingfangZhuyuanListRightImage.isHidden = true
        bingfangChakanBingliRightImage.isHidden = true
        zhuyuanInfoLeftView.backgroundColor = RGB(r: 239, g: 242, b: 242)
        zhuyuanListLeftView.backgroundColor = UIColor.white
        chakanBingliLeftView.backgroundColor = UIColor.white
        
        self.registerNofitification(forMainThread: "BingfangRoomDetailFetchResponse")
        self.registerNofitification(forMainThread: "BingfangRoomPosDetailFetchResponse")
        self.registerNofitification(forMainThread: "ApplyCheckOutResponse")
        self.registerNofitification(forMainThread: "BingfangCheckOutResponse")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let request = FetchBingfangRoomDetailRequest()
        request.params["hospitalized_id"] = hospitalized_id
        if operateId != nil
        {
            request.params["operate_id"] = operateId
        }
        request.execute()
        let requestPos = FetchBingfangRoomPosDetailRequest()
        requestPos.params["hospitalized_id"] = hospitalized_id
        requestPos.execute()
        let listRequest = GetMedicalRecordRequest()
        listRequest.params["member_id"] = member_id
        if operateId != nil
        {
            listRequest.params["operate_id"] = operateId
        }
        listRequest.execute()
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "BingfangRoomDetailFetchResponse" )
        {
            if let dict = notification.userInfo!["data"] as? NSDictionary
            {
                baseInfoDict = dict.object(forKey: "base_info") as! NSDictionary
                zhuyuanInfoView.hospitalized_id = hospitalized_id
                zhuyuanInfoView.baseInfoDict = baseInfoDict
                zhuyuanInfoView.prescriptionsArray = dict["prescriptions"] as! NSArray
                zhuyuanInfoView.recordsArray = dict["records"] as! NSArray
                print(baseInfoDict)
                bedId = baseInfoDict.object(forKey: "bed_id") as! NSNumber
                bingfangNameLabel.text = (baseInfoDict.object(forKey: "ward_bed_name") as? String) ?? ""
                avatarImageView.sd_setImage(with: URL(string: (baseInfoDict.object(forKey: "member_image_url") as? String) ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                memberNameLabel.text = (baseInfoDict.object(forKey: "customer_name") as? String) ?? ""
                genderLabel.text = "性别：" + ((baseInfoDict.object(forKey: "sex") as? String) ?? "")
                ageLabel.text = "年龄：" + ((baseInfoDict.object(forKey: "age") as? String) ?? "")
                xingzuoLabel.text = "星座：" + ((baseInfoDict.object(forKey: "astro") as? String) ?? "")
                xuexingLabel.text = "血型：" + ((baseInfoDict.object(forKey: "blood_type") as? String) ?? "")
//                vipImageView: UIIm
                customerStateLabel.text = (baseInfoDict.object(forKey: "customer_state_name") as? String) ?? ""
                if customerStateLabel.text == ""
                {
                    customerStateLabel.isHidden = true
                }
                else
                {
                    customerStateLabel.isHidden = false
                }
                huliLevelLabel.text = (baseInfoDict.object(forKey: "nursing_level_name") as? String) ?? ""
                nurseLabel.text = (baseInfoDict.object(forKey: "nurse_name") as? String) ?? ""
                doctorLabel.text = (baseInfoDict.object(forKey: "doctor_name") as? String) ?? ""
                state = baseInfoDict.object(forKey: "hospitalized_state_name") as! String
                if state == "住院中"
                {
                    applyCheckoutButton.isEnabled = true
                    applyCheckoutButton.setTitle("申请出院", for: .normal)
                    applyCheckoutButton.alpha = 1
                }
                else if state == "已申请"
                {
                    applyCheckoutButton.isEnabled = true
                    applyCheckoutButton.setTitle("出院", for: .normal)
                    applyCheckoutButton.alpha = 1
                }
                else
                {
                    applyCheckoutButton.isEnabled = false
                    applyCheckoutButton.alpha = 0.5
                }
                qingkuangString = baseInfoDict.object(forKey: "check_out_note") as! String
                yizhuString = baseInfoDict.object(forKey: "check_out_medical_note") as! String
            }
        }
        else if ( notification.name.rawValue == "BingfangRoomPosDetailFetchResponse" )
        {
            if let dict = notification.userInfo!["data"] as? NSDictionary
            {
                zhuyuanListView.zhuyuanListDict = dict
            }
        }
        else if ( notification.name.rawValue == "GetMedicalRecordResponse" )
        {
            let request = FetchBingfangRoomDetailRequest()
            if operateId != nil
            {
                request.params["operate_id"] = hospitalized_id
            }
            request.params["hospitalized_id"] = hospitalized_id
            request.execute()
        }
        else if ( notification.name.rawValue == "BingfangCheckOutResponse" )
        {
            if let dict = notification.userInfo as? NSDictionary
            {
                let alert = UIAlertController(title: nil, message: "\(dict.object(forKey: "errmsg") ?? "")", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else if ( notification.name.rawValue == "ApplyCheckOutResponse" )
        {
            if let dict = notification.userInfo as? NSDictionary
            {
                if (dict.object(forKey: "errcode") as! Int) == 0
                {
                    state = "已申请"
                    let alert = UIAlertController(title: nil, message: "\(dict.object(forKey: "errmsg") ?? "")", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好的", style: .default, handler: { (action) in
                        self.applyCheckoutButton.setTitle("出院", for: .normal)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "申请失败", message: "\(dict.object(forKey: "errmsg") ?? "")", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    let requestPos = FetchBingfangRoomPosDetailRequest()
                    requestPos.params["hospitalized_id"] = hospitalized_id
                    requestPos.execute()
                }
                
            }
        }
    }
    
    @IBAction func didZhuyuanInfoClicked(_ sender: Any) {
        zhuyuanInfoView.isHidden = false
        zhuyuanListView.isHidden = true
        chakanBingliView.isHidden = true
        bingfangZhuyuanInfoRightImage.isHidden = false
        bingfangZhuyuanListRightImage.isHidden = true
        bingfangChakanBingliRightImage.isHidden = true
        zhuyuanInfoLeftView.backgroundColor = RGB(r: 239, g: 242, b: 242)
        zhuyuanListLeftView.backgroundColor = UIColor.white
        chakanBingliLeftView.backgroundColor = UIColor.white
    }
    
    @IBAction func didZhuyuanListClicked(_ sender: Any) {
        zhuyuanInfoView.isHidden = true
        zhuyuanListView.isHidden = false
        chakanBingliView.isHidden = true
        bingfangZhuyuanInfoRightImage.isHidden = true
        bingfangZhuyuanListRightImage.isHidden = false
        bingfangChakanBingliRightImage.isHidden = true
        zhuyuanInfoLeftView.backgroundColor = UIColor.white
        zhuyuanListLeftView.backgroundColor = RGB(r: 239, g: 242, b: 242)
        chakanBingliLeftView.backgroundColor = UIColor.white
    }
    
    @IBAction func didChakanBingliClicked(_ sender: Any) {
        chakanBingliView.member_id = member_id
        chakanBingliView.operate_id = operateId
        zhuyuanInfoView.isHidden = true
        zhuyuanListView.isHidden = true
        chakanBingliView.isHidden = false
        bingfangZhuyuanInfoRightImage.isHidden = true
        bingfangZhuyuanListRightImage.isHidden = true
        bingfangChakanBingliRightImage.isHidden = false
        zhuyuanInfoLeftView.backgroundColor = UIColor.white
        zhuyuanListLeftView.backgroundColor = UIColor.white
        chakanBingliLeftView.backgroundColor = RGB(r: 239, g: 242, b: 242)
    }
    
    @IBAction func changeNurse(_ sender: Any) {
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
//            self?.nurseName = nurseArray[index].name
            self?.nurseLabel.text = nurseArray[index].name
            self?.update()
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func changeDoctor(_ sender: Any) {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let doctorArray = BSCoreDataManager.current().fetchStaffs(withShopID: PersonalProfile.current().bshopId)
        self.selectVC?.countOfTheList = {
            return doctorArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            return doctorArray[index].name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            self?.doctorId = doctorArray[index].staffID
            self?.doctorLabel.text = doctorArray[index].name
            self?.update()
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    func update()
    {
        let request = WenZhenAnpaiRoomRequest()
        //                operate_id
//        if huliLevel == 0
//        {
//            request.params["nursing_level"] = "level1"
//        }
//        else if huliLevel == 1
//        {
//            request.params["nursing_level"] = "level2"
//        }
//        else if huliLevel == 2
//        {
//            request.params["nursing_level"] = "level3"
//        }
        if nurseId != nil
        {
            request.params["nurse_id"] = nurseId
        }
        if doctorId != nil
        {
            request.params["doctors_id"] = doctorId
        }
        //request.params["operate_id"] = currentBook.book_id
        request.params["hospitalized_id"] = hospitalized_id
        //request.params["bed_id"] = bedId
        request.execute()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutAction(_ sender: Any) {
        //state = baseInfoDict.object(forKey: "hospitalized_state_name") as! String
        if state == "住院中"
        {
            let request = BingfangApplyCheckOutRequest()
            request.params["hospitalized_id"] = hospitalized_id
            request.execute()
        }
        else if state == "已申请"
        {
            checkoutView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
            checkoutView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
            let centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
            centerView.backgroundColor = UIColor.white
            let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
            naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
            centerView.addSubview(naviView)
            
            let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
            closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: UIControlState.normal)
            closeButton.addTarget(self, action:#selector(self.closeMask), for: UIControlEvents.touchUpInside)
            centerView.addSubview(closeButton)
            
            let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 72))
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.text = "出院小结"
            centerView.addSubview(titleLabel)
            
            let confirmButton = UIButton(frame: CGRect(x: 624, y: 0, width: 100, height: 72))
            confirmButton.setTitle("确定", for: UIControlState.normal)
            confirmButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            confirmButton.addTarget(self, action: #selector(self.confirm), for: UIControlEvents.touchUpInside)
            centerView.addSubview(confirmButton)
            
            let qingkuangLabel = UILabel(frame: CGRect(x: 30, y: 95, width: 200, height: 20))
            qingkuangLabel.text = "出院情况："
            qingkuangLabel.font = UIFont.systemFont(ofSize: 16)
            qingkuangLabel.textColor = RGB(r: 105, g: 104, b: 104)
            centerView.addSubview(qingkuangLabel)
            
            qingkuangTextView = UITextView(frame:  CGRect(x: 30, y: 135, width: 664, height: 140))
            qingkuangTextView.text = qingkuangString
            qingkuangTextView.font = UIFont.systemFont(ofSize: 16)
            qingkuangTextView.textColor = RGB(r: 155, g: 155, b: 155)
            qingkuangTextView.layer.cornerRadius = 6
            qingkuangTextView.layer.borderColor = RGB(r: 220, g: 224, b: 224).cgColor
            qingkuangTextView.layer.borderWidth = 1
            centerView.addSubview(qingkuangTextView)
            
            let yizhuLabel = UILabel(frame: CGRect(x: 30, y: 305, width: 200, height: 20))
            yizhuLabel.text = "出院医嘱："
            yizhuLabel.font = UIFont.systemFont(ofSize: 16)
            yizhuLabel.textColor = RGB(r: 105, g: 104, b: 104)
            centerView.addSubview(yizhuLabel)
            
            yizhuTextView = UITextView(frame:  CGRect(x: 30, y: 345, width: 664, height: 140))
            yizhuTextView.text = yizhuString
            yizhuTextView.font = UIFont.systemFont(ofSize: 16)
            yizhuTextView.textColor = RGB(r: 155, g: 155, b: 155)
            yizhuTextView.layer.cornerRadius = 6
            yizhuTextView.layer.borderColor = RGB(r: 220, g: 224, b: 224).cgColor
            yizhuTextView.layer.borderWidth = 1
            centerView.addSubview(yizhuTextView)
            
            checkoutView.addSubview(centerView)
            UIApplication.shared.keyWindow?.addSubview(checkoutView)
        }
        
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    func closeMask()
    {
        checkoutView.removeFromSuperview()
    }
    
    func confirm()
    {
        if (yizhuTextView.text == "" || qingkuangTextView.text == "")
        {
            let v = UIAlertView(title: "", message: "请填写出院情况和出院医嘱", delegate: self, cancelButtonTitle: "好的")
            v.show()
        }
        else
        {
            let request = BingfangCheckOutRequest()
            request.params["hospitalized_id"] = hospitalized_id
            request.params["check_out_medical_note"] = yizhuTextView.text
            request.params["check_out_note"] = qingkuangTextView.text
            request.execute()
            checkoutView.removeFromSuperview()
        }
    }
    
    //MARK : - tableview delegate
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == zhuyuanInfoTableView
//        {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: "ZhuyuanInfoTableViewCell")
//            return cell
//        }
//        else if tableView == zhuyuanListTableView
//        {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: "ZhuyuanListTableViewCell")
//            return cell
//        }
//        else
//        {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: "ChakanBingliTableViewCell")
//            return cell
//        }
//    }
    
}
