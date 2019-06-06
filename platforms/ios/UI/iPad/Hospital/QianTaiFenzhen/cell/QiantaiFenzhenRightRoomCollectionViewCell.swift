//
//  QiantaiFenzhenRightRoomCollectionViewCell.swift
//  meim
//
//  Created by jimmy on 2017/5/31.
//
//

import UIKit

class QiantaiFenzhenRightRoomCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var bgImageView : UIImageView!
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var roomNameLabel : UILabel!
    @IBOutlet weak var stateLabel : UILabel!
    @IBOutlet weak var memberNameLabel : UILabel!
    @IBOutlet weak var shejishiLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var messageLabel : UILabel!
    var memberCountView : UILabel!
    
    var memberCount:Int = 0
    {
        didSet
        {
            if memberCount > 1
            {
                if self.memberCountView != nil
                {
                    self.memberCountView.removeFromSuperview()
                    self.memberCountView = nil
                }
                self.memberCountView = UILabel(frame: CGRect(x: 0, y: 0, width: self.avatarImageView.frame.size.width, height: self.avatarImageView.frame.size.height))
                self.memberCountView.text = "+\(memberCount)"
                self.memberCountView.textColor = UIColor.white
                self.memberCountView.font = UIFont.systemFont(ofSize: 20)
                self.memberCountView.textAlignment = .center
                self.memberCountView.backgroundColor = RGBA(r: 96, g: 211, b: 212, a: 0.5)
                //self.avatarImageView.addSubview(self.memberCountView)
            }
        }
    }
    
    var room: CDZixunRoom?
    {
        didSet
        {
            if let room = self.room
            {
                self.roomNameLabel.text = room.name
                self.stateLabel.text = room.state
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
                
                self.avatarImageView.sd_setImage(with: URL(string: room.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                self.memberNameLabel.text = room.member_name
                self.shejishiLabel.text = (room.designers_name ?? "") + "    " + (room.director_employee_name ?? "")
                
//                if let persons = room.person, persons.count > 0, let person = persons[0] as? CDZixunRoomPerson, person.state == "done"
//                {
//                    self.avatarImageView.sd_setImage(with: URL(string: person.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
//                    self.memberNameLabel.text = person.member_name
//                    self.shejishiLabel.text = "设计师: " + (person.designers_name ?? "") + "    设计总监: " + (person.director_employee_name ?? "")
////                    self.timeLabel.text = person.start_date!.dateFrom("yyyy-MM-dd HH:mm:ss", to: "HH:mm:ss")
//                }
//                else
//                {
//                    self.memberNameLabel.text = ""
//                    self.shejishiLabel.text = ""
//                    self.timeLabel.text = ""
//                    self.avatarImageView.image = #imageLiteral(resourceName: "pad_avatar_default.png")
//                }
                
                if let r = room.is_recycle, r.boolValue
                {
                    self.avatarImageView.isHidden = true
                }
                else
                {
                    self.avatarImageView.isHidden = false
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
                let formatDate = Date(timeIntervalSince1970: timeInterval - 8 * 3600 + 1)
                let formator = DateFormatter()
                formator.dateFormat = "HH:mm:ss"
                self.timeLabel.text = formator.string(from: formatDate)
            }
        }
    }
}
