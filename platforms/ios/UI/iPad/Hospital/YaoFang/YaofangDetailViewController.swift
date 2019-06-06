//
//  YaofangDetailViewController.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/13.
//

import UIKit

class YaofangDetailViewController: ICCommonViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var xingzuoLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var fundLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var designerLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var yaofangDetail = NSDictionary()
    var yaopinAray = NSArray()
    var memberId = NSNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = FetchYaofangDetailRequest()
        request.params["prescription_id"] = memberId
        request.execute()
        self.registerNofitification(forMainThread: "YaofangDetailFetchResponse")
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "YaofangDetailFetchResponse" )
        {
            print(notification.userInfo!["data"])
            if let dict = notification.userInfo!["data"] as? NSDictionary
            {
                yaofangDetail = dict
                yaopinAray = dict.object(forKey: "prescriptions") as! NSArray
                statusLabel.text = "\(yaofangDetail.object(forKey: "customer_state_name") ?? "")"
                if(statusLabel.text?.lengthOfBytes(using: .utf8) == 0)
                {
                    statusLabel.isHidden = true
                }
                avatarView.sd_setImage(with: URL(string: "\(yaofangDetail.object(forKey: "member_image_url") ?? "")"), placeholderImage: UIImage(named: "pad_avatar_default"))
                nameLabel.text = "\(yaofangDetail.object(forKey: "customer_name") ?? "")"
                genderLabel.text = "性别:\(yaofangDetail.object(forKey: "sex") ?? "")"
                ageLabel.text = "年龄:\(yaofangDetail.object(forKey: "age") ?? "")"
                //xingzuoLabel.text = "\(yaofangDetail.object(forKey: "customer_name") ?? "")"
                bloodTypeLabel.text = "血型:\(yaofangDetail.object(forKey: "blood_type") ?? "")"
                //fundLabel.text = "\(yaofangDetail.object(forKey: "customer_name") ?? "")"
                //pointLabel.text = "\(yaofangDetail.object(forKey: "customer_name") ?? "")"
                designerLabel.text = "\(yaofangDetail.object(forKey: "designers_name") ?? "")"
                directorLabel.text = "\(yaofangDetail.object(forKey: "director_employee_name") ?? "")"
                
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func printAction(_ sender: Any) {
        let request = BSPrintPosOperateRequestNew()
        request.printUrl = "\(yaofangDetail.object(forKey: "print_url") ?? "")"
        request.isYaofang = true
        request.execute()
    }
    
    @IBAction func finishAction(_ sender: Any) {
        let request = YaofangFinishRequest()
        request.params["prescription_id"] = yaofangDetail.object(forKey: "prescription_id")
        request.execute()
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yaopinAray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "YaofangDetailTableViewCell")//tableView.dequeueReusableCell(withIdentifier: "YaofangDetailTableViewCell") as! UITableViewCell
        let dict = yaopinAray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = "\(dict.object(forKey: "product_name") ?? "")"
        cell.textLabel?.textColor = RGB(r: 37, g: 37, b: 37)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel?.text = "\(dict.object(forKey: "qty") ?? "")\(dict.object(forKey: "uom_name") ?? "")"
        cell.detailTextLabel?.textColor = RGB(r: 37, g: 37, b: 37)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        if (indexPath.row == 0)
        {
            let topLine = UIView(frame: CGRect(x: 0, y: 0, width: 660, height: 1))
            topLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
            cell.addSubview(topLine)
        }
        let line = UIView(frame: CGRect(x: 0, y: 60, width: 660, height: 1))
        line.backgroundColor = RGB(r: 236, g: 237, b: 237)
        cell.addSubview(line)
        let leftLine = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 60))
        leftLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
        cell.addSubview(leftLine)
        let rightLine = UIView(frame: CGRect(x: 659, y: 0, width: 1, height: 60))
        rightLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
        cell.addSubview(rightLine)
        return cell
    }
}
