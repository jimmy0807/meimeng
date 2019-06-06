//
//  PadHandWriteBookVC.h
//  meim
//
//  Created by 刘伟 on 2017/11/10.
//

#import <UIKit/UIKit.h>
#import "ICCommonViewController.h"
@class FirstStepView;
@class SecondStepView;
@class ThirdStepView;
@class FourStepView;
@class SevenStepView;

@interface PadHandWriteBookVC : ICCommonViewController

@property(nonatomic,strong)FirstStepView *firstStepView;
@property(nonatomic,strong)SecondStepView *secondStepView;
@property(nonatomic,strong)ThirdStepView *thirdStepView;
@property(nonatomic,strong)FourStepView *fourStepView;
@property(nonatomic,strong)SevenStepView *sevenStepView;

@property(nonatomic,strong)UILabel *currentDevice;
@property(nonatomic,strong)UILabel *connectedDevice;


@end
