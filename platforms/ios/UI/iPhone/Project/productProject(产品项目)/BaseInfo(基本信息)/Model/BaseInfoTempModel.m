//
//  BaseInfoTempModel.m
//  Boss
//
//  Created by jiangfei on 16/8/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BaseInfoTempModel.h"

@implementation BaseInfoTempModel
-(instancetype)init
{
    if (self = [super init]) {
        self.time = 0;
        self.name = @"";
        self.list_price = 0;
        self.standard_price = 0;
        self.qty_available = 0;
        self.imageUrl = @"";
    }
    return self;
}
@end
