//
//  YimeiPhotoCollectionViewCell.h
//  ds
//
//  Created by jimmy on 16/11/3.
//
//

#import <UIKit/UIKit.h>

@interface YimeiPhotoCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)CDYimeiImage* yimeiImage;
@property(nonatomic, weak)IBOutlet UIImageView* photoImageView;
@property(nonatomic, weak)IBOutlet UIView* progressBgView;
@property(nonatomic, weak)IBOutlet UILabel* progressLabel;
@property(nonatomic, weak)IBOutlet UILabel* tagLabel;

@end
