//
//  H9ShoushuNotifyTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/8/3.
//
//

import UIKit

class H9ShoushuNotifyTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var detailLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var iconImageView : UIImageView!
    
    var notify : CDH9Notify?
    {
        didSet
        {
            if let notify = self.notify
            {
                self.titleLabel.text = notify.title
                self.detailLabel.text = notify.name
                self.timeLabel.text = notify.planning_time
                
//                if notify.state == "unread"
//                {
//                    self.iconImageView.isHidden = false
//                }
//                else
//                {
//                    self.iconImageView.isHidden = true
//                }
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
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
                                label.font = UIFont.systemFont(ofSize: 17)
                            }
                        }
                    }
                }
            }
        }
    }
}
