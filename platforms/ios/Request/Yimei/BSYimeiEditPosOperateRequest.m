//
//  BSYimeiEditPosOperateRequest.m
//  ds
//
//  Created by jimmy on 16/10/28.
//
//

#import "BSYimeiEditPosOperateRequest.h"

@interface BSYimeiEditPosOperateRequest ()
@property (nonatomic, strong) CDPosOperate *operate;
@property (nonatomic, strong) NSNumber *operateID;
@end

@implementation BSYimeiEditPosOperateRequest

- (id)initWithPosOperate:(CDPosOperate *)operate params:(NSDictionary *)params
{
    self = [super init];
    if (self)
    {
        self.operate = operate;
        self.params = params;
    }
    
    return self;
}

- (id)initWithPosOperateID:(NSNumber *)operateID params:(NSDictionary *)params
{
    self = [super init];
    if (self)
    {
        self.operateID = operateID;
        self.params = params;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.card.operate";
    if ( [self.operateID integerValue] > 0 )
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.operateID],self.params]];
    }
    else
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.operate.operate_id],self.params]];
    }
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([retArray isKindOfClass:[NSNumber class]])
    {
        dict[@"rc"] = @(0);
    }
    else
    {
        dict = [self generateResponse:self.errorMesasge];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEidtPosOperateResponse object:nil userInfo:dict];
}

@end
