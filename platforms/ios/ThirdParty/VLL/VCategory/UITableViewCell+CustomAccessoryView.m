//
//  UITableViewCell+CustomAccessoryView.m
//  CardBag
//
//  Created by jimmy on 14/12/23.
//  Copyright (c) 2014年 Everydaysale. All rights reserved.
//

#import "UITableViewCell+CustomAccessoryView.h"
#import <objc/runtime.h>

static NSString* customAccessoryViewKey = @"customAccessoryView";

@implementation UITableViewCell (CustomAccessoryView)
@dynamic customAccessoryView;

- (void)setCustomAccessoryView:(UIView *)customAccessoryView
{
    UIView* currentView = objc_getAssociatedObject(self, &customAccessoryViewKey);
    if ( currentView )
    {
        [currentView removeFromSuperview];
    }

    CGRect frame = customAccessoryView.frame;
    frame.origin.x = self.contentView.frame.size.width - frame.size.width;
    frame.origin.y = (self.contentView.frame.size.height - frame.size.height)/2;
    customAccessoryView.frame = frame;
    customAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:customAccessoryView];
    objc_setAssociatedObject(self, &customAccessoryViewKey, customAccessoryView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)customAccessoryView
{
    return objc_getAssociatedObject(self, &customAccessoryViewKey);
}

@end
