//
//  HomeTodayIncomeDetailTableViewCell.h
//  Boss
//
//  Created by jimmy on 15/7/22.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTodayIncomeDetailTableViewCell;
@protocol HomeTodayIncomeDetailTableViewCellDelegate <NSObject>
-(void)didExpandPressedAtIndex:(NSIndexPath*)path isExpand:(BOOL)expand;
@end

@interface HomeTodayIncomeDetailTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomeTodayIncomeDetailTableViewCellDelegate> delegate;

@property(nonatomic)BOOL isExpand;
@property(nonatomic, strong)NSIndexPath* indexPath;

- (void)setItemInfo:(CDTodayIncomeItem*)item;
- (void)didCellPressed;

@end
