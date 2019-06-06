//
//  productCategoryLeftController.h
//  Boss
//
//  Created by jiangfei on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CategoryLeftControllerDelegate <NSObject>
@optional
- (void)didSelectedLeftCategory:(CDProjectCategory *)category categoryIds:(NSArray *)categoryIds;

@end

@interface ProductCategoryLeftController : ICCommonViewController

@property (nonatomic, strong) CDBornCategory *bornCategory;
@property (nonatomic, weak) id<CategoryLeftControllerDelegate>delegate;
@end
