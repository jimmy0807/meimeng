//
//  H9ShoushuAnpaiSearchViewController.swift
//  meim
//
//  Created by jimmy on 2017/8/23.
//
//

import UIKit

class H9ShoushuAnpaiSearchViewController: ICCommonViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var shoushuTagButton : UIButton!
    @IBOutlet weak var patientNameButton : UIButton!
    @IBOutlet weak var patientMobileButton : UIButton!
    @IBOutlet weak var shoushuTimeButton : UIButton!
    @IBOutlet weak var doctorButton : UIButton!
    @IBOutlet weak var teamButton : UIButton!
    @IBOutlet weak var lineImageView : UIImageView!
    @IBOutlet weak var fetchTableView : UITableView!
    @IBOutlet weak var selectResultView : UIView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var naviBackgroundImageView : UIImageView!
    @IBOutlet weak var naviView : UIView!
    
    var selectVC : SeletctListViewController?
    var tabFocusNumber = 0
    var tagArray = [CDH9ShoushuTag]()
    var doctorArray = [CDStaff]()
    var teamArray = [CDTeam]()
    //1 array for showing, 1 array for order (use key) and 1 dictionary for data (key,value)
    var selectResultArray = [String]() //key
    var selectDetailArray = [String]() //value
    var selectRequestArray = [String]() //use for request
    var showResultArray = [String]()
    var showDetailArray = [String]()
    var selectResultDictionary = Dictionary<String, String>()
    var isStartDate = true
    var resultStartX : CGFloat = 52.0
    var resultStartY : CGFloat = 8.0
    var resultTotalWidth : CGFloat = 0.0
    let resultViewWidth : CGFloat = 624.0
    var nameTextfield = UITextField()
    var phoneTextfield = UITextField()
    let TEXT_COLOR = RGB(r: 112, g: 109, b: 110)
    let BUTTON_BACKGROUND_COLOR = RGB(r: 242, g: 245, b: 245)
    let NAVI_BACKGROUND_COLOR = RGB(r: 242, g: 245, b: 245)
    var resultTableView : UITableView!
    var contentViewOriginFrame : CGRect!
    var naviViewOriginFrame : CGRect!
    var fillView = UIView()
    var eventList = [CDHFetchResult]()
    var didSelectItem : ((_ year_month_day : String?) -> Void)?
    var eventDateArray = [String]()
    var eventDetailArray = [Array<CDHFetchResult>]()
    var currentEditing = ""
    
    enum TabFocus : Int {
        case Tag = 0
        case PatientName
        case PatientMobile
        case ShoushuDate
        case Doctor
        case Team
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        selectResultDictionary = ["tag_ids":"", "member_name":"", "mobile":"", "date_start":"", "date_end":"", "doctor_ids":"", "department_ids":""]
        resultTableView = UITableView(frame: CGRect(x: 0.0, y: 60.0, width: 690.0, height: 633.0), style: .grouped)
        resultTableView.backgroundColor = BUTTON_BACKGROUND_COLOR
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.separatorStyle = .none
        resultTableView.showsVerticalScrollIndicator = false
        contentView.addSubview(resultTableView)
        resultTableView.isHidden = true
        fetchTableView.tableFooterView = UIView()
        contentViewOriginFrame = contentView.frame
        naviViewOriginFrame = naviBackgroundImageView.frame
        didShoushuTagButtonPressed(self.shoushuTagButton)
    }
    
    
    @IBAction func didShoushuTagButtonPressed(_ sender : UIButton)
    {
        currentEditing = "ShoushuTag"
        resultTableView.isHidden = true
        nameTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        tagArray = BSCoreDataManager.current().fetchH9Shoushutag("")
        moveLineImageView(sender)
        tabFocusNumber = TabFocus.Tag.rawValue
        fetchTableView.reloadData()
    }
    
    @IBAction func didPatientNameButtonPressed(_ sender : UIButton)
    {
        if (tabFocusNumber == TabFocus.PatientName.rawValue && nameTextfield.isEditing ) {
            return
        }
        currentEditing = "Name"
        resultTableView.isHidden = true
        nameTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        nameTextfield = UITextField(frame: CGRect(x: resultStartX, y: resultStartY, width: resultViewWidth - resultStartX, height: 30.0))
        nameTextfield.keyboardType = .default
        nameTextfield.textColor = TEXT_COLOR
        nameTextfield.font = UIFont.systemFont(ofSize: 16.0)
        nameTextfield.delegate = self
        nameTextfield.placeholder = "请输入姓名"
        selectResultView.addSubview(nameTextfield)
        nameTextfield.becomeFirstResponder()
        moveLineImageView(sender)
        tabFocusNumber = TabFocus.PatientName.rawValue
        fetchTableView.reloadData()
    }
    
    @IBAction func didPatientMobileButtonPressed(_ sender : UIButton)
    {
        if (tabFocusNumber == TabFocus.PatientMobile.rawValue && phoneTextfield.isEditing) {
            return
        }
        currentEditing = "Mobile"
        resultTableView.isHidden = true
        nameTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        phoneTextfield = UITextField(frame: CGRect(x: resultStartX, y: resultStartY, width: resultViewWidth - resultStartX, height: 30.0))
        phoneTextfield.keyboardType = .numberPad
        phoneTextfield.textColor = TEXT_COLOR
        phoneTextfield.font = UIFont.systemFont(ofSize: 16.0)
        phoneTextfield.delegate = self
        phoneTextfield.placeholder = "请输入手机号"
        selectResultView.addSubview(phoneTextfield)
        phoneTextfield.becomeFirstResponder()
        moveLineImageView(sender)
        tabFocusNumber = TabFocus.PatientMobile.rawValue
        fetchTableView.reloadData()
    }
    
    @IBAction func didShoushuTimeButtonPressed(_ sender : UIButton)
    {
        currentEditing = "Time"
        resultTableView.isHidden = true
        nameTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        moveLineImageView(sender)
        tabFocusNumber = TabFocus.ShoushuDate.rawValue
        fetchTableView.reloadData()
    }
    
    @IBAction func didDoctorButtonPressed(_ sender : UIButton)
    {
        currentEditing = "Doctor"
        resultTableView.isHidden = true
        nameTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        moveLineImageView(sender)
        doctorArray = BSCoreDataManager.current().fetchDoctorStaffs(withShopID: PersonalProfile.current().bshopId)
        tabFocusNumber = TabFocus.Doctor.rawValue
        fetchTableView.reloadData()
    }
    
    @IBAction func didTeamButtonPressed(_ sender : UIButton)
    {
        currentEditing = "Team"
        resultTableView.isHidden = true
        nameTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        moveLineImageView(sender)
        teamArray = BSCoreDataManager.current().fetchAllShoushuTeam()
        tabFocusNumber = TabFocus.Team.rawValue
        fetchTableView.reloadData()
    }
    
    @IBAction func didCloseButtonPressed(_ sender : UIButton)
    {
        resultTableView.isHidden = true
        nameTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        if let superView = self.view.superview
        {
            superView.isHidden = true
        }
    }
    
    @IBAction func didSearchButtonPressed(_ sender : UIButton)
    {
        resultTableView.isHidden = false
        resultTableView.reloadData()
        nameTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        packageData()
        let request = FetchHSearchResultRequest()
        request.params = selectResultDictionary
        request.execute()
        request.finished = {[weak self] dict in
            self?.eventList = BSCoreDataManager.current().fetchH9SSAPSearchResult()
            self?.collectSelectList()
            self?.resultTableView.reloadData()
        }

        resultTableView.reloadData()
    }
    
    func moveLineImageView(_ sender : UIButton)
    {
        UIView.animate(withDuration: 0.3) { 
            self.lineImageView.center = CGPoint(x: sender.center.x, y: self.lineImageView.center.y)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == resultTableView {
            return eventDateArray.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == resultTableView {
            return 40.0
        }
        else {
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {
            return 82
        }
        else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == resultTableView {
            let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 690.0, height: 40.0))
            headerView.backgroundColor = RGB(r: 242, g: 245, b: 245)
            headerView.layer.borderColor = RGBA(r: 0, g: 0, b: 0, a: 0.06).cgColor
            headerView.layer.borderWidth = 1
            
            let dateLabel = UILabel(frame: CGRect(x: 20.0, y: 11.0, width: 200.0, height: 18.0))
            let dateString = eventDateArray[section]
            var weekDay = (dateString.date(with: "yyyy-MM-dd")?.weekDay()?.cn)!
            if weekDay == "零" {
                weekDay = "日"
            }
            dateLabel.text = dateString.dateFrom("yyyy-MM-dd", to: "yyyy年MM月dd日") + " 星期" + weekDay
            dateLabel.textColor = RGB(r: 37, g: 37, b: 37)
            dateLabel.backgroundColor = UIColor.clear
            dateLabel.font = UIFont.systemFont(ofSize: 18)
            headerView.addSubview(dateLabel)
            
            let lunaLabel = UILabel(frame: CGRect(x: 470.0, y: 13.0, width: 200.0, height: 14.0))
            lunaLabel.text = dateString.date(with: "yyyy-MM-dd")?.chineseDateString()
            lunaLabel.textColor = RGB(r: 153, g: 153, b: 153)
            lunaLabel.backgroundColor = UIColor.clear
            lunaLabel.font = UIFont.systemFont(ofSize: 14)
            lunaLabel.textAlignment = NSTextAlignment.right
            headerView.addSubview(lunaLabel)
            
            return headerView
        }
        else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect.zero)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resultTableView {
            return eventDetailArray[section].count
        }
        else {
            switch tabFocusNumber {
            case (TabFocus.Tag.rawValue):
                return tagArray.count
            case (TabFocus.ShoushuDate.rawValue):
                return 2
            case (TabFocus.Doctor.rawValue):
                return doctorArray.count
            case (TabFocus.Team.rawValue):
                return teamArray.count
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "AnPaiTableViewCell")
        cell.selectionStyle = .none
        if tableView == resultTableView {
            let timeLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 50, height: 16))
            timeLabel.text = self.eventDetailArray[indexPath.section][indexPath.row].operate_date?.dateFrom("yyyy-MM-dd HH:mm:ss", to: "HH:mm")
            timeLabel.textColor = RGB(r: 96, g: 211, b: 212)
            timeLabel.font = UIFont.systemFont(ofSize: 16)
            cell.addSubview(timeLabel)
            
            let shoushuLabel = UILabel(frame: CGRect(x: 83, y: 20, width: 200, height: 17))
            shoushuLabel.text = self.eventDetailArray[indexPath.section][indexPath.row].operate_name
            shoushuLabel.textColor = RGB(r: 74, g: 74, b: 74)
            shoushuLabel.font = UIFont.systemFont(ofSize: 17)
            cell.addSubview(shoushuLabel)
            
            let doctorLabel = UILabel(frame: CGRect(x: 470, y: 20, width: 200, height: 17))
            doctorLabel.text = self.eventDetailArray[indexPath.section][indexPath.row].doctor_name
            doctorLabel.textAlignment = .right
            doctorLabel.textColor = RGB(r: 74, g: 74, b: 74)
            doctorLabel.font = UIFont.systemFont(ofSize: 17)
            cell.addSubview(doctorLabel)
            
            let noteLabel = UILabel(frame: CGRect(x: 83, y: 38, width: 580, height: 42))
            noteLabel.numberOfLines = 0
            noteLabel.font = UIFont.systemFont(ofSize: 14)
            noteLabel.lineBreakMode = .byCharWrapping
            noteLabel.text = self.eventDetailArray[indexPath.section][indexPath.row].note
            noteLabel.textColor = RGB(r: 160, g: 160, b: 160)
            cell.addSubview(noteLabel)
            
            let separatorLine = UIView(frame: CGRect(x: 0, y: 81, width: 690, height: 1))
            separatorLine.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.06)
            cell.addSubview(separatorLine)
        }
        else {
            switch tabFocusNumber {
            case (TabFocus.Tag.rawValue):
                cell.textLabel?.text = tagArray[indexPath.row].name
            case (TabFocus.ShoushuDate.rawValue):
                cell.accessoryType = .disclosureIndicator
                if indexPath.row == 0 {
                    cell.textLabel?.text = "起始日期"
                    cell.detailTextLabel?.text = selectResultDictionary["date_start"]
                }
                else{
                    cell.textLabel?.text = "结束日期"
                    cell.detailTextLabel?.text = selectResultDictionary["date_end"]
                }
            case (TabFocus.Doctor.rawValue):
                cell.textLabel?.text = doctorArray[indexPath.row].name
            case (TabFocus.Team.rawValue):
                cell.textLabel?.text = teamArray[indexPath.row].name
            default:
                print("")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == resultTableView {
            resultTableView.isHidden = true
            nameTextfield.resignFirstResponder()
            phoneTextfield.resignFirstResponder()
            if let superView = self.view.superview
            {
                superView.isHidden = true
            }
            self.didSelectItem?(eventDateArray[indexPath.section])
        }
        else {
            switch tabFocusNumber {
            case (TabFocus.Tag.rawValue):
                insertSelectResult(Key: "tag_ids", Value: (tagArray[indexPath.row].name)!, Request: (tagArray[indexPath.row].tag_id?.stringValue)!)
            case (TabFocus.ShoushuDate.rawValue):
                let datePicker = PadDatePickerView()
                datePicker.datePickerMode = .date;
                datePicker.selectFinished = {[weak self] (date) in
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy/MM/dd"
                    let dateString = dateFormat.string(from: date!)
                    if indexPath.row == 0 {
                        self?.isStartDate = true
                        self?.selectResultDictionary["date_start"] = dateString
                        self?.insertSelectResult(Key: "date_start", Value: dateString)
                    }
                    else{
                        self?.isStartDate = false
                        self?.selectResultDictionary["date_end"] = dateString
                        self?.insertSelectResult(Key: "date_end", Value: dateString)
                    }
                    self?.fetchTableView.reloadData()
                    
                    self?.refreshSelectResult()
                }
                UIApplication.shared.keyWindow?.addSubview(datePicker)
            case (TabFocus.Doctor.rawValue):
                insertSelectResult(Key: "doctor_ids", Value: doctorArray[indexPath.row].name!, Request: (doctorArray[indexPath.row].staffID?.stringValue)!)
            case (TabFocus.Team.rawValue):
                insertSelectResult(Key: "department_ids", Value: teamArray[indexPath.row].name!, Request: (teamArray[indexPath.row].team_id?.stringValue)!)
            default:
                print("")
            }
        }
        refreshSelectResult()
    }
    
    func refreshSelectResult(){
        resultStartX = 52.0
        //total width > view width, replace with original frame
        if (resultTotalWidth > resultViewWidth) {
            selectResultView.frame = CGRect(x: selectResultView.frame.origin.x, y: selectResultView.frame.origin.y, width: selectResultView.frame.width, height: 46.0)
            contentView.frame = contentViewOriginFrame
            naviView.frame = naviViewOriginFrame
            naviBackgroundImageView.frame = naviViewOriginFrame
            fillView.removeFromSuperview()
        }
        resultTotalWidth = 52.0
        resultStartY = 8.0
        for sub in selectResultView.subviews{
            sub.removeFromSuperview()
        }
        var resultCount = 0
        showResultArray.removeAll()
        showDetailArray.removeAll()
        for ele in selectResultArray {
            showResultArray.append(ele)
        }
        for ele in selectDetailArray {
            showDetailArray.append(ele)
        }
        if checkNoStartOrEndDate(){
            resultCount = selectResultArray.count
        }
        else {
            resultCount = selectResultArray.count - 1
        }
        //remove only once, so if there is still a StartDate or Enddate in show array, there are both StartDate and Enddate, result button is required
        if(showResultArray.contains("date_start")) {
            showDetailArray.remove(at: showResultArray.index(of: "date_start")!)
            showResultArray.remove(at: showResultArray.index(of: "date_start")!)
        }
        else if (showResultArray.contains("date_end")){
            showDetailArray.remove(at: showResultArray.index(of: "date_end")!)
            showResultArray.remove(at: showResultArray.index(of: "date_end")!)
        }
        let resultButtonHeight:CGFloat = 30.0
        //ex-width is for the radius
        let resultButtonExWidth:CGFloat = 30.0
        let resultButtonGapWidth:CGFloat = 6.0
        resultStartX = resultStartX + resultButtonGapWidth
        resultTotalWidth = resultTotalWidth + resultButtonGapWidth
        for i in 0..<resultCount {
            let size = CGSize();
            var resultString = showDetailArray[i]
            if (showResultArray[i] == "date_start" || showResultArray[i] == "date_end"){
                resultString = "手术时间"
            }
            resultString = resultString + " ×"
            let resultButtonTitleWidth = resultString.boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading, attributes: nil, context: nil).width / 12 * 14
            let totalLines = CGFloat(Int((resultTotalWidth + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth)/resultViewWidth)+1)
            //print("Result count:\(i),Total lines:\(totalLines), TotalWidth:\(resultTotalWidth + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth)")
            //when next button startX > view width
            //need to expand result view frame
            if (resultStartX + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth > resultViewWidth) {
                resultStartX = resultButtonGapWidth
                resultStartY = resultStartY + 46.0
                resultTotalWidth = resultButtonGapWidth + CGFloat(Int((resultTotalWidth + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth)/resultViewWidth)) * resultViewWidth
                selectResultView.frame = CGRect(x: selectResultView.frame.origin.x, y: selectResultView.frame.origin.y, width: selectResultView.frame.width, height: 46.0 * totalLines)
                contentView.frame = CGRect(x: contentViewOriginFrame.origin.x, y: contentViewOriginFrame.origin.y + 46.0 * (totalLines-1), width: contentViewOriginFrame.width, height: contentViewOriginFrame.height - (46.0 * (totalLines-1)-1.0))
                naviView.frame = CGRect(x: naviViewOriginFrame.origin.x, y: naviViewOriginFrame.origin.y, width: naviViewOriginFrame.width, height: naviViewOriginFrame.height + 46.0 * (totalLines-1))
                naviBackgroundImageView.frame = CGRect(x: naviViewOriginFrame.origin.x, y: naviViewOriginFrame.origin.y, width: naviViewOriginFrame.width, height: naviViewOriginFrame.height + 46.0 * (totalLines-1))
                //about 3.0 between naviView and backgroundView
                fillView = UIView(frame: CGRect(x: 0.0, y: naviBackgroundImageView.frame.height - 49.0, width: naviBackgroundImageView.frame.width, height: 46.0))
                fillView.backgroundColor = NAVI_BACKGROUND_COLOR
                naviBackgroundImageView.addSubview(fillView)
            }
            //when total width > view width, start with a new line, update Y
//            if (resultTotalWidth + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth > resultViewWidth){
//                resultStartY = resultStartY + 46.0 * CGFloat(Int((resultTotalWidth + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth)/resultViewWidth))
//            }
//            else {
//                resultStartY = 8.0
//            }
            //when new startX > view width, start with a new line, restart X
            if (resultStartX + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth > resultViewWidth) {
                resultStartX = resultButtonGapWidth
                resultStartY = resultStartY + 46.0
                resultTotalWidth = resultButtonGapWidth + CGFloat(Int((resultTotalWidth + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth)/resultViewWidth)) * resultViewWidth
            }
            let resultButton = UIButton(frame: CGRect(x:resultStartX, y:resultStartY, width:resultButtonExWidth+resultButtonTitleWidth, height:resultButtonHeight))
            resultStartX = resultStartX + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth
            resultTotalWidth = resultTotalWidth + resultButtonExWidth + resultButtonTitleWidth + resultButtonGapWidth
            resultButton.layer.cornerRadius = 15.0
            resultButton.setTitle(resultString, for: .normal)
            resultButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            resultButton.setTitleColor(TEXT_COLOR, for: .normal)
            resultButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            resultButton.addTarget(self, action: #selector(H9ShoushuAnpaiSearchViewController.didResultButtonPressed), for: .touchUpInside)
            resultButton.tag = i
            selectResultView.addSubview(resultButton)
        }
    }
    
    func insertSelectResult(Key:String, Value:String){
        insertSelectResult(Key: Key, Value: Value, Request: Value)
    }
    
    func insertSelectResult(Key:String, Value:String, Request:String){
        //insert when key does not exist
//        for key in selectResultArray {
//            if key == Key{
//                return
//            }
//        }
        if (Key != "date_start" && Key != "date_end"){
            if selectDetailArray.contains(Value) {
                return
            }
        }
        selectResultArray.append(Key)
        selectDetailArray.append(Value)
        selectRequestArray.append(Request)
    }

    func didResultButtonPressed(sender:UIButton){
        removeSelectResult(Key: showResultArray[sender.tag], Value: showDetailArray[sender.tag])
        if currentEditing == "Name"
        {
            self.didPatientNameButtonPressed(self.patientNameButton)
        }
        else if currentEditing == "Mobile"
        {
            self.didPatientMobileButtonPressed(self.patientMobileButton)
        }
        resultTableView.isHidden = true
    }
    
    func removeSelectResult(Key:String, Value:String){
        for i in 0..<selectDetailArray.count {
            //array count is reducing, check i and count
            if i >= selectDetailArray.count {
                break
            }
            //remove both value in array and dictionary
            if selectDetailArray[i] == Value {
                selectResultArray.remove(at: i)
                selectRequestArray.remove(at: i)
                selectDetailArray.remove(at: i)
            }
        }
        //if trying to remove StartDate or EndDate, remove both
        if (Key == "date_start" || Key == "date_end") {
            if selectResultArray.contains("date_start"){
                selectDetailArray.remove(at: selectResultArray.index(of: "date_start")!)
                selectRequestArray.remove(at: selectResultArray.index(of: "date_start")!)
                selectResultArray.remove(at: selectResultArray.index(of: "date_start")!)
            }
            if selectResultArray.contains("date_end"){
                selectDetailArray.remove(at: selectResultArray.index(of: "date_end")!)
                selectRequestArray.remove(at: selectResultArray.index(of: "date_end")!)
                selectResultArray.remove(at: selectResultArray.index(of: "date_end")!)
            }
        }
        refreshSelectResult()
        fetchTableView.reloadData()
    }
    
    //if no start no end date, result label number equeals array count, else equals array count - 1
    //return true means no start no end date
    func checkNoStartOrEndDate()->Bool{
        if(selectResultArray.contains("date_start")||selectResultArray.contains("date_end")) {
            return false
        }
        else{
            return true
        }
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if (tabFocusNumber == TabFocus.PatientName.rawValue) {
            if(textField.text != "") {
                selectResultDictionary["member_name"] = textField.text
                insertSelectResult(Key: "member_name", Value: textField.text!)
            }
        }
        else if (tabFocusNumber == TabFocus.PatientMobile.rawValue) {
            if(textField.text != "") {
                selectResultDictionary["mobile"] = textField.text
                insertSelectResult(Key: "mobile", Value:textField.text!)
            }
        }
        refreshSelectResult()
    }
    
    func packageData(){
        selectResultDictionary.removeAll()
        selectResultDictionary = ["tag_ids":"", "member_name":"", "mobile":"", "date_start":"", "date_end":"", "doctor_ids":"", "department_ids":""]
        for i in 0..<selectResultArray.count {
            insertIntoDictionary(key: selectResultArray[i], value: selectRequestArray[i])
        }
    }
    
    func insertIntoDictionary(key:String, value:String)
    {
        if selectResultDictionary[key] != "" {
            selectResultDictionary[key] = selectResultDictionary[key]! + "," + value
        }
        else {
            selectResultDictionary[key] = value
        }
    }
    
    func collectSelectList()
    {
        eventDateArray.removeAll()
        eventDetailArray.removeAll()
        for i in 0..<eventList.count {
            let dateString = formatDate(timeStamp: eventList[i].operate_date!)
            if eventDateArray.contains(dateString) {
                eventDetailArray[eventDateArray.index(of: dateString)!].append(eventList[i])
            }
            else {
                eventDateArray.append(dateString)
                eventDetailArray.insert([eventList[i]], at: eventDateArray.index(of: dateString)!)
            }
        }
        print("Days:\(eventDateArray)")
        print("Events:\(eventDetailArray)")
    }
    
    func formatDate(timeStamp:String)->String
    {
        return timeStamp.dateFrom("yyyy-MM-dd HH:mm:ss", to: "yyyy-MM-dd")
    }
}
