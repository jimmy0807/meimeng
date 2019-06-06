//
//  PadProjectRemindView.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-4.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadProjectRemindView.h"
#import "PadProjectConstant.h"
#import "BSUserDefaultsManager.h"

@implementation PadProjectRemindView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        contentButton.frame = self.bounds;
        contentButton.backgroundColor = [UIColor blackColor];
        contentButton.alpha = 0.5;
        [contentButton addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:contentButton];
        
        UIImage *tipsImage = [UIImage imageNamed:@"pad_select_category_tips"];
        UIImageView *tipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - kPadProjectSideViewWidth - tipsImage.size.width)/2.0, kPadNaviHeight - 12.0, tipsImage.size.width, tipsImage.size.height)];
        tipsImageView.backgroundColor = [UIColor clearColor];
        tipsImageView.image = tipsImage;
        [self addSubview:tipsImageView];
        
        tipsImage = [UIImage imageNamed:@"pad_select_member_tips"];
        tipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - 32.0 - tipsImage.size.width, kPadNaviHeight - 12.0, tipsImage.size.width, tipsImage.size.height)];
        tipsImageView.backgroundColor = [UIColor clearColor];
        tipsImageView.image = tipsImage;
        [self addSubview:tipsImageView];
    }
    
    return self;
}

- (void)didContentButtonClick:(id)sender
{
    [[BSUserDefaultsManager sharedManager] setIsPadProjectViewRemind:YES];
    
    [self removeFromSuperview];
}

@end
