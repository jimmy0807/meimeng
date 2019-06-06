//
//  YimeiHistoryTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/6/27.
//
//

import UIKit

class YimeiHistoryTableViewCell: UITableViewCell
{
    @IBOutlet weak var bgButton: UIButton!
    @IBOutlet weak var operateTypeLabel: UILabel!
    @IBOutlet weak var operateUserLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    
    var history : CDYimeiHistory?
    {
        didSet
        {
            if let history = self.history
            {
                self.operateTypeLabel.text = history.name
                self.operateUserLabel.text = history.member_name
                self.timeLabel.text = history.create_date
                self.moneyLabel.text = "¥\(history.amount ?? "0")"
                self.tagImageView.isHidden = !(history.state == "cancel")
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.bgButton.setBackgroundImage(#imageLiteral(resourceName: "Home_historyPos_cellBg_N.png").stretchableImage(withLeftCapWidth: 270, topCapHeight: 5), for: .normal)
    }
}
