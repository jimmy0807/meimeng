//
//  BSProjectItemUpdateAvailableRequest.m
//  meim
//
//  Created by 波恩公司 on 2018/5/17.
//

#import "BSProjectItemUpdateAvailableRequest.h"
#import "BSCoreDataManager.h"
#import "BSProjectItemIDRequest.h"
#import "ChineseToPinyin.h"

@interface BSProjectItemUpdateAvailableRequest ()

@property (nonatomic, strong) NSString *lastUpdate;

@end


@implementation BSProjectItemUpdateAvailableRequest


- (BOOL)willStart
{
    self.tableName = @"product.product";
    
    NSMutableArray* shopids = [NSMutableArray arrayWithObject:@(0)];
    if ( [PersonalProfile currentProfile].shopIds.count > 0 )
    {
        [shopids addObjectsFromArray:[PersonalProfile currentProfile].shopIds];
    }
    
    //self.filter = @[@"|", @[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]]];
    
    if (self.fetchProductIDs.count > 0) {
        //self.filter = @[@"&",@"|",@[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]], @[@"id", @"in", self.fetchProductIDs]];
        self.filter = @[@[@"id", @"in", self.fetchProductIDs], @[@"shop_id",@"in",shopids]];
        
    }
    self.field = @[@"id", @"qty_available"];
    
    //self.timeOut = 600;
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectItemUpdateAvailableResponse" object:self userInfo:params];
    
    //    [BSCoreDataManager performBlockOnWriteQueue:^{
    //        [self doInThread:resultList];
    //    }];
    [self doInThread:resultList];
}

- (void)doInThread:(NSArray *)resultList
{
    if (resultStr.length != 0 && resultList != nil)
    {
        PersonalProfile *userinfo = [PersonalProfile currentProfile];
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *items = [NSArray array];
        NSMutableArray *oldItems = [NSMutableArray arrayWithArray:items];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *itemID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectItem *item = [coreDataManager findEntity:@"CDProjectItem" withValue:itemID forKey:@"itemID"];
            item.inHandAmount = [NSNumber numberWithDouble:[[dict objectForKey:@"qty_available"] doubleValue]];
        }
        [[BSCoreDataManager currentManager] save:nil];
    }
}

@end

