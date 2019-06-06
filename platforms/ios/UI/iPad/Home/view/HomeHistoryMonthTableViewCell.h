//
//  HomeHistoryMonthTableViewCell.h
//  Boss
//
//  Created by jimmy on 15/10/23.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeHistoryMonthTableViewCell;

@protocol HomeHistoryMonthTableViewCellDelegate <NSObject>
- (void)didHomeHistoryPosTableViewYearCellPresssed:(HomeHistoryMonthTableViewCell*)cell inCome:(CDPosMonthIncome*)inCome;
@end

@interface HomeHistoryMonthTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomeHistoryMonthTableViewCellDelegate> delegate;

@property(nonatomic, strong)CDPosMonthIncome* inCome;
@property(nonatomic, strong)NSIndexPath* indexPath;

- (void)showDate:(NSString*)dateString;
- (void)hideDate;

@end
