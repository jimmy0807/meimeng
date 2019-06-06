//
//  BSFetchCallRecordRequest.m
//  Boss
//
//  Created by lining on 16/5/4.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchCallRecordRequest.h"

@interface BSFetchCallRecordRequest ()
@property (nonatomic, strong) NSNumber *storeID;
@end

@implementation BSFetchCallRecordRequest

- (instancetype)initWithStoreID:(NSNumber *)storeID
{
    self = [super init];
    if (self) {
        self.storeID = storeID;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.call.record";
    self.needCompany = true;
    if (self.storeID) {
        self.needCompany = false;
        self.filter = @[@[@"shop_id",@"=",self.storeID]];
    }
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldRecords = [NSMutableArray arrayWithArray:[dataManager fetchMemberRecordsWithStoreID:self.storeID]];
        for (NSDictionary *params in retArray) {
            NSNumber *record_id = [params numberValueForKey:@"id"];
            CDMemberCallRecord *callRecord = [dataManager findEntity:@"CDMemberCallRecord" withValue:record_id forKey:@"record_id"];
            if (callRecord) {
                [oldRecords removeObject:callRecord];
            }
            else
            {
                callRecord = [dataManager insertEntity:@"CDMemberCallRecord"];
                callRecord.record_id = record_id;
            }
            callRecord.phone = [params stringValueForKey:@"phone"];
            callRecord.is_answer = [params numberValueForKey:@"is_answer"];
            
            callRecord.last_update = [params stringValueForKey:@"__last_update"];
            
            callRecord.member_id = [params arrayIDValueForKey:@"member_id"];
            callRecord.member_name = [params arrayNameValueForKey:@"member_id"];
            
            callRecord.shop_id = [params arrayIDValueForKey:@"shop_id"];
            callRecord.shop_name = [params arrayNameValueForKey:@"shop_id"];
        }
        [dataManager deleteObjects:oldRecords];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败,请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCallRecordResponse object:nil userInfo:dict];
}
@end
