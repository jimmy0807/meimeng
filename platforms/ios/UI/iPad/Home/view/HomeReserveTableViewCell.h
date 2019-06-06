//
//  HomeCurrentPosTableViewCell.h
//  Boss
//
//  Created by jimmy on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeReserveTableViewCell;

@protocol HomeReserveTableViewCellDelegate <NSObject>
- (void)didHomeReserveTableViewCellDeleteButtonPresssed:(HomeReserveTableViewCell*)cell;
- (void)didHomeReserveTableViewCellModifyButtonPresssed:(HomeReserveTableViewCell*)cell;
- (void)didHomeReserveTableViewCellPresssed:(HomeReserveTableViewCell*)cell;
@end

@interface HomeReserveTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomeReserveTableViewCellDelegate> delegate;
@property(nonatomic, strong, readonly)CDBook* book;
@property(nonatomic, weak)IBOutlet UIImageView* avatarImageView;
@property(nonatomic, strong)NSIndexPath* indexPath;
@property(nonatomic, weak)IBOutlet UILabel* numberLabel;

@property(nonatomic)BOOL isSelected;

- (void)setBook:(CDBook*)book indexPath:(NSIndexPath*)indexPath;

@end
