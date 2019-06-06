//
//  BSProjectTemplateCreateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectTemplateCreateRequest.h"

typedef enum kProjectTemplateRequestType
{
    kProjectTemplateRequestCreate,
    kProjectTemplateRequestEdit
}kProjectTemplateRequestType;

@interface BSProjectTemplateCreateRequest ()

@property (nonatomic, assign) kProjectTemplateRequestType type;
@property (nonatomic, strong) NSNumber *templateID;
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation BSProjectTemplateCreateRequest

- (id)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        self.type = kProjectTemplateRequestCreate;
    }
    
    return self;
}

- (id)initWithProjectTemplateID:(NSNumber *)templateID params:(NSDictionary *)params
{
    self = [super init];
    
    if (self != nil)
    {
        self.params = params;
        self.templateID = templateID;
        self.type = kProjectTemplateRequestEdit;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"product.template";
    
    NSNumber *categoryCode = [self.params objectForKey:@"born_category"];
    if (categoryCode.integerValue == kPadBornCategoryCourses || categoryCode.integerValue == kPadBornCategoryPackage || categoryCode.integerValue == kPadBornCategoryPackageKit)
    {
        self.tableName = @"product.template";
    }
    
    CDBornCategory *bornCategory = [[BSCoreDataManager currentManager] findEntity:@"CDBornCategory" withValue:categoryCode forKey:@"code"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.params];
    [mutableDict setObject:bornCategory.bornCategoryID forKey:@"category_id"];
    self.params = [NSDictionary dictionaryWithDictionary:mutableDict];
    if (self.type == kProjectTemplateRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == kProjectTemplateRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.templateID], self.params]];
    }
    
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (resultStr.length != 0)
    {
        if (self.type == kProjectTemplateRequestEdit)
        {
            NSNumber *isSuccess = (NSNumber *)resultList;
            if (!isSuccess.boolValue)
            {
                params = [self generateResponse:@"服务器异常, 请稍后重试"];
            }
            else
            {
                if ( self.projectTemplate )
                {
                    [[BSCoreDataManager currentManager] deleteObject:self.projectTemplate];
                    [[BSCoreDataManager currentManager] save:nil];
                }
            }
        }
        else if (self.type == kProjectTemplateRequestCreate)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *templateID = (NSNumber *)resultList;
                [params setObject:templateID forKey:@"TemplateID"];
            }
            else
            {
                params = [self generateResponse:@"服务器异常, 请稍后重试"];
            }
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    params[@"isCreat"] = @((self.type == kProjectTemplateRequestCreate) ?1:0);
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectTemplateCreateResponse object:self userInfo:params];
}

@end
