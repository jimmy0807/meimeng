//
//  BSYimeiEditOperateActivityRequest.m
//  ds
//
//  Created by jimmy on 16/11/7.
//
//

#import "BSYimeiEditOperateActivityRequest.h"

@interface BSYimeiEditOperateActivityRequest ()
@property (nonatomic, strong)CDOperateActivity *activity;
@end

@implementation BSYimeiEditOperateActivityRequest

- (id)initWithOperateActivityToNextState:(CDOperateActivity *)activity
{
    self = [super init];
    if (self)
    {
        self.activity = activity;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.operate.activity";
    NSString* state = @"";
    if ( self.isBack )
    {
        state = @"draft";
    }
    else
    {
        if ( [self.activity.state isEqualToString:@"waiting"] )
        {
            state = @"doing";
        }
        else if ( [self.activity.state isEqualToString:@"doing"] )
        {
            state = @"done";
        }
        else if ( [self.activity.state isEqualToString:@"done"] )
        {
            state = @"done";
        }
        else
        {
            state = @"doing";
        }
    }
    
    [self sendShopAssistantXmlWriteCommand:@[@[self.activity.lineID],@{@"state":state}]];
    
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([retArray isKindOfClass:[NSNumber class]])
    {
        if ( self.isBack )
        {
            self.activity.state = @"draft";
            [[BSCoreDataManager currentManager] deleteObject:self.activity.operate];
        }
        else if ( [self.activity.state isEqualToString:@"waiting"] )
        {
            self.activity.state = @"doing";
        }
        else if ( [self.activity.state isEqualToString:@"doing"] )
        {
            self.activity.state = @"done";
        }
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEidtYimeiOperateActivityResponse object:self userInfo:dict];
}

@end
