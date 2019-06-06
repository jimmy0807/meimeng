//
//  BNRightButtonItem.m
//  Boss
//
//  Created by XiaXianBing on 15/6/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BNRightButtonItem.h"

@interface BNRightButtonItem ()
{
    UIButton *button;
}

@end
@implementation BNRightButtonItem

- (id)initWithTitle:(NSString *)title
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize minSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:17.0] constrainedToSize:CGSizeMake(120.0, 44.0) lineBreakMode:NSLineBreakByWordWrapping];
    button.frame = CGRectMake(0.0, 0.0, minSize.width + (IS_SDK7 ? (IOS7_MARGINS - IOS6_MARGINS) : 0.0), minSize.height);
    [button setTitle:(title ? title : LS(@"OK")) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:COLOR(164.0, 225.0, 255.0, 1.0) forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:button];
    
    return self;
}

- (id)initWithNormalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted
{
    button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, normal.size.width, normal.size.height)];
    [button setImage:normal forState:UIControlStateNormal];
    [button setImage:highlighted forState:UIControlStateHighlighted];
//    if (IS_SDK7)
//    {
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, IOS6_MARGINS - IOS7_MARGINS);
//    }
    
    self = [super initWithCustomView:button];
    if (self)
    {
        [button addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)setBtnTitle:(NSString *)btnTitle
{
    _btnTitle = btnTitle;
    [button setTitle:btnTitle forState:UIControlStateNormal];
    
}

- (void)rightButtonClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didRightBarButtonItemClick:)])
    {
        [self.delegate performSelector:@selector(didRightBarButtonItemClick:) withObject:sender];
    }
}

@end
