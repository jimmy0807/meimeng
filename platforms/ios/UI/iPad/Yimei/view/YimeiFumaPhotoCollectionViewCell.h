//
//  YimeiFumaPhotoCollectionViewCell.h
//  meim
//
//  Created by jimmy on 2017/5/25.
//
//

#import <UIKit/UIKit.h>

@interface YimeiFumaPhotoCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)CDYimeiImage* yimeiImage;
@property(nonatomic, weak)IBOutlet UIImageView* photoImageView;
@property(nonatomic, weak)IBOutlet UIView* progressBgView;
@property(nonatomic, weak)IBOutlet UILabel* progressLabel;

@end
