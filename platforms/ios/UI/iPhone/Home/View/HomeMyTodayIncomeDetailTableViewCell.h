//
//  HomeMyTodayIncomeDetailTableViewCell.h
//  Boss
//
//  Created by jimmy on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeMyTodayIncomeDetailTableViewCell;
@protocol HomeMyTodayIncomeDetailTableViewCellDelegate <NSObject>
-(void)didExpandPressedAtIndex:(NSIndexPath*)path isExpand:(BOOL)expand;
@end

@interface HomeMyTodayIncomeDetailTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomeMyTodayIncomeDetailTableViewCellDelegate> delegate;

@property(nonatomic)BOOL isExpand;
@property(nonatomic, strong)NSIndexPath* indexPath;

- (void)setItemInfo:(CDMyTodayInComeItem*)item;
- (void)didCellPressed;

@end