//
//  BSFetchProjectRequest.m
//  Boss
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "CDMemberCardProject.h"
#import "BSFetchTotalPriceRequest.h"

@implementation BSFetchTotalPriceRequest
- (id)initWithProjectID:(NSArray *)projectIDs priceListID:(NSNumber *)pricelist_id;
{
    if(self = [super init])
    {
        self.projectIDs = projectIDs;
        self.pricelist_id = pricelist_id;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"product.product";
    self.additionalParams = @[@{@"tz":@"Asia/Shanghai"},@{@"pricelist":self.pricelist_id}];
    self.filter = @[@[@"id",@"in",self.projectIDs]];
    self.field = @[@"id",@"name",@"list_price",@"lst_price",@"price",@"default_code"];
    [self sendShopAssistantXmlSearchReadCommand];
    return YES;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = (NSArray *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        for(NSDictionary *param in retArray)
        {
            NSNumber *projectId = [param numberValueForKey:@"id"];
            CDMemberCardProject *project = [dataManager findEntity:@"CDMemberCardProject" withValue:projectId forKey:@"projectID"];
            if(!project)
            {
                project = [dataManager insertEntity:@"CDMemberCardProject"];
                project.projectID = projectId;
            }
            project.projectPriceUnit = [param numberValueForKey:@"lst_price"];
            project.projectTotalPrice = [param numberValueForKey:@"price"];
            project.defaultCode = [param stringValueForKey:@"default_code"];
            CDProjectItem *item = [dataManager findEntity:@"CDProjectItem" withValue:projectId forKey:@"itemID"];
            if (item == nil)
            {
                project.defaultCode = @"0";
                project.uomName = LS(@"PadDefaultUomName");
                item = [dataManager insertEntity:@"CDProjectItem"];
                item.itemID = projectId;
            }
            else
            {
                project.uomName = item.uomName;
                project.defaultCode = item.defaultCode;
            }
            
            if (project.uomName.length == 0)
            {
                project.uomName = LS(@"PadDefaultUomName");
            }
            project.item = item;
            [dataArray addObject:project];
        }
        [dataManager save:nil];
        [dict setObject:@0 forKey:@"rc"];
        [dict setObject:dataArray forKey:@"data"];
    }
    else
    {
        dict = [self generateResponse:@"请求支付方式发生错误"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchTotalPriceRequest object:nil userInfo:dict];
}
@end
