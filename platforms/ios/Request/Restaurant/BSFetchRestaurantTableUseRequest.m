//
//  BSFetchRestaurantTableUseRequest.m
//  Boss
//
//  Created by lining on 16/6/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchRestaurantTableUseRequest.h"

@implementation BSFetchRestaurantTableUseRequest
- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"restaurant.table.line";
    if (self.bookIds) {
        self.filter = @[@[@"reservation_id",@"in",self.bookIds]];
    }
    
    [self sendShopAssistantXmlSearchReadCommand];
//    [self cancel];
    return true;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict;
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldTableUses = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchRestaurantTableUseWithBookIds:self.bookIds]];
        for (NSDictionary *params in retArray) {
           
            NSNumber *use_id = [params numberValueForKey:@"id"];
            
            CDRestaurantTableUse *tableUse = [dataManager findEntity:@"CDRestaurantTableUse" withValue:use_id forKey:@"use_id"];
            if (tableUse) {
                [oldTableUses removeObject:tableUse];
            }
            else
            {
                tableUse = [dataManager insertEntity:@"CDRestaurantTableUse"];
                tableUse.use_id = use_id;
            }
            tableUse.table_id = [params arrayIDValueForKey:@"table_id"];
            tableUse.table_name = [params arrayNameValueForKey:@"table_name"];
            tableUse.state = [params stringValueForKey:@"state"];
            
            tableUse.start_date = [params stringValueForKey:@"start_date"];
            tableUse.end_date = [params stringValueForKey:@"end_date"];
            tableUse.people_num = [params numberValueForKey:@"people_num"];
            
            NSNumber *book_id = [params arrayIDValueForKey:@"reservation_id"];
            CDBook *book = [dataManager uniqueEntityForName:@"CDBook" withValue:book_id forKey:@"book_id"];
            tableUse.book = book;
            book.table_id = tableUse.table_id;
            book.table_name = tableUse.table_name;
            book.people_num = tableUse.people_num;
        }
        
        [[BSCoreDataManager currentManager] deleteObjects:oldTableUses];
    }
    else
    {
        dict = [self generateResponse:@"请求失败"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchBookResponse object:nil userInfo:dict];
}

@end
