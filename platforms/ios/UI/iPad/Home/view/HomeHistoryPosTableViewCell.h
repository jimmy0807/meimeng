//
//  HomeHistoryPosTableViewCell.h
//  Boss
//
//  Created by jimmy on 15/10/20.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeHistoryPosTableViewCell;

@protocol HomeHistoryPosTableViewCellDelegate <NSObject>
- (void)didHomeHistoryPosTableViewCellPresssed:(HomeHistoryPosTableViewCell*)cell;
@end

@interface HomeHistoryPosTableViewCell : UITableViewCell

@property(nonatomic, strong)CDPosOperate* operate;
@property(nonatomic, strong)NSIndexPath* indexPath;
@property(nonatomic, weak)id<HomeHistoryPosTableViewCellDelegate> delegate;

- (void)showDate:(NSString*)dateString;
- (void)hideDate;

@end
