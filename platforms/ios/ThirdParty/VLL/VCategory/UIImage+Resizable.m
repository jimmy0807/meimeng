//
//  UIImage+Resizable.m
//  CardBag
//
//  Created by chen yan on 13-9-18.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "UIImage+Resizable.h"

@implementation UIImage (Resizable)

- (UIImage *)imageResizableWithCapInsets:(UIEdgeInsets)insets
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
    {
        return [self stretchableImageWithLeftCapWidth:insets.left topCapHeight:insets.top];
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
    {
        return [self resizableImageWithCapInsets:insets];
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    
    return self;
}

@end
