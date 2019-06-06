//
//  PeopleBottomSelectedView.m
//  Boss
//
//  Created by lining on 16/5/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PeopleBottomSelectedView.h"

@interface PeopleBottomSelectedView ()
{
    BOOL allSelected;
}
@end

@implementation PeopleBottomSelectedView

+ (instancetype)createView
{
    return [self loadFromNib];
}

- (IBAction)allSelectedBtnPressed:(id)sender {
    allSelected = !allSelected;
    self.selectedImgView.highlighted = allSelected;
    self.sureBtn.enabled = allSelected;
    if ([self.delegate respondsToSelector:@selector(didAllSelectedBtnPressed:)]) {
        [self.delegate didAllSelectedBtnPressed:allSelected];
    }
}

- (IBAction)sureBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSureBtnPressed)]) {
        [self.delegate didSureBtnPressed];
    }
}

@end
