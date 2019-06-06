//
//  ICColoredLabel.h
//  BetSize
//
//  Created by jimmy on 12-10-31.
//
//

#import <UIKit/UIKit.h>

@interface ICColoredLabel : UILabel
{
    NSMutableAttributedString *resultAttributedString;
}

-(void)setTextWithOutFontAndColor:(NSString *)text;
-(void)setText:(NSString *)text WithFont:(UIFont *)font AndColor:(UIColor *)color;

-(void)setKeyWordTextArray:(NSArray *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor;
-(void)setKeyWordTextString:(NSString *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor;

@end
