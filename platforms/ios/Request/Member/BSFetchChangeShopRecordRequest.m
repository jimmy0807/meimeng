//
//  BSFetchChangeShopRecordRequest.m
//  Boss
//
//  Created by lining on 16/5/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchChangeShopRecordRequest.h"

@interface BSFetchChangeShopRecordRequest ()
@property (nonatomic, strong) CDMember *member;
@end

@implementation BSFetchChangeShopRecordRequest

- (instancetype)initWithMember:(CDMember *)member
{
    self = [super init];
    if (self) {
        self.member = member;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.shop.record";
    self.filter = @[@[@"member_id",@"=",self.member.memberID]];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldRecords = [NSMutableArray arrayWithArray:[dataManager fetchChangeShopRecordsWithMember:self.member]];
        for (NSDictionary *params in retArray) {
            NSNumber *record_id = [params numberValueForKey:@"id"];
            CDMemberChangeShop *shopRecord = [dataManager findEntity:@"CDMemberChangeShop" withValue:record_id forKey:@"record_id"];
            if (shopRecord) {
                [oldRecords removeObject:shopRecord];
            }
            else
            {
                shopRecord = [dataManager insertEntity:@"CDMemberChangeShop"];
                shopRecord.record_id = record_id;
            }
            
            shopRecord.is_change_member_shop = [params numberValueForKey:@"is_change_member_shop"];
            shopRecord.member_id = [params arrayIDValueForKey:@"member_id"];
            shopRecord.member_name = [params arrayNameValueForKey:@"member_id"];
            
            shopRecord.member_shop_id = [params arrayIDValueForKey:@"member_shop_id"];
            shopRecord.member_shop_name = [params arrayNameValueForKey:@"member_shop_id"];
            
            shopRecord.card_id = [params arrayIDValueForKey:@"card_id"];
            shopRecord.card_name = [params arrayNameValueForKey:@"card_id"];
            
            shopRecord.card_shop_id = [params arrayIDValueForKey:@"card_shop_id"];
            shopRecord.card_shop_name = [params arrayNameValueForKey:@"card_shop_id"];
            
            shopRecord.create_date = [params stringValueForKey:@"create_date"];
            
            shopRecord.create_uid_id = [params arrayIDValueForKey:@"create_uid"];
            shopRecord.create_uid_name = [params arrayNameValueForKey:@"create_uid"];
            
            shopRecord.shop_id = [params arrayIDValueForKey:@"shop_id"];
            shopRecord.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            shopRecord.now_member_shop_id = [params arrayIDValueForKey:@"new_member_shop_id"];
            shopRecord.now_member_shop_name = [params arrayNameValueForKey:@"new_member_shop_id"];
            
            shopRecord.now_card_shop_id = [params arrayIDValueForKey:@"new_card_shop_id"];
            shopRecord.now_card_shop_name = [params arrayNameValueForKey:@"new_card_shop_id"];
            
            shopRecord.member = self.member;
        }
        [dataManager deleteObjects:oldRecords];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败,请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberChangeShopResponse object:nil userInfo:dict];
    
}

@end
