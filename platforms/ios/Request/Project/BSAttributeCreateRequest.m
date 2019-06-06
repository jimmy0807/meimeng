//
//  BSAttributeCreateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSAttributeCreateRequest.h"

typedef enum kAttributeRequestType
{
    kAttributeRequestEdit,
    kAttributeRequestCreate
}kAttributeRequestType;

@interface BSAttributeCreateRequest ()

@property (nonatomic, assign) kAttributeRequestType type;
@property (nonatomic, strong) NSString *attributeName;
@property (nonatomic, strong) CDProjectAttribute *attribute;

@end

@implementation BSAttributeCreateRequest

- (id)initWithAttributeName:(NSString *)attributeName
{
    self = [super init];
    if (self != nil)
    {
        self.attributeName = attributeName;
        self.type = kAttributeRequestCreate;
    }
    
    return self;
}

- (id)initWithAttribute:(CDProjectAttribute *)attribute attributeName:(NSString *)attributeName
{
    self = [super init];
    if (self != nil)
    {
        self.attribute = attribute;
        self.attributeName = attributeName;
        self.type = kAttributeRequestEdit;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"product.attribute";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.attributeName, @"name", nil];
    if (self.type == kAttributeRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[params]];
    }
    else if (self.type == kAttributeRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.attribute.attributeID], params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (resultStr.length != 0 && resultList != nil)
    {
        NSNumber *attributeID = nil;
        if (self.type == kAttributeRequestEdit)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *result = (NSNumber *)resultList;
                if ([result boolValue])
                {
                    attributeID = self.attribute.attributeID;
                }
            }
        }
        else if (self.type == kAttributeRequestCreate)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                attributeID = (NSNumber *)resultList;
            }
        }
        
        if (attributeID != nil)
        {
            NSNumber *attributeID = (NSNumber *)resultList;
            CDProjectAttribute *attribute = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttribute" withValue:attributeID forKey:@"attributeID"];
            if (attribute == nil)
            {
                attribute = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectAttribute"];
                attribute.attributeID = attributeID;
            }
            attribute.attributeName = self.attributeName;
            
            [[BSCoreDataManager currentManager] save:nil];
            [params setValue:attribute forKey:@"object"];
        }
        else
        {
            params = [self generateResponse:@"服务器异常, 请稍后重试"];
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeCreateResponse object:self userInfo:params];
}

@end
