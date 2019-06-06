//
//  UILabel+ColorFont.m
//  Boss
//
//  Created by lining on 16/8/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "UILabel+ColorFont.h"

@implementation UILabel (ColorFont)
- (void)setAttributeString:(NSString *)string colorString:(NSString *)colorString color:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange colorRange = [string rangeOfString:colorString ];

    if (color) {
        [attributeString addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    }
    
    if (font) {
        [attributeString addAttribute:NSFontAttributeName value:font range:colorRange];
    }
    self.attributedText = attributeString;
    
}

- (void)setAttributeString:(NSString *)string colorStrings:(NSArray *)colorStrings colors:(NSArray *)colors fonts:(NSArray *)fonts
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    
    if (colorStrings.count > 0) {
        for (int i = 0; i < colorStrings.count; i++) {
            NSString *colorString = [colorStrings objectAtIndex:i];
            NSRange colorRange = [string rangeOfString:colorString ];
            if (i < colors.count) {
                UIColor *color = [colors objectAtIndex:i];
                [attributeString addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
            }
            if (i < fonts.count) {
                UIFont *font = [fonts objectAtIndex:i];
                [attributeString addAttribute:NSFontAttributeName value:font range:colorRange];
            }
        }
    }
    self.attributedText = attributeString;
}
@end
