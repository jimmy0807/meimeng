//
//  ZixunInRoomTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

class ZixunHistoryTableViewCell: UITableViewCell
{
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var customerStateLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    var zixun: CDZixun?
    {
        didSet
        {
            if let zixun = self.zixun
            {
                self.nameLabel.text = zixun.member_name
                if zixun.create_date != nil {
                    self.timeLabel.text = zixun.create_date!.dateFrom("yyyy-MM-dd HH:mm:ss", to: "MM-dd HH:mm")
                }
                self.customerStateLabel.text = zixun.customer_state_name
                self.stateLabel.text = zixun.state_name
                self.avatarImage.sd_setImage(with: URL(string: zixun.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
            }
        }
    }
}
