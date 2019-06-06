//
//  WenZhenAnpaishoushuView.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/26.
//

import UIKit

class WenZhenAnpaishoushuView: UIView, UITableViewDelegate, UITableViewDataSource
{
    public var wash:CDPosWashHand!
    var chooseShoushushiButton:UIButton!
    var chooseShoushuTimeButton:UIButton!
    var selectedTime = ""
    var selectedDate:Date!
    var selectVC : SeletctListViewController?
    var roomName = ""
    var roomId:NSNumber!
    var selectRoomView:UIView!
    var roomsTableView:UITableView!
    var roomList = NSArray()
    var operateCount = 0
    
    func initView()
    {
        self.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        let maskView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        maskView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
        self.addSubview(maskView)
        
        let centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
        centerView.backgroundColor = UIColor.white
        let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
        naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
        centerView.addSubview(naviView)
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeView), for: .touchUpInside)
        centerView.addSubview(closeButton)
        let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 75))
        titleLabel.text = "安排手术"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = RGB(r: 37, g: 37, b: 37)
        titleLabel.textAlignment = .center
        centerView.addSubview(titleLabel)
        let submitButton = UIButton(frame: CGRect(x: 649, y: 0, width: 75, height: 72))
        submitButton.addTarget(self, action: #selector(self.submit), for: .touchUpInside)
        submitButton.setTitle("提交", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
        centerView.addSubview(submitButton)
        
        let mainView = UIView(frame: CGRect(x: 0, y: 75, width: 724, height: 693))
        mainView.backgroundColor = UIColor.white
        
        let shoushushiLabel = UILabel(frame: CGRect(x: 33, y: 28, width: 158, height: 16))
        shoushushiLabel.text = "手术室"
        shoushushiLabel.textColor = RGB(r: 149, g: 171, b: 171)
        shoushushiLabel.font = UIFont.systemFont(ofSize: 16)
        mainView.addSubview(shoushushiLabel)
        chooseShoushushiButton = UIButton(frame: CGRect(x: 32, y: 53, width: 660, height: 60))
        chooseShoushushiButton.layer.cornerRadius = 6
        chooseShoushushiButton.layer.borderColor = RGB(r: 220, g: 224, b: 224).cgColor
        chooseShoushushiButton.layer.borderWidth = 1
        chooseShoushushiButton.setTitle("请选择...", for: .normal)
        chooseShoushushiButton.setTitleColor(RGB(r: 37, g: 37, b: 37), for: .normal)
        chooseShoushushiButton.addTarget(self, action: #selector(self.chooseRoom), for: .touchUpInside)
        mainView.addSubview(chooseShoushushiButton)
        
        let shoushuTimeLabel = UILabel(frame: CGRect(x: 33, y: 150, width: 158, height: 16))
        shoushuTimeLabel.text = "手术时间"
        shoushuTimeLabel.textColor = RGB(r: 149, g: 171, b: 171)
        shoushuTimeLabel.font = UIFont.systemFont(ofSize: 16)
        mainView.addSubview(shoushuTimeLabel)
        chooseShoushuTimeButton = UIButton(frame: CGRect(x: 32, y: 175, width: 660, height: 60))
        chooseShoushuTimeButton.layer.cornerRadius = 6
        chooseShoushuTimeButton.layer.borderColor = RGB(r: 220, g: 224, b: 224).cgColor
        chooseShoushuTimeButton.layer.borderWidth = 1
        selectedTime = formatDate(Date())
        chooseShoushuTimeButton.setTitle(selectedTime, for: .normal)
        chooseShoushuTimeButton.setTitleColor(RGB(r: 37, g: 37, b: 37), for: .normal)
        chooseShoushuTimeButton.addTarget(self, action: #selector(self.selectTime), for: .touchUpInside)
        mainView.addSubview(chooseShoushuTimeButton)
        
        centerView.addSubview(mainView)
        self.addSubview(centerView)
        let request = WenZhenGetOperateRoomRequest()
        request.execute()
        self.registerNofitification(forMainThread: "GetOperateRoomResponse")
        
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "GetOperateRoomResponse" )
        {
            if let dict = notification.userInfo!["data"] as? NSDictionary
            {
                roomList = dict.object(forKey: "department") as! NSArray
                operateCount = dict.object(forKey: "count") as! Int
            }
        }
    }
    
    func closeView()
    {
        self.removeFromSuperview()
    }
    
    func submit()
    {
        if selectedDate == nil
        {
            selectedDate = Date()
        }
        if roomId == nil
        {
            let alert = UIAlertView(title: "请选择手术室", message: nil, delegate: nil, cancelButtonTitle: "好的")
            alert.show()
            return
        }
        let request = WenZhenAnpaiShoushuRequest()
        request.params["operate_id"] = wash.operate_id
        request.params["operate_date"] = formatDateToPost(selectedDate)
        request.params["departments_id"] = roomId ?? NSNumber(value: 0)
        request.execute()
        self.removeFromSuperview()
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
    
    func chooseRoom()
    {
        selectRoomView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        selectRoomView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
        let roomsView = UIView(frame: CGRect(x: 684, y: 0, width: 340, height: 768))
        roomsView.backgroundColor = UIColor.white
        let closeRoomsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        closeRoomsButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: .normal)
        closeRoomsButton.addTarget(self, action: #selector(self.closeRooms), for: .touchUpInside)
        roomsView.addSubview(closeRoomsButton)
        let titleLabel = UILabel(frame: CGRect(x: 70, y: 0, width: 200, height: 75))
        titleLabel.textAlignment = .center
        titleLabel.text = "选择手术室"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        roomsView.addSubview(titleLabel)
        let colorView = UIView(frame: CGRect(x: 0, y: 75, width: 340, height: 22))
        colorView.backgroundColor = RGB(r: 180, g: 213, b: 218)
        let totalLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 22))
        totalLabel.textColor = UIColor.white
        totalLabel.text = "共有\(operateCount)台手术"
        totalLabel.font = UIFont.systemFont(ofSize: 18)
        colorView.addSubview(totalLabel)
        roomsView.addSubview(colorView)

        roomsTableView = UITableView(frame: CGRect(x: 0, y: 97, width: 340, height: 671))
        roomsTableView.separatorStyle = .none
        roomsTableView.backgroundColor = UIColor.clear
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        roomsView.addSubview(roomsTableView)
        selectRoomView.addSubview(roomsView)
        self.addSubview(selectRoomView)
//        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
//        let roomArray = BSCoreDataManager.current().fetchAllZongkongRoom()
//        print(roomArray)
//        self.selectVC?.countOfTheList = {
//            return roomArray.count
//        }
//
//        self.selectVC?.nameAtIndex = { index in
//            return roomArray[index].name
//        }
//
//        self.selectVC?.selectAtIndex = {[weak self] index in
//            self?.roomId = roomArray[index].room_id
//            self?.roomName = roomArray[index].name!
//            self?.chooseShoushushiButton.setTitle(self?.roomName, for: .normal)
//        }
//
//        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
//        self.selectVC?.showWithAnimation();
    }
    
    func closeRooms()
    {
        selectRoomView.removeFromSuperview()
    }
    
    func selectTime()
    {
        let datePicker = PadDatePickerView()
        datePicker.datePickerMode = .dateAndTime
        datePicker.selectFinished = {[weak self] (date) in
            self?.selectedDate = date!
            self?.selectedTime = (self?.formatDate(date!))!
            self?.chooseShoushuTimeButton.setTitle(self?.selectedTime, for: .normal)
        }
        //datePicker.addTarget(self, action: #selector(self.dateChanged(datePicker:)),for: .valueChanged)
        self.addSubview(datePicker)
    }
    
    func dateChanged(datePicker : UIDatePicker){
        selectedTime = formatDate(datePicker.date)
        chooseShoushuTimeButton.setTitle(selectedTime, for: .normal)
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.1
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 10))
//        view.backgroundColor = RGB(r: 242, g: 245, b: 245)
//        return view
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = (roomList[indexPath.row] as! NSDictionary).object(forKey: "infos") as! String
        let lines = info.components(separatedBy: "\r").count
        print(lines)
        return CGFloat(60 + 10 + lines * 20)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "WenzhenAnpaiShoushushiTableViewCell")
        let dict = roomList[indexPath.row] as! NSDictionary
        let name = UILabel(frame: CGRect(x: 20, y: 15, width: 200, height: 16))
        name.text = "\(dict.object(forKey: "name") ?? "")"
        name.textColor = RGB(r: 37, g: 37, b: 37)
        cell.addSubview(name)
        let state = UILabel(frame: CGRect(x: 220, y: 15, width: 100, height: 16))
        state.text = "\(dict.object(forKey: "state") ?? "")"
        if state.text == "空闲"
        {
            state.textColor = RGB(r: 96, g: 211, b: 212)
        }
        else
        {
            state.textColor = RGB(r: 153, g: 153, b: 153)
        }
        state.textAlignment = .right
        cell.addSubview(state)
        let info = (roomList[indexPath.row] as! NSDictionary).object(forKey: "infos") as! String
        let lines = info.components(separatedBy: "\r").count
        let detail = UILabel(frame: CGRect(x: 20, y: 45, width: 300, height: lines*20))
        detail.text = info.replacingOccurrences(of: "\r", with: "\n")
        detail.textColor = RGB(r: 153, g: 153, b: 153)
        detail.font = UIFont.systemFont(ofSize: 14)
        detail.numberOfLines = lines
        cell.addSubview(detail)
        let colorView = UIView(frame: CGRect(x: 0, y: 60 + lines*20, width: 340, height: 10))
        colorView.backgroundColor = RGB(r: 242, g: 245, b: 245)
        cell.addSubview(colorView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = roomList[indexPath.row] as! NSDictionary
        chooseShoushushiButton.setTitle("\(dict.object(forKey: "name") ?? "")", for: .normal)

        roomId = (dict.object(forKey: "id") as? NSNumber ?? NSNumber(value: 0))
        closeRooms()
    }
}

