//
//  WenZhenDetailViewController.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/25.
//
import WILLDevices
import CoreBluetooth
import UIKit

class WenZhenDetailViewController : ICCommonViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    enum tableViewSectionType : Int
    {
        //case shouxieban = 0
        case main = 0
        case medicalNote
        case beizhu
        case check
        case shoushuyongyao
        case yuanneiyongyao
        case huijiayongyao
        case shoushuxinxi
        case zhuyuanxinxi
        case count
    }
    
    enum tableViewRowType : Int
    {
        case operateItem = 0
        case doctor
        case peitaiNurse
        case xunhuiNurse
        case mazuishi
        case zhenduan
        case fangan
        case count
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var xingzuoLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var designerLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var dateScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kaichufangButton: UIButton!
    @IBOutlet weak var jianchaButton: UIButton!
    @IBOutlet weak var anpaishoushuButton: UIButton!
    @IBOutlet weak var anpaizhuyuanButton: UIButton!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var doingView: UIView!

    var wenzhenDateArray = NSArray()
    var wenzhenDetailDict = NSDictionary()
    var currentIndex = 0
    var zhenduanTextView:KMPlaceholderTextView!
    var fanganTextView:KMPlaceholderTextView!
    var yizhuTextView:KMPlaceholderTextView!
    var member:CDMember!
    var base_info = NSMutableDictionary()
    var check_info = NSArray()
    var hospitalized_info = NSDictionary()
    var operate_info = NSDictionary()
    var prescription_home_info = NSArray()
    var prescription_hospital_info = NSArray()
    var prescription_operate_info = NSArray()
    var medicalNote = ""
    var selectVC : SeletctListViewController?
    var isCurrentEditable = false
    var isCurrentChanged = false
    var diagnoseArray = NSArray()
    var treatmentArray = NSArray()
    var photoView : UIView!
    var centerView : UIView!
    var photoCollectionView : UICollectionView!
    var checkPhotoView : UIView!
    var imageUrlArray:[String]! = []
    var wash:CDPosWashHand!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //wenzhenArray = NSArray(objects: "1", "2")
        let request = BSFetchMemberCardRequest(memberID: wash.member_id)
        request?.execute()//BSCoreDataManager.current().findEntity("CDMember", withValue: wash.member_id, forKey: "memberID") as? CDMember
        
        let memberRequest = FetchHPatientRequest()
        memberRequest.keyword = wash.member_name
        memberRequest.execute()
        
        let listRequest = GetMedicalRecordRequest()
        listRequest.params["member_id"] = wash.member_id
        listRequest.params["operate_id"] = wash.operate_id
        listRequest.execute()
        
        let washRequest = FetchWorkHandDetailRequest()
        washRequest.washHand = wash
        washRequest.execute()
        
        let diagnoseRequest = FetchDiagnoseRequest()
        diagnoseRequest.execute()
        
        let treatmentRequest = FetchTreatmentRequest()
        treatmentRequest.execute()
        
        refreshDateView()
        self.registerNofitification(forMainThread: kBSFetchMemberCardResponse)
        self.registerNofitification(forMainThread: kEditWashHandResponse)
        self.registerNofitification(forMainThread: kFetchWashHandDetailResponse)
        self.registerNofitification(forMainThread: "GetMedicalRecordResponse")
        self.registerNofitification(forMainThread: "GetMedicalRecordDetailResponse")
        self.registerNofitification(forMainThread: "DeleteChufangResponse")
        self.registerNofitification(forMainThread: "FetchDiagnoseResponse")
        self.registerNofitification(forMainThread: "FetchTreatmentResponse")
        self.registerNofitification(forMainThread: "WenZhenDidChanged")
        self.registerNofitification(forMainThread: "WenZhenKaichufangResponse")
        self.registerNofitification(forMainThread: "WenZhenKaijianchaResponse")
        self.registerNofitification(forMainThread: "WenZhenAnpaishoushuResponse")
        self.registerNofitification(forMainThread: "WenZhenAnpaizhuyuanResponse")

        kaichufangButton.setImage(#imageLiteral(resourceName: "pad_wenzhen_chufang.png"), for: .normal)
        kaichufangButton.setImage(#imageLiteral(resourceName: "pad_wenzhen_chufang_disable.png"), for: .disabled)
        jianchaButton.setImage(#imageLiteral(resourceName: "pad_wenzhen_check.png"), for: .normal)
        jianchaButton.setImage(#imageLiteral(resourceName: "pad_wenzhen_check_disable.png"), for: .disabled)
        anpaishoushuButton.setImage(#imageLiteral(resourceName: "pad_wenzhen_shoushu.png"), for: .normal)
        anpaishoushuButton.setImage(#imageLiteral(resourceName: "pad_wenzhen_shoushu_disable.png"), for: .disabled)
        anpaizhuyuanButton.setImage(#imageLiteral(resourceName: "pad_wenzhen_zhuyuan.png"), for: .normal)
        anpaizhuyuanButton.setImage(#imageLiteral(resourceName: "pad_wenzhen_zhuyuan_disable.png"), for: .disabled)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNotification(onMainThread: kBSFetchMemberCardResponse)
        self.removeNotification(onMainThread: kEditWashHandResponse)
        self.removeNotification(onMainThread: kFetchWashHandDetailResponse)
        self.removeNotification(onMainThread: "GetMedicalRecordResponse")
        self.removeNotification(onMainThread: "GetMedicalRecordDetailResponse")
        self.removeNotification(onMainThread: "DeleteChufangResponse")
        self.removeNotification(onMainThread: "FetchDiagnoseResponse")
        self.removeNotification(onMainThread: "FetchTreatmentResponse")
        self.removeNotification(onMainThread: "WenZhenDidChanged")
        self.removeNotification(onMainThread: "WenZhenKaichufangResponse")
        self.removeNotification(onMainThread: "WenZhenKaijianchaResponse")
        self.removeNotification(onMainThread: "WenZhenAnpaishoushuResponse")
        self.removeNotification(onMainThread: "WenZhenAnpaizhuyuanResponse")
        let washRequest = FetchWorkHandDetailRequest()
        washRequest.washHand = wash
        washRequest.execute()
        self.wash = nil
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kBSFetchMemberCardResponse )
        {
            member = BSCoreDataManager.current().findEntity("CDMember", withValue: wash.member_id, forKey: "memberID") as? CDMember
            //print(member)
            if (member != nil)
            {
                avatarView.sd_setImage(with: URL(string: "\(member.image_url ?? "")"), placeholderImage: UIImage(named: "pad_avatar_default"))
                nameLabel.text = "姓名：" + (member.memberName ?? "")
                let gender = member.gender ?? "" == "Female" ? "女" : "男"
                genderLabel.text = "性别：" + gender
//                ageLabel.text = "年龄：" +
//                xingzuoLabel.text = "星座：" + (member.astro ?? "")
//                bloodTypeLabel.text = "血型：" + (member.blood_type ?? "")
//                startTimeLabel.text = "初诊时间：" + (wash.operate_date ?? "")
            }
        }
        else if ( notification.name.rawValue == "GetMedicalRecordResponse" )
        {
            if let array = notification.userInfo!["data"] as? NSArray
            {
                print("\(array.count)")
                wenzhenDateArray = array
                refreshDateView()
                let request = GetMedicalRecordDetailRequest()
                request.params["operate_id"] = (array[0] as! NSDictionary).object(forKey: "operate_id")
                request.execute()
                let currentDict = wenzhenDateArray[currentIndex] as! NSDictionary
                print("\(wash.state)")
                if let operate_id = currentDict.object(forKey: "operate_id") as? NSNumber, operate_id.intValue == wash.operate_id?.intValue && wash.state != "done"
                {
                    isCurrentEditable = true
                    kaichufangButton.isEnabled = isCurrentEditable
                    jianchaButton.isEnabled = isCurrentEditable
                    anpaishoushuButton.isEnabled = isCurrentEditable
                    anpaizhuyuanButton.isEnabled = isCurrentEditable
                }
                else
                {
                    isCurrentEditable = false
                    kaichufangButton.isEnabled = isCurrentEditable
                    jianchaButton.isEnabled = isCurrentEditable
                    anpaishoushuButton.isEnabled = isCurrentEditable
                    anpaizhuyuanButton.isEnabled = isCurrentEditable
                }
            }
        }
        else if ( notification.name.rawValue == "GetMedicalRecordDetailResponse" )
        {
            if let dict = notification.userInfo!["data"] as? NSDictionary
            {
                print(dict)
                wenzhenDetailDict = dict
                base_info = NSMutableDictionary(dictionary: wenzhenDetailDict.object(forKey: "base_info") as! NSDictionary)
                medicalNote = "\(base_info.object(forKey: "medical_note") ?? "")"
                check_info = wenzhenDetailDict.object(forKey: "check_info") as! NSArray
                hospitalized_info = wenzhenDetailDict.object(forKey: "hospitalized_info") as! NSDictionary
                operate_info = wenzhenDetailDict.object(forKey: "operate_info") as! NSDictionary
                prescription_home_info = wenzhenDetailDict.object(forKey: "prescription_home_info") as! NSArray
                prescription_hospital_info = wenzhenDetailDict.object(forKey: "prescription_hospital_info") as! NSArray
                prescription_operate_info = wenzhenDetailDict.object(forKey: "prescription_operate_info") as! NSArray
                tableView.reloadData()
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                self.isCurrentChanged = false
                ageLabel.text = "年龄：" + (base_info.object(forKey: "age") as! String)
                xingzuoLabel.text = "星座：" + (base_info.object(forKey: "astro") as! String)
                bloodTypeLabel.text = "血型：" + (base_info.object(forKey: "blood_type") as! String)
                designerLabel.text = "设计师：" + (base_info.object(forKey: "designers_name") as! String)
                directorLabel.text = "设计总监：" + (base_info.object(forKey: "director_employee_name") as! String)
            }
        }
        else if ( notification.name.rawValue == "DeleteChufangResponse" )
        {
            let listRequest = GetMedicalRecordRequest()
            listRequest.params["member_id"] = wash.member_id
            listRequest.params["operate_id"] = wash.operate_id
            listRequest.execute()
        }
        else if ( notification.name.rawValue == kEditWashHandResponse )
        {
            let listRequest = GetMedicalRecordRequest()
            listRequest.params["member_id"] = wash.member_id
            listRequest.params["operate_id"] = wash.operate_id
            listRequest.execute()
            
//            let washRequest = FetchWorkHandDetailRequest()
//            washRequest.washHand = wash
//            washRequest.execute()
        }
        else if ( notification.name.rawValue == kFetchWashHandDetailResponse )
        {
            if wash.activity_state_name == "未问诊"
            {
                isCurrentEditable = false
                startView.isHidden = false
                doingView.isHidden = true
                kaichufangButton.isEnabled = isCurrentEditable
                jianchaButton.isEnabled = isCurrentEditable
                anpaishoushuButton.isEnabled = isCurrentEditable
                anpaizhuyuanButton.isEnabled = isCurrentEditable
            }
            else if wash.activity_state_name == "已完成"
            {
                isCurrentEditable = false
                startView.isHidden = true
                doingView.isHidden = false
                kaichufangButton.isEnabled = isCurrentEditable
                jianchaButton.isEnabled = isCurrentEditable
                anpaishoushuButton.isEnabled = isCurrentEditable
                anpaizhuyuanButton.isEnabled = isCurrentEditable
            }
            else
            {
                isCurrentEditable = true
                startView.isHidden = true
                doingView.isHidden = false
                kaichufangButton.isEnabled = isCurrentEditable
                jianchaButton.isEnabled = isCurrentEditable
                anpaishoushuButton.isEnabled = isCurrentEditable
                anpaizhuyuanButton.isEnabled = isCurrentEditable
            }
        }
        else if ( notification.name.rawValue == "FetchDiagnoseResponse" )
        {
            if let array = notification.userInfo!["data"] as? NSArray
            {
                diagnoseArray = array
            }
        }
        else if ( notification.name.rawValue == "FetchTreatmentResponse" )
        {
            if let array = notification.userInfo!["data"] as? NSArray
            {
                treatmentArray = array
            }
        }
        else if ( notification.name.rawValue == "WenZhenDidChanged" )
        {
            let request = GetMedicalRecordDetailRequest()
            request.params["operate_id"] = (wenzhenDateArray[currentIndex] as! NSDictionary).object(forKey: "operate_id")
            request.execute()
            let washRequest = FetchWorkHandDetailRequest()
            washRequest.washHand = wash
            washRequest.execute()
        }
        else if ( notification.name.rawValue == "WenZhenKaichufangResponse" )
        {
            if let dict = notification.userInfo as? NSDictionary
            {
                var title = ""
                if (dict.object(forKey: "errcode") as! Int) == 0
                {
                    title = "添加成功"
                }
                let alertView = UIAlertView(title: title, message: "\(dict.object(forKey: "errmsg") ?? "")", delegate: self, cancelButtonTitle: "确定")
                alertView.tag = 999
                alertView.show()
            }
        }
        else if ( notification.name.rawValue == "WenZhenKaijianchaResponse" )
        {
            if let dict = notification.userInfo as? NSDictionary
            {
                var title = ""
                if (dict.object(forKey: "errcode") as! Int) == 0
                {
                    title = "添加成功"
                }
                let alertView = UIAlertView(title: title, message: "\(dict.object(forKey: "errmsg") ?? "")", delegate: self, cancelButtonTitle: "确定")
                alertView.tag = 999
                alertView.show()
            }
        }
        else if ( notification.name.rawValue == "WenZhenAnpaishoushuResponse" )
        {
            if let dict = notification.userInfo as? NSDictionary
            {
                var title = ""
                if (dict.object(forKey: "errcode") as! Int) == 0
                {
                    title = "安排成功"
                }
                let alertView = UIAlertView(title: title, message: "\(dict.object(forKey: "errmsg") ?? "")", delegate: self, cancelButtonTitle: "确定")
                alertView.tag = 999
                alertView.show()
            }
        }
        else if ( notification.name.rawValue == "WenZhenAnpaizhuyuanResponse" )
        {
            if let dict = notification.userInfo as? NSDictionary
            {
                var title = ""
                if (dict.object(forKey: "errcode") as! Int) == 0
                {
                    title = "安排成功"
                }
                let alertView = UIAlertView(title: title, message: "\(dict.object(forKey: "errmsg") ?? "")", delegate: self, cancelButtonTitle: "确定")
                alertView.tag = 999
                alertView.show()
            }
        }
        else if (notification.name.rawValue == selectedCellNotiName){
            /// 根据通知的select字段判断是选中还是未选中cell 来决定是否加入合并的临时数组
            if (notification.userInfo!["select"] as! String) == "true" {
                ///选中添加
                selectedCellArr.append(notification.userInfo!["cellImgUrl"] as! String)
                
            }
            else{
                ///非选中删除 也就是选中了之后可能改为非选中
                selectedCellArr = selectedCellArr.filter({ (string) -> Bool in
                    return !(string == (notification.userInfo!["cellImgUrl"] as! String))
                })
                
            }
            
            print("selct count = \(selectedCellArr.count)")
            ///如果selectedCellArr数目>1 则navi上的“移出” “删除”按钮 可操作 否则不能
            if selectedCellArr.count > 0 {
                
                removeButton.isEnabled = true
                removeButton.setTitleColor(UIColor.init(red: 96/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1), for: UIControlState.normal)
                
                deleteButton.isEnabled = true
            }
            else {
                
                removeButton.isEnabled = false
                removeButton.setTitleColor(UIColor.init(red: 197/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1), for: UIControlState.normal)
                deleteButton.isEnabled = false
            }
            if selectedCellArr.count > 1 {
                combileButton.isEnabled = true
                combileButton.setTitleColor(UIColor.init(red: 96/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1), for: UIControlState.normal)
            }
            else {
                combileButton.isEnabled = false
                combileButton.setTitleColor(UIColor.init(red: 197/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1), for: UIControlState.normal)
            }
        }
        else if (notification.name.rawValue == lookCloundVCImgNotiName){
            let imgBrowserVC = ZixunImgBrowserVC()
            imgBrowserVC.lookImgFrom = notification.userInfo!["from"] as! String
            imgBrowserVC.iconArray = notification.userInfo!["arr"] as! [Any]
            imgBrowserVC.index = (notification.userInfo!["index"] as! IndexPath).row
            
            imgBrowserVC.removebtnBlock = {(imgIndex , imgUrl) in
                
                //print("removebtn准备删除第\(imgIndex)张 imgUrl = \(imgUrl)")
                
                ///删除本地离线数据源 刷新InkCloudVC
                InkFileManager.shared.removeDownLoadOffLineImage(imgUrl: imgUrl!)
                
                self.cloudVC.offLineImgDownLoadFinish()
                
            }
            self.navigationController?.pushViewController(imgBrowserVC, animated: true)
        }
        else if (notification.name.rawValue == connectDeviceCatchNotiName){
            ///设备断开连接了
            self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
            dealBlueToothReStart()
            
        }
        else if (notification.name.rawValue == setUpFileDataReceiverFaildNotiName){
            ///设置下载接受服务失败或出现断电情况
            PersisitentTool.shared.hasRetConnectedDevice = false
            self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
        }
        else if (notification.name.rawValue == inkDeviceHasConnectedNotiName){
            //TODO : 点一下完成 需要用户重新配对
            needClickFlag = true
            
            isInkDeviceConnected = true
            
            self.powerOffView.removeFromSuperview()
            
            ///和云朵按钮一起显示
            if !cloundButton.isHidden {
                
                self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
                pushInkDeviceButtonView.removeFromSuperview()
                self.reConnectedView.removeFromSuperview()
            }
        }
        else if (notification.name.rawValue == inkDevicePowerChangeNotiName){
            ///电量低于20%显示电量低 其他按百分比显示 默认显示ink_baterry@2x
            let power = notification.userInfo!["level"] as! Int
            print("数为本当前电量=\(power)") //Int
            if power == 100 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power100.png"), for: UIControlState.normal)
            }
            else if power<100 && power >= 90 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power90.png"), for: UIControlState.normal)
            }
            else if power<90 && power >= 80 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power80.png"), for: UIControlState.normal)
            }
            else if power<80 && power >= 70 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power70.png"), for: UIControlState.normal)
            }
            else if power<70 && power >= 60 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power60.png"), for: UIControlState.normal)
            }
            else if power<60 && power >= 50 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power50.png"), for: UIControlState.normal)
            }
            else if power<50 && power >= 40 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power40.png"), for: UIControlState.normal)
            }
            else if power<40 && power >= 30 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power30.png"), for: UIControlState.normal)
            }
            else if power<30 && power >= 20 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power20.png"), for: UIControlState.normal)
            }
            else {
                ///电量极低
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power10.png"), for: UIControlState.normal)
            }
        }
            //inkDeviceDidReconnectedNotification
        else if (notification.name.rawValue == inkDeviceDidReconnectedNotification) {
            
            //取消按一下View 改connectBtn为已连接
            pushInkDeviceButtonView.removeFromSuperview()
            checkoutInkDeviceLostTimer.invalidate()
            connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
            
            powerOffView.removeFromSuperview()
            print("接收到通知处isInkDeviceClosedTimer.isValid = \(isInkDeviceClosedTimer.isValid)")
            //isInkDeviceClosedTimer.invalidate()
            if blueToothStatus == "poweredOn"
            {
                checkOutInkDeviceIsPowerOff()
            }
        }
            //inkDeviceDidReDisConnectedNotification
        else if (notification.name.rawValue == inkDeviceDidReDisConnectedNotification){
            connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
            checkoutInkDeviceLostTimer.invalidate()
        }
    }
    
    func refreshDateView()
    {
        if wenzhenDateArray.count == 1
        {
            dateScrollView.isHidden = true
            tableView.frame = CGRect(x: 0, y: 0, width: 604, height: 693)
        }
        else
        {
            dateScrollView.isHidden = false
            tableView.frame = CGRect(x: 0, y: 58, width: 604, height: 635)
        }
        
        dateScrollView.contentSize = CGSize(width: wenzhenDateArray.count*122, height: 58)
        for subview in dateScrollView.subviews
        {
            subview.removeFromSuperview()
        }
        for i in 0..<wenzhenDateArray.count
        {
            let detailDict = wenzhenDateArray[i] as! NSDictionary
            let button = UIButton(frame: CGRect(x: i*122, y: 0, width: 122, height: 58))
            button.tag = i
            button.addTarget(self, action: #selector(WenZhenDetailViewController.didDateTabSelected(_:)), for: UIControlEvents.touchUpInside)
            dateScrollView.addSubview(button)
            let dateLabel = UILabel(frame: CGRect(x: i*122 + 11, y: 10, width: 100, height: 18))
            dateLabel.text = "\(detailDict.object(forKey: "create_date") ?? "")"
            dateLabel.font = UIFont.systemFont(ofSize: 18)
            dateLabel.textAlignment = NSTextAlignment.center
            let doctorLabel = UILabel(frame: CGRect(x: i*122 + 11, y: 34, width: 100, height: 14))
            doctorLabel.text = "\(detailDict.object(forKey: "doctor_name") ?? "")"
            doctorLabel.font = UIFont.systemFont(ofSize: 14)
            doctorLabel.textColor = RGB(r: 37, g: 37, b: 37)
            doctorLabel.textAlignment = NSTextAlignment.center
            
            dateScrollView.addSubview(dateLabel)
            dateScrollView.addSubview(doctorLabel)
            let rightLine = UIView(frame: CGRect(x: i*122 + 122, y: 0, width: 1, height: 58))
            rightLine.backgroundColor = RGB(r: 224, g: 230, b: 230)
            dateScrollView.addSubview(rightLine)
            if currentIndex == i
            {
                dateLabel.textColor = RGB(r: 37, g: 37, b: 37)
                doctorLabel.textColor = RGB(r: 37, g: 37, b: 37)
                let bottomLine = UIView(frame: CGRect(x: i*122, y: 56, width: 122, height: 2))
                bottomLine.backgroundColor = RGB(r: 96, g: 211, b: 212)
                dateScrollView.addSubview(bottomLine)
                
            }
            else
            {
                dateLabel.textColor = RGB(r: 153, g: 153, b: 153)
                doctorLabel.textColor = RGB(r: 153, g: 153, b: 153)
            }
        }
    }
    
    func didDateTabSelected(_ sender : UIButton)
    {
        self.currentIndex = sender.tag
        if isCurrentChanged
        {
            let alert = UIAlertController(title: nil, message: "你要保存当前页面吗?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                self.updateDateView()
            }))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                self.save()
                self.updateDateView()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.updateDateView()
        }
    }
    
    func updateDateView()
    {
        self.refreshDateView()
        let currentDict = self.wenzhenDateArray[self.currentIndex] as! NSDictionary
        if let operate_id = currentDict.object(forKey: "operate_id") as? NSNumber, operate_id.intValue == self.wash.operate_id?.intValue && wash.state != "done"
        {
            self.isCurrentEditable = true
            if wash.activity_state_name == "未问诊" || wash.activity_state_name == "已完成"
            {
                isCurrentEditable = false
            }
            else
            {
                isCurrentEditable = true
            }
            self.kaichufangButton.isEnabled = self.isCurrentEditable
            self.jianchaButton.isEnabled = self.isCurrentEditable
            self.anpaishoushuButton.isEnabled = self.isCurrentEditable
            self.anpaizhuyuanButton.isEnabled = self.isCurrentEditable
        }
        else
        {
            self.isCurrentEditable = false
            self.kaichufangButton.isEnabled = self.isCurrentEditable
            self.jianchaButton.isEnabled = self.isCurrentEditable
            self.anpaishoushuButton.isEnabled = self.isCurrentEditable
            self.anpaizhuyuanButton.isEnabled = self.isCurrentEditable
        }
        let request = GetMedicalRecordDetailRequest()
        request.params["operate_id"] = (self.wenzhenDateArray[self.currentIndex] as! NSDictionary).object(forKey: "operate_id")
        request.execute()
        isCurrentChanged = false
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSectionType.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == tableViewSectionType.main.rawValue)
        {
            switch indexPath.row {
            case tableViewRowType.operateItem.rawValue:
                return 57
            case tableViewRowType.doctor.rawValue:
                return 57
            case tableViewRowType.peitaiNurse.rawValue:
                return 57
            case tableViewRowType.xunhuiNurse.rawValue:
                return 57
            case tableViewRowType.mazuishi.rawValue:
                return 57
            case tableViewRowType.zhenduan.rawValue:
                return 234
            case tableViewRowType.fangan.rawValue:
                return 234
//            case tableViewRowType.note.rawValue:
//                return 84
            default:
                return 0
            }
        }
        else if (indexPath.section == tableViewSectionType.medicalNote.rawValue)
        {
            if indexPath.row == 0
            {
                return 234
            }
            else
            {
                return 40
            }
        }
        else if (indexPath.section == tableViewSectionType.beizhu.rawValue)
        {
            return 200
        }
        else if (indexPath.section == tableViewSectionType.check.rawValue)
        {
            if indexPath.row == 0
            {
                return 130
            }
            else
            {
                return 100
            }
        }
        else if (indexPath.section == tableViewSectionType.shoushuyongyao.rawValue)
        {
            if indexPath.row == 0
            {
                return 150 + 50
            }
            else
            {
                return 150
            }
        }
        else if (indexPath.section == tableViewSectionType.yuanneiyongyao.rawValue)
        {
            if indexPath.row == 0
            {
                return 150 + 50
            }
            else
            {
                return 150
            }
        }
        else if (indexPath.section == tableViewSectionType.huijiayongyao.rawValue)
        {
            if indexPath.row == 0
            {
                return 150 + 50
            }
            else
            {
                return 150
            }
        }
        else if (indexPath.section == tableViewSectionType.shoushuxinxi.rawValue)
        {
            return 200
        }
        else if (indexPath.section == tableViewSectionType.zhuyuanxinxi.rawValue)
        {
            return 240
        }
        else
        {
            return 100
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == tableViewSectionType.main.rawValue
        {
            return tableViewRowType.count.rawValue
        }
        else if section == tableViewSectionType.medicalNote.rawValue
        {
            return 1
//            if medicalNote == ""
//            {
//                return 1
//            }
//            else
//            {
//                return medicalNote.components(separatedBy: "\n").count + 1
//            }
        }
        else if section == tableViewSectionType.beizhu.rawValue
        {
            if "\(base_info.object(forKey: "remark") ?? "")" == ""
            {
                return 0
            }
            else
            {
                return 1
            }
        }
        else if section == tableViewSectionType.shoushuyongyao.rawValue
        {
            return prescription_operate_info.count
        }
        else if section == tableViewSectionType.yuanneiyongyao.rawValue
        {
            return prescription_hospital_info.count
        }
        else if section == tableViewSectionType.huijiayongyao.rawValue
        {
            return prescription_home_info.count
        }
        else if section == tableViewSectionType.check.rawValue
        {
            return check_info.count
        }
        else if section == tableViewSectionType.shoushuxinxi.rawValue
        {
            if "\(operate_info.object(forKey: "name") ?? "")" == ""
            {
                return 0
            }
            else
            {
                return 1
            }
        }
        else if section == tableViewSectionType.zhuyuanxinxi.rawValue
        {
            if "\(hospitalized_info.object(forKey: "name") ?? "")" == ""
            {
                return 0
            }
            else
            {
                return 1
            }
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "WenzhenDetailMainTableViewCell\(indexPath.section)\(indexPath.row)")
        cell.selectionStyle = .none
        let leftLabel = UILabel(frame: CGRect(x: 23, y: 21, width: 400, height: 16))
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.textColor = RGB(r: 37, g: 37, b: 37)
        let rightLabel = UILabel(frame: CGRect(x: 400, y: 21, width: 140, height: 16))
        rightLabel.textAlignment = .right
        rightLabel.tag = 101
        rightLabel.textColor = RGB(r: 37, g: 37, b: 37)
        let rightArrow = UIImageView(frame: CGRect(x: 567, y: 20, width: 8, height: 14))
        rightArrow.image = #imageLiteral(resourceName: "pos_right_arrow.png")
        let bottomLine = UIView()
        bottomLine.backgroundColor = RGB(r: 224, g: 230, b: 230)
        if (indexPath.section == tableViewSectionType.main.rawValue)
        {
            switch indexPath.row {
            case tableViewRowType.operateItem.rawValue:
                leftLabel.frame = CGRect(x: 23, y: 21, width:556, height: 16)
                leftLabel.text = "\(base_info.object(forKey: "name") ?? "")"
                bottomLine.frame = CGRect(x: 23, y: 56, width: 556, height: 1)
            case tableViewRowType.doctor.rawValue:
                leftLabel.text = "手术医生："
                rightLabel.text = "\(base_info.object(forKey: "doctor_name") ?? "")"
                rightLabel.tag = 101
                cell.addSubview(rightLabel)
                cell.addSubview(rightArrow)
                bottomLine.frame = CGRect(x: 23, y: 56, width: 556, height: 1)
            case tableViewRowType.peitaiNurse.rawValue:
                leftLabel.text = "配台护士："
                rightLabel.text = "\(base_info.object(forKey: "peitai_nurse_name") ?? "")"
                rightLabel.tag = 101
                cell.addSubview(rightLabel)
                cell.addSubview(rightArrow)
                bottomLine.frame = CGRect(x: 23, y: 56, width: 556, height: 1)
            case tableViewRowType.xunhuiNurse.rawValue:
                leftLabel.text = "巡回护士："
                rightLabel.text = "\(base_info.object(forKey: "xunhui_nurse_name") ?? "")"
                rightLabel.tag = 101
                cell.addSubview(rightLabel)
                cell.addSubview(rightArrow)
                bottomLine.frame = CGRect(x: 23, y: 56, width: 556, height: 1)
            case tableViewRowType.mazuishi.rawValue:
                leftLabel.text = "麻醉师："
                rightLabel.text = "\(base_info.object(forKey: "anesthetist_name") ?? "")"
                rightLabel.tag = 101
                cell.addSubview(rightLabel)
                cell.addSubview(rightArrow)
                bottomLine.frame = CGRect(x: 23, y: 56, width: 556, height: 1)
            case tableViewRowType.zhenduan.rawValue:
                leftLabel.text = "诊断："
                rightLabel.text = "请选择模板"
                cell.addSubview(rightLabel)
                cell.addSubview(rightArrow)
                zhenduanTextView = KMPlaceholderTextView(frame: CGRect(x: 20, y: 38, width: 556, height: 170))
                zhenduanTextView.font = UIFont.systemFont(ofSize: 16)
                zhenduanTextView.delegate = self
                zhenduanTextView.text = "\(base_info.object(forKey: "diagnose") ?? "")"
                if !isCurrentEditable
                {
                    zhenduanTextView.isEditable = false
                }
                else
                {
                    zhenduanTextView.placeholder = "请输入"
                }
                cell.addSubview(zhenduanTextView)
                bottomLine.frame = CGRect(x: 23, y: 233, width: 556, height: 1)
            case tableViewRowType.fangan.rawValue:
                leftLabel.text = "治疗方案："
                rightLabel.text = "请选择模板"
                cell.addSubview(rightLabel)
                cell.addSubview(rightArrow)
                fanganTextView = KMPlaceholderTextView(frame: CGRect(x: 20, y: 38, width: 556, height: 170))
                fanganTextView.font = UIFont.systemFont(ofSize: 16)
                fanganTextView.delegate = self
                if !isCurrentEditable
                {
                    fanganTextView.isEditable = false
                }
                else
                {
                    fanganTextView.placeholder = "请输入"
                }
                fanganTextView.text = "\(base_info.object(forKey: "treatment") ?? "")"
                cell.addSubview(fanganTextView)
                bottomLine.frame = CGRect(x: 23, y: 233, width: 556, height: 1)
            default:
                cell.textLabel?.text = ""
            }
            cell.addSubview(leftLabel)
            cell.addSubview(bottomLine)
        }
        else if (indexPath.section == tableViewSectionType.medicalNote.rawValue)
        {
            if (indexPath.row == 0)
            {
                leftLabel.text = "医嘱："
                yizhuTextView = KMPlaceholderTextView(frame: CGRect(x: 20, y: 38, width: 556, height: 170))
                yizhuTextView.font = UIFont.systemFont(ofSize: 16)
                if !isCurrentEditable
                {
                    yizhuTextView.isEditable = false
                }
                else
                {
                    yizhuTextView.placeholder = "请输入"
                }
                yizhuTextView.delegate = self
                yizhuTextView.text = "\(base_info.object(forKey: "medical_note") ?? "")"
                cell.addSubview(yizhuTextView)
                bottomLine.frame = CGRect(x: 23, y: 233, width: 556, height: 1)
                cell.addSubview(leftLabel)
                cell.addSubview(bottomLine)
            }
            else
            {
                let noteLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 556, height: 40))
                noteLabel.textColor = RGB(r: 153, g: 153, b: 153)
                noteLabel.font = UIFont.systemFont(ofSize: 16)
                noteLabel.text = medicalNote.components(separatedBy: "\n")[indexPath.row-1]
                cell.addSubview(noteLabel)
                bottomLine.frame = CGRect(x: 23, y: 39, width: 556, height: 1)
                cell.addSubview(bottomLine)
            }
        }
        else if (indexPath.section == tableViewSectionType.beizhu.rawValue)
        {
            leftLabel.text = "医生备注："
            let beizhuTextView = UITextView(frame: CGRect(x: 20, y: 50, width: 530, height: 140))
            beizhuTextView.textColor = RGB(r: 153, g: 153, b: 153)
            beizhuTextView.text = "\(base_info.object(forKey: "remark") ?? "")"
            beizhuTextView.font = UIFont.systemFont(ofSize: 16)
            beizhuTextView.isEditable = false
            cell.addSubview(beizhuTextView)
            cell.addSubview(leftLabel)
            bottomLine.frame = CGRect(x: 23, y: 199, width: 556, height: 1)
            cell.addSubview(bottomLine)
        }
        else if (indexPath.section == tableViewSectionType.check.rawValue)
        {
            leftLabel.text = "检查："
            let checkTextView = UITextView(frame: CGRect(x: 20, y: 50, width: 470, height: 70))
            let button = UIButton(frame: CGRect(x: 480, y: 100, width: 100, height: 20))
            if check_info.count != 0
            {
                let dict = check_info[indexPath.row] as! NSDictionary
                checkTextView.textColor = RGB(r: 153, g: 153, b: 153)
                checkTextView.text = "\(dict.object(forKey: "name") ?? "")"
                checkTextView.font = UIFont.systemFont(ofSize: 16)
                checkTextView.isEditable = false
                cell.addSubview(checkTextView)
                let imageString = dict.object(forKey: "image_urls") as! String
                var imageArray : [String] = []
                if imageString != ""
                {
                    imageArray = imageString.components(separatedBy: ",")
                }
                button.setTitle("查看结果(\(imageArray.count))", for: .normal)
                button.setTitleColor(RGB(r: 47, g: 143, b: 255), for: .normal)
                button.tag = indexPath.row
                button.addTarget(self, action: #selector(self.checkPhoto(_:)), for: .touchUpInside)
                if imageArray.count > 0
                {
                    cell.addSubview(button)
                }
            }
            if (indexPath.row == 0)
            {
                cell.addSubview(leftLabel)
                bottomLine.frame = CGRect(x: 23, y: 129, width: 556, height: 1)
            }
            else
            {
                bottomLine.frame = CGRect(x: 23, y: 99, width: 556, height: 1)
                checkTextView.frame = CGRect(x: 20, y: 20, width: 470, height: 70)
                button.frame = CGRect(x: 480, y: 70, width: 100, height: 20)
            }
            cell.addSubview(bottomLine)
        }
        else if (indexPath.section == tableViewSectionType.shoushuyongyao.rawValue)
        {
            if (indexPath.row == 0)
            {
                leftLabel.text = "手术用药："
                let dict = prescription_operate_info[indexPath.row] as! NSDictionary
                let shoushuTextView = UITextView(frame: CGRect(x: 20, y: 50, width: 530, height: 140))
                shoushuTextView.textColor = RGB(r: 153, g: 153, b: 153)
                shoushuTextView.text = "\(dict.object(forKey: "title") ?? "")"
                shoushuTextView.font = UIFont.systemFont(ofSize: 16)
                shoushuTextView.isEditable = false
                cell.addSubview(shoushuTextView)
                let deleteButton = UIButton(frame: CGRect(x: 520, y: 50, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true && (dict.object(forKey: "state") as! String == "draft")
                {
                    cell.addSubview(deleteButton)
                }
                cell.addSubview(leftLabel)
                bottomLine.frame = CGRect(x: 23, y: 199, width: 556, height: 1)
                cell.addSubview(bottomLine)
            }
            else
            {
                let dict = prescription_operate_info[indexPath.row] as! NSDictionary
                let shoushuTextView = UITextView(frame: CGRect(x: 20, y: 10, width: 530, height: 130))
                shoushuTextView.textColor = RGB(r: 153, g: 153, b: 153)
                shoushuTextView.text = "\(dict.object(forKey: "title") ?? "")"
                shoushuTextView.font = UIFont.systemFont(ofSize: 16)
                shoushuTextView.isEditable = false
                cell.addSubview(shoushuTextView)
                let deleteButton = UIButton(frame: CGRect(x: 520, y: 10, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true && (dict.object(forKey: "state") as! String == "draft")
                {
                    cell.addSubview(deleteButton)
                }
                cell.addSubview(leftLabel)
                bottomLine.frame = CGRect(x: 23, y: 149, width: 556, height: 1)
                cell.addSubview(bottomLine)
            }
        }
        else if (indexPath.section == tableViewSectionType.yuanneiyongyao.rawValue)
        {
            if (indexPath.row == 0)
            {
                leftLabel.text = "院内用药："
                let dict = prescription_hospital_info[indexPath.row] as! NSDictionary
                let yuanneiTextView = UITextView(frame: CGRect(x: 20, y: 50, width: 530, height: 140))
                yuanneiTextView.textColor = RGB(r: 153, g: 153, b: 153)
                yuanneiTextView.text = "\(dict.object(forKey: "title") ?? "")"
                yuanneiTextView.font = UIFont.systemFont(ofSize: 16)
                yuanneiTextView.isEditable = false
                cell.addSubview(yuanneiTextView)
                let deleteButton = UIButton(frame: CGRect(x: 520, y: 50, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true && (dict.object(forKey: "state") as! String == "draft")
                {
                    cell.addSubview(deleteButton)
                }
                cell.addSubview(leftLabel)
                bottomLine.frame = CGRect(x: 23, y: 199, width: 556, height: 1)
                cell.addSubview(bottomLine)
            }
            else
            {
                let dict = prescription_hospital_info[indexPath.row] as! NSDictionary
                let yuanneiTextView = UITextView(frame: CGRect(x: 20, y: 10, width: 530, height: 130))
                yuanneiTextView.textColor = RGB(r: 153, g: 153, b: 153)
                yuanneiTextView.text = "\(dict.object(forKey: "title") ?? "")"
                yuanneiTextView.font = UIFont.systemFont(ofSize: 16)
                yuanneiTextView.isEditable = false
                cell.addSubview(yuanneiTextView)
                let deleteButton = UIButton(frame: CGRect(x: 520, y: 10, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true  && (dict.object(forKey: "state") as! String == "draft")
                {
                    cell.addSubview(deleteButton)
                }
                cell.addSubview(leftLabel)
                bottomLine.frame = CGRect(x: 23, y: 149, width: 556, height: 1)
                cell.addSubview(bottomLine)
            }
        }
        else if (indexPath.section == tableViewSectionType.huijiayongyao.rawValue)
        {
            if (indexPath.row == 0)
            {
                leftLabel.text = "回家用药："
                let dict = prescription_home_info[indexPath.row] as! NSDictionary
                let homeTextView = UITextView(frame: CGRect(x: 20, y: 50, width: 530, height: 140))
                homeTextView.textColor = RGB(r: 153, g: 153, b: 153)
                homeTextView.text = "\(dict.object(forKey: "title") ?? "")"
                homeTextView.font = UIFont.systemFont(ofSize: 16)
                homeTextView.isEditable = false
                cell.addSubview(homeTextView)
                let deleteButton = UIButton(frame: CGRect(x: 520, y: 50, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true  && (dict.object(forKey: "state") as! String == "draft")
                {
                    cell.addSubview(deleteButton)
                }
                cell.addSubview(leftLabel)
                bottomLine.frame = CGRect(x: 23, y: 199, width: 556, height: 1)
                cell.addSubview(bottomLine)
            }
            else
            {
                let dict = prescription_home_info[indexPath.row] as! NSDictionary
                let homeTextView = UITextView(frame: CGRect(x: 20, y: 10, width: 530, height: 130))
                homeTextView.textColor = RGB(r: 153, g: 153, b: 153)
                homeTextView.text = "\(dict.object(forKey: "title") ?? "")"
                homeTextView.font = UIFont.systemFont(ofSize: 16)
                homeTextView.isEditable = false
                cell.addSubview(homeTextView)
                let deleteButton = UIButton(frame: CGRect(x: 520, y: 10, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true  && (dict.object(forKey: "state") as! String == "draft")
                {
                    cell.addSubview(deleteButton)
                }
                cell.addSubview(leftLabel)
                bottomLine.frame = CGRect(x: 23, y: 149, width: 556, height: 1)
                cell.addSubview(bottomLine)
            }
        }
        else if (indexPath.section == tableViewSectionType.shoushuxinxi.rawValue)
        {
            leftLabel.text = "手术信息："
            let shoushuxinxiTextView = UITextView(frame: CGRect(x: 20, y: 50, width: 530, height: 140))
            shoushuxinxiTextView.textColor = RGB(r: 153, g: 153, b: 153)
            shoushuxinxiTextView.text = "\(operate_info.object(forKey: "name") ?? "")"
            shoushuxinxiTextView.font = UIFont.systemFont(ofSize: 16)
            shoushuxinxiTextView.isEditable = false
            cell.addSubview(shoushuxinxiTextView)
            cell.addSubview(leftLabel)
            bottomLine.frame = CGRect(x: 23, y: 199, width: 556, height: 1)
            cell.addSubview(bottomLine)
        }
        else if (indexPath.section == tableViewSectionType.zhuyuanxinxi.rawValue)
        {
            leftLabel.text = "住院信息："
            let zhuyuanxinxiTextView = UITextView(frame: CGRect(x: 20, y: 50, width: 530, height: 140))
            zhuyuanxinxiTextView.textColor = RGB(r: 153, g: 153, b: 153)
            zhuyuanxinxiTextView.text = "\(hospitalized_info.object(forKey: "name") ?? "")"
            zhuyuanxinxiTextView.font = UIFont.systemFont(ofSize: 16)
            zhuyuanxinxiTextView.isEditable = false
            cell.addSubview(zhuyuanxinxiTextView)
            cell.addSubview(leftLabel)
            bottomLine.frame = CGRect(x: 23, y: 239, width: 556, height: 1)
            cell.addSubview(bottomLine)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCurrentEditable == false
        {
            return
        }
        if (indexPath.section == tableViewSectionType.main.rawValue)
        {
            switch indexPath.row {
            case tableViewRowType.doctor.rawValue:
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
                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
                    label.text = doctor.name
                    self?.base_info.setValue(doctor.name, forKey: "doctor_name")
                    self?.wash.doctor_id = doctor.staffID
                    self?.isCurrentChanged = true
                }
                
                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
                self.selectVC?.showWithAnimation();
            case tableViewRowType.peitaiNurse.rawValue:
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
                    
                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
                    label.text = nurse.name
                    self?.base_info.setValue(nurse.name, forKey: "peitai_nurse_name")
                    self?.wash.peitai_nurse_id = nurse.staffID
                    self?.isCurrentChanged = true
                }
                
                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
                self.selectVC?.showWithAnimation();
            case tableViewRowType.xunhuiNurse.rawValue:
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
                    
                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
                    label.text = nurse.name
                    self?.base_info.setValue(nurse.name, forKey: "xunhui_nurse_name")
                    self?.wash.xunhui_nurse_id = nurse.staffID
                    self?.isCurrentChanged = true
                }
                
                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
                self.selectVC?.showWithAnimation();
            case tableViewRowType.mazuishi.rawValue:
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
                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
                    label.text = doctor.name
                    self?.base_info.setValue(doctor.name, forKey: "anesthetist_name")
                    self?.wash.anesthetist_id = doctor.staffID
                    self?.isCurrentChanged = true
                }
                
                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
                self.selectVC?.showWithAnimation();
            case tableViewRowType.zhenduan.rawValue:
                self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
                
                self.selectVC?.countOfTheList = {
                    return self.diagnoseArray.count
                }
                
                self.selectVC?.nameAtIndex = { index in
                    let diagnose = self.diagnoseArray[index] as! NSDictionary
                    return diagnose.object(forKey: "name") as? String
                }
                
                self.selectVC?.selectAtIndex = {[weak self] index in
                    let diagnose = self?.diagnoseArray[index] as! NSDictionary
                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
                    label.text = diagnose.object(forKey: "name") as? String
                    self?.zhenduanTextView.text = "\(diagnose.object(forKey: "note") ?? "")"
                    self?.textViewDidChange((self?.zhenduanTextView)!)
                    self?.isCurrentChanged = true
                }
                
                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
                self.selectVC?.showWithAnimation();
            case tableViewRowType.fangan.rawValue:
                self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
                
                self.selectVC?.countOfTheList = {
                    return self.treatmentArray.count
                }
                
                self.selectVC?.nameAtIndex = { index in
                    let treatment = self.treatmentArray[index] as! NSDictionary
                    return treatment.object(forKey: "name") as? String
                }
                
                self.selectVC?.selectAtIndex = {[weak self] index in
                    let treatment = self?.treatmentArray[index] as! NSDictionary
                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
                    label.text = treatment.object(forKey: "name") as? String
                    self?.fanganTextView.text = "\(treatment.object(forKey: "note") ?? "")"
                    self?.textViewDidChange((self?.fanganTextView)!)
                    self?.isCurrentChanged = true
                }
                
                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
                self.selectVC?.showWithAnimation();
            default:
                print("default")
            }
        }
    }
    
    func deleteChufang(_ sender:UIButton)
    {
        let alert = UIAlertController(title: nil, message: "确认要删除吗?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            let request = DeleteChufangRequest()
            request.params["prescription_id"] = NSNumber(value: sender.tag)
            request.execute()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if isCurrentChanged
        {
            let alert = UIAlertController(title: nil, message: "该页面有改动，是否要保存?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "不保存", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
                self.save()
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func startAction(_ sender: Any) {
        let request = EditWashHandRequest()
        request.wash = wash
        //        request.params[""] =
        request.execute()
        wash.activity_state_name = "问诊中"
        startView.isHidden = true
        doingView.isHidden = false
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if currentIndex != 0
        {
            return
        }
        save()
    }
    
    func doNotSave()
    {
        let listRequest = GetMedicalRecordRequest()
        listRequest.params["member_id"] = wash.member_id
        listRequest.params["operate_id"] = wash.operate_id
        listRequest.execute()
    }
    
    func save()
    {
        if (yizhuTextView.text != "")
        {
            wash.medical_note = yizhuTextView.text //+ "\n" + medicalNote
        }
        if (zhenduanTextView.text != "")
        {
            wash.diagnose = zhenduanTextView.text
        }
        if (fanganTextView.text != "")
        {
            wash.treatment = fanganTextView.text
        }
        
        let request = EditWashHandRequest()
        request.wash = wash
        request.notGoNext = true
        //        request.params[""] =
        request.execute()
        CBMessageView(title: "已保存").show()
    }
    
    @IBAction func finishAction(_ sender: Any) {
        print("\(wash)")
        if wash.state == "done"
        {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let request = EditWashHandRequest()
        request.wash = wash
//        request.params[""] =
        request.execute()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didKaichufangButtonClicked(_ sender: Any) {
        if isCurrentChanged
        {
            let alert = UIAlertController(title: nil, message: "该页面有改动，是否要保存?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "不保存", style: .cancel, handler: { (action) in
                self.chufangAction(sender)
            }))
            alert.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
                self.save()
                self.chufangAction(sender)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            chufangAction(sender)
        }
    }
    
    func chufangAction(_ sender:Any)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionShoushu = UIAlertAction(title: "手术用药", style: .default) { (action) in
            let shoushuView = WenZhenChufangView()
            shoushuView.chufangType = "手术用药"
            shoushuView.wash = self.wash
            shoushuView.initView()
            shoushuView.yaopinArray = NSMutableArray()
            self.view.addSubview(shoushuView)
        }
        alert.addAction(actionShoushu)
        let actionYuannei = UIAlertAction(title: "院内用药", style: .default) { (action) in
            let shoushuView = WenZhenChufangView()
            shoushuView.chufangType = "院内用药"
            shoushuView.wash = self.wash
            shoushuView.yaopinArray = NSMutableArray()
            shoushuView.initView()
            self.view.addSubview(shoushuView)
        }
        alert.addAction(actionYuannei)
        let actionHuijia = UIAlertAction(title: "回家用药", style: .default) { (action) in
            let shoushuView = WenZhenChufangView()
            shoushuView.chufangType = "回家用药"
            shoushuView.wash = self.wash
            shoushuView.yaopinArray = NSMutableArray()
            shoushuView.initView()
            self.view.addSubview(shoushuView)
        }
        alert.addAction(actionHuijia)
        alert.popoverPresentationController?.sourceView = (sender as! UIButton)
        alert.popoverPresentationController?.sourceRect = (sender as! UIButton).bounds
        alert.popoverPresentationController?.permittedArrowDirections = .up
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didJianchaButtonClicked(_ sender: Any) {
        if isCurrentChanged
        {
            let alert = UIAlertController(title: nil, message: "该页面有改动，是否要保存?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "不保存", style: .cancel, handler: { (action) in
                self.jianchaAction()
            }))
            alert.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
                self.save()
                self.jianchaAction()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            jianchaAction()
        }
    }
    
    func jianchaAction()
    {
        let jianchaView = WenZhenJianchaView()
        jianchaView.jianchaArray = NSMutableArray()
        jianchaView.wash = self.wash
        jianchaView.initView()
        self.view.addSubview(jianchaView)
    }
    
    @IBAction func didAnpaishoushuButtonClicked(_ sender: Any) {
        if isCurrentChanged
        {
            let alert = UIAlertController(title: nil, message: "该页面有改动，是否要保存?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "不保存", style: .cancel, handler: { (action) in
                self.shoushuAction()
            }))
            alert.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
                self.save()
                self.shoushuAction()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            shoushuAction()
        }
    }
    
    func shoushuAction()
    {
        let shoushuView = WenZhenAnpaishoushuView()
        shoushuView.wash = self.wash
        shoushuView.initView()
        self.view.addSubview(shoushuView)
    }
    
    @IBAction func didAnpaiZhuyuanButtonClicked(_ sender: Any) {
        if isCurrentChanged
        {
            let alert = UIAlertController(title: nil, message: "该页面有改动，是否要保存?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "不保存", style: .cancel, handler: { (action) in
                self.zhuyuanAction()
            }))
            alert.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
                self.save()
                self.zhuyuanAction()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            zhuyuanAction()
        }
    }
    
    func zhuyuanAction()
    {
        let zhuyuanView = WenZhenAnpaiZhuyuanView()
        zhuyuanView.hospitalized_id = (hospitalized_info.object(forKey: "hospitalized_id") as? NSNumber) ?? NSNumber(value: 0)
        zhuyuanView.wash = self.wash
        zhuyuanView.initView()
        self.view.addSubview(zhuyuanView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == zhenduanTextView
        {
            tableView.scrollToRow(at: IndexPath(row: tableViewRowType.zhenduan.rawValue, section: tableViewSectionType.main.rawValue), at: .top, animated: false)
        }
        else if textView == fanganTextView
        {
            tableView.scrollToRow(at: IndexPath(row: tableViewRowType.fangan.rawValue, section: tableViewSectionType.main.rawValue), at: .top, animated: false)
        }
        else if textView == yizhuTextView
        {
            tableView.scrollToRow(at: IndexPath(row: 0, section: tableViewSectionType.medicalNote.rawValue), at: .top, animated: false)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == zhenduanTextView
        {
            isCurrentChanged = true
            base_info.setValue(zhenduanTextView.text, forKey: "diagnose")
        }
        else if textView == fanganTextView
        {
            isCurrentChanged = true
            base_info.setValue(fanganTextView.text, forKey: "treatment")
        }
        else if textView == yizhuTextView
        {
            isCurrentChanged = true
            base_info.setValue(yizhuTextView.text, forKey: "medical_note")
        }
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView == zhenduanTextView
//        {
//            base_info.setValue(zhenduanTextView.text, forKey: "diagnose")
//        }
//        else if textView == fanganTextView
//        {
//            base_info.setValue(fanganTextView.text, forKey: "treatment")
//        }
//    }
    
    func checkPhoto(_ button:UIButton)
    {
        let dict = check_info[button.tag] as! NSDictionary
        let imageString = dict.object(forKey: "image_urls") as! String
        if imageString != ""
        {
            imageUrlArray = imageString.components(separatedBy: ",")
        }

        self.photoView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        self.photoView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
        
        self.centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
        self.centerView.backgroundColor = UIColor.white
        let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
        naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
        self.centerView.addSubview(naviView)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: UIControlState.normal)
        closeButton.addTarget(self, action:#selector(self.closeMask), for: UIControlEvents.touchUpInside)
        self.centerView.addSubview(closeButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 72))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "检查照片"
        self.centerView.addSubview(titleLabel)
        
        let confirmButton = UIButton(frame: CGRect(x: 624, y: 0, width: 100, height: 72))
        confirmButton.setTitle("确定", for: UIControlState.normal)
        confirmButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
        confirmButton.addTarget(self, action: #selector(self.closeMask), for: UIControlEvents.touchUpInside)
        self.centerView.addSubview(confirmButton)
        self.photoView.addSubview(self.centerView)
        
        
        setUpCollectionView()
        
        self.view.addSubview(self.photoView)
    }
    
    func closeMask()
    {
        photoView.removeFromSuperview()
    }
    
    func setUpCollectionView()
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 185, height: 137);
        flowLayout.minimumLineSpacing = 17;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsets(top: 30, left: 70, bottom: 40, right: 70)
        //        flowLayout.headerReferenceSize = CGSize(width: 172, height: 30);
        
        //        photoCollectionView.collectionViewLayout = flowLayout;
        //        self.automaticallyAdjustsScrollViewInsets = NO;
        photoCollectionView = UICollectionView(frame:  CGRect(x: 152, y: 75, width: 720, height: 693), collectionViewLayout: flowLayout)
        photoCollectionView.backgroundColor = UIColor.clear
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UICollectionViewCell.self,                                 forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        photoView.addSubview(photoCollectionView)
        photoCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as UICollectionViewCell
        for view in cell.subviews
        {
            view.removeFromSuperview()
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 185, height: 137))
        
        imageView.sd_setImage(with: URL(string: imageUrlArray?[indexPath.row] ?? ""))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = RGB(r: 186, g: 201, b: 201).cgColor
        imageView.layer.borderWidth = 1
        cell.addSubview(imageView)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 185, height: 137)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row != imageUrlArray.count)
        {
            checkPhotoView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
            checkPhotoView.backgroundColor = UIColor.black
            let photoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.sd_setImage(with: URL(string: imageUrlArray[indexPath.row]))
            checkPhotoView.addSubview(photoImageView)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didCheckPhotoTapped))
            checkPhotoView.addGestureRecognizer(tapGesture)
            self.view.addSubview(checkPhotoView)
        }
    }
    
    func didCheckPhotoTapped()
    {
        checkPhotoView.removeFromSuperview()
    }
    
    // MARK: 手写板
    //
    //
    //
    ///保存写字本图片url的数组
    var inkImageUrlArray:[String]! = []
    
    ///传输状态数组
    var inkUploadStatusArray:[Bool]! = []
    
    ///path数据存储 一次书写的结果
    var currentBezierPathArr = [UIBezierPath]()
    
    var filetotalArr = [[UIBezierPath]]()
    
    var pushInkDeviceButtonView = PushInkDeviceButtonView()
    var checkoutInkDeviceLostTimer = Timer()
    var reConnectedView = ReConnectedView()
    
    func needToReconnectInkDevice() {
        firstConnected = false
        PersisitentTool.shared.hasRetConnectedDevice = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.reConnectedView.alpha = 0
            self.powerOffView.alpha = 0
        }) { (ret) in
            self.reConnectedView.removeFromSuperview()
            self.powerOffView.removeFromSuperview()
            
            //删除UserDefault中的InkDevice数据 重新走连接步骤
            self.deleteUserDefaultInkDeviceData()
            self.startConnectInkDeviceFirstStep()
        }
        
    }
    
    func deleteUserDefaultInkDeviceData() {
        UserDefaults.standard.removeObject(forKey: "InkDeviceName")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "InkDevicedeviceID")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "InkDeviceDiscovered")
        UserDefaults.standard.synchronize()
    }
    
    func noMoreFileReConnect() {
        print("noMoreFileReConnect")
        PersisitentTool.shared.connect()
    }
    
    func registerSomeNoti() {
        
        self.registerNofitification(forMainThread: selectedCellNotiName)
        
        self.registerNofitification(forMainThread: lookCloundVCImgNotiName)
        
        self.registerNofitification(forMainThread: connectDeviceCatchNotiName)
        
        self.registerNofitification(forMainThread: setUpFileDataReceiverFaildNotiName)
        
        self.registerNofitification(forMainThread: inkDeviceHasConnectedNotiName)
        
        self.registerNofitification(forMainThread: inkDevicePowerChangeNotiName)
        
        //inkDeviceDidReconnectedNotification
        self.registerNofitification(forMainThread: inkDeviceDidReconnectedNotification)
        
        //点一下重新连接 设备自动断开蓝牙
        self.registerNofitification(forMainThread: inkDeviceDidReDisConnectedNotification)
        
    }
    
    func removeSomeNoti() {
        self.removeNotification(onMainThread: selectedCellNotiName)
        self.removeNotification(onMainThread: lookCloundVCImgNotiName)
        self.removeNotification(onMainThread: connectDeviceCatchNotiName)
        self.removeNotification(onMainThread: setUpFileDataReceiverFaildNotiName)
        self.removeNotification(onMainThread: inkDeviceHasConnectedNotiName)
        self.removeNotification(onMainThread: inkDevicePowerChangeNotiName)
        self.removeNotification(onMainThread: inkDeviceDidReconnectedNotification)
        self.removeNotification(onMainThread: inkDeviceDidReDisConnectedNotification)
    }
    
    func connectDefaultDeviceTask() {
        //为了一定能连接默认设备 定时3秒监听是否要连接 如果连接上了就不必执行重复任务
        connectDeviceTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            
            if PersisitentTool.shared.hasRetConnectedDevice == false {
                //print("每3s检查一次定时任务.....")
                //self.connectDefaultDevice()
            }
        })
    }
    
    var connectDeviceTimer = Timer();
    
    ///设置inkPicture下载参数
    func setUpInkDownloadParams() {
        ///监听连接丢失回调
        BSWILLManager.shared.connectingInkDevice?.deviceDisconnected = {() in
            print("deviceDisconnected")
        }
        //print("设置下载功能的必要参数\(BSWILLManager.shared.connectingInkDevice)")
        //Optional(<WILLDevices.SmartPadInkDevice: 0x1c43448e0>)
        ///设置下载功能的必要参数
        FileTransferManger.shared.inkDevice = BSWILLManager.shared.connectingInkDevice
        FileTransferManger.shared.deviceWidth = 29700
        FileTransferManger.shared.deviceHeight = 21000
        FileTransferManger.shared.hasDevice()
        FileTransferManger.shared.startDownload(tileSize: 490)
    }
    
    ///写字本离线时写入的文件数组
    var offLinetotalFileArr = [[UIBezierPath]]()
    var indicator = UIActivityIndicatorView()
    var indicatorBg = UIView()
    
    func joinDownLoadMode() {
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
        self.setUpInkDownloadParams()
        
        FileTransferManger.shared.downloadFinished =  { (isfinished,currentBezierpathArr) -> () in
            
            print("下载完成了吗=\(isfinished)")
            
            if isfinished {
                
                //下载到离线区
                InkFileManager.shared.saveDownLoadOffLineImage(bezierPathArr: currentBezierpathArr)
                
            }
            
        }
        
    }
    
    func dealBezierPathArr(bezierPathArr:[UIBezierPath]) {
        
        let cellImg = self.creatCellImage(bezierPathsArr: bezierPathArr)
        
        let v = UploadPicToZimg()
        v.uploadPic(cellImg, finished: { (ret, urlString) in
            print("处理实时模式的图片上传后台ret = \(ret) -- url = \(String(describing: urlString))")
            //写字板图片上传后台ret = true -- url = Optional("http://devimg.we-erp.com/671bf81fea9e6589a2d866a1aebb40df")
            if (ret) {
                self.inkImageUrlArray?.append(urlString!)
                ///保存图片creatDate
                UserDefaults.standard.set(self.dateConvertString(date: Date()), forKey: "imgCreatDate-\(urlString!)")
                UserDefaults.standard.synchronize()
                SDWebImageManager.shared().saveImage(toCache: cellImg, for: URL.init(string: urlString!))
                
                let list = urlString!.split(separator: "/")
                
                let tag = list.last
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
                var filePath = path+"/BezierPath"
                if tag != nil
                {
                    filePath = filePath+"-\(tag!)"
                }
                //归档
                NSKeyedArchiver.archiveRootObject(bezierPathArr, toFile: filePath)
                //self.ziXunContentCollectionView.reloadData()
                
                if realTimeFinishUrlString != urlString! {
                    realTimeFinishUrlString = urlString!
                    print("绑定图片时当前imgArrCount = \(self.inkImageUrlArray.count)")
                    //self.bindDragImgToCurrentZiXun(dragImgUrlStr: urlString!)
                }
            }
            else
            {
                let alert = UIAlertController(title: "图片上传失败", message: "", preferredStyle: UIAlertControllerStyle.alert)
                let okaction = UIAlertAction(title: "好的", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okaction)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
    }
    
    func dateConvertString(date:Date) -> String {
        
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年MM月dd日"
        
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    
    func creatCellImage(bezierPathsArr : [UIBezierPath]) -> UIImage {
        
        ///绘制手写本内容: 因为这里下载的是大图尺寸 所以先画到一个UIImageView上 再缩放成小图添加到cell上
        let bigImageView:UIImageView = UIImageView.init(frame: CGRect.init(x: 270, y: 80, width: 490, height: 693))
        bigImageView.image = UIImage.init(named: "ink_moban2.jpg")
        ///把写字板里的笔迹放到UIView上
        if let sublayers = bigImageView.layer.sublayers {
            for l in sublayers {
                if l is CAShapeLayer {
                    l.removeFromSuperlayer()
                }
            }
        }
        
        for bezPath in bezierPathsArr {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezPath.cgPath
            shapeLayer.position = CGPoint.zero
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            bigImageView.layer.addSublayer(shapeLayer)
        }
        
        ///UIView转UIImage
        UIGraphicsBeginImageContextWithOptions(bigImageView.bounds.size, false, 0.0 )
        bigImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return img
    }
    
    var persistentInkDeviceInfo = InkDeviceInfo()
    
    ///提示开始咨询按钮view
    func startButtonDidpressed() {
        
        ///开始咨询了 显示云朵按钮
        self.cloundButton.isHidden = false
        
        ///显示开始计时按钮和时间
        //self.startButtonBgView.isHidden = false
        
        
        self.selectButton.isHidden = false
        
        self.connectInkDeviceButton.isHidden = false
        
        if !cloundButton.isHidden {
            
            ///再判断设备是否连接
            if UserDefaults.standard.object(forKey: "InkDeviceName") != nil {
                self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
            }
            else {
                
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
            }
        }
        
    }
    
    func test() {
        if (UserDefaults.standard.string(forKey: "InkDeviceName") != nil) {
            if !PersisitentTool.shared.hasRetConnectedDevice && !UserDefaults.standard.bool(forKey: "hasStepFirstConnected") && !cloundButton.isHidden {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
                pushInkDeviceButtonView = PushInkDeviceButtonView.loadNibNamed("PushInkDeviceButtonView")
                pushInkDeviceButtonView.frame = self.view.bounds
                //self.view.addSubview(pushInkDeviceButtonView)
                let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
                pushInkDeviceButtonView.addGestureRecognizer(singleTap)
                
                checkoutInkDeviceLostTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { (t) in
                    if !PersisitentTool.shared.hasRetConnectedDevice {
                        /// 10s未响应 则认为设备被其他pad连去了
                        self.pushInkDeviceButtonView.removeFromSuperview()
                        self.reConnectedView = ReConnectedView.loadNibNamed("ReConnectedView")
                        self.reConnectedView.frame = self.view.bounds
                        self.view.addSubview(self.reConnectedView)
                        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
                        self.reConnectedView.addGestureRecognizer(singleTap)
                        self.reConnectedView.reConnectNowBtn.addTarget(self, action: #selector(self.needToReconnectInkDevice), for: UIControlEvents.touchUpInside)
                    }
                    else {
                        self.pushInkDeviceButtonView.removeFromSuperview()
                    }
                })
            }
            else {
                
            }
        }
    }
    
    var isInkDeviceClosedTimer = Timer()
    
    var powerOffView = PowerOffView()
    
    func checkOutInkDeviceIsPowerOff() {
        
        /**TODO:
         ///数位本关闭了 无法直接知道 那么只能判断一段时间后
         // 没有走no more file 这个方法
         // 也不在reciveFile
         // 并且不在实时模式
         */
        //这个bool值只有在设备已连接 然后关闭设备电源时才会检测到false 如果一开始没连接上 就一直是fasle 所以这个定时器启动的前提是设备连接了
        if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
            print("isInkDeviceClosedTimer.isValid = \(isInkDeviceClosedTimer.isValid)")
            if isInkDeviceClosedTimer.isValid == false {
                
                isInkDeviceClosedTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (t) in
                    print("数位本是否关闭了呢=\(SmartpadManager.sharedInstance.isSmartpadConnected())")
                    
                    if SmartpadManager.sharedInstance.isSmartpadConnected() == false && self.isLongPressed == false{
                        ///看下当前界面是否有连接stepView界面 还有就是要在长按step之后重置该定时器
                        //这个变量是为了重新打开电源时移出powerOffView
                        isInkDeviceConnected = false
                        self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
                        self.powerOffView = PowerOffView.loadNibNamed("PowerOffView")
                        self.powerOffView.frame = self.view.bounds
                        self.view.addSubview(self.powerOffView)
                        
                        if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
                            ///取UserDefault中的name和时间
                            self.powerOffView.namelabel.text = UserDefaults.standard.string(forKey: "InkDeviceName")
                            let InkDeviceDiscovered = UserDefaults.standard.object(forKey: "InkDeviceDiscovered")
                            
                            self.powerOffView.connectTimeLabel.text = self.dateConvertString(date: InkDeviceDiscovered as! Date)
                        }
                        
                        self.powerOffView.pairBtn.addTarget(self, action: #selector(self.needToReconnectInkDevice), for: UIControlEvents.touchUpInside)
                        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
                        self.powerOffView.addGestureRecognizer(singleTap)
                        self.isInkDeviceClosedTimer.invalidate()
                    }
                })
            }
        }
    }
    
    func showPowerOffView() {
        ///powerOffView
        self.powerOffView = PowerOffView.loadNibNamed("PowerOffView")
        self.powerOffView.frame = self.view.bounds
        self.view.addSubview(self.powerOffView)
        
        if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
            ///取UserDefault中的name和时间
            self.powerOffView.namelabel.text = UserDefaults.standard.string(forKey: "InkDeviceName")
            let InkDeviceDiscovered = UserDefaults.standard.object(forKey: "InkDeviceDiscovered")
            
            self.powerOffView.connectTimeLabel.text = self.dateConvertString(date: InkDeviceDiscovered as! Date)
        }
        
        self.powerOffView.pairBtn.addTarget(self, action: #selector(self.needToReconnectInkDevice), for: UIControlEvents.touchUpInside)
        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
        self.powerOffView.addGestureRecognizer(singleTap)
    }
    
    var firstConnected : Bool = false
    var inkDeviceDetailInfoView = DeviceInfoView()
    @IBAction func connectInkDeviceButtonPressed(_ sender: Any) {
        // !UserDefaults.standard.bool(forKey: "hasStepFirstConnected") ||
        print("------------------")
        print(UserDefaults.standard.bool(forKey: "hasStepFirstConnected"))//
        print(UserDefaults.standard.string(forKey: "InkDeviceName"))
        print(PersisitentTool.shared.hasRetConnectedDevice)
        print("------------------")
        
        if blueToothStatus != "poweredOn"
        {
            let alertVC : UIAlertController = UIAlertController.init(title: "连接手写本需要打开蓝牙,请您确认当前设备蓝牙是否打开？", message: "", preferredStyle: .alert)
            let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                
            }
            alertVC.addAction(comfirmAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        if PersisitentTool.shared.hasRetConnectedDevice {
            inkDeviceDetailInfoView = DeviceInfoView.loadNibNamed("DeviceInfoView")
            self.view.addSubview(inkDeviceDetailInfoView)
            ///如果点了 重新配对删除了旧数据 但是没有存入新数据 注意会报nil错误
            if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
                let InkDeviceName = UserDefaults.standard.string(forKey: "InkDeviceName")
                inkDeviceDetailInfoView.deviceNameLabel.text = InkDeviceName
                let InkDeviceDiscovered = UserDefaults.standard.object(forKey: "InkDeviceDiscovered")
                inkDeviceDetailInfoView.lastConnectLabel.text = dateConvertString(date: InkDeviceDiscovered as! Date)
            }
            
            let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
            inkDeviceDetailInfoView.addGestureRecognizer(singleTap)
            inkDeviceDetailInfoView.reConnectBtn.addTarget(self, action: #selector(chongXinPeiDui), for: UIControlEvents.touchUpInside)
        }
        else {
            
            if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
                self.showPowerOffView()
                
            }else {
                startConnectInkDeviceFirstStep()
            }
            //            if !UserDefaults.standard.bool(forKey: "hasStepFirstConnected") || (UserDefaults.standard.string(forKey: "InkDeviceName") == nil) {
            //
            //                startConnectInkDeviceFirstStep()
            //
            //                //self.showPowerOffView()
            //            }
        }
        
        
        
        
    }
    
    //重新配对
    func chongXinPeiDui() {
        
        inkDeviceDetailInfoView.removeFromSuperview()
        //删除UserDefault中的InkDevice数据 重新走连接步骤
        self.deleteUserDefaultInkDeviceData()
        firstConnected = false
        PersisitentTool.shared.hasRetConnectedDevice = false
        ///连接按钮变灰
        connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
        self.startConnectInkDeviceFirstStep()
    }
    
    ///因为连接的时候也要长按 重启设备 所以会和手动关闭设备冲突需要用个flag区分一下
    var isLongPressed : Bool = false
    
    func startConnectInkDeviceFirstStep() {
        
        ///判断系统蓝牙是否开启
        //print("blueToothStatus = \(blueToothStatus)")
        
        if blueToothStatus == "poweredOff" {
            let alertVC : UIAlertController = UIAlertController.init(title: "连接手写本需要打开蓝牙,请您确认当前设备蓝牙是否打开？", message: "", preferredStyle: .alert)
            let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                
            }
            alertVC.addAction(comfirmAction)
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
            
            if !firstConnected {
                if !PersisitentTool.shared.hasRetConnectedDevice {
                    
                    isLongPressed = true
                    openDeviceView = OpenDeviceView.loadNibNamed("OpenDeviceView")
                    openDeviceView.frame = self.view.frame
                    self.view.addSubview(openDeviceView)
                    
                    openDeviceView.nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
                    
                    let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
                    openDeviceView.addGestureRecognizer(singleTap)
                }
            }
        }
    }
    func handleSingleTap(tap:UITapGestureRecognizer) {
        checkoutInkDeviceLostTimer.invalidate()
        UIView.animate(withDuration: 0.4, animations: {
            tap.view?.alpha = 0
        }, completion: { (ret) in
            tap.view?.removeFromSuperview()
        })
    }
    
    func nextStep() {
        self.openDeviceView.removeFromSuperview()
        ///加载连接中界面
        longPressedView = LongPressedView.loadNibNamed("LongPressedView")
        longPressedView.frame = self.view.frame
        self.view.addSubview(longPressedView)
        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
        longPressedView.addGestureRecognizer(singleTap)
        
        /// 为了避免和长按重启设备冲突 关闭监测设备powerOff的定时器
        isInkDeviceClosedTimer.invalidate()
        
        BSWILLManager.shared.startScan()
        
        ///是否扫描到设备
        BSWILLManager.shared.findDeviceHandler = { (arr) -> Void in
            
            //print("是否扫描到设备\(arr)")
            //[Device Name: Bamboo Device ID: 6BC601E6-32BB-0654-E14A-042F39E7BAB9 Type: Bamboo Slate or Folio Discovered: 2018-01-09 02:50:16 +0000]
            
            ///显示设备列表页面
            self.selectDeviceView = SelectDeviceView.loadNibNamed("SelectDeviceView")
            self.selectDeviceView.inkDeviceInfoArr = arr
            self.view.addSubview(self.selectDeviceView)
            self.selectDeviceView.nextStepBtn.addTarget(self, action: #selector(self.willConnectToOneInkDevice), for: UIControlEvents.touchUpInside)
            //            let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
            //            self.selectDeviceView.addGestureRecognizer(singleTap)
        }
        
    }
    
    func willConnectToOneInkDevice() {
        ///改变按钮背景色和字
        self.selectDeviceView.nextStepBtn.backgroundColor = UIColor.gray
        self.selectDeviceView.nextStepBtn.setTitle("等待中", for: UIControlState.normal)
        self.selectDeviceView.nextStepBtn.isEnabled = false
        
        if BSWILLManager.shared.discoveredDevices == nil {
            return
        }
        let deviceInfo : InkDeviceInfo = BSWILLManager.shared.discoveredDevices[0]
        
        BSWILLManager.shared.connectDevice(deviceInfo: deviceInfo, finished: { (ret, message) -> (Void) in
            print("ret = \(ret) and message = \(message)")
            
            if message == "Device connecting" {
                
            }
            else if message == "Tap device button to confirm connection"
            {
                //移除longPressedView, selectDeviceView
                self.longPressedView.removeFromSuperview()
                self.selectDeviceView.removeFromSuperview()
                
                //添加确认按钮界面
                self.confirmView = ConfirmView.loadNibNamed("ConfirmView")
                self.confirmView.frame = self.view.frame
                self.view.addSubview(self.confirmView)
                let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
                self.confirmView.addGestureRecognizer(singleTap)
            }
            else if message == "Device connected" {
                
                ///已经历连接步骤标志 不想单独依赖PersisitentTool.shared.hasRetConnectedDevice 判断是否连接
                UserDefaults.standard.set(true, forKey: "hasStepFirstConnected")
                UserDefaults.standard.synchronize()
                
                ///第一次连接成功标志 重新配对的时候要置false
                self.firstConnected = true
                
                ///已经连接标志 防止从其他界面切换到当前界面重复连接
                PersisitentTool.shared.hasRetConnectedDevice = true
                
                //移除所有子界面
                self.confirmView.removeFromSuperview()
                
                //输入数为本名字界面 也就是可以改数位本名字
                //ChangeDeviceNameView
                self.changeNameView = ChangeDeviceNameView.loadNibNamed("ChangeDeviceNameView")
                self.view.addSubview(self.changeNameView)
                self.changeNameView.nextButton.addTarget(self, action: #selector(self.changeNameFinished), for: UIControlEvents.touchUpInside)
                self.changeNameView.deviceNameTextField.text = deviceInfo.name
                
                ///在这里进入下载模式 不要在最后一步
                ///点连接按钮连接成功之后可直接进入下载模式 不用延时
                self.joinDownLoadMode()
                self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
                
                BSWILLManager.shared.connectingInkDevice?.deviceStatusChanged = {(status1,status2) in
                    print("deviceStatusChanged = \(status1.description),\(status2.description)")
                }
                
                
            }
            else if message == "Failed to connect to device. Restarting scan." {
                
                let alertVC : UIAlertController = UIAlertController.init(title: "连接丢失\n请再试一次。", message: "", preferredStyle: .alert)
                
                let comfirmAction = UIAlertAction(title: "请再试一次", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                    self.selectDeviceView.removeFromSuperview()
                    ///再次回到长按界面
                    self.view.addSubview(self.longPressedView)
                }
                
                alertVC.addAction(comfirmAction)
                
                self.present(alertVC, animated: true, completion: nil)
                
            }
            
        })
    }
    
    func changeNameFinished() {
        ///修改数为本名字
        if changeNameView.deviceNameTextField.text == "" || changeNameView.deviceNameTextField.text == nil {
            changeNameView.deviceNameTextField.text = "Bamboo 智能数位本"
        }
        SmartpadManager.sharedInstance.setDeviceName(changeNameView.deviceNameTextField.text ?? "Bamboo 智能数位本") { (ret, error) in
            print("修改数为本名字ret = \(ret) error = \(error.debugDescription)")
        }
        
        ///修改UserDefault中的名字
        UserDefaults.standard.set(changeNameView.deviceNameTextField.text ?? "Bamboo 智能数位本", forKey: "InkDeviceName")
        UserDefaults.standard.synchronize()
        
        self.changeNameView.removeFromSuperview()
        
        ///连接完成view
        connectFinishedView = PairSuccessView.loadNibNamed("PairSuccessView")
        self.view.addSubview(connectFinishedView)
        connectFinishedView.nextButton.addTarget(self, action: #selector(connectOk), for: UIControlEvents.touchUpInside)
    }
    
    ///点了连接完成 “完成”按钮
    func connectOk() {
        connectFinishedView.removeFromSuperview()
        
    }
    @IBOutlet weak var connectInkDeviceButton: UIButton!
    
    var openDeviceView = OpenDeviceView()
    var longPressedView = LongPressedView()
    var confirmView = ConfirmView()
    var selectDeviceView = SelectDeviceView()
    var changeNameView = ChangeDeviceNameView()
    var connectFinishedView = PairSuccessView()
    
    func dealBlueToothReStart() {
        connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
        pushInkDeviceButtonView = PushInkDeviceButtonView.loadNibNamed("PushInkDeviceButtonView")
        pushInkDeviceButtonView.frame = self.view.bounds
        //self.view.addSubview(pushInkDeviceButtonView)
        self.powerOffView = PowerOffView.loadNibNamed("PowerOffView")
        self.powerOffView.frame = self.view.bounds
        self.view.addSubview(self.powerOffView)
        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
        pushInkDeviceButtonView.addGestureRecognizer(singleTap)
        checkoutInkDeviceLostTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { (t) in
            if !PersisitentTool.shared.hasRetConnectedDevice {
                /// 10s未响应 则认为设备被其他pad连去了
                self.pushInkDeviceButtonView.removeFromSuperview()
                self.reConnectedView = ReConnectedView.loadNibNamed("ReConnectedView")
                self.reConnectedView.frame = self.view.bounds
                self.view.addSubview(self.reConnectedView)
                let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
                self.reConnectedView.addGestureRecognizer(singleTap)
                self.reConnectedView.reConnectNowBtn.addTarget(self, action: #selector(self.needToReconnectInkDevice), for: UIControlEvents.touchUpInside)
            }
            else {
                self.pushInkDeviceButtonView.removeFromSuperview()
            }
        })
    }
    
    //    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    //        print("外设=\(peripheral.state.rawValue)")
    //
    //    }
    
    var bluetoothManager = CBCentralManager()
    var blueToothStatus : String?
    
    ///外设管理者CBPeripheralManager
    //var peripheralManager = CBPeripheralManager()
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        central.scanForPeripherals(withServices: nil, options: nil)
        
        print("蓝牙central = \(central)")
        switch central.state {
            
        case CBManagerState.poweredOn:
            if blueToothStatus == "poweredOff" {
                dealBlueToothReStart()
            }
            blueToothStatus = "poweredOn"
            print("蓝牙已打开,请扫描外设")
            print("hasRetConnectedDevice\(PersisitentTool.shared.hasRetConnectedDevice)")
            //self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
            //connectInkDeviceButton.isEnabled = true
            
        case CBManagerState.unauthorized:
            print("这个应用程序是无权使用蓝牙低功耗")
        case CBManagerState.poweredOff:
            blueToothStatus = "poweredOff"
            isInkDeviceConnected = false
            print("蓝牙目前已关闭")
            
            dealBlueToothCloseStatus()
        case CBManagerState.resetting:
            print("蓝牙resetting")
        default:
            print("中央管理器没有改变状态")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("蓝牙didConnect")
    }
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("蓝牙willRestoreState")
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("蓝牙didFailToConnect")
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("蓝牙didDisconnectPeripheral")
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("蓝牙didDiscover")
    }
    
    
    func dealBlueToothCloseStatus() {
        
        ///连接按钮断开
        connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
        //connectInkDeviceButton.isEnabled = false
        ///提示用户先去打开系统设置的蓝牙
        let alertVC : UIAlertController = UIAlertController.init(title: "连接数位本需要打开蓝牙,请您确认蓝牙是否打开", message: "", preferredStyle: .alert)
        let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            
        }
        alertVC.addAction(comfirmAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var selectButton: UIButton!
    
    //选择按钮被点击
    @IBAction func selectbuttonPressed(_ sender: UIButton) {
        
        if  sender.currentTitle == "选择"{
            changeSelectedBtn()
            
        }
        else {
            changeSelectBtn2()
        }
    }
    ///“选择”->“取消”
    func changeSelectedBtn() {
        //1.选择->取消
        selectButton.setTitle("取消", for: UIControlState.normal)
        
        //2.setUI Navi
        //titleLabel.text = "选择"
        connectInkDeviceButton.isHidden=true
        
        //3.显示 合并, 移出, 删除 3个按钮
        combileButton.isHidden=false
        removeButton.isHidden=false
        deleteButton.isHidden=false
        //删除 云朵按钮隐藏
        cloundButton.isHidden = true
        
        //4.cell当前处与选中效果 这时去掉defaultCell
        //通知ZixunDetailRightZixunContentViewController reload collectionView
        let inkDeviceCellDidSelected = Notification.Name.init(rawValue: "InkDeviceCellDidSelected")
        NotificationCenter.default.post(name: inkDeviceCellDidSelected, object: self, userInfo: ["select":"选择"])
        
        //删除和移出按钮不可点击 当选择cell大于1个时可点击
        removeButton.isEnabled = false
        removeButton.setTitleColor(UIColor.init(red: 197/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1), for: UIControlState.normal)
        deleteButton.isEnabled = false
        combileButton.isEnabled = false
        combileButton.setTitleColor(UIColor.init(red: 197/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1), for: UIControlState.normal)
    }
    
    ///“取消”->“选择”
    func changeSelectBtn2() {
        //1.取消->选择
        selectButton.setTitle("选择", for: UIControlState.normal)
        //2.setUI Navi
        //titleLabel.text = "咨询内容"
        connectInkDeviceButton.isHidden=false
        //hidden 合并 移出 删除 3个按钮
        combileButton.isHidden=true
        removeButton.isHidden=true
        deleteButton.isHidden=true
        
        //云朵按钮隐藏
        cloundButton.isHidden = false
        
        //3.cell选中效果
        //通知ZixunDetailRightZixunContentViewController reload collectionView
        let inkDeviceCellDidSelected = Notification.Name.init(rawValue: "InkDeviceCellDidSelected")
        NotificationCenter.default.post(name: inkDeviceCellDidSelected, object: self, userInfo: ["select":"未选择"])
        
        selectedCellArr.removeAll()
        //self.zixunRightContentVC?.ziXunContentCollectionView.reloadData()
    }
    
    ///处理合并
    func dealWithCombine(willCombineArr : [String]) {
        ///临时数组 存储从UserDefaults中取出来的imgUrl对应的点数组
        let pointArrs = NSMutableArray()
        for imgUrl in willCombineArr {
            //print("即将要合并的imgUrl = \(imgUrl)")
            //print(UserDefaults.standard.object(forKey: "ink-\(imgUrl)"))//一个包含N个点的数组
            
            let tag = imgUrl.subString(start: 25, length: 32)
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            let filePath = path+"/BezierPath"+"-\(tag)"
            print(NSKeyedUnarchiver.unarchiveObject(withFile: filePath))
            
            if (NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [Any]).count == 0
            {
                let alertVC : UIAlertController = UIAlertController.init(title: "", message: "您选中的图片在本机没有存储笔画，请重新选择。", preferredStyle: .alert)
                
                let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                    return
                    //self.deleteSelectCellImgs()
                    
                }
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (action:UIAlertAction)in
                    
                }
                alertVC.addAction(comfirmAction)
                
                //alertVC.addAction(cancelAction)
                
                self.present(alertVC, animated: true, completion: nil)
            }
            else
            {
                pointArrs.addObjects(from: NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [Any])
            }
            //解归档（反序列化）
            //NSArray *currentBezierPathArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            //pointArrs.addObjects(from:(UserDefaults.standard.object(forKey: "ink-\(imgUrl)") as! [Any]))
            //删除inkImageUrlArray中的imgUrl
            for (index,url) in self.inkImageUrlArray!.enumerated() {
                if imgUrl == url {
                    
                    ///同时删除UserDefault中的内容
                    BezierPathManager.sharedInstance().removeBezierPathArr(url)
                    
                    ///删除collection数据源中数据
                    self.inkImageUrlArray.remove(at: index)
                    
                }
            }
            
        }
        
        //print("处理合并\(pointArrs)")//pointArrs要转成UIBezierPath
        let bezierPathArr = pointArrs//BezierPathManager.sharedInstance().dealPointsStr(toBezierPathArr2: pointArrs as! [Any])
        
        ///而且要发咨询请求API
//        zixunDataUpDate()
        ///遗留问题:合并之后还能加载原来的子图片 是因为后台只有增，没有删
        
        //print("待合并处理的\(bezierPathArr)")
        ///多张变一张 合并结束 刷新Navi(相当于点“取消”按钮一样)
        self.dealBezierPathArr(bezierPathArr: bezierPathArr as! [UIBezierPath])
        self.deleteSelectCellImgs()
        changeSelectBtn2()
        
        ///清空临时数组
        pointArrs.removeAllObjects()
        
    }
    //ziXunIdForAPI
//    func zixunDataUpDate() {
//
//        let request = HZixunUpdate()
//        request.params["advisory_id"] = self.zixunRightContentVC!.zixun?.zixun_id
//
//        ///此处不能用inkImageUrlArray 因为这里面可能包含写字本下载的图片
//        var paramsInkImageUrlArray = [String]()
//        for url in self.zixunRightContentVC!.inkImageUrlArray {
//            if url.hasPrefix("http") {
//                paramsInkImageUrlArray.append(url)
//            }
//        }
//        let imageStr = paramsInkImageUrlArray.joined(separator: ",")
//        request.params["image_urls"] = imageStr
//        request.params["is_writing_board"] = true
//        request.execute()
//        print("更新咨询写字本图片请求参数=\(request.params)")
//
//    }
    
    //合并按钮
    @IBOutlet weak var combileButton: UIButton!
    
    
    ///合并[UIBezierPath]用的临时数组
    var combilePath = [UIBezierPath]()
    
    ///合并按钮点击方法
    @IBAction func combileButtonPressed(_ sender: Any) {
        
        ///没有选中任何cell时直接跳过 或者给出提示
        if selectedCellArr.count <= 1 {
            let noSelectMsg = CBMessageView.init(title: "请至少选择2页来合并")
            noSelectMsg?.show()
            return
        }
        
        ///处理合并selectedCellArr 是一个装imgUrl的数组 通过imgUrl可以取到UserDefault中的UIBezierPath 合并成一张img 再重新存入UserDefault 同时删除合并前的数组 刷新collectionView
        dealWithCombine(willCombineArr: selectedCellArr)
        
    }
    
    //移出按钮
    @IBOutlet weak var removeButton: UIButton!
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        
        ///移出到离线区
        InkFileManager.shared.removeImgFromZixunContent(selectedImgArr: selectedCellArr)
        
        ///同时删除选中的内容
        deleteSelectCellImgs()
        
    }
    
    //删除
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        showComfirmDeleteMsg()
    }
    
    func showComfirmDeleteMsg() {
        
        let alertVC : UIAlertController = UIAlertController.init(title: "确定删除吗", message: "", preferredStyle: .alert)
        
        let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            
            self.deleteSelectCellImgs()
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (action:UIAlertAction)in
            
        }
        alertVC.addAction(comfirmAction)
        
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    var willDeleteButNotHaveImgID = [String]()
    func deleteSelectCellImgs() {
        
        if selectedCellArr.contains(DragImgUrlString ?? "") {
            DragImgUrlString = nil
        }
        //realTimeFinishUrlString
        if selectedCellArr.contains(realTimeFinishUrlString ?? "") {
            realTimeFinishUrlString = nil
        }
        
        ///选择了之后点删除按钮 批量删除selectedCell
        // selectedCellArr 里面装的是imgUrl 后台imgUrl格式是ID@http:XXX@t ID存在了UserDefault key是http:XXX 这个在zixunRightContentVC就已经处理
        
        print("准备批量删除=\(selectedCellArr)")
        //TODO :因为写完不会立即获得imgID 得出去进来才有 所以在这里删除后台图片可能获取不到imgID
        var willDeleteIDsArr = [String]()
        
        for imgUrl in selectedCellArr {
            if UserDefaults.standard.string(forKey: "imgID-\(imgUrl)") != nil {
                willDeleteIDsArr.append(UserDefaults.standard.string(forKey: "imgID-\(imgUrl)")!)
            }
            else
            {
                ///如果从实时模式刚写完就删 这时候因为没有获得imgID 无法删除
                ///只能暂时删除当前数据源 然后等待下载zixun Set方法被调用后再删后台数据
                willDeleteButNotHaveImgID.append(imgUrl)
            }
            
        }
        print("willDeleteIDsArr = \(willDeleteIDsArr)")
        UserDefaults.standard.set(willDeleteButNotHaveImgID, forKey: "willDeleteButNotHaveImgID")
        UserDefaults.standard.synchronize()
        
        ///删除ziXunContentCollectionView数据源
        var inkImgUrls = [String]()
        if self.inkImageUrlArray != nil {
            
            inkImgUrls = self.inkImageUrlArray ?? [""]
            print("inkImgUrls = \(inkImgUrls)")
            
            ///选出inkImageUrlArray中未被选中的imgUrl
            var inkImgUrls2 = inkImgUrls.filter({ (string) -> Bool in
                
                return !selectedCellArr.contains(string)
            })
            
            print("inkImgUrls2 = \(inkImgUrls2)")
            
            self.inkImageUrlArray.removeAll()
            self.inkImageUrlArray = inkImgUrls2
            inkImgUrls2.removeAll()
        }
        
        /// TODO :有bug
        //self.zixunRightContentVC?.ziXunUpDateAPI(willDeleteImgIDsArr: willDeleteIDsArr)
        deleteSome(willDeleteIDsArr: willDeleteIDsArr, selectCellArr: selectedCellArr)
        
        //self.ziXunContentCollectionView.reloadData()
        
        selectedCellArr.removeAll()
        
        ///恢复“选择”按钮
        changeSelectBtn2()
        
    }
    
    ///TODO : test批量删除
    func deleteSome(willDeleteIDsArr:[String],selectCellArr : [String]) {
        
        let request = HZixunUpdate2()
        request.params["advisory_id"] = ziXunIdForAPI
        
        ///此处不能用inkImageUrlArray 因为这里面可能包含写字本下载的图片
        var paramsInkImageUrlArray = [String]()
        
        ///防止发了不是http开头的图片
        for url in selectCellArr {
            if url.hasPrefix("http") {
                paramsInkImageUrlArray.append(url)
            }
        }
        
        let imageStr = paramsInkImageUrlArray.joined(separator: ",")
        request.params["image_urls"] = imageStr
        
        request.params["is_writing_board"] = true
        request.params["del_img_list"] = willDeleteIDsArr.joined(separator: ",")
        
        request.execute()
        
        print("选择删除参数HZixunUpdate2=\(request.params)")
        
    }
    
    ///不要定义局部的变量（添加到UIWindow上之后一点Cell会消失） 最好定义成强引用属性
    ///点击navi上的云朵 show出的左侧离线图片View
    var cloudVC = InkCloundVC()
    
    ///云朵按钮
    @IBOutlet weak var cloundButton: UIButton!
    
    @IBAction func cloundButtonDidPressed(_ sender: Any) {
        print("cloudVC = \(cloudVC)")
        
        cloudVC = InkCloundVC()
        cloudVC.view.frame = CGRect.init(x: 0, y: 0, width: 1024, height: 768)
        //cloudVC.offLinetotalFileArr = self.offLinetotalFileArr
        UIApplication.shared.keyWindow?.addSubview(cloudVC.view)
        cloudVC.show()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}
