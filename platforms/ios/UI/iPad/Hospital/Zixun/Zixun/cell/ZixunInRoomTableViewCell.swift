//
//  ZixunInRoomTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

class ZixunInRoomTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!

    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var customerStateImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var customerStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var zixun: CDZixun?
    {
        didSet
        {
            if let zixun = self.zixun
            {
                self.nameLabel.text = zixun.member_name
                self.indexLabel.text = zixun.queue_no
                self.timeLabel.text = zixun.create_date
                self.roomLabel.text = zixun.room_name
                self.customerStateLabel.text = zixun.customer_state_name
                self.avatarImage.sd_setImage(with: URL(string: zixun.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                //setVIPImageFrame(zixun)
            }
        }
    }
    
    func setVIPImageFrame(_ zixun : CDZixun)
    {
        let maxLabelWidth : CGFloat = 220
        var iconImage : UIImage?
        
        if let level = zixun.member_level
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
        var frame = self.nameLabel.frame
        if let icon = iconImage
        {
            let iconWidth = icon.size.width
            let name = self.nameLabel.text! as NSString
            let width = maxLabelWidth - 10 - iconWidth
            let size = name.boundingRect(with: CGSize(width: width, height: frame.size.width) , options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.nameLabel.font], context: nil).size
            frame.size.width = size.width
        }
        else
        {
            frame.size.width = maxLabelWidth;
        }
        
        self.nameLabel.frame = frame;
        
        frame = self.levelImage.frame;
        frame.origin.x = self.nameLabel.frame.size.width + 10 + self.nameLabel.frame.origin.x;
        frame.size.width = iconImage?.size.width ?? 0;
        self.levelImage.frame = frame;
    }


}
