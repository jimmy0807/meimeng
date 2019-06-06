//
//  BSProjectRelatedItemRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/5/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectRelatedItemRequest.h"
#import "BSCoreDataManager.h"
@interface BSProjectRelatedItemRequest()
@property (nonatomic,strong)NSString *lastUpdate;
@end
@implementation BSProjectRelatedItemRequest

- (id)initWithLastUpdate
{
    self = [super init];
    if (self)
    {
        self.lastUpdate = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDProjectRelated"];
    }
    
    return self;
}
-(NSMutableArray *)fetchProductIDs
{
    if (!_fetchProductIDs) {
        _fetchProductIDs = [NSMutableArray array];
    }
    return _fetchProductIDs;
}
- (BOOL)willStart
{
    self.tableName = @"product.pack.line";
   
     if (self.lastUpdate.length != 0)
     {
         self.filter = @[@[@"write_date", @">", self.lastUpdate]];
     }
    
   self.field = @[@"id", @"lst_price", @"open_price", @"quantity", @"limited_qty", @"limited_date", @"product_id", @"parent_product_id", @"same_ids", @"create_date", @"write_date",@"same_price_replace",@"same_price_replace_max",@"same_price_replace_min",@"is_show_more",@"limited_qty"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
//        NSArray *relatedArray = [coreDataManager fetchAllProjectRelated];
//        NSMutableArray *oldRelatedArray = [NSMutableArray arrayWithArray:relatedArray];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *relatedID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectRelated *related = [coreDataManager findEntity:@"CDProjectRelated" withValue:relatedID forKey:@"relatedID"];
            if (related)
            {
                
//                [oldRelatedArray removeObject:related];
            }
            else
            {
                related = [coreDataManager insertEntity:@"CDProjectRelated"];
                related.relatedID = relatedID;
            }
            
            related.createDate = [dict stringValueForKey:@"create_date"];
            related.lastUpdate = [dict stringValueForKey:@"write_date"];
            related.productID = [NSNumber numberWithInteger:[[[dict objectForKey:@"product_id"] objectAtIndex:0] integerValue]];
            related.productName = [[dict objectForKey:@"product_id"] objectAtIndex:1];
            related.parentProductID = [NSNumber numberWithInteger:[[[dict objectForKey:@"parent_product_id"] objectAtIndex:0] integerValue]];
            related.parentProductName = [[dict objectForKey:@"parent_product_id"] objectAtIndex:1];
            related.price = [NSNumber numberWithDouble:[[dict objectForKey:@"lst_price"] doubleValue]];
            related.openPrice = [NSNumber numberWithDouble:[[dict objectForKey:@"open_price"] doubleValue]];
            related.quantity = [NSNumber numberWithInteger:[[dict objectForKey:@"quantity"] integerValue]];
            related.isUnlimited = [NSNumber numberWithBool:[[dict objectForKey:@"limited_qty"] boolValue]];
             /*@"same_price_replace",@"same_price_replace_max",@"same_price_replace_min",@"is_show_more",@"limited_qty"*/
            related.same_price_replace_max = [NSNumber numberWithFloat:[[dict objectForKey:@"same_price_replace_max"] integerValue]];
            related.same_price_replace_min = [NSNumber numberWithFloat:[[dict objectForKey:@"same_price_replace_min"] integerValue]];
            related.same_price_replace = [NSNumber numberWithFloat:[[dict objectForKey:@"same_price_replace"] integerValue]];
            related.is_show_more = [NSNumber numberWithBool:[[dict objectForKey:@"is_show_more"] integerValue]];
            related.limited_qty = [NSNumber numberWithBool:[[dict objectForKey:@"limited_qty"] integerValue]];
            related.unlimitedDays = [NSNumber numberWithInteger:[[dict objectForKey:@"limited_date"] integerValue]];
            NSMutableOrderedSet *items = [[NSMutableOrderedSet alloc] init];
            NSArray *sameIds = [dict objectForKey:@"same_ids"];
       
            
            if ([sameIds isKindOfClass:[NSArray class]] && sameIds.count > 0)
            {
                for (int i = 0; i < sameIds.count; i++)
                {
                    NSNumber *itemID = [NSNumber numberWithInteger:[[sameIds objectAtIndex:i] integerValue]];
                    CDProjectItem *item = [coreDataManager findEntity:@"CDProjectItem" withValue:itemID forKey:@"itemID"];
                    if (item)
                    {
                        [items addObject:item];
                    }
                    else
                    {
                        item = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectItem"];
                        item.itemID = itemID;
                    }
                }
            }
            related.sameItems = items;
        }
//        [coreDataManager deleteObjects:oldRelatedArray];
        [coreDataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectRelatedItemResponse object:self userInfo:params];
}

@end
