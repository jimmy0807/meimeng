//
//  YaofangTableViewCell.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/13.
//

import UIKit

class YaofangTableViewCell: UITableViewCell {
    
    public var member:NSDictionary!
    
    public func initCell()
    {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 722, height: 75))
        mainView.backgroundColor = .white
        let numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 105, height: 75))
        numberLabel.text = "\(member.object(forKey: "id") ?? "")"
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.systemFont(ofSize: 18)
        numberLabel.textColor = RGB(r: 37, g: 37, b: 37)
        mainView.addSubview(numberLabel)
        let line = UIView(frame: CGRect(x: 105, y: 0, width: 1, height: 75))
        line.backgroundColor = RGB(r: 180, g: 213, b: 218)
        mainView.addSubview(line)
        let avatarImage = UIImageView(frame: CGRect(x: 135, y: 13, width: 50, height: 50))
        //avatarImage.setImageWithName("\(/*member.memberID ?? */0)_\(/*member.memberName ?? */"")", tableName: "born.member", filter: member.memberID, fieldName: member.memberName, writeDate: member.lastUpdate, placeholderString: "pad_avatar_default", cacheDictionary: nil)
        avatarImage.sd_setImage(with: URL(string: "\(member.object(forKey: "member_image_url") ?? "")"), placeholderImage: UIImage(named: "pad_avatar_default"))
        avatarImage.layer.cornerRadius = 25
        avatarImage.clipsToBounds = true
        mainView.addSubview(avatarImage)
        let nameLabel = UILabel(frame: CGRect(x: 205, y: 15, width: 350, height: 20))
        //nameLabel.text = "\(member.object(forKey: "customer_name") ?? ""))"
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = RGB(r: 37, g: 37, b: 37)
        nameLabel.setAttributeString("\(member.object(forKey: "customer_name") ?? "")\(member.object(forKey: "customer_mobile") ?? "")", colorString: "\(member.object(forKey: "customer_mobile") ?? "")", textColor: RGB(r: 153, g: 153, b: 153), textFont: UIFont.systemFont(ofSize: 14))
        mainView.addSubview(nameLabel)
       
        let detailLabel = UILabel(frame: CGRect(x: 205, y: 43, width: 250, height: 20))
        detailLabel.text = "医生：\(member.object(forKey: "doctor_name") ?? "")，科室：\(member.object(forKey: "departments_name") ?? "")"
        detailLabel.textAlignment = .left
        detailLabel.font = UIFont.systemFont(ofSize: 16)
        detailLabel.textColor = RGB(r: 37, g: 37, b: 37)
        mainView.addSubview(detailLabel)
        let clockImage = UIImageView(frame: CGRect(x: 495, y: 29, width: 16, height: 16))
        clockImage.image = #imageLiteral(resourceName: "member_follow_clock_icon.png")
        mainView.addSubview(clockImage)
        let timeLabel = UILabel(frame: CGRect(x: 515, y: 30, width: 150, height: 15))
        timeLabel.text = "\(member.object(forKey: "create_date") ?? "")"
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = RGB(r: 153, g: 153, b: 153)
        mainView.addSubview(timeLabel)
        let prescriptionLabel = UILabel(frame: CGRect(x: 550, y: 25, width: 148, height: 25))
        prescriptionLabel.text = "\(member.object(forKey: "prescription_type_name") ?? "")"
        prescriptionLabel.textAlignment = .right
        prescriptionLabel.font = UIFont.systemFont(ofSize: 16)
        prescriptionLabel.textColor = RGB(r: 96, g: 211, b: 212)
        mainView.addSubview(prescriptionLabel)
        let statusLabel = UILabel(frame: CGRect(x: 662, y: 0, width: 60, height: 22))
        if (member.object(forKey: "is_checkout") as! Bool)
        {
//            statusLabel.text = "已支付"
//            statusLabel.backgroundColor = RGB(r: 253, g: 207, b: 0)
        }
        else
        {
            statusLabel.text = "待支付"
            statusLabel.backgroundColor = RGB(r: 253, g: 207, b: 0)
            statusLabel.textAlignment = .center
            statusLabel.font = UIFont.systemFont(ofSize: 16)
            statusLabel.textColor = UIColor.white
            mainView.addSubview(statusLabel)
        }
        
        self.addSubview(mainView)
    }
    
}
