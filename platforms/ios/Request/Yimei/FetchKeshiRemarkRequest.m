//
//  FetchKeshiRemarkRequest.m
//  meim
//
//  Created by 波恩公司 on 2018/3/2.
//

#import <Foundation/Foundation.h>

#import "FetchKeshiRemarkRequest.h"

@implementation FetchKeshiRemarkRequest

- (BOOL)willStart
{
    self.tableName = @"born.medical.remarks";
    self.field = @[@"id",@"name"];
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
        NSArray* array = [dataManager fetchKeshiRemark];
        NSMutableArray *oldKeshis = nil;
        if ( array.count > 0 )
        {
            oldKeshis = [NSMutableArray arrayWithArray:array];
        }
        
        for (NSDictionary *params in resultArray)
        {
            NSNumber* remarkID = [params numberValueForKey:@"id"];
            CDKeshiRemarks *k = [dataManager findEntity:@"CDKeshiRemarks" withValue:remarkID forKey:@"remark_id"];
            if ( k )
            {
                [oldKeshis removeObject:k];
            }
            else
            {
                k = [dataManager insertEntity:@"CDKeshiRemarks"];
                k.remark_id = remarkID;
            }
            
            k.remark_name = [params stringValueForKey:@"name"];
        }
        
        [dataManager deleteObjects:oldKeshis];
        [dataManager save:nil];
    }
    else
    {
    }
}

@end
