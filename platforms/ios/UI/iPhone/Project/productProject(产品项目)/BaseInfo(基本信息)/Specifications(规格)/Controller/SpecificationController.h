//
//  SpecificationController.h
//  Boss
//
//  Created by jiangfei on 16/7/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductProjectBaseController.h"
@class CDProjectTemplate;
@protocol specificationControllerDelegate <NSObject>
@optional
//更新了projectTemp
-(void)specificationControllerUpdateProjectTempWith:(CDProjectTemplate*)temp withOrderSet:(NSOrderedSet*)orderSet;

@end
@interface SpecificationController : ProductProjectBaseController
/** delegate*/
@property (nonatomic,weak)id <specificationControllerDelegate> delegate;
@end
