//
//  ZixunPictureCell.swift
//  meim
//
//  Created by 波恩公司 on 2017/11/15.
//

import Foundation

class ZixunPictureCell : UICollectionViewCell {
    
    var showImageAction:((Int,Array<Any>,UIImage)->())?  //声明闭包

    @IBOutlet weak var smallImageView: UIImageView!
    
    ///选中标记
    var coverView = UIImageView()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        smallImageView.isUserInteractionEnabled=true
        self.contentView.addSubview(smallImageView)//一定要写这句
        smallImageView.backgroundColor = UIColor.clear
        
        coverView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 124, height: 124))
        let selectImgV = UIImageView.init(frame: CGRect.init(x: 47, y: 47, width: 30, height: 30))
        selectImgV.image = UIImage.init(named: "ink_selectedCell")
        coverView.addSubview(selectImgV)
        coverView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)

        coverView.isHidden = true;
        smallImageView.addSubview(coverView)
   
    }
    
    var smallImage : UIImage? {
        didSet {
            if self.smallImage != nil
            {
                
                smallImageView.clipsToBounds = true
                
                smallImageView.image = smallImage
            }
        }
    }
    
    var select : Bool = false {
        willSet{
            
            //NSLog("==========")
            
        }
        didSet{
            
            //NSLog("did set \(select)")
            if select {
                
                coverView.isHidden = false
                
            } else {
                coverView.isHidden = true

            }
            
        }
    }
    
    var inkImageUrlArray = [String]()
 
}
