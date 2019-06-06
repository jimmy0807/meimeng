//
//  BSCreateProviderRequest.m
//  Boss
//
//  Created by lining on 15/6/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCreateProviderRequest.h"


@interface BSCreateProviderRequest ()
@property(nonatomic, strong) CDProvider *provider;
@property(nonatomic, strong) NSDictionary *params;
@end


@implementation BSCreateProviderRequest

- (id)initWithProvider:(CDProvider *)provider params:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.provider = provider;
        self.params = params;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"res.partner";
    [self sendShopAssistantXmlCreateCommand:@[self.params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSNumber *resultArray = (NSNumber*)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSLog(@"%@",resultStr);
    if ( [resultArray isKindOfClass:[NSNumber class]] )
    {
        [dict setValue:@0 forKey:@"rc"];
        [dict setValue:@"创建成功" forKey:@"rm"];
        self.provider.provider_id = resultArray;
        [[BSCoreDataManager currentManager] save:nil];
        
    }
    else
    {
        [[BSCoreDataManager currentManager] deleteObject:self.provider];
        [[BSCoreDataManager currentManager] save:nil];
        [dict setValue:@-1 forKey:@"rc"];
        [dict setValue:@"创建失败，请稍后重试" forKey:@"rm"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCreateProviderResponse object:self userInfo:dict];
}

@end
