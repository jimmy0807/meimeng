//
//  ZongKongLiYuanMemberTableViewCell.swift
//  meim
//
//  Created by 宋海斌 on 2017/6/21.
//
//

import UIKit

class ZongKongLiYuanRightInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var item: CDZongkongLiyuanItem?
    {
        didSet
        {
            if let item = self.item
            {
                self.titleLabel.text = item.title
                self.contentLabel.text = item.content
                self.timeLabel.text = item.time
            }
        }
    }
}
