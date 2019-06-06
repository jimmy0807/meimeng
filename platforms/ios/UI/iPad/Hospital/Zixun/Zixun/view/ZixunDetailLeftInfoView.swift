//
//  ZixunDetailLeftInfoView.swift
//  meim
//
//  Created by jimmy on 2017/6/9.
//
//

import UIKit

class ZixunDetailLeftInfoView: UIView {

    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var vipImageView : UIImageView!
    @IBOutlet weak var memberNameLabel : UILabel!
    @IBOutlet weak var roomNameLabel : UILabel!
    @IBOutlet weak var noLabel : UILabel!
    @IBOutlet weak var sexLabel : UILabel!
    @IBOutlet weak var ageLabel : UILabel!
    @IBOutlet weak var xingzuoLabel : UILabel!
    @IBOutlet weak var xuexingLabel : UILabel!
    @IBOutlet weak var customerStateLabel : UILabel!
    
    var zixun : CDZixun?
    {
        didSet
        {
            if let zixun = self.zixun
            {
                self.avatarImageView.sd_setImage(with: URL(string: zixun.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                self.memberNameLabel.text = zixun.member_name
                self.roomNameLabel.text = "咨询室:" + (zixun.room_name ?? "")
                self.noLabel.text = "排号:" + (zixun.queue_no ?? "")
                self.sexLabel.text = "性别:" + (zixun.sex ?? "")
                self.ageLabel.text = "年龄:" + (zixun.age ?? "")
                self.xingzuoLabel.text = "星座:" + (zixun.xingzuo ?? "")
                self.xuexingLabel.text = "血型:" + (zixun.xuexing ?? "")
                self.customerStateLabel.text = zixun.customer_state_name
                //setVIPImageFrame(zixun)
            }
        }
    }
    
    func setVIPImageFrame(_ zixun : CDZixun)
    {
        let maxLabelWidth : CGFloat = 150
        var iconImage : UIImage?
        zixun.member_level = "mvp"
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
        
        self.vipImageView.image = iconImage
        var frame = self.memberNameLabel.frame
        if let icon = iconImage
        {
            let iconWidth = icon.size.width
            let name = self.memberNameLabel.text! as NSString
            let width = maxLabelWidth - 10 - iconWidth
            let size = name.boundingRect(with: CGSize(width: width, height: frame.size.width) , options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.memberNameLabel.font], context: nil).size
            frame.size.width = size.width
        }
        else
        {
            frame.size.width = maxLabelWidth;
        }

        self.memberNameLabel.frame = frame;
        
        frame = self.vipImageView.frame;
        frame.origin.x = self.memberNameLabel.frame.size.width + 5 + self.memberNameLabel.frame.origin.x;
        frame.size.width = iconImage?.size.width ?? 0;
        self.vipImageView.frame = frame;
    }
}
