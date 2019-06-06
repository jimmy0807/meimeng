//
//  CardPayCell.m
//  Boss
//
//  Created by lining on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CardPayCell.h"

@implementation CardPayCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)changeBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(changeCardPay)]) {
        [self.delegate changeCardPay];
    }
}

@end
