//
//  HomeYimeiWashTableViewCell.h
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import <UIKit/UIKit.h>

@class HomeYimeiWashTableViewCell;

@protocol HomeYimeiWashTableViewCellDelegate <NSObject>
- (void)didHomeYimeiWashTableViewCellPresssed:(HomeYimeiWashTableViewCell*)cell;
@end

@interface HomeYimeiWashTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomeYimeiWashTableViewCellDelegate> delegate;
@property(nonatomic, weak)IBOutlet UIImageView* avatarImageView;
@property(nonatomic, strong)NSIndexPath* indexPath;
@property(nonatomic, weak)IBOutlet UILabel* numberLabel;
@property(nonatomic, strong, readonly)CDPosWashHand* washHand;

@property(nonatomic)BOOL isSelected;
@property(nonatomic)BOOL isCurrentPos;

- (void)setPosOperate:(CDPosWashHand*)posOperate indexPath:(NSIndexPath*)indexPath;

@end
