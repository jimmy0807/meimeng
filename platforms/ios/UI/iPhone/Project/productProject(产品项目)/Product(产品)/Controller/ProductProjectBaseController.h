//
//  ProductProjectBaseController.h
//  Boss
//
//  Created by jiangfei on 16/8/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductProjectBaseController : ICCommonViewController
/** temp*/
@property (nonatomic,strong)CDProjectTemplate *baseProjectTemp;
/** 网络请求的参数*/
@property (nonatomic,strong)NSMutableDictionary *parmasDict;
@end
