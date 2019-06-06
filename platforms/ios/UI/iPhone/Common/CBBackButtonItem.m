//
//  CBBackButtonItem.m
//  CardBag
//
//  Created by jimmy on 13-8-6.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "CBBackButtonItem.h"

@implementation CBBackButtonItem

- (id)initWithTitle:(NSString*)title
{
    UIImage* image = [UIImage imageNamed:LS(@"common_back_N.png")];
    UIButton* backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    if (title.length == 0)
    {
        [backBtn setImage:image forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:LS(@"common_back_H.png")] forState: UIControlStateHighlighted];
    }
    else
    {
        backBtn.frame = CGRectMake(0.0, 0.0, 64.0, 44.0);
        UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, backBtn.frame.size.width, backBtn.frame.size.height)];
        customLab.text = [title length] > 0 ? title : LS(@"Back");
        customLab.textColor = [UIColor whiteColor];
        customLab.textAlignment = NSTextAlignmentCenter;
        customLab.backgroundColor = [UIColor clearColor];
        customLab.font = [UIFont boldSystemFontOfSize:14.0];
        [backBtn addSubview:customLab];
    }
    
    if (IS_SDK7)
    {
        //backBtn.frame = CGRectMake(0.0, 0.0, 64.0 + IOS6_MARGINS - IOS7_MARGINS, 44.0);
        //backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, IOS6_MARGINS - IOS7_MARGINS, 0, 0);
    }
    else
    {
//        backBtn.frame = CGRectMake(0.0, 0.0, 64.0 + IOS7_MARGINS - IOS6_MARGINS, 44.0);
//        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 1.0, 0, 0);
    }
    [backBtn addTarget:self action:@selector(didBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:backBtn];
    if (self)
    {
        [backBtn addTarget:self action:@selector(didBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.btn = backBtn;
    }
    
    return self;
}

-(void)didBackButtonPressed: (id)sender
{
    if ( [self.delegate respondsToSelector:@selector(didItemBackButtonPressed:)] )
    {
        [self.delegate performSelector:@selector(didItemBackButtonPressed:) withObject:sender];
    }
    else if ([self.delegate respondsToSelector:@selector(navigationController)])
    {
        UINavigationController* naviCtl = [self.delegate performSelector:@selector(navigationController)];
        [naviCtl popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
   
}

@end
