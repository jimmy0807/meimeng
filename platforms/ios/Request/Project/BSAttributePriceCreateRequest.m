//
//  BSAttributePriceCreateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSAttributePriceCreateRequest.h"

typedef enum kAttributePriceRequestType
{
    kAttributePriceRequestEdit,
    kAttributePriceRequestCreate
}kAttributePriceRequestType;

@interface BSAttributePriceCreateRequest ()

@property (nonatomic, assign) kAttributePriceRequestType type;
@property (nonatomic, strong) NSNumber *templateID;
@property (nonatomic, strong) NSNumber *attributeValueID;
@property (nonatomic, strong) CDProjectAttributePrice *attributePrice;
@property (nonatomic, assign) CGFloat extraPrice;

@end


@implementation BSAttributePriceCreateRequest

- (id)initWithTemplateID:(NSNumber *)templateID attributeValueID:(NSNumber *)attributeValueID extraPrice:(CGFloat)extraPrice
{
    self = [super init];
    if (self != nil)
    {
        self.templateID = templateID;
        self.attributeValueID = attributeValueID;
        self.extraPrice = extraPrice;
        self.attributePrice = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttributePrice" withValue:self.attributeValueID forKey:[NSString stringWithFormat:@"templateID == %@ && attributeValueID", self.templateID]];
        if (self.attributePrice)
        {
            self.type = kAttributePriceRequestEdit;
        }
        else
        {
            self.type = kAttributePriceRequestCreate;
        }
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"product.attribute.price";
    if (self.type == kAttributePriceRequestCreate)
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:self.extraPrice], @"price_extra", self.templateID, @"product_tmpl_id", self.attributeValueID, @"value_id", nil];
        [self sendShopAssistantXmlCreateCommand:@[params]];
    }
    else if (self.type == kAttributePriceRequestEdit)
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:self.extraPrice], @"price_extra", self.attributePrice.templateID, @"product_tmpl_id", self.attributePrice.attributeValueID, @"value_id", nil];
        [self sendShopAssistantXmlWriteCommand:@[@[self.attributePrice.attributePriceID], params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && resultList != nil)
    {
        if (self.type == kAttributePriceRequestEdit)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *result = (NSNumber *)resultList;
                if (![result boolValue])
                {
                    params = [self generateResponse:@"服务器异常, 请稍后重试"];
                }
            }
        }
        else if (self.type == kAttributePriceRequestCreate)
        {
            if (![resultList isKindOfClass:[NSNumber class]])
            {
                params = [self generateResponse:@"服务器异常, 请稍后重试"];
            }
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributePriceCreateResponse object:self userInfo:params];
}

@end
