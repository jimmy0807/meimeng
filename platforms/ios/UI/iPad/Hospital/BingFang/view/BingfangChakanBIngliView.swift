//
//  BingfangChakanBIngliView.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/30.
//

import UIKit

class BingfangChakanBIngliView: UIView, UITableViewDelegate, UITableViewDataSource,
UICollectionViewDelegate, UICollectionViewDataSource{
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
        case chuyuanxinxi
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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateScrollView: UIScrollView!
    
    var wenzhenDetailDict = NSDictionary()
    var currentIndex = 0
    var zhenduanTextView:KMPlaceholderTextView!
    var fanganTextView:KMPlaceholderTextView!
    var yizhuTextView:KMPlaceholderTextView!
    var base_info = NSDictionary()
    var check_info = NSArray()
    var hospitalized_info = NSDictionary()
    var operate_info = NSDictionary()
    var prescription_home_info = NSArray()
    var prescription_hospital_info = NSArray()
    var prescription_operate_info = NSArray()
    var hospitalized_check_out_info = NSDictionary()
    var medicalNote = ""
    var selectVC : SeletctListViewController?
    var isCurrentEditable = false
    var photoView : UIView!
    var centerView : UIView!
    var photoCollectionView : UICollectionView!
    var checkPhotoView : UIView!
    var imageUrlArray:[String]! = []
    var operate_id : NSNumber!
    {
        didSet
        {
            let request = BSFetchMemberCardRequest(memberID: member_id)
            request?.execute()//BSCoreDataManager.current().findEntity("CDMember", withValue: wash.member_id, forKey: "memberID") as? CDMember
            
            let listRequest = GetMedicalRecordRequest()
            listRequest.params["member_id"] = member_id
            listRequest.params["operate_id"] = operate_id
            listRequest.execute()
            
            refreshDateView()
            self.registerNofitification(forMainThread: "GetMedicalRecordResponse")
            self.registerNofitification(forMainThread: "GetMedicalRecordDetailResponse")
            self.registerNofitification(forMainThread: "DeleteChufangResponse")
            
        }
    }
    
    var chakanbingliDict : NSDictionary = NSDictionary()
    {
        didSet
        {
        }
    }
    
    var wenzhenDateArray : NSArray = NSArray()
//    {
//        
//    }
    
    var member_id:NSNumber!
//    {
//        didSet
//        {
//            let request = BSFetchMemberCardRequest(memberID: member_id)
//            request?.execute()//BSCoreDataManager.current().findEntity("CDMember", withValue: wash.member_id, forKey: "memberID") as? CDMember
//
//            let listRequest = GetMedicalRecordRequest()
//            listRequest.params["member_id"] = member_id
//            listRequest.execute()
//
//            refreshDateView()
//            self.registerNofitification(forMainThread: "GetMedicalRecordResponse")
//            self.registerNofitification(forMainThread: "GetMedicalRecordDetailResponse")
//            self.registerNofitification(forMainThread: "DeleteChufangResponse")
//
//        }
//    }
    
    var member:CDMember!
//    {
//        didSet
//        {
//            let request = BSFetchMemberCardRequest(memberID: member_id)
//            request?.execute()//BSCoreDataManager.current().findEntity("CDMember", withValue: wash.member_id, forKey: "memberID") as? CDMember
//            
//            let listRequest = GetMedicalRecordRequest()
//            listRequest.params["member_id"] = member_id
//            listRequest.execute()
//            
//            refreshDateView()
//            self.registerNofitification(forMainThread: "GetMedicalRecordResponse")
//            self.registerNofitification(forMainThread: "GetMedicalRecordDetailResponse")
//            self.registerNofitification(forMainThread: "DeleteChufangResponse")
//        }
//    }
    
    
//    override func awakeFromNib() {
//        let request = BSFetchMemberCardRequest(memberID: member_id)
//        request?.execute()//BSCoreDataManager.current().findEntity("CDMember", withValue: wash.member_id, forKey: "memberID") as? CDMember
//        
//        let listRequest = GetMedicalRecordRequest()
//        listRequest.params["member_id"] = member_id
//        listRequest.execute()
//        
//        refreshDateView()
//        self.registerNofitification(forMainThread: "GetMedicalRecordResponse")
//        self.registerNofitification(forMainThread: "GetMedicalRecordDetailResponse")
//        self.registerNofitification(forMainThread: "DeleteChufangResponse")
//    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "GetMedicalRecordResponse" )
        {
            if let array = notification.userInfo!["data"] as? NSArray
            {
                wenzhenDateArray = array
                refreshDateView()
                let request = GetMedicalRecordDetailRequest()
                request.params["operate_id"] = (array[0] as! NSDictionary).object(forKey: "operate_id")
                request.execute()
                
            }
        }
        else if ( notification.name.rawValue == "GetMedicalRecordDetailResponse" )
        {
            if let dict = notification.userInfo!["data"] as? NSDictionary
            {
                print(dict)
                wenzhenDetailDict = dict
                base_info = wenzhenDetailDict.object(forKey: "base_info") as! NSDictionary
                medicalNote = "\(base_info.object(forKey: "medical_note") ?? "")"
                check_info = wenzhenDetailDict.object(forKey: "check_info") as! NSArray
                hospitalized_info = wenzhenDetailDict.object(forKey: "hospitalized_info") as! NSDictionary
                hospitalized_check_out_info = wenzhenDetailDict.object(forKey: "hospitalized_check_out_info") as! NSDictionary
                operate_info = wenzhenDetailDict.object(forKey: "operate_info") as! NSDictionary
                prescription_home_info = wenzhenDetailDict.object(forKey: "prescription_home_info") as! NSArray
                prescription_hospital_info = wenzhenDetailDict.object(forKey: "prescription_hospital_info") as! NSArray
                prescription_operate_info = wenzhenDetailDict.object(forKey: "prescription_operate_info") as! NSArray
                tableView.reloadData()
            }
        }
        else if ( notification.name.rawValue == "DeleteChufangResponse" )
        {
            let listRequest = GetMedicalRecordRequest()
            listRequest.params["member_id"] = member_id
            listRequest.execute()
        }
    }
    
    func refreshDateView()
    {
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
            button.addTarget(self, action: #selector(self.didDateTabSelected(_:)), for: UIControlEvents.touchUpInside)
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
            
//            if let canUpdate = detailDict.object(forKey: "can_update") as? Bool, canUpdate == true
//            {
//                dateLabel.textColor = RGB(r: 37, g: 37, b: 37)
//                doctorLabel.textColor = RGB(r: 37, g: 37, b: 37)
//                isCurrentEditable = true
//            }
//            else
//            {
//                dateLabel.textColor = RGB(r: 153, g: 153, b: 153)
//                doctorLabel.textColor = RGB(r: 153, g: 153, b: 153)
//                isCurrentEditable = false
//            }
            dateScrollView.addSubview(dateLabel)
            dateScrollView.addSubview(doctorLabel)
            let rightLine = UIView(frame: CGRect(x: i*122 + 122, y: 0, width: 1, height: 58))
            rightLine.backgroundColor = RGB(r: 224, g: 230, b: 230)
            dateScrollView.addSubview(rightLine)
            if currentIndex == i
            {
                let bottomLine = UIView(frame: CGRect(x: i*122, y: 56, width: 122, height: 2))
                bottomLine.backgroundColor = RGB(r: 96, g: 211, b: 212)
                dateScrollView.addSubview(bottomLine)
            }
        }
    }

    func didDateTabSelected(_ sender : UIButton)
    {
        currentIndex = sender.tag
        refreshDateView()
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
            return 130
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
        else if (indexPath.section == tableViewSectionType.chuyuanxinxi.rawValue)
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
        else if section == tableViewSectionType.chuyuanxinxi.rawValue
        {
            if "\(hospitalized_check_out_info.object(forKey: "name") ?? "")" == ""
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "WenzhenDetailMainTableViewCell")
        cell.selectionStyle = .none
        let leftLabel = UILabel(frame: CGRect(x: 23, y: 21, width: 400, height: 16))
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.textColor = RGB(r: 37, g: 37, b: 37)
        let rightLabel = UILabel(frame: CGRect(x: 400, y: 21, width: 140, height: 16))
        rightLabel.textAlignment = .right
        rightLabel.textColor = RGB(r: 37, g: 37, b: 37)
        let rightArrow = UIImageView(frame: CGRect(x: 555, y: 20, width: 8, height: 14))
        rightArrow.image = #imageLiteral(resourceName: "pos_right_arrow.png")
        let bottomLine = UIView()
        bottomLine.backgroundColor = RGB(r: 224, g: 230, b: 230)
        if (indexPath.section == tableViewSectionType.main.rawValue)
        {
            switch indexPath.row {
            case tableViewRowType.operateItem.rawValue:
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
                rightLabel.tag = 101
                rightLabel.text = "\(base_info.object(forKey: "anesthetist_name") ?? "")"
                cell.addSubview(rightLabel)
                cell.addSubview(rightArrow)
                bottomLine.frame = CGRect(x: 23, y: 56, width: 556, height: 1)
            case tableViewRowType.zhenduan.rawValue:
                leftLabel.text = "诊断："
                rightLabel.text = "请选择模板"
                //cell.addSubview(rightLabel)
                cell.addSubview(rightArrow)
                zhenduanTextView = KMPlaceholderTextView(frame: CGRect(x: 20, y: 38, width: 556, height: 170))
                zhenduanTextView.font = UIFont.systemFont(ofSize: 16)
                zhenduanTextView.text = "\(base_info.object(forKey: "diagnose") ?? "")"
                zhenduanTextView.isEditable = false
                cell.addSubview(zhenduanTextView)
                bottomLine.frame = CGRect(x: 23, y: 233, width: 556, height: 1)
            case tableViewRowType.fangan.rawValue:
                leftLabel.text = "治疗方案："
                rightLabel.text = "请选择模板"
                //cell.addSubview(rightLabel)
                cell.addSubview(rightArrow)
                fanganTextView = KMPlaceholderTextView(frame: CGRect(x: 20, y: 38, width: 556, height: 170))
                fanganTextView.font = UIFont.systemFont(ofSize: 16)
                fanganTextView.isEditable = false
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
                yizhuTextView.text = "\(base_info.object(forKey: "medical_note") ?? "")"
                yizhuTextView.isEditable = false
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
                let deleteButton = UIButton(frame: CGRect(x: 480, y: 50, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true
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
                let deleteButton = UIButton(frame: CGRect(x: 480, y: 10, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true
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
                let deleteButton = UIButton(frame: CGRect(x: 480, y: 50, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true
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
                let deleteButton = UIButton(frame: CGRect(x: 480, y: 10, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true
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
                let deleteButton = UIButton(frame: CGRect(x: 480, y: 50, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true
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
                let deleteButton = UIButton(frame: CGRect(x: 480, y: 10, width: 50, height: 20))
                deleteButton.setTitle("删除", for: .normal)
                deleteButton.tag = dict.object(forKey: "prescription_id") as! Int
                deleteButton.addTarget(self, action: #selector(self.deleteChufang(_:)), for: .touchUpInside)
                deleteButton.setTitleColor(RGB(r: 255, g: 72, b: 72), for: .normal)
                if isCurrentEditable == true
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
        else if (indexPath.section == tableViewSectionType.chuyuanxinxi.rawValue)
        {
            leftLabel.text = "出院信息："
            let zhuyuanxinxiTextView = UITextView(frame: CGRect(x: 20, y: 50, width: 530, height: 140))
            zhuyuanxinxiTextView.textColor = RGB(r: 153, g: 153, b: 153)
            zhuyuanxinxiTextView.text = "\(hospitalized_check_out_info.object(forKey: "name") ?? "")"
            zhuyuanxinxiTextView.font = UIFont.systemFont(ofSize: 16)
            zhuyuanxinxiTextView.isEditable = false
            cell.addSubview(zhuyuanxinxiTextView)
            cell.addSubview(leftLabel)
            bottomLine.frame = CGRect(x: 23, y: 239, width: 556, height: 1)
            cell.addSubview(bottomLine)
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.section == tableViewSectionType.main.rawValue)
//        {
//            switch indexPath.row {
//            case tableViewRowType.doctor.rawValue:
//                self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
//                let doctorArray = BSCoreDataManager.current().fetchDoctorStaffs(withShopID: PersonalProfile.current().bshopId)
//                
//                self.selectVC?.countOfTheList = {
//                    return doctorArray.count
//                }
//                
//                self.selectVC?.nameAtIndex = { index in
//                    let doctor = doctorArray[index]
//                    return doctor.name
//                }
//                
//                self.selectVC?.selectAtIndex = {[weak self] index in
//                    let doctor = doctorArray[index]
//                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
//                    label.text = doctor.name
//                }
//                
//                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
//                self.selectVC?.showWithAnimation();
//            case tableViewRowType.peitaiNurse.rawValue:
//                self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
//                let nurseArray = BSCoreDataManager.current().fetchOperateStaffs(withShopID: PersonalProfile.current().bshopId)
//                
//                self.selectVC?.countOfTheList = {
//                    return nurseArray.count
//                }
//                
//                self.selectVC?.nameAtIndex = { index in
//                    let nurse = nurseArray[index]
//                    return nurse.name
//                }
//                
//                self.selectVC?.selectAtIndex = {[weak self] index in
//                    let nurse = nurseArray[index]
//                    
//                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
//                    label.text = nurse.name
//                }
//                
//                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
//                self.selectVC?.showWithAnimation();
//            case tableViewRowType.xunhuiNurse.rawValue:
//                self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
//                let nurseArray = BSCoreDataManager.current().fetchOperateStaffs(withShopID: PersonalProfile.current().bshopId)
//                
//                self.selectVC?.countOfTheList = {
//                    return nurseArray.count
//                }
//                
//                self.selectVC?.nameAtIndex = { index in
//                    let nurse = nurseArray[index]
//                    return nurse.name
//                }
//                
//                self.selectVC?.selectAtIndex = {[weak self] index in
//                    let nurse = nurseArray[index]
//                    
//                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
//                    label.text = nurse.name
//                }
//                
//                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
//                self.selectVC?.showWithAnimation();
//            case tableViewRowType.mazuishi.rawValue:
//                self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
//                let doctorArray = BSCoreDataManager.current().fetchDoctorStaffs(withShopID: PersonalProfile.current().bshopId)
//                
//                self.selectVC?.countOfTheList = {
//                    return doctorArray.count
//                }
//                
//                self.selectVC?.nameAtIndex = { index in
//                    let doctor = doctorArray[index]
//                    return doctor.name
//                }
//                
//                self.selectVC?.selectAtIndex = {[weak self] index in
//                    let doctor = doctorArray[index]
//                    let label = tableView.cellForRow(at: indexPath)?.viewWithTag(101) as! UILabel
//                    label.text = doctor.name
//                }
//                
//                UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
//                self.selectVC?.showWithAnimation();
//            default:
//                print("default")
//            }
//        }
//    }
    
    func deleteChufang(_ sender:UIButton)
    {
        let request = DeleteChufangRequest()
        request.params["prescription_id"] = NSNumber(value: sender.tag)
        request.execute()
    }
    
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
        
        UIApplication.shared.keyWindow?.addSubview(self.photoView)
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
            UIApplication.shared.keyWindow?.addSubview(checkPhotoView)
        }
    }
    
    func didCheckPhotoTapped()
    {
        checkPhotoView.removeFromSuperview()
    }
}
