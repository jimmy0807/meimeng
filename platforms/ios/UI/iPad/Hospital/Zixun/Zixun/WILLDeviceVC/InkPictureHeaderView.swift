//
//  InkPictureHeaderView.swift
//  meim
//
//  Created by 刘伟 on 2017/12/5.
//

import Foundation

class InkPictureHeaderView : UICollectionReusableView {
    
    var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        titleLabel.frame = CGRect.init(x: 0, y: 10, width:132, height: 18)
        titleLabel.text = "2018年1月1日"
        titleLabel.textColor = UIColor.init(red: 96/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1)
        self.addSubview(titleLabel)
    }
    
}
