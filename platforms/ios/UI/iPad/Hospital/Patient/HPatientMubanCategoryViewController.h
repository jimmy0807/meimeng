//
//  HPatientMubanCategoryViewController.h
//  meim
//
//  Created by 波恩公司 on 2018/4/9.
//

#import <UIKit/UIKit.h>

@protocol HPatientMubanCategoryViewControllerDelegate <NSObject>

- (void)didPadCategoryBack;
- (void)didPadCategorySubTotalSelect;
- (void)didPadCategorySubOtherSelect;
- (void)didPadCategoryCellSelect:(CDProjectCategory *)category;

@end

@interface HPatientMubanCategoryViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithBornCategory:(CDBornCategory *)bornCategory;

@property (nonatomic, assign) id<HPatientMubanCategoryViewControllerDelegate> delegate;

@end

