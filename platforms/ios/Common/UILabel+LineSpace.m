//
//  UILabel+LineSpace.m
//  Boss
//
//  Created by lining on 16/6/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "UILabel+LineSpace.h"

@implementation UILabel (LineSpace)

- (void)setText:(NSString *)text lineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;

}

@end
