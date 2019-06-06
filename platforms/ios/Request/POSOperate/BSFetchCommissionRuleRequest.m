//
//  BSFetchCommissionRuleRequest.m
//  ds
//
//  Created by lining on 16/10/12.
//
//

#import "BSFetchCommissionRuleRequest.h"

@implementation BSFetchCommissionRuleRequest


- (BOOL)willStart
{
    [super willStart];
    self.needCompany = true;
    self.tableName = @"commission.rule";
    self.field = @[@"id",@"name",@"sale_price_sel"];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict;
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldRules = [NSMutableArray arrayWithArray:[dataManager fetchCommissionRules]];
        for (NSDictionary *params in retArray) {
            NSNumber *rule_id = [params numberValueForKey:@"id"];
            CDCommissionRule *rule = [dataManager findEntity:@"CDCommissionRule" withValue:rule_id forKey:@"rule_id"];
            if (rule == nil) {
                rule = [dataManager insertEntity:@"CDCommissionRule"];
                rule.rule_id = rule_id;
            }
            else
            {
                [oldRules removeObject:rule];
            }
            rule.rule_name = [params stringValueForKey:@"name"];
            rule.sale_price_sel = [params stringValueForKey:@"sale_price_sel"];
        }
        [dataManager deleteObjects:oldRules];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败,请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchCommissionRuleResponse object:nil userInfo:dict];
}

@end
