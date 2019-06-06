//
//  FetchHomeAdvertisementReqeust.m
//  Boss
//
//  Created by jimmy on 15/7/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeAdvertisementReqeust.h"
//#import "FetchHomeAdvertisementDetailReqeust.h"
#import "PersonalProfile.h"

@implementation FetchHomeAdvertisementReqeust

-(BOOL)willStart
{
    [super willStart];
    
    NSString *cmd = [NSString stringWithFormat:@"%@%@",SERVER_IP,@"/xmlrpc/2/ds_api"];
    NSString *jsonStr = [BNXmlRpc jsonWithArray:@[@{@"position":@"boss_mobile_home"}]];
    NSString *xmlStr = [BNXmlRpc xmlMethod:@"mobile_carousel" jsonString:jsonStr];
    [self sendXmlCommand:cmd params:xmlStr];
    
    return true;
}

-(void)didFinishOnMainThread
{
    NSDictionary *retDict = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    
    if ([retDict isKindOfClass:[NSDictionary class]])
    {
        NSNumber *errorRet = [retDict numberValueForKey:@"errcode"];
        if (errorRet.integerValue == 0)
        {
            NSArray *retArray = [retDict arrayValueForKey:@"data"];
            
            BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
            NSArray *ads = [dataManager fetchItems:@"CDAdvertisementItem"];
            [dataManager deleteObjects:ads];
            for ( NSDictionary *params in retArray )
            {
                CDAdvertisementItem *ad = [dataManager insertEntity:@"CDAdvertisementItem"];
                ad.imageUrl = [params stringValueForKey:@"image_url"];
                ad.linkUrl = [params stringValueForKey:@"link_url"];
                ad.title = [params stringValueForKey:@"title"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeAdvertisementResponse object:nil userInfo:nil];
        }
    }
}

//-(BOOL)willStart
//{
//    [super willStart];
//    self.tableName = @"born.carousel";
//    
//    self.filter = @[];
//    self.field = @[@"name",@"item_ids",@"interval",@"type"];
//    [self sendShopAssistantXmlSearchReadCommand];
//    
//    return TRUE;
//}

//-(void)didFinishOnMainThread
//{
//    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    if ([retArray isKindOfClass:[NSArray class]])
//    {
//        BOOL bHasItem = FALSE;
//        NSNumber* parentID;
//        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
//        NSArray *ads = [dataManager fetchItems:@"CDAdvertisement"];
//        [dataManager deleteObjects:ads];
//        
//        for ( NSDictionary *params in retArray )
//        {
//            NSString* type = [params stringValueForKey:@"type"];
//            if ( ![type isEqualToString:@"banner"] )
//            {
//                continue;
//            }
//            
//            CDAdvertisement *ad = [dataManager insertEntity:@"CDAdvertisement"];
//            ad.adID = [params numberValueForKey:@"id"];
//            ad.interval = [params numberValueForKey:@"interval"];
//            ad.name = [params stringValueForKey:@"name"];
//            ad.type = @"banner";
//            
//            parentID = ad.adID;
//            NSArray* itemsArray = [params arrayValueForKey:@"item_ids"];
//            for ( NSNumber* itemID in itemsArray )
//            {
//                bHasItem = TRUE;
//                CDAdvertisementItem* item = [dataManager uniqueEntityForName:@"CDAdvertisementItem" withValue:itemID forKey:@"itemID"];
//                item.parent = ad;
//            }
//            
//            break;
//        }
//        
//        [dataManager save:nil];
//        
//        if ( bHasItem )
//        {
//            FetchHomeAdvertisementDetailReqeust* request = [[FetchHomeAdvertisementDetailReqeust alloc] initWithParentID:parentID];
//            [request execute];
//        }
//        else
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeAdvertisementResponse object:nil userInfo:dict];
//        }
//    }
//    else
//    {
//        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeAdvertisementResponse object:nil userInfo:dict];
//    }
//}

@end
