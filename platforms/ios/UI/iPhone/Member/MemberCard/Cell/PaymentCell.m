//
//  PaymentCell.m
//  Boss
//
//  Created by lining on 16/6/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell

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

- (IBAction)cancelBtnPressed:(UIButton *)sender {
    NSLog(@"cancel at indexPath: %@",self.indexPath);
    if ([self.delegate respondsToSelector:@selector(didCancelBtnPressed:)]) {
        [self.delegate didCancelBtnPressed:self];
    }
}

@end
