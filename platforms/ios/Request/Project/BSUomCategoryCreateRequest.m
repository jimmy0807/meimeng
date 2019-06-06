//
//  BSUomCategoryCreateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSUomCategoryCreateRequest.h"

typedef enum kUomCategoryRequestType
{
    kUomCategoryRequestEdit,
    kUomCategoryRequestCreate
}kUomCategoryRequestType;

@interface BSUomCategoryCreateRequest ()

@property (nonatomic, strong) NSNumber *uomCategoryID;
@property (nonatomic, strong) NSString *uomCategoryName;
@property (nonatomic, assign) kUomCategoryRequestType type;

@end

@implementation BSUomCategoryCreateRequest

- (id)initWithUomCategoryName:(NSString *)uomCategoryName
{
    self = [super init];
    if (self != nil)
    {
        self.type = kUomCategoryRequestCreate;
        self.uomCategoryName = uomCategoryName;
    }
    
    return self;
}

- (id)initWithUomCategoryID:(NSNumber *)uomCategoryID uomCategoryName:(NSString *)uomCategoryName
{
    self = [super init];
    if (self != nil)
    {
        self.type = kUomCategoryRequestEdit;
        self.uomCategoryID = uomCategoryID;
        self.uomCategoryName = uomCategoryName;
    }
    
    return self;
}


- (BOOL)willStart
{
    self.tableName = @"product.uom.categ";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.uomCategoryName, @"name", nil];
    if (self.type == kUomCategoryRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[params]];
    }
    else if (self.type == kUomCategoryRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.uomCategoryID], params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && resultList != nil)
    {
        NSNumber *uomCategoryID = nil;
        if (self.type == kUomCategoryRequestEdit)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *result = (NSNumber *)resultList;
                if ([result boolValue])
                {
                    uomCategoryID = self.uomCategoryID;
                }
            }
        }
        else if (self.type == kUomCategoryRequestCreate)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                uomCategoryID = (NSNumber *)resultList;
            }
        }
        
        if (uomCategoryID != nil)
        {
            CDProjectUomCategory *uomCategory = [[BSCoreDataManager currentManager] findEntity:@"CDProjectUomCategory" withValue:uomCategoryID forKey:@"uomCategoryID"];
            if (uomCategory == nil)
            {
                uomCategory = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectUomCategory"];
                uomCategory.uomCategoryID = uomCategoryID;
            }
            uomCategory.uomCategoryName = self.uomCategoryName;
            [[BSCoreDataManager currentManager] save:nil];
            
            [params setValue:uomCategory forKey:@"object"];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSUomCategoryCreateResponse object:self userInfo:params];
}


@end
