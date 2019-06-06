//
//  UIView+LoadNib.m
//  Boss
//
//  Created by lining on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "UIView+LoadNib.h"

@implementation UIView (LoadNib)

+ (instancetype)loadFromNib
{
    NSString *nibName = NSStringFromClass(self);
    return [self loadNibNamed:nibName];
}

+ (instancetype)loadNibNamed:(NSString *)nibName
{
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
}

@end
