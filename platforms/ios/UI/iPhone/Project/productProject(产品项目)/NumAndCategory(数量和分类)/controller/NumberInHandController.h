//
//  numInHandController.h
//  Boss
//
//  Created by jiangfei on 16/6/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductProjectBaseController.h"
@class CDProjectTemplate;
@interface NumberInHandController : ProductProjectBaseController
/** 产品*/
@property (nonatomic,strong)NSString *productName;
/**  在手数量*/
@property (nonatomic,assign)NSInteger num;
/** 库位*/
@property (nonatomic,strong)NSString *kuwei;
/**  titleTage*/
@property (nonatomic,assign)NSInteger tage;
/** cdprojectTemp*/
@property (nonatomic,strong)CDProjectTemplate *projectTemp;
@end
