//
//  ZongKongLiYuanMemberTableViewCell.swift
//  meim
//
//  Created by 宋海斌 on 2017/6/21.
//
//

import UIKit

class ZongKongLiYuanMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimelabel: UILabel!
    
    var person: CDZongkongLiyuanPerson?
    {
        didSet
        {
            if let person = self.person
            {
                self.memberNameLabel.text = person.name
                self.timeLabel.text = person.time
                self.startTimeLabel.text = person.billed_time
                self.endTimelabel.text = person.leave_time
                self.avatarImage.sd_setImage(with: URL(string: person.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                //setVIPImageFrame(person)
            }
        }
    }
    
    func setVIPImageFrame(_ person : CDZongkongLiyuanPerson)
    {
        let maxLabelWidth : CGFloat = 220
        var iconImage : UIImage?
        person.member_type = "mvp"
        if let level = person.member_type
        {
            if level.uppercased() == "VIP"
            {
                iconImage = #imageLiteral(resourceName: "pad_home_wash_vip.png")
            }
            else if level.uppercased() == "MVP"
            {
                iconImage = #imageLiteral(resourceName: "pad_home_wash_wvp.png")
            }
        }
        
        self.levelImage.image = iconImage
        var frame = self.memberNameLabel.frame
        if let icon = iconImage
        {
            let iconWidth = icon.size.width
            let name = (self.memberNameLabel.text ?? "") as NSString
            let width = maxLabelWidth - 10 - iconWidth
            let size = name.boundingRect(with: CGSize(width: width, height: frame.size.width) , options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.memberNameLabel.font], context: nil).size
            frame.size.width = size.width
        }
        else
        {
            frame.size.width = maxLabelWidth;
        }
        
        self.memberNameLabel.frame = frame;
        
        frame = self.levelImage.frame;
        frame.origin.x = self.memberNameLabel.frame.size.width + 12 + self.memberNameLabel.frame.origin.x;
        frame.size.width = iconImage?.size.width ?? 0;
        self.levelImage.frame = frame;
    }
}
