//
//  ICFloatingMessageView.h
//  BetSize
//
//  Created by jimmy on 12-10-15.
//
//

#import <Foundation/Foundation.h>
#import "ICColoredLabel.h"

@interface ICDefaultFloatingMessageViewObj : UIView
@property(nonatomic, retain)UIColor* default_text_color;
@property(nonatomic)CGFloat default_moving_distance;
@property(nonatomic)CGFloat default_display_time;
@property(nonatomic)CGFloat default_from_height;

InterfaceSharedManager(ICDefaultFloatingMessageViewObj)

@end

@interface ICFloatingMessageView : UIView
{
@private
    BOOL usingColoredLabel;
}

@property(nonatomic,retain)UILabel* messageLabel;

@property(nonatomic,retain)UIColor* color;
@property(nonatomic,assign)CGFloat fromHeight;
@property(nonatomic,assign)CGFloat moveDistance;
@property(nonatomic,assign)CGFloat duration;

+(void)setDefaultTextColor:(UIColor*)color;
+(void)setDefaultDisplayTime:(CGFloat)time;
+(void)setDefaultMovingDistance:(CGFloat)distance;
+(void)setDefaultFromHeight:(CGFloat)height;

-(id)initWithColoredMesasge:(NSString*)msg;
-(id)initWithMesasge:(NSString*)msg;

-(void)show;// 全屏显示
-(void)showInView:(UIView*)view;
-(void)showFromHeight:(CGFloat)height;
-(void)showInView:(UIView*)view fromHeight:(CGFloat)height;

-(void)setKeyWordTextArray:(NSArray *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor;
-(void)setKeyWordTextString:(NSString *)keyWordStr WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor;
    
@end
