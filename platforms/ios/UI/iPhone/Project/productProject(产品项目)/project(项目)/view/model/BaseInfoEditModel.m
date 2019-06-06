//
//  BaseInfoEditModel.m
//  Boss
//
//  Created by jiangfei on 16/7/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BaseInfoEditModel.h"
#import "MJExtension.h"
@implementation BaseInfoEditModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
   return @{@"name" : @"categoryName"};
}

@end
