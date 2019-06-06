//
//  MemberTableHeadView.m
//  Boss
//
//  Created by lining on 16/3/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberTableHeadView.h"

@implementation MemberTableHeadView

+ (instancetype)createView
{
    return [self loadFromNib];
}

- (IBAction)newContactBtnPressed:(id)sender {
    [self.delegate didNewContactBtnPressed];
}

- (IBAction)callBtnPressed:(id)sender {
    [self.delegate didCallBtnPressed];
}

- (IBAction)wekaBtnPressed:(id)sender {
    [self.delegate didwekaBtnPressed];
}

- (IBAction)serviceBtnPressed:(id)sender {
    [self.delegate didServiceBtnPressed];
}

- (IBAction)messageBtnPressed:(id)sender {
    [self.delegate didMessageBtnPressed];
}

- (IBAction)filterBtnPressed:(id)sender {
    [self.delegate didFilterBtnPressed];
}
@end
