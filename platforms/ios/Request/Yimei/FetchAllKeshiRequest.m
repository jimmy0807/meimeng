//
//  FetchAllKeshiRequest.m
//  ds
//
//  Created by jimmy on 16/10/25.
//
//

#import "FetchAllKeshiRequest.h"
#import "FetchKeshiRemarkRequest.h"

@implementation FetchAllKeshiRequest

- (BOOL)willStart
{
    self.tableName = @"born.departments";
    self.field = @[@"display_name",@"id",@"parent_id", @"hr_doctor_id", @"hr_doctor_ids", @"hr_operate_ids",@"is_display_adviser",@"is_display_designer",@"remark_ids"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray* array = [dataManager fetchALLKeshi];
        NSMutableArray *oldKeshis = nil;
        if ( array.count > 0 )
        {
            oldKeshis = [NSMutableArray arrayWithArray:array];
        }

        for (NSDictionary *params in resultArray)
        {
            NSNumber* keshiID = [params numberValueForKey:@"id"];
            CDKeShi *k = [dataManager findEntity:@"CDKeShi" withValue:keshiID forKey:@"keshi_id"];
            if ( k )
            {
                [oldKeshis removeObject:k];
            }
            else
            {
                k = [dataManager insertEntity:@"CDKeShi"];
                k.keshi_id = keshiID;
            }
            
            k.name = [params stringValueForKey:@"display_name"];
            k.parentID = [params arrayNotNullIDValueForKey:@"parent_id"];
            k.doctor_id = [params arrayNotNullIDValueForKey:@"hr_doctor_id"];
            k.doctor_name = [params arrayNameValueForKey:@"hr_doctor_id"];
            k.is_display_adviser = [params numberValueForKey:@"is_display_adviser"];
            k.is_display_designer = [params numberValueForKey:@"is_display_designer"];
            
            NSArray* remark_ids = [params arrayValueForKey:@"remark_ids"];
            if ( remark_ids.count > 0 )
            {
                k.remark_ids = [remark_ids componentsJoinedByString:@","];
            }
            else
            {
                k.remark_ids = @"";
            }
            
            NSArray* hr_doctor_ids = [params arrayValueForKey:@"hr_doctor_ids"];
            for ( NSNumber* hrID in hr_doctor_ids )
            {
                CDStaff* staff = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDStaff" withValue:hrID forKey:@"staffID"];
                [staff addKeshiObject:k];
            }
            
            NSArray* hr_operate_ids = [params arrayValueForKey:@"hr_operate_ids"];
            for ( NSNumber* hrID in hr_operate_ids )
            {
                CDStaff* staff = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDStaff" withValue:hrID forKey:@"staffID"];
                [staff addKeshi_operateObject:k];
            }
        }
        
        [dataManager deleteObjects:oldKeshis];
        [dataManager save:nil];
    }
    else
    {
    }
    [[[FetchKeshiRemarkRequest alloc] init] execute];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchKeshiResponse object:nil userInfo:dict];
}

@end
