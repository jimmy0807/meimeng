//
//  CombiModel.m
//  Boss
//
//  Created by jiangfei on 16/7/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CombiModel.h"

@implementation CombiModel
+(instancetype)combiModelWith:(CDProjectRelated*)related
{
    CombiModel *model = [[self alloc]init];
    model.name = related.productName;
    model.imageUrl = related.item.imageUrl;
    model.price = [related.price floatValue];
    model.num = [related.quantity integerValue];
    model.unitOfNum = related.item.uomName;
    model.related = related;
    return model;
}
+(instancetype)combiModelWithTemplate:(CDProjectTemplate*)temp
{
    CombiModel *model = [[self alloc]init];
    model.name = temp.templateName;
    model.imageUrl = temp.imageUrl;
    model.price = [temp.listPrice floatValue];
    model.num = [temp.qty_available integerValue];
    model.unitOfNum = temp.uomName;
    model.temp = temp;
    return model;
}
@end
