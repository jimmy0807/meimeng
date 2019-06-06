//
//  BSProjectCategoryRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/5/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectCategoryRequest.h"
#import "BSCoreDataManager.h"

@implementation BSProjectCategoryRequest

- (BOOL)willStart
{
    self.tableName = @"pos.category";
    self.filter = @[];
    self.field = @[@"id", @"name", @"parent_id", @"sequence", @"departments_id"];
    
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
        NSArray *categoryArray = [coreDataManager fetchAllProjectCategory];
        NSMutableArray *oldCategoryArray = [NSMutableArray arrayWithArray:categoryArray];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *categoryID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectCategory *category = [coreDataManager findEntity:@"CDProjectCategory" withValue:categoryID forKey:@"categoryID"];
            if (category)
            {
                [oldCategoryArray removeObject:category];
            }
            else
            {
                category = [coreDataManager insertEntity:@"CDProjectCategory"];
                category.categoryID = categoryID;
            }
            
            category.categoryName = [dict objectForKey:@"name"];
            category.sequence = [NSNumber numberWithInteger:[[dict stringValueForKey:@"sequence"] integerValue]];
            category.itemCount = [NSNumber numberWithInteger:0];
            if ([[dict objectForKey:@"departments_id"] isKindOfClass:[NSArray class]])
            {
                category.departments_id = [NSNumber numberWithInteger:[[dict objectForKey:@"departments_id"][0] integerValue]];
                category.departments_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"departments_id"][1]];
            }
            else
            {
                category.departments_id = [NSNumber numberWithInteger:0];
                category.departments_name = @"";
            }
//            NSMutableString *serialID = [NSMutableString string];
            if (![[dict objectForKey:@"parent_id"] isKindOfClass:[NSArray class]])
            {
                category.parentID = [NSNumber numberWithInteger:0];
                category.parentName = @"";
            }
            else
            {
                NSNumber *parentID = [NSNumber numberWithInteger:[[[dict objectForKey:@"parent_id"] objectAtIndex:0] integerValue]];
                category.parentID = parentID;
                category.parentName = [[dict objectForKey:@"parent_id"] objectAtIndex:1];
                CDProjectCategory *parentCategory = [coreDataManager findEntity:@"CDProjectCategory" withValue:parentID forKey:@"categoryID"];
                if (!parentCategory)
                {
                    parentCategory = [coreDataManager insertEntity:@"CDProjectCategory"];
                    parentCategory.categoryID = parentID;
                }
                parentCategory.itemCount = [NSNumber numberWithInteger:0];
                category.parent = parentCategory;
//                1,2,4,6;
            }
        }
        [coreDataManager deleteObjects:oldCategoryArray];
        [coreDataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectCategoryResponse object:self userInfo:params];
}

@end
