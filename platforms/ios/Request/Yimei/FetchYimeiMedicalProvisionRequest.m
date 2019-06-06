//
//  FetchYimeiMedicalProvisionRequest.m
//  ds
//
//  Created by jimmy on 16/11/11.
//
//

#import "FetchYimeiMedicalProvisionRequest.h"

@implementation FetchYimeiMedicalProvisionRequest

- (BOOL)willStart
{
    if ( [self.provisionID integerValue] == 0 )
        return FALSE;
    
    self.tableName = @"born.medical.provision";
    self.filter = @[@[@"id", @"=", self.provisionID]];
    self.field = @[@"promise",@"provision"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if ( [resultArray isKindOfClass:[NSArray class]] && resultArray.count > 0 )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchYimeiMedicalProvisionResponse object:nil userInfo:@{@"info":resultArray[0]}];
    }
    else
    {
    }
}

@end
