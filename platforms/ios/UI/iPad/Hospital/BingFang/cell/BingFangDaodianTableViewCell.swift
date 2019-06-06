//
//  BIngFangDaodianTableViewCell.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/9.
//

import UIKit

class BingFangDaodianTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var paiduiLabel : UILabel!
    @IBOutlet weak var doctorLabel : UILabel!
    @IBOutlet weak var designAndDirectorLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var book: CDBingFangBook?
    {
        didSet
        {
            if let book = self.book
            {
                self.avatarImageView.sd_setImage(with: URL(string: book.image_url ?? ""), placeholderImage: UIImage(named: "pad_avatar_default"))
                self.nameLabel.text = book.name
                //self.doctorLabel.text = (book.create_uid_name ?? "无") + "  " + book.create_date!.dateFrom("yyyy-MM-dd HH:mm:ss", to: "MM-dd HH:mm")
                self.doctorLabel.text = "医生：\(book.doctor_name ?? "")"
                self.timeLabel.text = book.create_date!.dateFrom("yyyy-MM-dd HH:mm:ss", to: "MM/dd HH:mm")
                self.designAndDirectorLabel.text = book.designer_name
                //self.paiduiLabel.text = book.queue_no_name
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

