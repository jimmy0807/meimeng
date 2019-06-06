//
//  CombiModel.h
//  Boss
//
//  Created by jiangfei on 16/7/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CDProjectRelated;
@class CDProjectTemplate;
@interface CombiModel : NSObject
/** 图片Url*/
@property (nonatomic,strong)NSString *imageUrl;
/** 名字*/
@property (nonatomic,strong)NSString *name;
/** 价格*/
@property (nonatomic,assign)CGFloat price;
/**  数量*/
@property (nonatomic,assign)NSInteger num;
/** 单位*/
@property (nonatomic,strong)NSString *unitOfNum;
/** CDProjectRelated*/
@property (nonatomic,strong)CDProjectRelated *related;
/** CDProjectTemplate*/
@property (nonatomic,strong)CDProjectTemplate *temp;
+(instancetype)combiModelWith:(CDProjectRelated*)related;
+(instancetype)combiModelWithTemplate:(CDProjectTemplate*)temp;
@end
