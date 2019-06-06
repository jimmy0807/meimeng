//
//  BSImportMemberCardRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSImportMemberCardRequest.h"

@interface BSImportMemberCardRequest ()

@property (nonatomic, strong) NSNumber *operateID;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSNumber *cardID;
@property (nonatomic, assign) kImportMemberCardType type;

@end

@implementation BSImportMemberCardRequest

- (id)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        self.type = kImportMemberCardCreate;
    }
    
    return self;
}

- (id)initWithOperateID:(NSNumber *)operateID params:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.operateID = operateID;
        self.params = params;
        self.type = kImportMemberCardEdit;
    }
    
    return self;
}

- (id)initWithOperateID:(NSNumber *)operateID
{
    self = [super init];
    if (self != nil)
    {
        self.operateID = operateID;
        self.type = kImportFetchMemberCardID;
    }
    
    return self;
}

- (id)initWithMemberCardID:(NSNumber *)cardID
{
    self = [super init];
    if (self != nil)
    {
        self.cardID = cardID;
        self.type = kImportMemberCardActive;
    }
    
    return self;
}


- (BOOL)willStart
{
    self.tableName = @"born.card.operate";
    if (self.type == kImportMemberCardCreate)
    {
        self.additionalParams = @[@{@"tz":@"Asia/Shanghai"}, @{@"type":@"card"}, @{@"is_import":[NSNumber numberWithBool:YES]}];
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == kImportMemberCardEdit)
    {
        self.additionalParams = @[@{@"tz":@"Asia/Shanghai"}, @{@"type":@"card"}, @{@"is_import":[NSNumber numberWithBool:YES]}];
        [self sendShopAssistantXmlCreateCommand:@[self.operateID, self.params]];
    }
    else if (self.type == kImportFetchMemberCardID)
    {
        self.filter = @[@[@"id", @"=", self.operateID]];
        self.field = @[@"card_id"];
        [self sendShopAssistantXmlSearchReadCommand];
    }
    else if (self.type == kImportMemberCardActive)
    {
        self.tableName = @"born.card";
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"active", @"state", nil];
        [self sendShopAssistantXmlWriteCommand:@[self.cardID, dict]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && resultList != nil)
    {
        if (self.type == kImportMemberCardCreate)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *operateID = (NSNumber *)resultList;
                BSImportMemberCardRequest *request = [[BSImportMemberCardRequest alloc] initWithOperateID:operateID];
                [request execute];
                
                return ;
            }
        }
        else if (self.type == kImportMemberCardEdit)
        {
            NSNumber *operateID = nil;
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *result = (NSNumber *)resultList;
                if ([result boolValue])
                {
                    operateID = self.operateID;
                }
            }
        }
        else if (self.type == kImportFetchMemberCardID)
        {
            if ([resultList isKindOfClass:[NSArray class]] && resultList.count > 0)
            {
                NSDictionary *params = [resultList objectAtIndex:0];
                NSArray *cards = [params arrayValueForKey:@"card_id"];
                if ([cards isKindOfClass:[NSArray class]] && cards.count > 0)
                {
                    NSNumber *cardID = [cards objectAtIndex:0];
                    BSImportMemberCardRequest *request = [[BSImportMemberCardRequest alloc] initWithMemberCardID:cardID];
                    [request execute];
                    
                    return ;
                }
            }
        }
        else if (self.type == kImportMemberCardActive)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *result = (NSNumber *)resultList;
                if ([result boolValue])
                {
                    CDMemberCard *card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.cardID forKey:@"cardID"];
                    if (card == nil)
                    {
                        card = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                        card.cardID = self.cardID;
                    }
                    card.isActive = [NSNumber numberWithBool:YES];
                    [[BSCoreDataManager currentManager] save:nil];
                }
            }
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSImportMemberCardResponse object:self userInfo:params];
}

@end
