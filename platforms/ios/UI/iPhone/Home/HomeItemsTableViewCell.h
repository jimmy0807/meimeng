//
//  HomeItemsTableViewCell.h
//  Boss
//
//  Created by jimmy on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeItemsTableViewCell;

@protocol HomeItemsTableViewCellDelegate <NSObject>
- (void)didItemButtonPressed:(NSInteger)index cell:(HomeItemsTableViewCell*)cell;
@end


@interface HomeItemsTableViewCell : UITableViewCell

@property(nonatomic)id<HomeItemsTableViewCellDelegate> delegate;

- (void)setItemImage:(UIImage*)image atIndex:(NSInteger)index;

@end
