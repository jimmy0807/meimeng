//
//  BNBackButtonItem.m
//  Boss
//
//  Created by XiaXianBing on 15/6/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BNBackButtonItem.h"

@implementation BNBackButtonItem

- (id)initWithNormalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, normal.size.width, normal.size.height)];
    [button setImage:normal forState:UIControlStateNormal];
    [button setImage:highlighted forState:UIControlStateHighlighted];
//    if (IS_SDK7)
//    {
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, IOS6_MARGINS - IOS7_MARGINS, 0, 0);
//    }
    
    self = [super initWithCustomView:button];
    if (self)
    {
        [button addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return self;
}

- (void)backButtonClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didBackBarButtonItemClick:)])
    {
        [self.delegate performSelector:@selector(didBackBarButtonItemClick:) withObject:sender];
    }
    else if ([self.delegate respondsToSelector:@selector(navigationController)])
    {
        UINavigationController *naviController = [self.delegate performSelector:@selector(navigationController)];
        [naviController popViewControllerAnimated:YES];
    }
}

@end
