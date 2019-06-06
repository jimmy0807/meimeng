//
//  productCategoryController.h
//  Boss
//
//  Created by jiangfei on 16/6/7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductCategoryControllerDelegate<NSObject>

@optional
- (void)didSelectedCategory:(CDProjectCategory *)category;

@end

@interface ProductCategoryController : ICCommonViewController

@property (nonatomic, strong)CDProjectTemplate *projectTemplate;
@property (nonatomic, strong)id<ProductCategoryControllerDelegate>delegate;

/** 当前选中的大分类*/
@property (nonatomic,strong)CDProjectCategory *topCategory;

/** 当前选中的小分类*/
@property (nonatomic,strong)CDProjectCategory *subCategory;



@end
