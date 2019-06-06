//
//  UINavigationItem+Custom.h
//  Spark2
//
//  Created by jimmy on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UINavigationItem;

@protocol CustomNavigationItemDelegate <NSObject>

@optional
- (void)didNavigationTitleClicked;
@end

@interface UINavigationItem (Custom)

-(void)setDelegate:(id<CustomNavigationItemDelegate>)delegate;
-(void)setTitle:(NSString *)title withColor:(UIColor*)color;
-(void)setTitle:(NSString *)title withColor:(UIColor *)color shadowOffset: (CGSize)shadowOffset shadowColor: (UIColor *)shadowColor;

// for paintingTycoon
-(void)setPTTitle:(NSString *)title;

@end
