//
//  OffLinePictureCell.swift
//  meim
//
//  Created by 刘伟 on 2017/12/5.
//

import Foundation

class OffLinePictureCell : UICollectionViewCell {
//    纯代码布局
//    let width = UIScreen.main.bounds.size.width//获取屏幕宽
//    var titleLabel:UILabel?//title
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        initView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func initView(){
//        titleLabel = UILabel(frame: CGRect.init(x: 5, y: 5, width: (width-40)/2, height: 50))
//        self .addSubview(titleLabel!)
//
//    }
    @IBOutlet weak var smallImageView: UIImageView!
    
    override func awakeFromNib() {
        //self.backgroundColor = UIColor.orange
        super.awakeFromNib()
        smallImageView.isUserInteractionEnabled=true
        self.contentView.addSubview(smallImageView)//一定要写这句
        
        //print(smallImageView.clipsToBounds)//false
        ///图片切圆角
        smallImageView.layer.masksToBounds = true
        smallImageView.layer.cornerRadius = 5
        
        self.contentView.layer.cornerRadius = 5
        
    }
    
}
