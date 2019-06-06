//
//  PadWxGiveSuccessViewController.h
//  Boss
//
//  Created by jimmy on 16/6/2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PadWxGiveSuccessType
{
    PadWxGiveSuccessType_BornGiftCard,
    PadWxGiveSuccessType_WxGiftCard,
    PadWxGiveSuccessType_WxPhoneNumber
}PadWxGiveSuccessType;

@interface PadWxGiveSuccessViewController : ICCommonViewController

@property(nonatomic, strong)NSArray* wxCardTemplates;
@property(nonatomic)PadWxGiveSuccessType successType;
@property(nonatomic, strong)NSString* wxQrCodeUrl;

@end
