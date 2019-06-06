//
//  BSFetchCommentTypeRequest.m
//  Boss
//
//  Created by lining on 16/4/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchCommentTypeRequest.h"

@implementation BSFetchCommentTypeRequest
- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.comment.type";
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldCommentTypes = [NSMutableArray arrayWithArray:[dataManager fetchCommentType]];
        for (NSDictionary *params in retArray) {
            
            NSNumber *type_id = [params numberValueForKey:@"id"];
            
            CDCommentType *commentType = [dataManager findEntity:@"CDCommentType" withValue:type_id forKey:@"type_id"];
            if (commentType) {
                [oldCommentTypes removeObject:commentType];
            }
            else
            {
                commentType = [dataManager insertEntity:@"CDCommentType"];
                commentType.type_id = type_id;
            }
            
            commentType.name = [params stringValueForKey:@"name"];
            commentType.type = [params stringValueForKey:@"type"];
        }
        
        [dataManager deleteObjects:oldCommentTypes];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchCommentResponse object:nil userInfo:dict];
}

@end
