//
//  PadCategoryViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadCategoryViewControllerDelegate <NSObject>

- (void)didPadCategoryBack;
- (void)didPadCategorySubTotalSelect;
- (void)didPadCategorySubOtherSelect;
- (void)didPadCategoryCellSelect:(CDProjectCategory *)category;

@end

@interface PadCategoryViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithBornCategory:(CDBornCategory *)bornCategory;

@property (nonatomic, assign) id<PadCategoryViewControllerDelegate> delegate;

@end
