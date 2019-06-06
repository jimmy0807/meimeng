//
//  WenZhenAnpaiZhuyuanView.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/26.
//

import UIKit

class WenZhenAnpaiZhuyuanView: UIView
{
    public var wash:CDPosWashHand!
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
    var hospitalized_id : NSNumber!
    
    func initView()
    {
        self.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        self.zhuyuanView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        self.zhuyuanView.isUserInteractionEnabled = true
        self.zhuyuanView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
        
        self.centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
        self.centerView.backgroundColor = UIColor.white
        self.centerView.isUserInteractionEnabled = true
        let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
        naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
        self.centerView.addSubview(naviView)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: UIControlState.normal)
        closeButton.addTarget(self, action:#selector(self.closeMask), for: UIControlEvents.touchUpInside)
        self.centerView.addSubview(closeButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 72))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "安排病房"
        self.centerView.addSubview(titleLabel)
        
        let confirmButton = UIButton(frame: CGRect(x: 624, y: 0, width: 100, height: 72))
        confirmButton.setTitle("确定", for: UIControlState.normal)
        confirmButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
        confirmButton.addTarget(self, action: #selector(self.confirm), for: UIControlEvents.touchUpInside)
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
            levelButton.addTarget(self, action: #selector(self.levelSelected(_:)), for: UIControlEvents.touchUpInside)
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
        nurseButton.setTitle("请选择…", for: .normal)
        nurseButton.setTitleColor(RGB(r: 37, g: 37, b: 37), for: .normal)
        nurseButton.addTarget(self, action: #selector(self.nurseSelected), for: .touchUpInside)
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
        doctorButton.setTitle("请选择…", for: .normal)
        doctorButton.setTitleColor(RGB(r: 37, g: 37, b: 37), for: .normal)
        doctorButton.addTarget(self, action: #selector(self.doctorSelected), for: .touchUpInside)
        self.centerView.addSubview(doctorButton)
        
        let dateLabel = UILabel(frame: CGRect(x: 65, y: 460, width: 324, height: 22))
        dateLabel.text = "住院日期"
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = titleColor
        self.centerView.addSubview(dateLabel)
        timeButton = UIButton(frame: CGRect(x: 65, y: 495, width: 594, height: 60))
        timeButton.setTitle(formatDate(selectedDate), for: .normal)
        timeButton.layer.cornerRadius = 6
        timeButton.layer.borderColor = borderColor.cgColor
        timeButton.layer.borderWidth = 1
        timeButton.setTitleColor(RGB(r: 37, g: 37, b: 37), for: .normal)
        timeButton.addTarget(self, action: #selector(self.selectTime), for: .touchUpInside)
        self.centerView.addSubview(timeButton)
        
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
        self.addSubview(self.zhuyuanView)
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
    
    func closeMask()
    {
//        if (self.zhuyuanView != nil)
//        {
//            self.zhuyuanView.removeFromSuperview()
//        }
        self.removeFromSuperview()
    }
    
    func confirm()
    {
        if doctorId == nil
        {
            let alert = UIAlertView(title: "请选择负责医生", message: nil, delegate: nil, cancelButtonTitle: "好的")
            alert.show()
            return
        }
        let request = WenZhenAnpaiRoomRequest()
        request.params["operate_id"] = wash.operate_id
        request.params["member_id"] = wash.member_id
        
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
        request.params["hospitalized_id"] = hospitalized_id
        request.execute()
        self.closeMask()
    }
    
    func levelSelected(_ sender : UIButton)
    {
        self.huliLevel = sender.tag
        self.updateZhuyuanView()
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
        self.addSubview(datePicker)
    }
    
    func dateChanged(datePicker : UIDatePicker){
        selectedTime = formatDate(datePicker.date)
        timeButton.setTitle(selectedTime, for: .normal)
    }
}
