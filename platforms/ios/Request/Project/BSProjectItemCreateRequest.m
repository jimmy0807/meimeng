//
//  BSProjectItemCreateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/11.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectItemCreateRequest.h"

typedef enum kProjectItemRequestType
{
    kProjectItemRequestCreate,
    kProjectItemRequestEdit
}kProjectItemRequestType;

@interface BSProjectItemCreateRequest ()

@property (nonatomic, assign) kProjectItemRequestType type;
@property (nonatomic, strong) NSNumber *itemID;
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation BSProjectItemCreateRequest

- (id)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        self.type = kProjectItemRequestCreate;
    }
    
    return self;
}

- (id)initWithProjectItemID:(NSNumber *)itemID params:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        self.itemID = itemID;
        self.type = kProjectItemRequestEdit;
    }
    
    return self;
}

- (BOOL)willStart
{
    if ( self.useTemplate )
    {
        self.tableName = @"product.template";
    }
    else
    {
        self.tableName = @"product.product";
    }
    
    NSNumber *categoryCode = [self.params objectForKey:@"born_category"];
    CDBornCategory *bornCategory = [[BSCoreDataManager currentManager] findEntity:@"CDBornCategory" withValue:categoryCode forKey:@"code"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.params];
    [mutableDict setObject:bornCategory.bornCategoryID forKey:@"category_id"];
    self.params = [NSDictionary dictionaryWithDictionary:mutableDict];
    
    if (self.type == kProjectItemRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == kProjectItemRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.itemID], self.params]];
    }
    NSLog(@"%@",self.params);
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (resultStr.length != 0)
    {
        NSNumber *itemID = nil;
        if (self.type == kProjectItemRequestEdit)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *isSuccess = (NSNumber *)resultList;
                if (isSuccess.boolValue)
                {
                    itemID = self.itemID;
                }
            }
        }
        else if (self.type == kProjectItemRequestCreate)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                itemID = (NSNumber *)resultList;
            }
        }
        
        if (itemID.integerValue != 0)
        {
            CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:itemID forKey:@"itemID"];
            if ([self.params objectForKey:@"barcode"] != nil && ![[self.params objectForKey:@"barcode"] isEqualToString:@"0"])
            {
                item.barcode = [self.params objectForKey:@"barcode"];
            }
            
            if ([self.params objectForKey:@"default_code"] != nil && ![[self.params objectForKey:@"default_code"] isEqualToString:@"0"])
            {
                item.defaultCode = [self.params objectForKey:@"default_code"];
            }
            
            if ([self.params objectForKey:@"standard_price"] != nil) {
                item.stanardPrice = [self.params numberValueForKey:@"standard_price"];
            }
            
            if ([self.params objectForKey:@"lst_price"] != nil) {
                item.totalPrice = [self.params numberValueForKey:@"lst_price"];
            }
            
            [[BSCoreDataManager currentManager] save:nil];
            [params setObject:itemID forKey:@"itemID"];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectItemCreateResponse object:self userInfo:params];
}


@end
