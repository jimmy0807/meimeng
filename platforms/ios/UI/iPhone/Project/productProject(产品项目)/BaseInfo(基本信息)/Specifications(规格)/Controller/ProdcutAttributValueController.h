//
//  ProdcutAttributValueController.h
//  Boss
//
//  Created by jiangfei on 16/7/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductProjectBaseController.h"
@class SpecificationEditModel;
@protocol ProdcutAttributValueControllerDelegate <NSObject>
@optional
/**
 *  updateAttributeLine
 */
-(void)prodcutAttributValueControllerWith:(SpecificationEditModel*)line;

@end
@interface ProdcutAttributValueController : ProductProjectBaseController
///** CDProjectAttributeLine*/
//@property (nonatomic,strong)CDProjectAttributeLine *attributeLine;
/** SpecificationEditModel*/
@property (nonatomic,strong)SpecificationEditModel *editModel;
/** delegate*/
@property (nonatomic,weak)id<ProdcutAttributValueControllerDelegate>delegate;
@end
