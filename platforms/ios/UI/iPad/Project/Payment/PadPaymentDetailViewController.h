//
//  PadPaymentDetailViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/11/3.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

typedef enum kPadPaymentDetailType
{
    kPadPaymentDetailCreate     = 0,
    kPadPaymentDetailRecharge   = 1,
    kPadPaymentDetailRepayment  = 2,
    kPadPaymentDetailPayment    = 3
}kPadPaymentDetailType;

@protocol PadPaymentDetailViewControllerDelegate <NSObject>

- (void)didPaymentDetailEditFinish;

@end

@interface PadPaymentDetailViewController : ICCommonViewController

@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, assign) id<PadPaymentDetailViewControllerDelegate> delegate;

- (id)initWithPayments:(NSMutableArray *)payments index:(NSInteger)index totalAmount:(CGFloat)totalAmount;
- (id)initWithPayments:(NSMutableArray *)payments index:(NSInteger)index operateType:(kPadPaymentDetailType)type;

@end
