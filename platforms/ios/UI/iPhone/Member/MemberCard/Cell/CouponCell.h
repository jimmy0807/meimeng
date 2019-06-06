//
//  CouponCell.h
//  Boss
//
//  Created by lining on 16/8/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponCellDelegate <NSObject>
@optional
- (void)didDetailBtnPressedAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CouponCell : UITableViewCell

+ (instancetype) createCell;

@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *validDateLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailBtn;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<CouponCellDelegate>delegate;


@property (nonatomic, strong) CDCouponCard *couponCard;

@end
