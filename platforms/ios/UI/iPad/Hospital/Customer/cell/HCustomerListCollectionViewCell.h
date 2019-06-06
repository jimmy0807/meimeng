//
//  HCustomerListCollectionViewCell.h
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import <UIKit/UIKit.h>

@interface HCustomerListCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)CDHCustomer* customer;
@property(nonatomic, weak)IBOutlet UIImageView* logoImageView;

@end
