//
//  BSPosCategoryCreateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSPosCategoryCreateRequest.h"

typedef enum kPosCategoryRequestType
{
    kPosCategoryRequestEdit,
    kPosCategoryRequestCreate
}kPosCategoryRequestType;

@interface BSPosCategoryCreateRequest ()

@property (nonatomic, assign) kPosCategoryRequestType type;
@property (nonatomic, strong) NSNumber *categoryID;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) CDProjectCategory *parent;
@property (nonatomic, strong) NSNumber *sequence;

@end

@implementation BSPosCategoryCreateRequest

- (id)initWithPosCategoryName:(NSString *)name parent:(CDProjectCategory *)parent sequence:(NSNumber *)sequence
{
    self = [super init];
    if (self != nil)
    {
        self.type = kPosCategoryRequestCreate;
        self.categoryName = name;
        self.parent = parent;
        self.sequence = sequence;
    }
    
    return self;
}

- (id)initWithPosCategoryID:(NSNumber *)categoryID categoryName:(NSString *)name parent:(CDProjectCategory *)parent sequence:(NSNumber *)sequence
{
    self = [super init];
    if (self != nil)
    {
        self.type = kPosCategoryRequestEdit;
        self.categoryID = categoryID;
        self.categoryName = name;
        self.parent = parent;
        self.sequence = sequence;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"pos.category";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.categoryName, @"name", [NSNumber numberWithInteger:self.parent.categoryID.integerValue], @"parent_id", self.sequence, @"sequence", nil];
    if (self.type == kPosCategoryRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[params]];
    }
    else if (self.type == kPosCategoryRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.categoryID], params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
        NSNumber *categoryID = nil;
        if (self.type == kPosCategoryRequestEdit)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *result = (NSNumber *)resultList;
                if ([result boolValue])
                {
                    categoryID = self.categoryID;
                }
            }
        }
        else if (self.type == kPosCategoryRequestCreate)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                categoryID = (NSNumber *)resultList;
            }
        }
        
        if (categoryID != nil)
        {
            CDProjectCategory *category = [[BSCoreDataManager currentManager] findEntity:@"CDProjectCategory" withValue:categoryID forKey:@"categoryID"];
            if (category == nil)
            {
                category = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectCategory"];
                category.categoryID = categoryID;
            }
            category.categoryName = self.categoryName;
            category.sequence = self.sequence;
            
            if (self.parent)
            {
                category.parentID = self.parent.categoryID;
                category.parentName = self.parent.categoryName;
                category.parent = self.parent;
            }
            else
            {
                category.parentID = [NSNumber numberWithInteger:0];
                category.parent = nil;
            }
            [[BSCoreDataManager currentManager] save:nil];
            
            [params setValue:category forKey:@"object"];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSPosCategoryCreateResponse object:self userInfo:params];
}

@end
