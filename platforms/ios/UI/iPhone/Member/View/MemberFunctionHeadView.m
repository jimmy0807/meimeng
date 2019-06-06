//
//  MemberFunctionHeadView.m
//  Boss
//
//  Created by lining on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFunctionHeadView.h"

@implementation MemberFunctionHeadView

+ (instancetype)createView
{
    MemberFunctionHeadView *headView = [self loadFromNib];
    if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
    {
        headView.tipImgView.image = [UIImage imageNamed:@"member_read_text.png"];
    }
    else
    {
        headView.tipImgView.image = [UIImage imageNamed:@"member_edit_text.png"];
    }
    headView.bgView.backgroundColor = AppThemeColor;
    return headView;
}

- (IBAction)editBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didEditBtnPressed)]) {
        [self.delegate didEditBtnPressed];
    }
}
@end
