//
//  BSGiveRequest.h
//  Boss
//  不再使用
//  Created by lining on 15/11/23.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"
#import "CouponObject.h"

typedef enum GiveType
{
    GiveType_ticket = 2,
    GiveType_card,
    
}GiveType;

@interface BSGiveRequest : ICRequest
@property (strong, nonatomic) NSArray *items;
- (instancetype) initWithOperate:(CDPosOperate *)operate coupon:(CouponObject *)coupon;
@end
