//
//  courseBaseController.h
//  Boss
//
//  Created by jiangfei on 16/6/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductProjectBaseController.h"
@interface courseBaseController : ProductProjectBaseController
/**  要显示那个子控制器对应的view*/
@property (nonatomic,assign)NSUInteger courseTage;
@end
