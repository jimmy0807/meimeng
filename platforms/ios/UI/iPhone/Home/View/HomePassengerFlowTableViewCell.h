//
//  HomePassengerFlowTableViewCell.h
//  Boss
//
//  Created by jimmy on 15/7/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomePassengerFlowTableViewCell;
@protocol HomePassengerFlowTableViewCellDelegate <NSObject>
-(void)didExpandPressedAtIndex:(NSIndexPath*)path isExpand:(BOOL)expand;
@end

@interface HomePassengerFlowTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomePassengerFlowTableViewCellDelegate> delegate;

@property(nonatomic)BOOL isExpand;
@property(nonatomic, strong)NSIndexPath* indexPath;

- (void)setItemInfo:(CDPassengerFlow*)item;
- (void)didCellPressed;

@end
