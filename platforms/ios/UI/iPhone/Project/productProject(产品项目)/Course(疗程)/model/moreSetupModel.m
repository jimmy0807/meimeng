//
//  moreSetupModel.m
//  Boss
//
//  Created by jiangfei on 16/6/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "moreSetupModel.h"

@implementation moreSetupModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
//        self.name = dict[@"name"];
//        self.norImageName = dict[@"norImageName"];
//        self.selImageName = dict[@"selImageName"];
//        self.placeHold = dict[@"placeHold"];
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)moreSetupModelWithDict:(NSMutableDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
