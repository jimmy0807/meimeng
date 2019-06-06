//
//  YImeiSignBeforePriceTableViewCell.m
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import "YImeiSignBeforePriceTableViewCell.h"

@interface YImeiSignBeforePriceTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* priceLabel;
@end

@implementation YImeiSignBeforePriceTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.02f",[operate.amount doubleValue]];
}

@end
