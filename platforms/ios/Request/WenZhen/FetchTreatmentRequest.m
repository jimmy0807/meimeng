//
//  FetchTreatmentRequest.m
//  meim
//
//  Created by 波恩公司 on 2018/5/7.
//

#import "FetchTreatmentRequest.h"

@implementation FetchTreatmentRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.medical.treatment.template";
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchTreatmentResponse" object:nil userInfo:dict];
    }
}

@end
