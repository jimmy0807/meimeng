//
//  PadSubCategoryViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadSubCategoryViewControllerDelegate <NSObject>

- (void)didPadSubCategoryBack:(CDProjectCategory *)category;
- (void)didPadSubCategorySubTotalSelect:(CDProjectCategory *)category;
- (void)didPadSubCategorySubOtherSelect:(CDProjectCategory *)category;
- (void)didPadSubCategoryCellSelect:(CDProjectCategory *)category;

@end

@interface PadSubCategoryViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithCategory:(CDProjectCategory *)category;

@property (nonatomic, assign) id<PadSubCategoryViewControllerDelegate> delegate;

@end
