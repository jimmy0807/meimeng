//
//  WillSplitView.h
//  meim
//
//  Created by 刘伟 on 2017/12/19.
//

#import <UIKit/UIKit.h>

@interface WillSplitView : UIView

///模版图片
@property(strong,nonatomic)UIImageView *mobanImageV;

///待画到view上的UIBezierPath
@property(strong,nonatomic)NSArray *bezierpathArr;

-(instancetype)initWithFrame:(CGRect)frame AndBezierPathArr: (NSArray *)bezierpathArr;

@end
