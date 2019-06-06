//
//  BSChangeStoreRequest.m
//  meim
//
//  Created by 波恩公司 on 2017/9/29.
//

#import "BSChangeStoreRequest.h"

@interface BSChangeStoreRequest ()

@property(nonatomic, strong) NSNumber *shopId;

@end

@implementation BSChangeStoreRequest

-(id)initWithShopId:(NSNumber *)shopId
{
    self = [super init];
    if (self) {
        self.shopId = shopId;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    PersonalProfile *profile = [PersonalProfile currentProfile];

    NSString *cmd = [NSString stringWithFormat:@"%@%@",profile.baseUrl,@"/xmlrpc/2/ds_api"];
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[profile.bshopId,profile.userID]];
    NSString *xmlString = [BNXmlRpc xmlLoginWithJsonString:jsonString];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.shopId, @"shop_id", profile.userID, @"user_id", nil];
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"change_shop" params:@[params]];

    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSDictionary *retDict = (NSDictionary*)[BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if ( [retDict isKindOfClass:[NSDictionary class]])
    {
        int errCode = [[retDict numberValueForKey:@"errcode"] integerValue];
        NSString *errMsg = [retDict stringValueForKey:@"errmsg"];
        NSLog(@"ErrorCode:%d, ErrorMessage:%@",errCode,errMsg);
        if(errCode == 0){
            [dict setValue:@0 forKey:@"rc"];
        }
        else{
            [dict setValue:@1 forKey:@"rc"];
        }
        [dict setValue:errMsg forKey:@"rm"];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSChangeStoreResponse object:self userInfo:dict];

}

@end
