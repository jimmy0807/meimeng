//
//  YimeiHistoryDetailProductTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/6/27.
//
//

import UIKit

class YimeiHistoryDetailProductTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var buweiLabel: UILabel!
    
    var buyItem : CDYimeiHistoryBuyItem?
    {
        didSet
        {
            if let buyItem = self.buyItem
            {
                self.nameLabel.text = buyItem.name_template
                self.countLabel.text = "x\(buyItem.qty ?? 0)"
                self.moneyLabel.text = "¥\(buyItem.price_unit ?? "0")"
                self.buweiLabel.isHidden = true
            }
        }
    }
    
    var consumeItem : CDYimeiHistoryConsumeItem?
    {
        didSet
        {
            if let consumeItem = self.consumeItem
            {
                self.nameLabel.text = consumeItem.name_template
                self.countLabel.text = "x\(consumeItem.qty ?? 0)"
                self.moneyLabel.text = ""
                self.buweiLabel.isHidden = false
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
