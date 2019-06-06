//
//  BSProjectTemplateIDRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/9/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSProjectTemplateIDRequest.h"
#import "BSCoreDataManager.h"
#import "BSProjectItemRequest.h"


@interface BSProjectTemplateIDRequest ()

@end


@implementation BSProjectTemplateIDRequest

- (BOOL)willStart
{
    NSMutableArray* shopids = [NSMutableArray arrayWithObject:@(0)];
    if ( [PersonalProfile currentProfile].shopIds.count > 0 )
    {
        [shopids addObjectsFromArray:[PersonalProfile currentProfile].shopIds];
    }
    
    self.tableName = @"product.template";
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
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *templates = [coreDataManager fetchAllProjectTemplate];
        NSMutableArray *oldTemplates = [NSMutableArray arrayWithArray:templates];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *templateID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectTemplate *template = [coreDataManager findEntity:@"CDProjectTemplate" withValue:templateID forKey:@"templateID"];
            if (template)
            {
                [oldTemplates removeObject:template];
            }
        }
        [coreDataManager deleteObjects:oldTemplates];
        [coreDataManager save:nil];
        
        BSProjectItemRequest *request = [[BSProjectItemRequest alloc] initWithLastUpdate];
        request.fetchProductIDs = self.fetchProductIDs;
        [request execute];
        
        return;
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectTemplateIDResponse object:self userInfo:params];
}

@end
