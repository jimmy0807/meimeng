//
//  PadOperateSuccessViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/11/25.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

typedef enum kPadOperateSuccessType
{
    kPadPosOperatePaymentSuccess,
    kPadFreeCombinationCreateSuccess,
    kPadGiveGiftCardSuccess
}kPadOperateSuccessType;

@interface PadOperateSuccessViewController : ICCommonViewController

@property (nonatomic, strong) NSNumber *operateID;
@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) CDMemberCard *card;
@property (nonatomic, strong) NSNumber *cardID;
@property (nonatomic, strong) NSNumber *memberID;//防止上一级页面新建导致self.card被清空

- (id)initWithOperateType:(kPadOperateSuccessType *)type detail:(NSString *)detail amount:(CGFloat)amount;

@end
