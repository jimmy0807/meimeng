//
//  productCategoryRightController.h
//  Boss
//
//  Created by jiangfei on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryRightControllerDelegate <NSObject>
@optional
- (void)didSelectedRightCategory:(CDProjectCategory *)category categoryIds:(NSArray *)categoryIds hide:(BOOL)hide;
@end

@interface ProductCategoryRightController : ICCommonViewController
/**  点击了那个titleBtn*/
@property (nonatomic,assign)NSInteger titleBtnTag;
@property (nonatomic, weak) id<CategoryRightControllerDelegate>delegate;
@property (nonatomic, strong) CDProjectCategory *parentCategory;

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) CDBornCategory * bornCategory;
@property (nonatomic, assign) BOOL isRightTop;

- (void)reloadData;

@end
