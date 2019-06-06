//
//  BingfangZhuyuanInfoView.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/30.
//

import UIKit

class BingfangZhuyuanInfoView: UIView, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate
{
    @IBOutlet weak var zhuyuanInfoTableView: UITableView!
    var baseInfoTextView: UITextView!
    var textViewHeight:CGFloat = 0.0
//    var shoushuyongyaoArray = NSMutableArray()
//    var yuanneiyongyaoArray = NSMutableArray()
//    var huijiayongyaoArray = NSMutableArray()
    var addHuliView: UIView!
    var baseTextView: UITextView!
    var yongyaoTextView: UITextView!
    var shuhouTextView: UITextView!
    public var hospitalized_id : NSNumber!
    var bigMaskView: UIView!
    var chufangType:String!
    var updateType = ""
    var currentLineId: NSNumber!
    
    var baseInfoDict : NSDictionary = NSDictionary()
    {
        didSet
        {
            baseInfoTextView.text = (baseInfoDict.object(forKey: "note") as? String ?? "")
            baseInfoTextView.isEditable = false
            baseInfoTextView.font = UIFont.systemFont(ofSize: 14)
            baseInfoTextView.textColor = RGB(r: 112, g: 109, b: 110)
            textViewHeight = heightForTextView(textView: baseInfoTextView, fixedWidth: 485)
            zhuyuanInfoTableView.reloadData()
        }
    }
    
    var prescriptionsArray : NSArray = NSArray()
    {
        didSet
        {
//            for i in 0..<prescriptionsArray.count
//            {
//                let dict = prescriptionsArray[i] as! NSDictionary
//                if dict["type"] as! String == "operate"
//                {
//                    shoushuyongyaoArray.add(dict)
//                }
//                else if dict["type"] as! String == "hospital"
//                {
//                    yuanneiyongyaoArray.add(dict)
//                }
//                else if dict["type"] as! String == "home"
//                {
//                    huijiayongyaoArray.add(dict)
//                }
//            }
            zhuyuanInfoTableView.reloadData()
        }
    }
    
    var recordsArray : NSArray = NSArray()
    {
        didSet
        {
            zhuyuanInfoTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        self.registerNofitification(forMainThread: "HuliUpdateResponse")
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "HuliUpdateResponse" )
        {
            if let dict = notification.userInfo as? NSDictionary
            {
                if (dict.object(forKey: "errcode") == nil)
                {
                    let alertView = UIAlertView(title: "删除失败", message: "\(dict.object(forKey: "errmsg") ?? "您没有权限删除")", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                    alertView.tag = 999
                    alertView.show()
                }
                else if (dict.object(forKey: "errcode") as? Int ?? 0) == 0
                {
                    let request = FetchBingfangRoomDetailRequest()
                    request.params["hospitalized_id"] = hospitalized_id
                    request.execute()
                }
                else
                {
                    let alertView = UIAlertView(title: "删除失败", message: "\(dict.object(forKey: "errmsg") ?? "您没有权限删除")", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                    alertView.tag = 999
                    alertView.show()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1
        {
            return prescriptionsArray.count
        }
        else if section == 2
        {
            return recordsArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return textViewHeight+40
        }
        else if indexPath.section == 1
        {
            return 58
        }
        else if indexPath.section == 2
        {
            return 193
        }
        else
        {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1
        {
            return 47
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))

        if section == 1
        {
            view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 47)
            let label = UILabel(frame: CGRect(x: 0, y: 20, width: 200, height: 16))
            label.text = "药品项目"
            label.textColor = RGB(r: 149, g: 171, b: 171)
            view.addSubview(label)
        }
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ZhuyuanInfoTableViewCell")
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        if indexPath.section == 0
        {
            cell.selectionStyle = .none
            if (baseInfoTextView == nil)
            {
                baseInfoTextView = UITextView(frame: CGRect(x: 150, y: 10, width: 485, height: textViewHeight))
                cell.addSubview(baseInfoTextView)
            }
            else
            {
                baseInfoTextView.frame = CGRect(x: 150, y: 10, width: 485, height: textViewHeight)
                let title = UILabel(frame: CGRect(x: 20, y: 20, width: 130, height: 16))
                title.text = "住院基本信息"
                title.textColor = RGB(r: 149, g: 171, b: 171)
                title.font = UIFont.systemFont(ofSize: 16)
                cell.addSubview(title)
                cell.addSubview(baseInfoTextView)
            }
        }
        else if indexPath.section == 1
        {
            cell.accessoryType = .disclosureIndicator
            let label = UILabel(frame: CGRect(x: 20, y: 20, width: 130, height: 16))
            print(prescriptionsArray[indexPath.row])
            label.text = "\((prescriptionsArray[indexPath.row] as! NSDictionary).object(forKey: "type_name") ?? "")"
            label.textColor = RGBA(r: 37, g: 37, b: 37, a: 0.6)
            label.font = UIFont.systemFont(ofSize: 16)
            if indexPath.row == prescriptionsArray.count - 1
            {
                let bottomLine = UIView(frame: CGRect(x: 0, y: 59, width: 660, height: 1))
                bottomLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
                cell.addSubview(bottomLine)
            }
            let topLine = UIView(frame: CGRect(x: 0, y: 0, width: 660, height: 1))
            topLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
            cell.addSubview(topLine)
            let leftLine = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 60))
            leftLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
            cell.addSubview(leftLine)
            let rightLine = UIView(frame: CGRect(x: 659, y: 0, width: 1, height: 1))
            rightLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
            cell.addSubview(rightLine)
            cell.addSubview(label)
        }
        else if indexPath.section == 2
        {
            let dict = recordsArray[indexPath.row] as! NSDictionary
            let title = UILabel(frame: CGRect(x: 20, y: 12, width: 300, height: 16))
            title.text = "\(dict["name"] ?? "")"
            title.textColor = RGB(r: 149, g: 171, b: 171)
            title.font = UIFont.systemFont(ofSize: 16)
            cell.addSubview(title)
            let timeLabel = UILabel(frame: CGRect(x: 400, y: 13, width: 240, height: 14))
            timeLabel.text = "\(dict["create_date"] ?? "")"
            timeLabel.textColor = RGB(r: 155, g: 155, b: 155)
            timeLabel.textAlignment = .right
            timeLabel.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(timeLabel)
            let line = UIView(frame: CGRect(x: 0, y: 40, width: 660, height: 1))
            line.backgroundColor = RGB(r: 224, g: 230, b: 230)
            cell.addSubview(line)
            let textView = UITextView(frame: CGRect(x: 15, y: 60, width: 630, height: 110))
            textView.text = "\(dict["info"] ?? "")"
            textView.textColor = RGB(r: 112, g: 109, b: 110)
            textView.font = UIFont.systemFont(ofSize: 14)
            textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
            textView.isEditable = false
            textView.isUserInteractionEnabled = false
            let bottomLine = UIView(frame: CGRect(x: 0, y: 192, width: 660, height: 1))
            bottomLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
            cell.addSubview(bottomLine)
            cell.addSubview(textView)
        }
        else
        {
            let addHuliButton = UIButton(frame: CGRect(x: 0, y: 0, width: 660, height: 60))
            addHuliButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
            addHuliButton.setTitle("添加护理记录", for: .normal)
            addHuliButton.addTarget(self, action: #selector(self.addHuliRecord), for: .touchUpInside)
            cell.addSubview(addHuliButton)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1
        {
            let detailView = BingfangYaopinDetailView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
            detailView.yaopinArray = (prescriptionsArray[indexPath.row] as! NSDictionary).object(forKey: "products") as! NSArray
            detailView.titleName = "\((prescriptionsArray[indexPath.row] as! NSDictionary).object(forKey: "type_name") ?? "")"
            UIApplication.shared.keyWindow?.addSubview(detailView)
        }
        else if indexPath.section == 2
        {
            updateHuliRecord(indexPath.row)
        }
    }
    
//    func checkYaopinView()
//    {
//        bigMaskView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
//        bigMaskView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
//        
//        let centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
//        centerView.backgroundColor = UIColor.white
//        let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
//        naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
//        centerView.addSubview(naviView)
//        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
//        closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: .normal)
//        closeButton.addTarget(self, action: #selector(self.closeView), for: .touchUpInside)
//        centerView.addSubview(closeButton)
//        let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 75))
//        titleLabel.text = chufangType
//        titleLabel.font = UIFont.systemFont(ofSize: 18)
//        titleLabel.textColor = RGB(r: 37, g: 37, b: 37)
//        titleLabel.textAlignment = .center
//        centerView.addSubview(titleLabel)
//        let submitButton = UIButton(frame: CGRect(x: 649, y: 0, width: 75, height: 72))
//        submitButton.addTarget(self, action: #selector(self.submit), for: .touchUpInside)
//        submitButton.setTitle("提交", for: .normal)
//        submitButton.setTitleColor(UIColor.white, for: .normal)
//        submitButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
//        centerView.addSubview(submitButton)
//        
//        let mainView = UIView(frame: CGRect(x: 0, y: 75, width: 724, height: 693))
//        mainView.backgroundColor = RGB(r: 242, g: 245, b: 245)
//        let yongyaoLabel = UILabel(frame: CGRect(x: 33, y: 28, width: 158, height: 16))
//        yongyaoLabel.text = chufangType
//        yongyaoLabel.textColor = RGB(r: 149, g: 171, b: 171)
//        yongyaoLabel.font = UIFont.systemFont(ofSize: 16)
//        mainView.addSubview(yongyaoLabel)
//        let addMubanButton = UIButton(frame: CGRect(x: 625, y: 28, width: 72, height: 16))
//        addMubanButton.setTitle("选择模板", for: .normal)
//        addMubanButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        addMubanButton.setTitleColor(RGB(r: 47, g: 143, b: 255), for: .normal)
//        addMubanButton.addTarget(self, action: #selector(self.addMuban), for: .touchUpInside)
//        mainView.addSubview(addMubanButton)
//        tableView = UITableView(frame: CGRect(x: 32, y: 60, width: 660, height: 633))
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = UIColor.clear
//        tableView.delegate = self
//        tableView.dataSource = self
//        mainView.addSubview(tableView)
//        
//        centerView.addSubview(mainView)
//        bigMaskView.addSubview(centerView)
//        self.addSubview(bigMaskView)
//
//    }
    
    func heightForTextView(textView: UITextView, fixedWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let constraint = textView.sizeThatFits(size)
        return constraint.height
    }
    
    func updateHuliRecord(_ index:Int)
    {
        let dict = recordsArray[index] as! NSDictionary

        currentLineId = dict.object(forKey: "id") as! NSNumber
        
        addHuliView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        addHuliView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
        let centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
        centerView.backgroundColor = UIColor.white
        let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
        naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
        centerView.addSubview(naviView)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: UIControlState.normal)
        closeButton.addTarget(self, action:#selector(self.removeHuliView), for: UIControlEvents.touchUpInside)
        centerView.addSubview(closeButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 72))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "护理记录"
        centerView.addSubview(titleLabel)
        
        let confirmButton = UIButton(frame: CGRect(x: 624, y: 0, width: 100, height: 72))
        confirmButton.setTitle("确认", for: UIControlState.normal)
        confirmButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
        confirmButton.addTarget(self, action: #selector(self.confirm), for: UIControlEvents.touchUpInside)
        centerView.addSubview(confirmButton)
        
        let titleColor = RGB(r: 149, g: 171, b: 171)
        let borderColor = RGB(r: 220, g: 224, b: 224)
        
        let baseLabel = UILabel(frame: CGRect(x: 70, y: 105, width: 300, height: 20))
        baseLabel.textColor = titleColor
        baseLabel.text = "基本情况录入(体温、血压、尿量等)"
        baseLabel.font = UIFont.systemFont(ofSize: 16)
        centerView.addSubview(baseLabel)
        baseTextView = UITextView(frame: CGRect(x: 70, y: 140, width: 584, height: 110))
        baseTextView.layer.borderColor = borderColor.cgColor
        baseTextView.layer.borderWidth = 1
        baseTextView.layer.cornerRadius = 6
        baseTextView.text = "\(dict.object(forKey: "base_info") ?? "")"
        centerView.addSubview(baseTextView)
        
        let yongyaoLabel = UILabel(frame: CGRect(x: 70, y: 275, width: 300, height: 20))
        yongyaoLabel.textColor = titleColor
        yongyaoLabel.text = "用药情况"
        yongyaoLabel.font = UIFont.systemFont(ofSize: 16)
        centerView.addSubview(yongyaoLabel)
        yongyaoTextView = UITextView(frame: CGRect(x: 70, y: 310, width: 584, height: 110))
        yongyaoTextView.layer.borderColor = borderColor.cgColor
        yongyaoTextView.layer.borderWidth = 1
        yongyaoTextView.layer.cornerRadius = 6
        yongyaoTextView.text = "\(dict.object(forKey: "prescription_info") ?? "")"
        centerView.addSubview(yongyaoTextView)
        
        let shuhouLabel = UILabel(frame: CGRect(x: 70, y: 445, width: 300, height: 20))
        shuhouLabel.textColor = titleColor
        shuhouLabel.text = "术后情况"
        shuhouLabel.font = UIFont.systemFont(ofSize: 16)
        centerView.addSubview(shuhouLabel)
        shuhouTextView = UITextView(frame: CGRect(x: 70, y: 480, width: 584, height: 110))
        shuhouTextView.layer.borderColor = borderColor.cgColor
        shuhouTextView.layer.borderWidth = 1
        shuhouTextView.layer.cornerRadius = 6
        shuhouTextView.text = "\(dict.object(forKey: "after_operation_info") ?? "")"
        centerView.addSubview(shuhouTextView)
        
        let line = UIView(frame: CGRect(x: 0, y: 645, width: 724, height: 1))
        line.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.1)
        centerView.addSubview(line)
        let deleteButton = UIButton(frame: CGRect(x: 70, y: 675, width: 584, height: 60))
        deleteButton.backgroundColor = RGB(r: 243, g: 244, b: 246)
        deleteButton.layer.borderColor = RGB(r: 220, g: 224, b: 224).cgColor
        deleteButton.setTitle("删除", for: .normal)
        deleteButton.setTitleColor(RGB(r: 96, g: 211, b: 212), for: .normal)
        deleteButton.addTarget(self, action: #selector(self.deleteRecord), for: .touchUpInside)
        centerView.addSubview(deleteButton)
        
        addHuliView.addSubview(centerView)
        updateType = "update"
        UIApplication.shared.keyWindow?.addSubview(addHuliView)
    }
    
    func addHuliRecord()
    {
        addHuliView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        addHuliView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
        let centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
        centerView.backgroundColor = UIColor.white
        let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
        naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
        centerView.addSubview(naviView)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: UIControlState.normal)
        closeButton.addTarget(self, action:#selector(self.removeHuliView), for: UIControlEvents.touchUpInside)
        centerView.addSubview(closeButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 72))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "护理记录"
        centerView.addSubview(titleLabel)
        
        let confirmButton = UIButton(frame: CGRect(x: 624, y: 0, width: 100, height: 72))
        confirmButton.setTitle("确认", for: UIControlState.normal)
        confirmButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
        confirmButton.addTarget(self, action: #selector(self.confirm), for: UIControlEvents.touchUpInside)
        centerView.addSubview(confirmButton)
        
        let titleColor = RGB(r: 149, g: 171, b: 171)
        let borderColor = RGB(r: 220, g: 224, b: 224)
        
        let baseLabel = UILabel(frame: CGRect(x: 70, y: 105, width: 300, height: 20))
        baseLabel.textColor = titleColor
        baseLabel.text = "基本情况录入(体温、血压、尿量等)"
        baseLabel.font = UIFont.systemFont(ofSize: 16)
        centerView.addSubview(baseLabel)
        baseTextView = UITextView(frame: CGRect(x: 70, y: 140, width: 584, height: 110))
        baseTextView.layer.borderColor = borderColor.cgColor
        baseTextView.layer.borderWidth = 1
        baseTextView.layer.cornerRadius = 6
        centerView.addSubview(baseTextView)
        
        let yongyaoLabel = UILabel(frame: CGRect(x: 70, y: 275, width: 300, height: 20))
        yongyaoLabel.textColor = titleColor
        yongyaoLabel.text = "用药情况"
        yongyaoLabel.font = UIFont.systemFont(ofSize: 16)
        centerView.addSubview(yongyaoLabel)
        yongyaoTextView = UITextView(frame: CGRect(x: 70, y: 310, width: 584, height: 110))
        yongyaoTextView.layer.borderColor = borderColor.cgColor
        yongyaoTextView.layer.borderWidth = 1
        yongyaoTextView.layer.cornerRadius = 6
        centerView.addSubview(yongyaoTextView)
        
        let shuhouLabel = UILabel(frame: CGRect(x: 70, y: 445, width: 300, height: 20))
        shuhouLabel.textColor = titleColor
        shuhouLabel.text = "术后情况"
        shuhouLabel.font = UIFont.systemFont(ofSize: 16)
        centerView.addSubview(shuhouLabel)
        shuhouTextView = UITextView(frame: CGRect(x: 70, y: 480, width: 584, height: 110))
        shuhouTextView.layer.borderColor = borderColor.cgColor
        shuhouTextView.layer.borderWidth = 1
        shuhouTextView.layer.cornerRadius = 6
        centerView.addSubview(shuhouTextView)
        
        addHuliView.addSubview(centerView)
        updateType = "create"
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(addHuliView)
        //self.addSubview(addHuliView)
    }
    
    func removeHuliView()
    {
        addHuliView.removeFromSuperview()
    }
    
    func confirm()
    {
        if baseTextView.text == "" && yongyaoTextView.text == "" && shuhouTextView.text == ""
        {
            addHuliView.removeFromSuperview()
            return
        }
        let request = HuliUpdateRequest()
        request.params["hospitalized_id"] = hospitalized_id
        request.params["base_info"] = baseTextView.text
        request.params["prescription_info"] = yongyaoTextView.text
        request.params["after_operation_info"] = shuhouTextView.text
        if updateType == "update"
        {
            request.params["hospitalized_line_id"] = currentLineId
        }
        request.execute()
        addHuliView.removeFromSuperview()
    }
    
    func deleteRecord()
    {
        let alertView = UIAlertView(title: "", message: "确定要删除这条护理记录吗?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.tag = 100
        alertView.show()
        
//        let alert = UIAlertController(title: nil, message: "确定要删除这条护理记录吗?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
//            self.addHuliView.isHidden = false
//        }))
//        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
//            let request = HuliDeleteRequest()
//            request.params["hospitalized_line_id"] = self.currentLineId
//            request.execute()
//            self.addHuliView.removeFromSuperview()
//        }))
//        addHuliView.isHidden = true
//        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 && alertView.tag == 100
        {
            let request = HuliDeleteRequest()
            request.params["hospitalized_line_id"] = self.currentLineId
            request.execute()
            self.addHuliView.removeFromSuperview()
        }
    }
}
