//
//  BossPermissionManager.m
//  Boss
//
//  Created by jimmy on 15/5/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BossPermissionManager.h"
#import "BSFetchPermissionModelRequest.h"


@implementation BossPermissionManager

IMPSharedManager(BossPermissionManager)

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        
    }
    
    return self;
}

-(void)fetchPermission
{
    if (_haveFetchPermission) {
        return;
    }
//    BSFetchPermissionModelRequest *req = [[BSFetchPermissionModelRequest alloc] init];
//    [req execute];
}

- (NSInteger)fetchAccess:(NSString*)item model:(NSString*)model
{
    NSNumber* identity = [PersonalProfile currentProfile].reachItems[item];
    identity = @([item integerValue]);
    CDPermission* permission = [[BSCoreDataManager currentManager] findEntity:@"CDPermission" withPredicateString:[NSString stringWithFormat:@"identity = %@ && model.name = \"%@\"",identity,model]];
    NSInteger access = [permission.access integerValue];
    
    return access;
}

-(BOOL)isReadAccess:(NSString*)item model:(NSString*)model
{
    return [self fetchAccess:item model:model] | BossPermission_Read;
}

-(BOOL)isWriteAccess:(NSString*)item model:(NSString*)model
{
    return [self fetchAccess:item model:model] | BossPermission_Write;
}

-(BOOL)isCreateAccess:(NSString*)item model:(NSString*)model
{
    return [self fetchAccess:item model:model] | BossPermission_Create;
}

-(BOOL)isDeleteAccess:(NSString*)item model:(NSString*)model
{
    return [self fetchAccess:item model:model] | BossPermission_Delete;
}

@end
