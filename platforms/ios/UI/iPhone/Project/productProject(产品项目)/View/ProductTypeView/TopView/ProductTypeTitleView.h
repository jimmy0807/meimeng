//
//  ProductTypeTitleBtnsView.h
//  Boss
//
//  Created by jiangfei on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BornCategoryAll              @"全部"
#define BornCategoryProduct          @"产品"
#define BornCategoryProject          @"项目"
#define BornCategoryCourses          @"疗程"
#define BornCategoryPackage          @"套餐"
#define BornFreeCombination          @"定制组合"
#define BornCategoryPackageKit       @"套盒"
#define BornCategoryCustomPrice      @"定制价格"
#define BornCategoryCardItem         @"卡内项目"



@protocol ProductTypeTitleViewDelegate <NSObject>

@optional
- (void)didSelectedBornCategory:(CDBornCategory *)bornCategory;
- (void)didSelectedCardItem;
- (BOOL)canSelectedBornCategory:(CDBornCategory *)bornCategory;
@end

@interface ProductTypeTitleView : UIView

@property (nonatomic, assign) NSInteger selectedIdx;
@property (nonatomic, weak) id<ProductTypeTitleViewDelegate>delegate;

- (instancetype)initWithCategorys:(NSArray *)categorys;
- (void)reloadWithCategorys:(NSArray *)categorys;

@end
