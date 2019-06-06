//
//  AllotSaleObject.m
//  Boss
//
//  Created by lining on 15/11/5.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "AllotObject.h"

@implementation AllotObject

- (void)setRule_id:(NSNumber *)rule_id
{
    _rule_id = rule_id;
    CDCommissionRule *rule = [[BSCoreDataManager currentManager] findEntity:@"CDCommissionRule" withValue:rule_id forKey:@"rule_id"];
    if (rule == nil) {
        NSLog(@"error:提成的方案为空");
    }
    self.commissionRule = rule;
}

@end
