//
//  BSFetchMenuOperateRequest.m
//  Boss
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "DailyOperateMenu.h"
#import "BSFetchMenuOperateRequest.h"

@implementation BSFetchMenuOperateRequest
- (id)initWithUserID:(NSNumber *)userID
{
    if(self = [super init])
    {
        self.userID = userID;
    }
    return self;
}
-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.card.operate";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    self.filter = @[@[@"shop_id",@"=",storeID],@[@"create_date",@">",[NSString stringWithFormat:@"%@ %@",today,@"00:00:00"]]];
    self.field = @[@"now_amount",@"member_id",@"card_id",@"type",@"create_date",@"create_uid",@"name",@"shop_id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        NSArray* array = [[BSCoreDataManager currentManager] fetchItems:@"CDPassengerFlow"];
        [[BSCoreDataManager currentManager] deleteObjects:array];
        NSMutableArray *menuArray = [[NSMutableArray alloc]init];
        for ( NSDictionary* params in retArray )
        {
            DailyOperateMenu *p = [[DailyOperateMenu alloc]init];
             p.create_date = [params stringValueForKey:@"create_date"];
             p.itemID = [params numberValueForKey:@"id"];
             p.memberName = [params arrayNameValueForKey:@"member_id"];
             p.name = [params stringValueForKey:@"name"];;
             p.operateUser = [params arrayNameValueForKey:@"create_uid"];
             p.shopName = [params arrayNameValueForKey:@"shop_id"];
             p.cardNo = [params arrayNameValueForKey:@"card_id"];
             p.totalAmount = [params stringValueForKey:@"now_amount"];
             p.type = [params stringValueForKey:@"type"];
            [menuArray addObject:p];
        }
        
        [dict setObject:@0 forKey:@"rc"];
        [dict setObject:menuArray forKey:@"data"];
        
    }else{
        dict = [self generateResponse:@"请求发生错误"];
    }
   [[NSNotificationCenter defaultCenter] postNotificationName:kBSDailyOperateMenuResponse object:nil userInfo:dict];
}

@end
