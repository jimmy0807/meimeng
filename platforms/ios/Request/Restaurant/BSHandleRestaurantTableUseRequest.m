//
//  BSHandleRestaurantTableUseRequest.m
//  Boss
//
//  Created by lining on 16/6/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSHandleRestaurantTableUseRequest.h"

@interface BSHandleRestaurantTableUseRequest ()
@property (nonatomic, strong) CDRestaurantTableUse *tableUse;
@property (nonatomic, assign) HandleTableUseType type;
@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation BSHandleRestaurantTableUseRequest

- (instancetype) initWithTableUse:(CDRestaurantTableUse *)tableUse type:(HandleTableUseType)type;
{
    self = [super init];
    if (self ) {
        self.tableUse = tableUse;
        self.type = type;
        self.params = [NSMutableDictionary dictionary];
        self.params[@"name"] = @"新";
        self.params[@"start_time"] = self.tableUse.start_date;
        self.params[@"end_time"] = self.tableUse.end_date;
        self.params[@"table_id"] = self.tableUse.table_id;
        self.params[@"people_num"] = self.tableUse.people_num;
        self.params[@"reservation_id"]= self.tableUse.book.book_id;
        self.params[@"state"] = @"done";
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"restaurant.table.line";
    if (self.type == HandleTableUseType_create) {
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == HandleTableUseType_edit)
    {
        [self sendShopAssistantXmlCreateCommand:@[@[self.tableUse.use_id],self.params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    
     NSNumber *bookId = nil;
    if ( [retArray isKindOfClass:[NSNumber class]]) {
        self.tableUse.use_id = (NSNumber *)retArray;
        bookId = self.tableUse.book.book_id;
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
        [[BSCoreDataManager currentManager] rollback];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCreateBookResponse object:bookId userInfo:dict];
}

@end
