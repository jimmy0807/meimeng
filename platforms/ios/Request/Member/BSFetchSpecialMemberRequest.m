//
//  BSFetchSpecialMember.m
//  Boss
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchSpecialMemberRequest.h"

@implementation BSFetchSpecialMemberRequest
 - (id)initWithText:(NSString *)text shopID:(NSNumber *)shopID;
{
    if(self = [super init])
    {
        self.text = text;
        self.shopID = shopID;
    }
    return self;
}
-(BOOL)willStart
{
    [super willStart];
    self.needCompany = true;
    self.tableName = @"born.member";
    self.filter = @[@[@"name",@"like",self.text],@[@"shop_id",@"=",self.shopID]];
    
    self.field = @[@"name",@"shop_id",@"write_date",@"no",@"id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        for(NSDictionary *param in retArray)
        {
            NSNumber *memberID = [param objectForKey:@"id"];
            CDMember *member = [dataManager findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
            if(!member)
            {
                member = [dataManager insertEntity:@"CDMember"];
                member.memberID = memberID;
            }
            member.memberNo = [param stringValueForKey:@"no"];
            member.memberName = [param stringValueForKey:@"name"];
            member.lastUpdate = [param stringValueForKey:@"write_date"];
            
            NSArray *shopArray = [param arrayValueForKey:@"shop_id"];
            if(shopArray.count>0)
            {
                NSNumber *storeNumber = [shopArray objectAtIndex:0];
                CDStore *store = [dataManager findEntity:@"CDStore" withValue:storeNumber forKey:@"storeID"];
                if(!store)
                {
                    store = [dataManager insertEntity:@"CDStore"];
                    store.storeID = storeNumber;
                }
                store.storeName = [shopArray objectAtIndex:1];
                member.store = store;
                member.imageName = [NSString stringWithFormat:@"%@_%@",memberID, member.memberName];
            }
            [dataArray addObject:member];
        }
        [dataManager save:nil];
        [dict setObject:@0 forKey:@"rc"];
        [dict setObject:dataArray forKey:@"data"];
        
        
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchSpecialMemberResponse object:nil userInfo:dict];
}

@end
