//
//  productModel.m
//  Boss
//
//  Created by jiangfei on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "productModel.h"

@implementation productModel
-(instancetype)initWithDict:(NSMutableDictionary *)dict
{
    return [productModel productModelWithDict:dict];
}
+(instancetype)productModelWithDict:(NSMutableDictionary*)dict
{
    productModel *model = [[self alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
@end
