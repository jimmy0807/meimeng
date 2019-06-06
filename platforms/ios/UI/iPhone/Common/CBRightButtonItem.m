//
//  CBRightButtonItem.m
//  CardBag
//
//  Created by chen yan on 13-10-18.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "CBRightButtonItem.h"

@implementation CBRightButtonItem

- (id)initWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 40.0)];
    [button setTitle:(title ? title : LS(@"OK")) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:button];
    
    return self;
}

- (id)initWithNormalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, normal.size.width, normal.size.height)];
    [button setImage:normal forState:UIControlStateNormal];
    [button setImage:highlighted forState:UIControlStateHighlighted];
    if (IS_SDK7)
    {
        //button.frame = CGRectMake(0.0, 0.0, normal.size.width + IOS6_MARGINS - IOS7_MARGINS, normal.size.height);
        //[button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, IOS6_MARGINS - IOS7_MARGINS)];
    }
    else
    {
//        button.frame = CGRectMake(0.0, 0.0, normal.size.width + IOS6_MARGINS - IOS7_MARGINS, normal.size.height);
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 1.0)];
    }
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:button];
    
    return self;
}

- (void)buttonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRightBarButtonItemPressed:)])
    {
        [self.delegate didRightBarButtonItemPressed:self];
    }
}

@end
