//
//  CombiNetRequestModel.h
//  Boss
//
//  Created by jiangfei on 16/7/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CombiNetRequestModel : NSObject
/**  有效期*/
@property (nonatomic,assign)NSInteger limited_date;
/**  是否不限次数*/
@property (nonatomic,assign)NSInteger limited_qty;
/**  是否等价替换*/
@property (nonatomic,assign)NSInteger same_price_replace;
/**  最高价*/
@property (nonatomic,assign)CGFloat same_price_replace_max;
/**  最低价*/
@property (nonatomic,assign)CGFloat same_price_replace_min;
/** 商品名*/
@property (nonatomic,strong)NSString *productName;
/**  数量*/
@property (nonatomic,assign)NSInteger quantity;
@end
