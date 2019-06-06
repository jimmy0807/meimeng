//
//  SpecificationListController.h
//  Boss
//
//  Created by jiangfei on 16/8/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductProjectBaseController.h"
@class CDProjectAttribute;
@protocol SpecificationListControllerDelegate <NSObject>
@optional
-(void)specificationListDidseletedCellWith:(CDProjectAttribute*)attribute;

@end
@interface SpecificationListController : ProductProjectBaseController
/** 存放所有的attributeId*/
@property (nonatomic,strong)NSMutableArray *attributeIdArray;
/** delegate*/
@property (nonatomic,weak)id<SpecificationListControllerDelegate>delegate;
@end
