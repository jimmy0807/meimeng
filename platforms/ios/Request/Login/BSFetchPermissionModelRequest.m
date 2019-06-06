//
//  BSFetchPermissionModelRequest.m
//  Boss
//
//  Created by jimmy on 15/5/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchPermissionModelRequest.h"
#import "BSFetchPermissionRequest.h"

@implementation BSFetchPermissionModelRequest

- (BOOL)willStart
{
    [super willStart];
//    NSString *lastTime = [[BSCoreDataManager currentManager] fetchPermissionModelLastUpdateTime];
//    if (lastTime) {
//        self.filter = @[@[@"__last_update",@">",lastTime]];
//    }
    self.filter = @[];
    self.field =  @[@"id",@"model"];
    self.tableName = @"ir.model";
    
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)doInThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *models = [dataManager fetchAllPermissionModels];
        NSMutableArray *oldModels = [NSMutableArray arrayWithArray:models];
        
        for (NSDictionary *params in resultArray)
        {
            NSNumber *modelID = [params numberValueForKey:@"id"];
            CDPermissionModel *model = [dataManager findEntity:@"CDPermissionModel" withValue:modelID forKey:@"modelID"];
            if (model) {
                [oldModels removeObject:model];
            }
            else
            {
                model = [dataManager insertEntity:@"CDPermissionModel"];
                model.modelID = modelID;
            }
            model.name = [params stringValueForKey:@"model"];
        }
        [dataManager deleteObjects:oldModels];
        [dataManager save:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BSFetchPermissionRequest *req = [[BSFetchPermissionRequest alloc] init];
            [req execute];
        });
    }
}

- (void)didFinishOnMainThread
{
    [BSCoreDataManager performBlockOnWriteQueue:^{
        [self doInThread];
    }];
}

@end
