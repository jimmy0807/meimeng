//
//  PosOperateBtnCell.m
//  Boss
//
//  Created by lining on 16/9/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateBtnCell.h"

@interface PosOperateBtnCell ()
@property (strong, nonatomic) IBOutlet UIButton *btn;

@end

@implementation PosOperateBtnCell

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.btn setTitle:title forState:UIControlStateNormal];
}

- (IBAction)btnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didBtnPressed)]) {
        [self.delegate didBtnPressed];
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
