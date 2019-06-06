//
//  CouponCell.m
//  Boss
//
//  Created by lining on 16/8/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setCouponCard:(CDCouponCard *)couponCard
{
    _couponCard = couponCard;

    self.couponNoLabel.text = couponCard.cardNumber;
    
    if (couponCard.cardType.integerValue == 2)
    {
        //礼品券
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",couponCard.courseRemainAmount.floatValue];
        self.countLabel.text = [NSString stringWithFormat:@"券内项目%d个",couponCard.courseRemainQty.integerValue];
    }
    else if (couponCard.cardType.integerValue == 3)
    {
        //礼品卡
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",couponCard.remainAmount.floatValue];
        self.countLabel.text = [NSString stringWithFormat:@"%@",@"无券内项目"];
    }
    
    if (couponCard.isInvalid.boolValue) {
       
        self.bgImgView.image = [UIImage imageNamed:@"coupon_cell_gray_bg.png"];
        self.detailBtn.hidden = true;
    }
    else
    {
        self.bgImgView.image = [UIImage imageNamed:@"coupon_cell_bg.png"];
        self.detailBtn.hidden = false;
    }
    
    self.validDateLabel.text = couponCard.invalidDate;
}

- (IBAction)detailBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didDetailBtnPressedAtIndexPath:)]) {
        [self.delegate didDetailBtnPressedAtIndexPath:self.indexPath];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
