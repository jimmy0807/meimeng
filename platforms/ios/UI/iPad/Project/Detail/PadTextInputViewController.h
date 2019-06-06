//
//  PadTextInputViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/27.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

typedef enum kPadTextInputType
{
    kPadTextInputHandNum,
    kPadTextInputCouponNum,
    kPadTextInputRestaurant,
    kPadTextInputBookedRestaurant
}kPadTextInputType;

@protocol PadTextInputViewControllerDelegate <NSObject>
- (void)didTextInputFinishedWithType:(kPadTextInputType)type inputText:(NSString *)inputText;
@optional
- (void)didTextInputFinishedWithType:(kPadTextInputType)type inputText:(NSString *)inputText memberCard:(CDMemberCard*)memberCard couponCard:(CDCouponCard*)couponCard;
@end

@interface PadTextInputViewController : ICCommonViewController

@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, assign) id<PadTextInputViewControllerDelegate> delegate;
@property (nonatomic, strong)CDMemberCard* memberCard;
@property (nonatomic, strong)CDCouponCard* couponCard;

- (id)initWithType:(kPadTextInputType)inputType;

@end
