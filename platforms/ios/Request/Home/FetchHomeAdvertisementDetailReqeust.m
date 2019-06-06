//
//  FetchHomeAdvertisementDetailReqeust.m
//  Boss
//
//  Created by jimmy on 15/7/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeAdvertisementDetailReqeust.h"

@interface FetchHomeAdvertisementDetailReqeust ()
@property(nonatomic, strong)NSNumber* parentID;
@end

@implementation FetchHomeAdvertisementDetailReqeust

-(id)initWithParentID:(NSNumber*)parentID
{
    self = [super init];
    if (self)
    {
        self.parentID = parentID;
    }
    
    return self;
}

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.carousel.item";
    
    self.filter = @[@[@"carousel_id",@"=",self.parentID]];
    self.field = @[@"write_date",@"title",@"link_url",@"id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        
        for ( NSDictionary *params in retArray )
        {
            CDAdvertisementItem *item = [dataManager uniqueEntityForName:@"CDAdvertisementItem" withValue:[params numberValueForKey:@"id"] forKey:@"itemID"];
            item.title = [params stringValueForKey:@"title"];
            item.linkUrl = [params stringValueForKey:@"link_url"];
            item.writeDate = [params stringValueForKey:@"write_date"];
            item.imageName = [NSString stringWithFormat:@"%@%@",@"advertisement",item.itemID];
        }
        
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeAdvertisementResponse object:nil userInfo:dict];
}

@end
