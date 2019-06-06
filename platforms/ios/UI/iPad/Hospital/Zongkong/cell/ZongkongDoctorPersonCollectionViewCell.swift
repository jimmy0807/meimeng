//
//  ZongkongDoctorPersonCollectionViewCell.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/9.
//

import UIKit

class ZongkongDoctorPersonCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var doctorNameLabel : UILabel!
    @IBOutlet weak var stateLabel : UILabel!
    @IBOutlet weak var memberNameLabel : UILabel!
    @IBOutlet weak var shejishiLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var messageLabel : UILabel!
    
    var isItemSelected: Bool = false
    {
        didSet
        {
            self.bgImageView.layer.masksToBounds = true
            self.bgImageView.layer.cornerRadius = 4
            
            if isItemSelected
            {
                if let message = self.doctor?.waiting_name, message.characters.count > 1
                {
                    self.bgImageView.layer.borderColor = RGB(r: 128, g: 213, b: 213).cgColor
                }
                else
                {
                    self.bgImageView.layer.borderColor = RGB(r: 166, g: 203, b: 209).cgColor
                }
                
                self.bgImageView.layer.borderWidth = 2
            }
            else
            {
                self.bgImageView.layer.borderWidth = 0
            }
        }
    }
    
    var doctor: CDZongkongDoctorPerson?
    {
        didSet
        {
            if let doctor = self.doctor
            {
//                if doctor.type == "empty"
//                {
//                    self.isHidden = true
//                    return
//                }
//                else
//                {
//                    self.isHidden = false
//                }
                
                self.doctorNameLabel.text = doctor.name
                self.stateLabel.text = doctor.state_name
                if let message = doctor.waiting_name, message.characters.count > 1
                {
                    self.messageLabel.textColor = RGB(r: 245, g: 178, b: 65)
                    self.messageLabel.text = message
                    self.bgImageView.image = #imageLiteral(resourceName: "fenzhen_room_green.png")
                }
                else
                {
                    self.messageLabel.textColor = RGB(r: 166, g: 166, b: 166)
                    self.messageLabel.text = "无预定"
                    self.bgImageView.image = #imageLiteral(resourceName: "fenzhen_room_gray.png")
                }
                if let count = doctor.doing_cnt as? Int, count > 0
                {
                    self.avatarImageView.sd_setImage(with: URL(string: doctor.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                    self.memberNameLabel.text = doctor.member_name
                    if let shejishi = doctor.designer_name, shejishi.characters.count > 0
                    {
                        self.shejishiLabel.text = shejishi + "  " + (doctor.name ?? "")
                    }
                    else
                    {
                        self.shejishiLabel.text = (doctor.name ?? "")
                    }
                    
                    self.timeLabel.text = doctor.start_date!.dateFrom("yyyy-MM-dd HH:mm:ss", to: "HH:mm:ss")
                }
                else
                {
                    self.memberNameLabel.text = ""
                    self.shejishiLabel.text = ""
                    self.timeLabel.text = ""
                    self.avatarImageView.image = #imageLiteral(resourceName: "pad_avatar_default.png")
                }
                
                setTimeLabelText()
            }
        }
    }
    
    func setTimeLabelText()
    {
        self.timeLabel.text = ""
        if let doctor = self.doctor
        {
            if let start = doctor.start_date?.date(with: "yyyy-MM-dd HH:mm:ss")
            {
                let timeInterval = Date().timeIntervalSince(start)
                let formatDate = Date(timeIntervalSince1970: timeInterval - 8 * 3600)
                let formator = DateFormatter()
                formator.dateFormat = "HH:mm:ss"
                self.timeLabel.text = formator.string(from: formatDate)
            }
        }
    }
}
