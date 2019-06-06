//
//  MemberPay.h
//  Boss
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberPay : NSObject
@property(nonatomic,strong)NSNumber *payID;
@property(nonatomic,strong)NSString *payMoney;
@property(nonatomic,strong)NSString *payName;
-(NSString *)payMoney;
@end
