//
//  FetchDiagnoseRequest.m
//  meim
//
//  Created by 波恩公司 on 2018/5/7.
//

#import "FetchDiagnoseRequest.h"

@implementation FetchDiagnoseRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.medical.diagnose.template";
    
    //self.filter = @[@[@"user_id",@"=",[PersonalProfile currentProfile].userID]];
    self.field = @[@"name",@"note"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        NSMutableArray* requestArray = [NSMutableArray array];
        for (NSDictionary* params in retArray )
        {
            [requestArray addObject:[params objectForKey:@"id"]];
        }
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:retArray, @"data", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchDiagnoseResponse" object:nil userInfo:dict];
    }
}

@end


