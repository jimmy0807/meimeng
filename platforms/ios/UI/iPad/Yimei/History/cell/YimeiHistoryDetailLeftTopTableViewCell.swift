//
//  YimeiHistoryDetailLeftTopTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/6/28.
//
//

import UIKit

class YimeiHistoryDetailLeftTopTableViewCell: UITableViewCell
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    
    var history : CDYimeiHistory?
    {
        didSet
        {
            if let history = self.history
            {
                self.dateLabel.text = history.create_date
                self.typeLabel.text = history.type
                self.moneyLabel.text = "¥\(history.amount ?? "0")"
                self.customerLabel.text = "客户:\(history.member_name ?? "")"
                self.operatorLabel.text = "操作人:\(history.create_name ?? "")"
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
