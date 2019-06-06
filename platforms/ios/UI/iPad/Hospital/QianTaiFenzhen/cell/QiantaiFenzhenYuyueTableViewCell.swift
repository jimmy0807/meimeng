//
//  QiantaiFenzhenYuyueTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/5/31.
//
//

import UIKit

class QiantaiFenzhenYuyueTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var vipImageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var timeoutLabel : UILabel!
    @IBOutlet weak var doctorLabel : UILabel!
    @IBOutlet var vipImageWidthConstraint : NSLayoutConstraint!
    
    open var longPressedBlock: ((_ text: String) -> Void)?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var book: CDZixunBook?
    {
        didSet
        {
            if let book = self.book
            {
                self.avatarImageView.sd_setImage(with: URL(string: book.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                //print("拖入房间之后book.name = \(String(describing: book.name))")
                //Optional("Ab(PT)[未到店] 咨询室-V6")
                self.nameLabel.text = book.name
                self.doctorLabel.text = book.create_uid_name
//                if ( book.member_type?.uppercased() == "VIP" )
//                {
//                    let image = UIImage(named: "pad_home_wash_vip")!
//                    self.vipImageWidthConstraint.constant = image.size.width;
//                    self.vipImageView.image = image
//                }
//                else if ( book.member_type?.uppercased() == "WIP" )
//                {
//                    let image = UIImage(named: "pad_home_wash_wvp")!
//                    self.vipImageWidthConstraint.constant = image.size.width;
//                    self.vipImageView.image = image
//                }
//                else
//                {
//                    self.vipImageView.image = nil
//                }
                
                self.timeoutLabel.isHidden = true
                if let yuyueDate = book.start_date!.date(with: "yyyy-MM-dd HH:mm:ss")
                {
                    let timestap = yuyueDate.timeIntervalSince(Date())
                    if timestap < 0
                    {
                        self.timeoutLabel.isHidden = false
                        self.timeoutLabel.text = "已超时"
                    }
                }
                self.timeLabel.text = book.start_date!.dateFrom("yyyy-MM-dd HH:mm:ss", to: "HH:mm")
            }
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        for subview in self.subviews
        {
            for subview2 in subview.subviews
            {
                if (String(describing: subview2).range(of: "UITableViewCellActionButton") != nil)
                {
                    for view in subview2.subviews
                    {
                        if (String(describing: view).range(of: "UIButtonLabel") != nil)
                        {
                            if let label = view as? UILabel
                            {
                                label.font = UIFont.systemFont(ofSize: 16)
                            }
                        }
                    }
                }
            }
        }
    }
}
