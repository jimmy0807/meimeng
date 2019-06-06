//
//  FetchHTeamRequest.m
//  meim
//
//  Created by 波恩公司 on 2017/9/25.
//
//

#import "FetchHTeamRequest.h"

@interface FetchHTeamRequest ()
@end

@implementation FetchHTeamRequest

//-(id)initWithShoushuID:(NSArray*)shoushuIDs
//{
//    self = [super init];
//    if (self)
//    {
//        self.shoushuIDs = shoushuIDs;
//    }
//    
//    return self;
//}

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:profile.userID forKey:@"user_id"];
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"get_team_list" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *data = [resuntDitc objectForKey:@"data"];
                
        if ([data isKindOfClass:[NSArray class]])
        {
            NSArray* array = [[BSCoreDataManager currentManager] fetchAllShoushuTeam];
            [[BSCoreDataManager currentManager] deleteObjects:array];
            
            for (NSDictionary *params in data)
            {
                NSNumber *teamID = [params objectForKey:@"id"];
                
                CDTeam *team = [[BSCoreDataManager currentManager] insertEntity:@"CDTeam"];
                team.team_id = teamID;
                team.name = [params stringValueForKey:@"name"];
            }
            
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"请求数据错误"];
        }
    }
}

@end
