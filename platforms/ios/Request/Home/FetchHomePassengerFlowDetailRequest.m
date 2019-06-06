//
//  FetchHomePassengerFlowDetailRequest.m
//  Boss
//
//  Created by jimmy on 15/7/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomePassengerFlowDetailRequest.h"
#import "HomeCountData.h"

@implementation FetchHomePassengerFlowDetailRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.card.operate";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    self.filter = @[@[@"shop_id",@"=",storeID],@[@"create_date",@">=",[NSString stringWithFormat:@"%@ %@",today,@"00:00:00"]],@[@"create_date",@"<=",[NSString stringWithFormat:@"%@ %@",today,@"23:59:59"]],@[@"id",@">",@(1)]];
    self.field = @[@"now_amount",@"member_id",@"card_id",@"type",@"create_date",@"create_uid",@"name",@"shop_id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        HomeCountData* homeData = [HomeCountData currentData];
        homeData.passengerFlowDate = [homeData getToday];
        homeData.totalpassengerFlow = [NSString stringWithFormat:@"%d",retArray.count];
        [homeData save];
        
        NSArray* array = [[BSCoreDataManager currentManager] fetchItems:@"CDPassengerFlow"];
        [[BSCoreDataManager currentManager] deleteObjects:array];
        
        for ( NSDictionary* params in retArray )
        {
            CDPassengerFlow* p = [[BSCoreDataManager currentManager] insertEntity:@"CDPassengerFlow"];
            p.create_date = [params stringValueForKey:@"create_date"];
            p.itemID = [params numberValueForKey:@"id"];
            p.memberName = [params arrayNameValueForKey:@"member_id"];
            p.name = [params stringValueForKey:@"name"];;
            p.operateUser = [params arrayNameValueForKey:@"create_uid"];
            p.shopName = [params arrayNameValueForKey:@"shop_id"];
            p.cardNo = [params arrayNameValueForKey:@"card_id"];
            p.totalAmount = [params stringValueForKey:@"now_amount"];
            p.type = [params stringValueForKey:@"type"];
            p.today = homeData.passengerFlowDate;
        }
        
        [[BSCoreDataManager currentManager] save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomePassengerFlowDetailResponse object:nil userInfo:nil];
    }
}

@end
