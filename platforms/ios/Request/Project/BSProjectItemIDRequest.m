//
//  BSProjectItemIDRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/9/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSProjectItemIDRequest.h"
#import "BSCoreDataManager.h"

@interface BSProjectItemIDRequest ()

@end


@implementation BSProjectItemIDRequest

- (BOOL)willStart
{
    NSMutableArray* shopids = [NSMutableArray arrayWithObject:@(0)];
    if ( [PersonalProfile currentProfile].shopIds.count > 0 )
    {
        [shopids addObjectsFromArray:[PersonalProfile currentProfile].shopIds];
    }
    
    self.tableName = @"product.product";
    self.filter = @[@[@"shop_id",@"in",shopids]];
    //self.filter = @[@"|", @[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]]];
    self.field = @[@"id"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
        [self doInThread:resultList];
#if 0
        [BSCoreDataManager performBlockOnWriteQueue:^{
            
        }];
#endif
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectItemIDResponse object:self userInfo:params];
    
    
}

- (void)doInThread:(NSArray *)resultList
{
    if (resultStr.length != 0 && resultList != nil)
    {
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *items = [coreDataManager fetchAllProjectItem];
        NSMutableArray *oldItems = [NSMutableArray arrayWithArray:items];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *itemID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectItem *item = [coreDataManager findEntity:@"CDProjectItem" withValue:itemID forKey:@"itemID"];
            if (item)
            {
                [oldItems removeObject:item];
            }
        }
        [coreDataManager deleteObjects:oldItems];
        [coreDataManager save:nil];
    }
}

@end
