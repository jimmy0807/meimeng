//
//  ZixunTodayCollectionViewCell.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

class ZixunTodayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var levelImage: UIImageView!
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var prodLabel: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    var zixun: CDZixun?
    {
        didSet
        {
            if let zixun = self.zixun
            {
                self.namelabel.text = zixun.member_name
                self.prodLabel.text = "咨询项目:无" + (zixun.product_names ?? "")
                
                self.timeLabel.text = zixun.create_date
                self.stateLabel.text = zixun.state_name
                if (zixun.state_name == "已开单")
                {
                    self.stateLabel.text = "已完成"
                }
                self.avatarImage.sd_setImage(with: URL(string: zixun.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                if zixun.state == "done" || zixun.state == "doing"
                {
                    self.stateImage.image = #imageLiteral(resourceName: "state_background2.png")
                }
                else {
                    self.stateImage.image = #imageLiteral(resourceName: "state_background1.png")
                }
                
                if zixun.state == "visit"
                {
                    self.stateImage.image = #imageLiteral(resourceName: "state_background1.png")
                }
                
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
        var frame = self.namelabel.frame
        if let icon = iconImage
        {
            let iconWidth = icon.size.width
            let name = self.namelabel.text! as NSString
            let width = maxLabelWidth - 10 - iconWidth
            let size = name.boundingRect(with: CGSize(width: width, height: frame.size.width) , options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.namelabel.font], context: nil).size
            frame.size.width = size.width
        }
        else
        {
            frame.size.width = maxLabelWidth;
        }
        
        self.namelabel.frame = frame;
        
        frame = self.levelImage.frame;
        frame.origin.x = self.namelabel.frame.size.width + 10 + self.namelabel.frame.origin.x;
        frame.size.width = iconImage?.size.width ?? 0;
        self.levelImage.frame = frame;
    }

}
