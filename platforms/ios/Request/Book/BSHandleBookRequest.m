//
//  BSHandleBookRequest.m
//  Boss
//
//  Created by lining on 15/12/16.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSHandleBookRequest.h"
#import "BSHandleRestaurantTableUseRequest.h"
#import "BSFetchBookRequest.h"
#import "BSFetchMemberRequest.h"

@interface BSHandleBookRequest ()
@property(strong, nonatomic) CDBook *book;
@end

@implementation BSHandleBookRequest
- (instancetype)initWithCDBook:(CDBook *)book
{
    self = [super init];
    if (self) {
        self.book = book;
        
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.reservation";
    if (self.type == HandleBookType_create)
    {
        self.book.state = @"approved";
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == HandleBookType_edit)
    {
        [self sendRpcXmlStyle:@"write" params:@[@[self.book.book_id],self.params]];
    }
    else if (self.type == HandleBookType_delete)
    {
        [self sendRpcXmlStyle:@"write" params:@[@[self.book.book_id],@{@"state":@"cancel"}]];
    }
    else if (self.type == HandleBookType_approved)
    {
        [self sendRpcXmlStyle:@"write" params:@[@[self.book.book_id],@{@"state":@"approved"}]];
    }
    else if (self.type == HandleBookType_billed)
    {
        [self sendRpcXmlStyle:@"write" params:@[@[self.book.book_id],@{@"state":@"billed"}]];
    }
    
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSNumber *bookId = nil;
    if (self.type == HandleBookType_create)
    {
        if ([retArray isKindOfClass:[NSNumber class]])
        {
            bookId = (NSNumber *)retArray;
            self.book.book_id = (NSNumber *)retArray;
            self.book.isUsed = [NSNumber numberWithBool:NO];
            
            if ([PersonalProfile currentProfile].isTable.boolValue || self.book.table_id.integerValue > 0) {
                CDRestaurantTableUse *tableUse = [[BSCoreDataManager currentManager] insertEntity:@"CDRestaurantTableUse"];
                tableUse.table_id = self.book.table_id;
                tableUse.table_name = self.book.table_name;
                tableUse.people_num = self.book.people_num;
                tableUse.start_date = self.book.start_date;
                tableUse.end_date = self.book.end_date;
                tableUse.state = self.book.state;
                tableUse.book = self.book;
                BSHandleRestaurantTableUseRequest *handleRequest = [[BSHandleRestaurantTableUseRequest alloc] initWithTableUse:tableUse type:HandleBookType_create];
                [handleRequest execute];
            
                //return;
            }
            
            BSFetchBookRequest *reqeust = [[BSFetchBookRequest alloc] init];
            reqeust.sendRefresh = YES;
            [reqeust execute];
            
            [[[BSFetchMemberRequest alloc] init] execute];
        }
        else
        {
            dict = [self generateResponse:@"预约创建失败"];
            [[BSCoreDataManager currentManager] deleteObject:self.book];

        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSCreateBookResponse object:bookId userInfo:dict];
        [[BSCoreDataManager currentManager] save:nil];
        
        
    }
    else if (self.type == HandleBookType_edit)
    {
        if ([retArray isKindOfClass:[NSNumber class]])
        {
            bookId = self.book.book_id;
            
            if ([PersonalProfile currentProfile].isTable.boolValue) {
                CDRestaurantTableUse *tableUse = self.book.tableUse;
                tableUse.table_id = self.book.table_id;
                tableUse.table_name = self.book.table_name;
                tableUse.people_num = self.book.people_num;
                tableUse.start_date = self.book.start_date;
                tableUse.end_date = self.book.end_date;
                tableUse.book = self.book;
                BSHandleRestaurantTableUseRequest *handleRequest = [[BSHandleRestaurantTableUseRequest alloc] initWithTableUse:tableUse type:HandleBookType_edit];
                [handleRequest execute];
                
                return;
            }
            
        }
        else
        {
            dict = [self generateResponse:@"预约编辑失败"];
            [[BSCoreDataManager currentManager] rollback];
        }
        [[BSCoreDataManager currentManager] save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSEditBookResponse object:bookId userInfo:dict];
    }
    else if (self.type == HandleBookType_delete)
    {
        if ([retArray isKindOfClass:[NSNumber class]] && !self.book.isDeleted )
        {
            [[BSCoreDataManager currentManager] deleteObject:self.book];
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"预约删除失败"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSDeleteBookResponse object:bookId userInfo:dict];
    }
    else if (self.type == HandleBookType_approved)
    {
        self.book.state = @"approved";
        self.book.isUsed = @(FALSE);
        [[BSCoreDataManager currentManager] save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSEditBookResponse object:bookId userInfo:dict];
    }
    else if (self.type == HandleBookType_billed)
    {
        self.book.state = @"billed";
        self.book.isUsed = @(TRUE);
        [[BSCoreDataManager currentManager] save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSEditBookResponse object:bookId userInfo:dict];
    }
}

@end
