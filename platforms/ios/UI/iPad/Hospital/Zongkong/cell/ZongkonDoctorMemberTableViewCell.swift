//
//  ZongkonDoctorMemberTableViewCell.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/10.
//

import UIKit

class ZongkongDoctorMemberTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var prodLabel: UILabel!
    @IBOutlet weak var designerNameLabel: UILabel!
    @IBOutlet weak var directorNameLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    var customer: CDZongkongDoctorCustomer?
    {
        didSet
        {
            if let customer = self.customer
            {
                self.avatarImage.sd_setImage(with: URL(string: customer.member_image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                
                self.memberNameLabel.text = customer.member_name
                self.doctorNameLabel.text = customer.doctor_name
                let strComponents = customer.remark?.components(separatedBy: "\n")
                var lines = strComponents?.count
                for str in (strComponents)!
                {
                    if (str.boundingRect(with: CGSize(), options: NSStringDrawingOptions.usesFontLeading, attributes: nil, context: nil).width > 243.0)
                    {
                        lines! += 1
                    }
                }
                self.prodLabel.frame = CGRect(x: self.prodLabel.frame.origin.x, y: self.prodLabel.frame.origin.y, width: self.prodLabel.frame.width, height: CGFloat(15*lines!))
                self.prodLabel.numberOfLines = lines!
                self.prodLabel.text = customer.remark ?? ""
                self.designerNameLabel.text = "设计师:" + (customer.designers_name ?? "")
                self.directorNameLabel.text = "设计总监:" + (customer.director_employee_name ?? "")
                //setVIPImageFrame(customer)
                setTimeLabelText()
            }
        }
    }
    
    func setTimeLabelText()
    {
        self.timeLabel.text = ""
        if let customer = self.customer
        {
            if let start = customer.start_date?.date(with: "yyyy-MM-dd HH:mm:ss")
            {
                let timeInterval = Date().timeIntervalSince(start)
                let time = Int(timeInterval / 60)
                let startDate = customer.start_date!.dateFrom("yyyy-MM-dd HH:mm:ss", to: "HH:mm")
                self.timeLabel.text = startDate + String(format: " %d分钟", time)
            }
        }
    }
    
    func setVIPImageFrame(_ customer : CDZongkongShoushuCustomer)
    {
        let maxLabelWidth : CGFloat = 150
        var iconImage : UIImage?
        customer.member_type = "mvp"
        if let level = customer.member_type
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
        
        frame = self.levelImage.frame;
        frame.origin.x = self.memberNameLabel.frame.size.width + 12 + self.memberNameLabel.frame.origin.x;
        frame.size.width = iconImage?.size.width ?? 0;
        self.levelImage.frame = frame;
    }
    
    
}

