//
//  ZongKongShoushuRoomCollectionViewCell.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit

class ZongKongShoushuRoomCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var bgImageView : UIImageView!
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var roomNameLabel : UILabel!
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
                if let message = self.room?.wait_message, message.characters.count > 1
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
    
    var room: CDZongkongShoushuRoom?
    {
        didSet
        {
            if let room = self.room
            {
                if room.type == "empty"
                {
                    self.isHidden = true
                    return
                }
                else
                {
                    self.isHidden = false
                }
                
                self.roomNameLabel.text = room.name
                self.stateLabel.text = room.state_name
                if let message = room.wait_message, message.characters.count > 1
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
                if let count = room.waiting_count as? Int, count > 0
                {
                    self.avatarImageView.sd_setImage(with: URL(string: room.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                    self.memberNameLabel.text = room.member_name
                    if let shejishi = room.shejishi, shejishi.characters.count > 0
                    {
                        self.shejishiLabel.text = shejishi + "  " + (room.doctor_name ?? "")
                    }
                    else
                    {
                        self.shejishiLabel.text = (room.doctor_name ?? "")
                    }
                    
                    self.timeLabel.text = room.start_date!.dateFrom("yyyy-MM-dd HH:mm:ss", to: "HH:mm:ss")
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
        if let room = self.room
        {
            if let start = room.start_date?.date(with: "yyyy-MM-dd HH:mm:ss")
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
