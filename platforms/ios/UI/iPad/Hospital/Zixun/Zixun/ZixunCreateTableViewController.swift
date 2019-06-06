//
//  ZixunCreateTableViewController.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/25.
//

import UIKit

class ZixunCreateTableViewController: ICTableViewController, ZixunMemberSelectViewControllerDelegate {

    struct SelectInfo
    {
        var state : String?
        var date : String?
        var shejishi : Int?
        var shejizongjian : Int?
        var zixunroom : Int?
        var member : Int?
    }
    
    var selectVC : SeletctListViewController?
    var selectInfo : SelectInfo = SelectInfo()
    var additionView = UIView()
    var memberTableView = UITableView()
    var todayMember : [CDBook]?
    var memberSelectVc : ZixunMemberSelectViewController?
    var isButtonAvailable = true
    
    var book : CDZixunBook?
    {
        didSet
        {
            if let book = self.book
            {
                if let designer_name = book.designer_name
                {
                    self.shejishiTextField.text = designer_name
                    self.selectInfo.shejishi = book.designer_id as? Int
                }
                
                if let director_name = book.director_name
                {
                    self.shejizongjianTextField.text = director_name
                    self.selectInfo.shejizongjian = book.director_id as? Int
                }
                
                self.stateTextField.text = "初诊"
                self.selectInfo.state = "new"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNofitification(forMainThread: "AdditionTableViewShouldHide")
        self.registerNofitification(forMainThread: "SaveCreateZixun")
        self.registerNofitification(forMainThread: kPadSelectMemberFinish)
        let request = FetchHQiantaiFenzhenRoomRequest()
        request.execute()
        let request2 = BSFetchBookRequest()
        request2.execute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setAdditionView()
    }
    
    @IBOutlet weak var memberTextField : UITextField!
    @IBOutlet weak var stateTextField : UITextField!
    @IBOutlet weak var zixunroomTextField : UITextField!
    @IBOutlet weak var dateTextField : UITextField!
    @IBOutlet weak var shejishiTextField : UITextField!
    @IBOutlet weak var shejizongjianTextField : UITextField!
    @IBOutlet weak var dateCancelButton : UIButton!
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "AdditionTableViewShouldHide" )
        {
            isButtonAvailable = true
//            UIView.animate(withDuration: 0.15) {
                self.additionView.frame = CGRect(x: 1024, y: 135, width: 341, height: 633)
//            }
        }
        else if ( notification.name.rawValue == "SaveCreateZixun" )
        {
            let request = ZixunAddRequest()
            request.params["member_id"] = self.selectInfo.member
            request.params["designers_id"] = self.selectInfo.shejishi
            request.params["director_employee_id"] = self.selectInfo.shejizongjian
            request.params["customer_state"] = self.selectInfo.state
            request.params["room_id"] = self.selectInfo.zixunroom
            request.execute()
        }
        else if ( notification.name.rawValue == kPadSelectMemberFinish )
        {
            isButtonAvailable = true
            let member = notification.object as! CDMember
            self.memberTextField.text = member.memberName
            self.selectInfo.member = member.memberID as? Int
            memberSelectVc?.dismiss(animated: false, completion: nil)
        }
    }
    
    func clear()
    {
        selectInfo = SelectInfo()
        self.memberTextField.text = ""
        self.zixunroomTextField.text = ""
        self.stateTextField.text = ""
        self.dateTextField.text = ""
        self.shejishiTextField.text = ""
        self.shejizongjianTextField.text = ""
    }
    
    func setAdditionView()
    {
        additionView.removeFromSuperview()
        additionView = UIView(frame: CGRect(x: 1024, y: 135, width: 340, height: 633))
        additionView.backgroundColor = UIColor.white
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 22))
        headerView.backgroundColor = RGB(r: 180, g: 213, b: 218)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height: 22))
        titleLabel.text = "今日预约会员"
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.white
        headerView.addSubview(titleLabel)
        
        todayMember = BSCoreDataManager.current().fetchTodayBooks() as? [CDBook]
        memberTableView = UITableView(frame: CGRect(x: 0, y: 22, width: 340, height: 611), style: .plain)
        memberTableView.backgroundColor = UIColor.white
        memberTableView.delegate = self
        memberTableView.dataSource = self
        memberTableView.separatorStyle = .none
        
        additionView.addSubview(headerView)
        additionView.addSubview(memberTableView)
        
    }
    
    @IBAction func didMemberButtonPressed(_ sender: UIButton)
    {
        if isButtonAvailable
        {
            isButtonAvailable = !isButtonAvailable
        }
        else
        {
            return
        }
        memberSelectVc = ZixunMemberSelectViewController(viewType: kPadMemberAndCardSelect)
        memberSelectVc?.view.backgroundColor = UIColor.clear
        memberSelectVc?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        memberSelectVc?.delegate = self
        memberSelectVc?.bgView.image = self.snapView(targetView: (UIApplication.shared.keyWindow?.rootViewController?.view)!)
        UIApplication.shared.keyWindow?.rootViewController?.present(memberSelectVc!, animated: false, completion: nil)
//        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
//        let memberArray = BSCoreDataManager.current().fetchAllMember(withStoreID: PersonalProfile.current().shopIds.first as! NSNumber);
//
//        self.selectVC?.countOfTheList = {
//            return (memberArray?.count)!
//        }
//
//        self.selectVC?.nameAtIndex = { index in
//            let member = memberArray![index] as! CDMember
//
//            return member.memberName
//        }
//
//        self.selectVC?.rightInfoAtIndex = { index in
//            let member = memberArray![index] as! CDMember
//
//            return member.mobile
//        }
//
//        self.selectVC?.selectAtIndex = {[weak self] index in
//            let member = memberArray![index] as! CDMember
//            self?.memberTextField.text = member.memberName
//            self?.selectInfo.member = member.memberID as? Int
//        }
//
//        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
//        self.selectVC?.showWithAnimation();
        UIApplication.shared.keyWindow?.addSubview(additionView)
        if todayMember!.count > 0
        {
//        UIView.animate(withDuration: 0.15) {
            self.additionView.frame = CGRect(x: 684, y: 135, width: 340, height: 633)
//        }
        }
    }
    
    @IBAction func didZixunRoomButtonPressed(_ sender: UIButton)
    {
        if isButtonAvailable
        {
            isButtonAvailable = !isButtonAvailable
        }
        else
        {
            return
        }
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        var zixunroomArray = BSCoreDataManager.current().fetchAllZixunRoom()
        for zixunRoom in zixunroomArray
        {
            if (zixunRoom.is_recycle?.boolValue)!
            {
                zixunroomArray.remove(at: zixunroomArray.index(of: zixunRoom)!)
            }
        }
        
        self.selectVC?.countOfTheList = {
            return zixunroomArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let room = zixunroomArray[index]
            var str = room.name
            if room.wait_message != nil {
                if room.wait_message! != "无预定" {
                    var message = room.wait_message!
//                    message = message.substring(from: message.endIndex.advanced(by: -4))
                    if (message.lengthOfBytes(using: String.Encoding.utf8) >= 4)
                    {
                        let start = message.index(message.endIndex, offsetBy: -4)
                        let end = message.index(message.endIndex, offsetBy: 0)
                        let range = start..<end
                        message = message.substring(with: range)
                        str = str! + "(" + message + ")"
                    }
                }
            }
            return str
        }
        
        self.selectVC?.rightInfoAtIndex = { index in
            let room = zixunroomArray[index]
            
            return room.state
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let room = zixunroomArray[index]
            self?.zixunroomTextField.text = room.name
            self?.selectInfo.zixunroom = room.room_id as? Int
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didStateButtonPressed(_ sender: UIButton)
    {
        if isButtonAvailable
        {
            isButtonAvailable = !isButtonAvailable
        }
        else
        {
            return
        }
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let stateStringArray = ["初诊","复诊","复查","再消费"]
        let stateKeyArray = ["new","referral","review","consume"]
        self.selectVC?.countOfTheList = {
            return stateStringArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            return stateStringArray[index]
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let state = stateStringArray[index]
            let statekey = stateKeyArray[index]
            
            self?.stateTextField.text = state
            self?.selectInfo.state = statekey
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didDateButtonPressed(_ sender: UIButton)
    {
        if isButtonAvailable
        {
            isButtonAvailable = !isButtonAvailable
        }
        else
        {
            return
        }
        let v = PadDatePickerView()
        v.datePickerMode = .dateAndTime;
        
        v.selectFinished = {[weak self] (date) in
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = dateFormat.string(from: date!)
            self?.dateTextField.text = dateString + ":00"
            self?.selectInfo.date = self?.dateTextField.text
            self?.dateCancelButton.isHidden = false
        }
        
        UIApplication.shared.keyWindow?.addSubview(v)
    }
    
    @IBAction func didShejishiButtonPressed(_ sender: UIButton)
    {
        if isButtonAvailable
        {
            isButtonAvailable = !isButtonAvailable
        }
        else
        {
            return
        }
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let shejishiArray = BSCoreDataManager.current().fetchShejishiStaffs(withShopID: PersonalProfile.current().bshopId);
        
        self.selectVC?.countOfTheList = {
            return shejishiArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let staff = shejishiArray[index]
            
            return staff.name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let staff = shejishiArray[index]
            self?.shejishiTextField.text = staff.name
            self?.selectInfo.shejishi = staff.staffID as? Int
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didShejizongjianButtonPressed(_ sender: UIButton)
    {
        if isButtonAvailable
        {
            isButtonAvailable = !isButtonAvailable
        }
        else
        {
            return
        }
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let shejishiArray = BSCoreDataManager.current().fetchShejizongjianStaffs(withShopID: PersonalProfile.current().bshopId);
        
        self.selectVC?.countOfTheList = {
            return shejishiArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let staff = shejishiArray[index]
            
            return staff.name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let staff = shejishiArray[index]
            self?.shejizongjianTextField.text = staff.name
            self?.selectInfo.shejizongjian = staff.staffID as? Int
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didDateCancelButtonPressed(_ sender: UIButton)
    {
        self.dateTextField.text = ""
        self.selectInfo.date = ""
        sender.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == memberTableView
        {
            return todayMember?.count ?? 0
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == memberTableView
        {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "TodayBookMember")
            cell.selectionStyle = .none
            let book = todayMember![indexPath.row] as CDBook
            cell.textLabel?.text = book.booker_name
            cell.textLabel?.textColor = RGB(r: 37, g: 37, b: 37)
            cell.detailTextLabel?.text = book.telephone
            cell.detailTextLabel?.textColor = RGB(r: 37, g: 37, b: 37)
            let line = UIView(frame: CGRect(x: 0, y: 49, width: 341, height: 1))
            line.backgroundColor = RGB(r: 228, g: 228, b: 228)
            cell.addSubview(line)
            return cell
        }
        else
        {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == memberTableView
        {
            return 50
        }
        else
        {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == memberTableView
        {
            return 0
        }
        else
        {
            return super.tableView(tableView, heightForHeaderInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == memberTableView
        {
            return 0
        }
        else
        {
            return super.tableView(tableView, heightForFooterInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == memberTableView
        {
            let book = todayMember![indexPath.row] as CDBook
            self.memberTextField.text = book.booker_name
            print(book.member_id ?? 0)
            self.selectInfo.member = book.member_id?.intValue
            memberSelectVc?.dismiss(animated: false, completion: nil)
            isButtonAvailable = true
            UIView.animate(withDuration: 0.15) {
                self.additionView.frame = CGRect(x: 1024, y: 135, width: 341, height: 633)
            }
        }
//        else
//        {
//            super.tableView(tableView, didSelectRowAt: indexPath)
//        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if tableView == memberTableView
        {
            return 0
        }
        else{
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
    
    func didMemberSelectCancel() {
        memberSelectVc?.dismiss(animated: false, completion: nil)
        isButtonAvailable = true
    }
    
    func snapView(targetView: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, false, 0)
        // iOS7.0 之后系统提供的截屏的功能
        targetView.drawHierarchy(in: targetView.bounds, afterScreenUpdates: false)
        
        let snapdImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapdImage!
    }
//    func didMemberCreateButtonClick(_ isTiyan: Bool) {
//        
//    }
}
