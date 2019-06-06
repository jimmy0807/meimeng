//
//  HomeCurrentPosTableViewCell.h
//  Boss
//
//  Created by jimmy on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeCurrentPosTableViewCell;

@protocol HomeCurrentPosTableViewCellDelegate <NSObject>
- (void)didHomeCurrentPosTableViewCellDeleteButtonPresssed:(HomeCurrentPosTableViewCell*)cell;
- (void)didHomeCurrentPosTableViewCellPresssed:(HomeCurrentPosTableViewCell*)cell;
@end

@interface HomeCurrentPosTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomeCurrentPosTableViewCellDelegate> delegate;
@property(nonatomic, strong, readonly)CDPosOperate* posOperate;
@property(nonatomic, weak)IBOutlet UIImageView* avatarImageView;

@property(nonatomic)BOOL isCurrentPos;

@property(nonatomic, weak)IBOutlet UILabel* currentPosLabel;

- (void)setPosOperate:(CDPosOperate*)posOperate indexPath:(NSIndexPath*)indexPath;

@property(nonatomic, weak)IBOutlet UILabel* numberLabel;

@end
