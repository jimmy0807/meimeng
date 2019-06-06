//
//  BSFetchBookRequest.m
//  Boss
//
//  Created by lining on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchBookRequest.h"
#import "BSFetchRestaurantTableUseRequest.h"

@interface BSFetchBookRequest ()
@property(nonatomic, strong) NSString *lastUpdateTime;
@end

@implementation BSFetchBookRequest

- (BOOL)willStart
{
    [super willStart];

    self.tableName = @"born.reservation";

//    self.filter = @[@[@"state",@"=",@"approved"]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSTimeInterval t = [[NSDate date] timeIntervalSince1970] - 3600.0 * 24 * 30;
    
    NSString* oneMonthAgo = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:t]];
    self.lastUpdateTime = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDBook"];
    if (self.lastUpdateTime)
    {
        self.filter = @[@[@"write_date",@">",self.lastUpdateTime],@[@"shop_id",@"in",[PersonalProfile currentProfile].shopIds]];
    }
    else
    {
        self.filter = @[@[@"shop_id",@"in",[PersonalProfile currentProfile].shopIds],@[@"create_date",@">",[NSString stringWithFormat:@"%@ %@",oneMonthAgo,@"00:00:00"]]];
    }
    
    self.field = @[@"id",@"name",@"member_name",@"telephone",@"source",@"is_visit",@"active",@"aside_time",@"description",@"start_date",@"end_date",@"state",@"write_date",@"technician_id",@"table_id",@"member_id",@"gender",@"email",@"consume_date",@"address",@"company_id",@"shop_id",@"operate_id",@"approve_id",@"approve_date",@"refuse_desc",@"product_id",@"is_reservation_bill",@"doctor_id",@"designers_id",@"designers_service_id",@"director_employee_id",@"employee_id",@"member_type",@"is_partner",@"is_anesthetic",@"is_checked",@"create_uid",@"product_ids",@"recommend_member_phone",@"is_consult_finished"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *books = [dataManager fetchBooksWithLastUpdateTime:self.lastUpdateTime];
        NSMutableArray *oldBooks = [NSMutableArray arrayWithArray:books];
        NSMutableArray *newBooks = [NSMutableArray array];
        for (NSDictionary *params in retArray)
        {
            NSNumber *book_id = [params numberValueForKey:@"id"];
            CDBook *book = [dataManager findEntity:@"CDBook" withValue:book_id forKey:@"book_id"];
            if (book)
            {
                [oldBooks removeObject:book];
            }
            else
            {
                book = [dataManager insertEntity:@"CDBook"];
                
                book.book_id = book_id;
                book.isUsed = [NSNumber numberWithBool:NO];
                
                [newBooks addObject:book];
            }
            
            if ( [[params stringValueForKey:@"state"] isEqualToString:@"refuse"] || [[params stringValueForKey:@"state"] isEqualToString:@"cancel"] )
            {
                [[BSCoreDataManager currentManager] deleteObject:book];
                [newBooks removeObject:book];
            }
            
            book.name = [params stringValueForKey:@"name"];
            book.booker_name = [params stringValueForKey:@"member_name"];
            book.telephone = [params stringValueForKey:@"telephone"];
            book.source = [params stringValueForKey:@"source"];
            book.is_visit = [params numberValueForKey:@"is_visit"];
            book.is_active = [params numberValueForKey:@"active"];
            book.aside_time = [params numberValueForKey:@"aside_time"];
            if ( [[params stringValueForKey:@"description"] isEqualToString:@"0"] )
            {
                book.mark = @"";
            }
            else
            {
                book.mark = [params stringValueForKey:@"description"];
            }
            
            book.start_date = [params stringValueForKey:@"start_date"];
            book.end_date = [params stringValueForKey:@"end_date"];
            book.state = [params stringValueForKey:@"state"];
            book.lastUpdate = [params stringValueForKey:@"write_date"];
            book.technician_id = [params arrayIDValueForKey:@"technician_id"];
            book.technician_name = [params arrayNameValueForKey:@"technician_id"];
            book.room_id = [params arrayIDValueForKey:@"table_id"];
            book.room_name = [params arrayNameValueForKey:@"table_id"];
            
            book.table_id = [params arrayIDValueForKey:@"table_id"];
            book.table_name = [params arrayNameValueForKey:@"table_id"];
            
            book.member_id = [params arrayIDValueForKey:@"member_id"];
            book.member_name = [params arrayNameValueForKey:@"member_id"];
            
            book.gender = [params stringValueForKey:@"gender"];
            book.email = [params stringValueForKey:@"email"];
            book.consume_date = [params stringValueForKey:@"consume_date"];
            book.address = [params stringValueForKey:@"address"];
            
            book.company_id = [params arrayIDValueForKey:@"company_id"];
            book.company_name = [params arrayNameValueForKey:@"company_id"];
            
            book.shop_id = [params arrayIDValueForKey:@"shop_id"];
            book.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            book.operate_id = [params arrayIDValueForKey:@"operate_id"];
            book.operate_name = [params arrayNameValueForKey:@"operate_id"];
            
            book.approve_id = [params arrayIDValueForKey:@"approve_id"];
            book.approve_name = [params arrayNameValueForKey:@"approve_id"];
            book.approve_date = [params stringValueForKey:@"approve_date"];
            book.approve_mark = [params stringValueForKey:@"refuse_desc"];
            
            //book.product_id = [params arrayIDValueForKey:@"product_id"];
            book.product_name = [params arrayNameValueForKey:@"product_id"];
            book.is_reservation_bill = [params numberValueForKey:@"is_reservation_bill"];
            
            
            book.doctor_id = [params arrayIDValueForKey:@"doctor_id"];
            book.doctor_name = [params arrayNameValueForKey:@"doctor_id"];
            book.designers_id = [params arrayIDValueForKey:@"designers_id"];
            book.designers_name = [params arrayNameValueForKey:@"designers_id"];
            book.designers_service_id = [params arrayIDValueForKey:@"designers_service_id"];
            book.designers_service_name = [params arrayNameValueForKey:@"designers_service_id"];
            book.director_employee_id = [params arrayIDValueForKey:@"director_employee_id"];
            book.director_employee_name = [params arrayNameValueForKey:@"director_employee_id"];
            book.employee_id = [params arrayIDValueForKey:@"employee_id"];
            book.employee_name = [params arrayNameValueForKey:@"employee_id"];
            book.member_type = [params stringValueForKey:@"member_type"];
            book.is_partner = [params numberValueForKey:@"is_partner"];
            book.is_anesthetic = [params numberValueForKey:@"is_anesthetic"];
            book.is_checked = [params numberValueForKey:@"is_checked"];
            book.create_uid = [params arrayIDValueForKey:@"create_uid"];
            book.recommend_member_phone = [params stringValueForKey:@"recommend_member_phone"];
            book.is_consult_finished = [params numberValueForKey:@"is_consult_finished"];
            
            NSArray* product_ids = [params arrayValueForKey:@"product_ids"];
#if 0
            if ( [product_ids containsObject:book.product_id] && product_ids.count > 0 )
            {
                book.product_ids = [product_ids componentsJoinedByString:@","];
            }
            else
            {
                if ( [book.product_id integerValue] > 0 )
                {
                    NSMutableArray* a = [NSMutableArray arrayWithArray:product_ids];
                    [a addObject:book.product_id];
                    book.product_ids = [a componentsJoinedByString:@","];
                }
                else
                {
                    if ( product_ids.count > 0 )
                    {
                        book.product_ids = [product_ids componentsJoinedByString:@","];
                    }
                }
            }
#else
            if ( product_ids.count > 0 )
            {
                book.product_ids = [product_ids componentsJoinedByString:@","];
            }
            else
            {
                book.product_ids = @"";
            }
#endif
        }
        
        [dataManager deleteObjects:oldBooks];
        [dataManager save:nil];
        
        if ([PersonalProfile currentProfile].isTable && newBooks.count > 0) {
            BSFetchRestaurantTableUseRequest *reqeust = [[BSFetchRestaurantTableUseRequest alloc] init];
            NSMutableArray *bookIds = [NSMutableArray array];
            for (CDBook *book in newBooks) {
                if (book.book_id) {
                   [bookIds addObject:book.book_id];
                }
            }
            reqeust.bookIds = bookIds;
            [reqeust execute];
            
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFetchBookResponse object:nil userInfo:dict];
        }
    }
    else
    {
        dict = [self generateResponse:@"请求失败,请稍后重试"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchBookResponse object:nil userInfo:dict];
    }
    
    if ( self.sendRefresh )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshBookResponse object:nil userInfo:dict];
    }
}

@end
