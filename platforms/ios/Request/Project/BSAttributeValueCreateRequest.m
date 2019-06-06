//
//  BSAttributeValueCreateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSAttributeValueCreateRequest.h"

typedef enum kAttributeValueRequestType
{
    kAttributeValueRequestEdit,
    kAttributeValueRequestCreate
}kAttributeValueRequestType;

@interface BSAttributeValueCreateRequest ()

@property (nonatomic, assign) kAttributeValueRequestType type;
@property (nonatomic, assign) CDProjectAttribute *attribute;
@property (nonatomic, strong) NSString *attributeValueName;
@property (nonatomic, strong) CDProjectAttributeValue *attributeValue;
@end


@implementation BSAttributeValueCreateRequest

- (id)initWithAttribute:(CDProjectAttribute *)attribute attributeValueName:(NSString *)attributeValueName
{
    self = [super init];
    if (self != nil)
    {
        self.attribute = attribute;
        self.attributeValueName = attributeValueName;
        self.type = kAttributeValueRequestCreate;
    }
    
    return self;
}

- (id)initWithAttribute:(CDProjectAttribute *)attribute attributeValue:(CDProjectAttributeValue *)attributeValue attributeValueName:(NSString *)attributeValueName
{
    self = [super init];
    if (self != nil)
    {
        self.attribute = attribute;
        self.attributeValue = attributeValue;
        self.attributeValueName = attributeValueName;
        self.type = kAttributeValueRequestEdit;
    }
    
    return self;
}


- (BOOL)willStart
{
    self.tableName = @"product.attribute.value";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSMutableArray *paramsArray = [NSMutableArray array];
    if (self.attributeValueName.length>0) {
        params[@"attribute_id"] = self.attribute.attributeID;
        params[@"name"] = self.attributeValueName;
        [paramsArray addObject:params];
    }
    
    if (self.type == kAttributeValueRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:paramsArray];
    }
    else if (self.type == kAttributeValueRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.attributeValue.attributeValueID], params]];
        
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (resultStr.length != 0 && resultList != nil)
    {
        NSNumber *attributeValueID = nil;
        if (self.type == kAttributeValueRequestEdit)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *result = (NSNumber *)resultList;
                if ([result boolValue])
                {
                    attributeValueID = self.attributeValue.attributeValueID;
                }
            }
        }
        else if (self.type == kAttributeValueRequestCreate)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                attributeValueID = (NSNumber *)resultList;
            }
        }
        
        if (attributeValueID != nil)
        {
            CDProjectAttributeValue *attributeValue = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttributeValue" withValue:attributeValueID forKey:@"attributeValueID"];
            if (attributeValue == nil)
            {
                attributeValue = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectAttributeValue"];
                attributeValue.attributeValueID = attributeValueID;
            }
            attributeValue.attributeValueName = self.attributeValueName;
            attributeValue.attribute = self.attribute;
            
            [[BSCoreDataManager currentManager] save:nil];
            [params setValue:attributeValue forKey:@"object"];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeValueCreateResponse object:self userInfo:params];
}

@end
