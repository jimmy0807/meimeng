//
//  H9AnPaiRightEventTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/8/3.
//
//

import UIKit

class H9AnPaiRightEventTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var detailLabel : UILabel!
    @IBOutlet weak var cancelStateLabel : UILabel!
    
    var event : CDH9SSAPEvent?
    {
        didSet
        {
            if let event = self.event
            {
                self.titleLabel.text = event.operate_time
                self.nameLabel.text = event.product_name
                self.detailLabel.text = event.note
                self.cancelStateLabel.isHidden = !(event.state == "cancel")
                if (event.state == "ontime" || event.state == "non-ontime")
                {
                    self.cancelStateLabel.isHidden = false
                    self.cancelStateLabel.text = event.state_name
                }
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
