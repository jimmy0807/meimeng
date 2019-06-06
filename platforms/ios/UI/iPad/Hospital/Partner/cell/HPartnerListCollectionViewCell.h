//
//  HPartnerListCollectionViewCell.h
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import <UIKit/UIKit.h>

@interface HPartnerListCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)CDPartner* partner;
@property(nonatomic, weak)IBOutlet UIImageView* logoImageView;

@end
