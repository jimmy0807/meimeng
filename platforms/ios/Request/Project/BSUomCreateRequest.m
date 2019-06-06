//
//  BSUomCreateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSUomCreateRequest.h"

typedef enum kUomRequestType
{
    kUomRequestEdit,
    kUomRequestCreate
}kUomRequestType;

@interface BSUomCreateRequest ()


@property (nonatomic, assign) kUomRequestType type;
@property (nonatomic, strong) CDProjectUom *projectUom;

@property (nonatomic, strong) NSString *uomName;
@property (nonatomic, strong) NSString *uomType;
@property (nonatomic, strong) NSNumber *uomCategoryId;
@property (nonatomic, strong) NSString *uomCategoryName;

@end

@implementation BSUomCreateRequest

- (id)initWithUomName:(NSString *)uomName uomType:(NSString *)uomType uomCategoryId:(NSNumber *)uomCategoryId uomCategoryName:(NSString *)uomCategoryName
{
    self = [super init];
    if (self != nil)
    {
        self.type = kUomRequestCreate;
        self.uomName = uomName;
        self.uomType = uomType;
        self.uomCategoryId = uomCategoryId;
        self.uomCategoryName = uomCategoryName;
    }
    
    return self;
}

- (id)initWithProjectUom:(CDProjectUom *)projectUom uomName:(NSString *)uomName uomType:(NSString *)uomType uomCategoryId:(NSNumber *)uomCategoryId uomCategoryName:(NSString *)uomCategoryName
{
    self = [super init];
    if (self != nil)
    {
        self.type = kUomRequestEdit;
        self.projectUom = projectUom;
        
        self.uomName = uomName;
        self.uomType = uomType;
        self.uomCategoryId = uomCategoryId;
        self.uomCategoryName = uomCategoryName;
    }
    
    return self;
}


- (BOOL)willStart
{
    self.tableName = @"product.uom";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.uomName, @"name", self.uomType, @"uom_type", self.uomCategoryId, @"category_id", nil];
    
    if (self.type == kUomRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[params]];
    }
    else if (self.type == kUomRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.projectUom.uomID], params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && resultList != nil)
    {
        NSNumber *uomID = nil;
        if (self.type == kUomRequestEdit)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *result = (NSNumber *)resultList;
                if ([result boolValue])
                {
                    uomID = self.projectUom.uomID;
                }
            }
        }
        else if (self.type == kUomRequestCreate)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                uomID = (NSNumber *)resultList;
            }
        }
        
        if (uomID != nil)
        {
            CDProjectUom *uom = [[BSCoreDataManager currentManager] findEntity:@"CDProjectUom" withValue:uomID forKey:@"uomID"];
            if (uom == nil)
            {
                uom = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectUom"];
                uom.uomID = uomID;
            }
            uom.uomName = self.uomName;
            uom.uomType = self.uomType;
            uom.uomCategoryID = self.uomCategoryId;
            uom.uomCategoryName = self.uomCategoryName;
            
            [[BSCoreDataManager currentManager] save:nil];
            
            [params setValue:uom forKey:@"object"];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSUomCreateResponse object:self userInfo:params];
}

@end
