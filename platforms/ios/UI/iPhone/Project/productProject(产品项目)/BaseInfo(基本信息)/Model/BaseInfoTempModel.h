//
//  BaseInfoTempModel.h
//  Boss
//
//  Created by jiangfei on 16/8/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfoTempModel : NSObject
/** 产品名*/
@property (nonatomic,strong)NSString *name;
/**  售价*/
@property (nonatomic,assign)CGFloat list_price;
/**  成本*/
@property (nonatomic,assign)CGFloat standard_price;
/**  在手数量*/
@property (nonatomic,assign)NSInteger qty_available;
/**  项目服务时间*/
@property (nonatomic,assign)NSInteger time;
/** image*/
@property (nonatomic,strong)NSString *imageUrl;

@end
