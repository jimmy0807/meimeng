//
//  UILabel+ColorFont.h
//  Boss
//
//  Created by lining on 16/8/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ColorFont)
- (void)setAttributeString:(NSString *)string colorString:(NSString *)colorString color:(UIColor *)color font:(UIFont *)font;

- (void)setAttributeString:(NSString *)string colorStrings:(NSArray *)colorStrings colors:(NSArray *)colors fonts:(NSArray *)fonts;
@end
