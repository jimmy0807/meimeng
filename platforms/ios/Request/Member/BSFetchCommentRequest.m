//
//  BSFetchCommentRequest.m
//  Boss
//
//  Created by lining on 16/4/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchCommentRequest.h"
//#import "BSFetchCommentTypeRequest.h"

@implementation BSFetchCommentRequest

- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"born.comment";
    if (self.member) {
        self.filter = @[@[@"member_id",@"=",self.member.memberID]];
    }
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldComments = [NSMutableArray arrayWithArray:[dataManager fetchCommentsWithMember:self.member]];
        for (NSDictionary *params in retArray) {
            NSNumber *comment_id = [params numberValueForKey:@"id"];
            CDComment *comment = [dataManager findEntity:@"CDComment" withValue:comment_id forKey:@"comment_id"];
            if (comment) {
                [oldComments removeObject:comment];
            }
            else
            {
                comment = [dataManager insertEntity:@"CDComment"];
                comment.comment_id = comment_id;
            }
            
            comment.shop_id = [params arrayIDValueForKey:@"shop_id"];
            comment.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            comment.member_id = [params arrayIDValueForKey:@"member_id"];
            comment.member_name = [params arrayNameValueForKey:@"member_id"];
            
            comment.operate_id = [params arrayIDValueForKey:@"operate_id"];
            comment.operate_name = [params arrayNameValueForKey:@"operate_id"];
            
            comment.comment_mark = [params stringValueForKey:@"comment"];
            comment.date = [params stringValueForKey:@"__last_update"];
            comment.operate_type = [params stringValueForKey:@"type"];
            
            NSArray *type_ids = [params arrayValueForKey:@"type_ids"];
            NSMutableOrderedSet *orderSet = [NSMutableOrderedSet orderedSet];
            for (NSNumber *type_id in type_ids) {
                CDCommentType *commentType = [dataManager uniqueEntityForName:@"CDCommentType" withValue:type_id forKey:@"type_id"];
                [orderSet addObject:commentType];
            }
            comment.commentTypes = orderSet;

        }
        [dataManager deleteObjects:oldComments];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchCommentResponse object:nil userInfo:dict];
}


@end
