//
//  SpecialButton.h
//  meim
//
//  Created by 刘伟 on 2017/9/18.
//
//

#import <UIKit/UIKit.h>
@class SpecialButton;
typedef void(^BtnBlock)();
@interface SpecialButton : UIButton

@property(nonatomic,strong)BtnBlock btnBlock;
/**
 *
 */
+(instancetype)initWithTitle:(NSString *)title andRect:(CGRect)rect andCanClick:(BOOL)canClick andBlock:(BtnBlock)btnBlock;
@end
