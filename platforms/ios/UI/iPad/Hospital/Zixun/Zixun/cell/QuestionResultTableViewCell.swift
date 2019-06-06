//
//  QuestionResultTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/6/14.
//
//

import UIKit

class QuestionResultTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var iconImageView : UIImageView!
    
    var item: CDQuestionResultItem?
    {
        didSet
        {
            if let item = self.item
            {
                self.nameLabel.text = item.name
            }
        }
    }
}
