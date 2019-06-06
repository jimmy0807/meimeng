//
//  MemberBuyCardItemViewController.h
//  Boss
//
//  Created by mac on 15/8/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "MemberPay.h"
#import "ICCommonViewController.h"

@interface MemberBuyCardItemViewController : ICCommonViewController
@property(nonatomic,strong)CDMemberCard *card;
@property(nonatomic,strong)NSArray *itemArray;
@property(nonatomic,strong)NSMutableArray *cardInfoArray;
@property(nonatomic,strong)NSMutableArray *cardTypeArray;
//支付
@property(nonatomic,strong)NSNumber *payAmount;//实付金额
@property(nonatomic,strong)NSNumber *shouldPayAmount;//应付金额
@property(nonatomic,strong)NSNumber *cardAmount;//卡内余额
@property(nonatomic,strong)NSMutableArray *statements;
@property(nonatomic,strong)NSArray *payModes;
//项目／产品
@property(nonatomic,strong)NSMutableArray *cardProjects;

//经理折扣code
@property(nonatomic,strong)NSString *managerCode;
@property(nonatomic,assign)BOOL isNeedManagerCode;
@property(nonatomic,assign)BOOL isPriceUnitChanged;
@end
