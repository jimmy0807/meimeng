//
//  UINavigationBarBackground.m
//  yunio
//
//  Created by Vincent Xiao on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+Background.h"
#import <objc/runtime.h>

static  IMP originalMethodOfdrawRect;

@implementation UINavigationBar (UINavigationBarBackground)

- (void)customizedDrawRect:(CGRect)rect 
{
    UIImage *image = [UIImage imageNamed:IS_SDK7?@"commom_navi_bk_IOS7.png":@"commom_navi_bk.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];    
}

-(void)setCustomizedNaviBar:(BOOL)customized
{
    if (originalMethodOfdrawRect == nil) 
    {
        originalMethodOfdrawRect = [self methodForSelector:@selector(drawRect:)];
    }
    if (customized) 
    {
        if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            if ( [self respondsToSelector:@selector(setShadowImage:)] )
            {
                [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
            }

            [self setBackgroundImage:[UIImage imageNamed:IS_SDK7?@"commom_navi_bk_IOS7.png":@"commom_navi_bk.png"] forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
        
            class_replaceMethod([self class], @selector(drawRect:), [self methodForSelector: @selector(customizedDrawRect:)], nil);
        }
    }
    else
    {
        if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            class_replaceMethod([self class], @selector(drawRect:), originalMethodOfdrawRect, nil); 
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
}

@end
