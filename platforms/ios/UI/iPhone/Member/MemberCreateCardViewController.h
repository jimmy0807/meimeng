//
//  MemberCreateCardViewController.h
//  Boss
//  //开卡界面
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "BSEditCell.h"
#import "ICCommonViewController.h"
NS_ENUM(int, CardOperate)
{
    CardOperateCreate = 0,
    CardOperateRecharge = 1,
};
@interface MemberCreateCardViewController : ICCommonViewController
@property(nonatomic,strong)NSMutableArray *cardInfoArray;
@property(nonatomic,strong)NSMutableArray *cardTypeArray;
@property(nonatomic,strong)NSIndexPath *selectIndexPath;

@property(nonatomic,strong)NSMutableDictionary *selectList;

@property(nonatomic,retain)NSString *randomString;

@property(nonatomic,strong)NSNumber *memberID;
@property(nonatomic,assign)enum CardOperate operateType;
@property(nonatomic,assign)CDMemberCard *card;//充值时传的会员卡信息

@property(nonatomic,strong)NSArray *payModes;
@property(nonatomic,strong)NSNumber *payAmount;
@property(nonatomic,strong)NSMutableArray *statements;//

@property(nonatomic,strong)CDMemberPriceList *priceList;//开卡时选取的折扣方案
@property(nonatomic,strong)NSNumber *give_money;//赠送金额

@property(nonatomic,strong)NSNumber *needMoney;//本次欠款金额
@property(nonatomic,assign)BOOL isFromCreateMember;
@end
