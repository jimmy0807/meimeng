//
//  BSFetchCardTemplateProductsRequest.m
//  Boss
//
//  Created by lining on 16/4/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchCardTemplateProductsRequest.h"

@interface BSFetchCardTemplateProductsRequest ()
@property (nonatomic, strong) CDCardTemplate *cardTemplate;
@end

@implementation BSFetchCardTemplateProductsRequest

- (instancetype)initWithTemplate:(CDCardTemplate *)cardTemplate
{
    self = [super init];
    if (self) {
        self.cardTemplate = cardTemplate;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.condition.field.line";
    self.filter = @[@[@"weika_id",@"=",self.cardTemplate.template_id]];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldProducts =[NSMutableArray arrayWithArray: [dataManager fetchCardTemplateProducts:self.cardTemplate]];
        for (NSDictionary *params in retArray) {
            NSNumber *line_id = [params numberValueForKey:@"id"];
            CDCardTemplateProduct *templateProduct = [dataManager findEntity:@"CDCardTemplateProduct" withValue:line_id forKey:@"line_id"];
            if (templateProduct == nil) {
                templateProduct = [dataManager insertEntity:@"CDCardTemplateProduct"];
                templateProduct.line_id = line_id;
            }
            else
            {
                [oldProducts removeObject:templateProduct];
            }
            templateProduct.price_unit = [params numberValueForKey:@"price_unit"];
            templateProduct.qty = [params numberValueForKey:@"qty"];
            
            templateProduct.product_id = [params arrayIDValueForKey:@"product_id"];
            templateProduct.product_name = [params arrayNameValueForKey:@"product_id"];
            
            
            templateProduct.template_id = [params arrayIDValueForKey:@"weika_id"];
            templateProduct.template_name = [params arrayNameValueForKey:@"weika_id"];
            
            
        }
        
        [dataManager deleteObjects:oldProducts];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchCardTemplateProductResponse object:nil userInfo:dict];
    
}


@end
