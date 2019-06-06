//
//  BSFetchFeedbacksRequest.m
//  Boss
//
//  Created by lining on 16/8/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchFeedbacksRequest.h"

@interface BSFetchFeedbacksRequest ()
@property (nonatomic, strong) CDMember *member;
@end

@implementation BSFetchFeedbacksRequest

- (instancetype)initWithMember:(CDMember *)member
{
    self = [super init];
    if (self) {
        self.member = member;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.feedback";
    
    self.filter = @[@[@"member_id",@"=",self.member.memberID]];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict;
    if ([retArray isKindOfClass:[NSArray class]]) {
        
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldFeedbacks = [NSMutableArray arrayWithArray:[dataManager fetchMemberFeedbackWithMember:self.member]];

        for (NSDictionary *params in retArray) {
            NSNumber *feedback_id = [params numberValueForKey:@"id"];
            CDMemberFeedback *feedback = [dataManager findEntity:@"CDMemberFeedback" withValue:feedback_id forKey:@"feedback_id"];
            if (feedback == NULL) {
                feedback = [dataManager insertEntity:@"CDMemberFeedback"];
                feedback.feedback_id = feedback_id;
            }
            else
            {
                [oldFeedbacks removeObject:feedback];
            }
            feedback.display_name = [params stringValueForKey:@"display_name"];
            feedback.last_update = [params stringValueForKey:@"__last_update"];
            feedback.operate_id = [params arrayIDValueForKey:@"operate_id"];
            feedback.operate_name = [params arrayNameValueForKey:@"operate_id"];
            
            feedback.shop_id = [params arrayIDValueForKey:@"shop_id"];
            feedback.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            feedback.employee_id = [params arrayIDValueForKey:@"employee_id"];
            feedback.employee_name = [params arrayNameValueForKey:@"employee_id"];
            
            feedback.note = [params stringValueForKey:@"note"];
            
            feedback.member = self.member;
        }
        [dataManager deleteObjects:oldFeedbacks];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchFeedbackResponse object:nil userInfo:dict];
}

@end
