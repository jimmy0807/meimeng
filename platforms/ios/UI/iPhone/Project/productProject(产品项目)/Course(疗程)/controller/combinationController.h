//
//  combinationController.h
//  Boss
//
//  Created by jiangfei on 16/6/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductProjectBaseController.h"
@class combinationController;
@protocol combinationControllerDelegate <NSObject>
/**
 *  获取当前显示的数据源
 */
-(void)combinationControllerDataSourece:(NSArray*)array;

@end
@interface combinationController : ProductProjectBaseController
/** delegate*/
@property (nonatomic,weak)id<combinationControllerDelegate>delegate;
@end
