//
//  BSFetchPermissionRequest.m
//  Boss
//
//  Created by jimmy on 15/5/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchPermissionRequest.h"
#import "BossPermissionManager.h"

@implementation BSFetchPermissionRequest

- (BOOL)willStart
{
    [super willStart];
    
//    NSString *lastTime = [[BSCoreDataManager currentManager] fetchPermissionLastUpdateTime];
//    if (lastTime) {
//        self.filter = @[@"__last_update",@">",lastTime];
//    }
    self.filter = @[];
    self.field =  @[@"active",@"name",@"perm_create",@"perm_read",@"perm_unlink",@"perm_write",@"group_id",@"model_id"];
    self.tableName = @"ir.model.access";
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)doInThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithBool:YES] forKey:@"rc"];
    
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        [BossPermissionManager sharedManager].haveFetchPermission = true;
        
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *permissions = [dataManager fetchAllPermissions];
        NSMutableArray *oldPermisssions = [NSMutableArray arrayWithArray:permissions];
        
        for (NSDictionary *params in resultArray)
        {
            NSNumber *permissionID = [params numberValueForKey:@"id"];
            CDPermission *permission = [dataManager findEntity:@"CDPermission" withValue:permissionID forKey:@"permissionID"];
            if (permission) {
                [oldPermisssions removeObject:permission];
            }
            else
            {
                permission = [dataManager insertEntity:@"CDPermission"];
                permission.permissionID = permissionID;
            }
            
            //            permission.last_time = [params stringValueForKey:@"__last_update"];
            NSNumber *active = [params numberValueForKey:@"active"];
            NSInteger access = 0;
            if ([active integerValue] == 1) {
                if ([[params numberValueForKey:@"perm_create"] integerValue] == 1) {
                    access = BossPermission_Create;
                }
                else if ([[params numberValueForKey:@"perm_read"] integerValue] == 1)
                {
                    access = access|BossPermission_Read;
                }
                else if ([[params numberValueForKey:@"perm_unlink"] integerValue] == 1)
                {
                    access = access|BossPermission_Delete;
                }
                else if ([[params numberValueForKey:@"perm_write"] integerValue] == 1)
                {
                    access = access|BossPermission_Write;
                }
            }
            permission.access = [NSNumber numberWithInteger:access];
            
            NSArray *groups = [params arrayValueForKey:@"group_id"];
            if (groups.count > 0) {
                permission.identity = [groups objectAtIndex:0];
            }
            
            NSArray *models = [params arrayValueForKey:@"model_id"];
            if (models.count > 0) {
                NSNumber *modelId = [models objectAtIndex:0];
                CDPermissionModel *model = [dataManager findEntity:@"CDPermissionModel" withValue:modelId forKey:@"modelID"];
                if (!model) {
                    NSLog(@"!!!!!!!!!! Assert !!!!!!!! can't find Permission Model");
                    model = [dataManager insertEntity:@"CDPermissionModel"];
                    model.modelID = modelId;
                }
                permission.model = model;
            }
        }
        
        [dataManager deleteObjects:oldPermisssions];
        [dataManager save:nil];
        [dict setValue:@0 forKey:@"rc"];
    }
    else
    {
        [dict setValue:@-1 forKey:@"rc"];
        [dict setValue:@"请求发生错误" forKey:@"rm"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPermissionRequest object:nil userInfo:dict];
}

- (void)didFinishOnMainThread
{
    [BSCoreDataManager performBlockOnWriteQueue:^{
        [self doInThread];
    }];
}

@end
