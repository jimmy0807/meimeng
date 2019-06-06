//
//  FetchWashHandRequest.m
//  meim
//
//  Created by jimmy on 2017/6/26.
//
//

#import "FetchWashHandRequest.h"

@implementation FetchWashHandRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"user_id"] = profile.userID;
    params[@"workflow_item_id"] = self.workID;
    if (self.keyword != nil)
    {
        params[@"keyword"] = self.keyword;
        params[@"state"] = @"keyword";
    }
    if ( self.bFetchDone )
    {
        params[@"state"] = @"done";
    }
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"pos_operate_list" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *data = [resuntDitc objectForKey:@"data"];
        NSInteger index = 0;
        if ([data isKindOfClass:[NSArray class]])
        {
            NSArray* o = [[BSCoreDataManager currentManager] fetchAllWashHandWithID:self.workID keyword:nil isDone:self.bFetchDone];
            NSMutableArray* oldArray = [NSMutableArray arrayWithArray:o];
            
            for (NSDictionary *params in data)
            {
                NSNumber *line_id = [params objectForKey:@"id"];
                CDPosWashHand *wash = [[BSCoreDataManager currentManager] findEntity:@"CDPosWashHand" withValue:line_id forKey:@"operate_id"];
                if( wash == nil )
                {
                    wash = [[BSCoreDataManager currentManager] insertEntity:@"CDPosWashHand"];
                    wash.operate_id = line_id;
                }
                else
                {
                    [oldArray removeObject:wash];
                }
                wash.activity_state = [params stringValueForKey:@"activity_state"];
                wash.activity_state_name = [params stringValueForKey:@"activity_state_name"];
                wash.customer_state = [params stringValueForKey:@"customer_state"];
                wash.customer_state_name = [params stringValueForKey:@"customer_state_name"];
                wash.yimei_queueID = [params stringValueForKey:@"queue_no"];
                wash.member_name = [params stringValueForKey:@"customer_name"];
                wash.member_id = [params numberValueForKey:@"member_id"];
                wash.imageUrl = [params stringValueForKey:@"member_image_url"];
                wash.operate_date = [params stringValueForKey:@"create_date"];
                wash.doctor_name = [params stringValueForKey:@"doctor_name"];
                wash.keshi_name = [params stringValueForKey:@"departments_name"];
                wash.fumayao_time = [params stringValueForKey:@"fumayao_time"];
                wash.currentWorkflowID = self.workID;
                wash.role_option = [params numberValueForKey:@"role_option"];
                if ( self.bFetchDone )
                {
                    wash.state = @"done";
                }
                else
                {
                    wash.state = @"";
                }
                
                wash.sort_index = @(index++);
            }
            
            [[BSCoreDataManager currentManager] deleteObjects:oldArray];
            [[BSCoreDataManager currentManager] save:nil];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchWashHandResponse object:nil userInfo:dict];
}

@end
