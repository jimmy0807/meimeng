//
//  HomeMemberListTableViewCell.h
//  Boss
//
//  Created by jimmy on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeMemberListTableViewCell;

@protocol HomeMemberListTableViewCellDelegate <NSObject>
- (void)didHomeMemberListTableViewCellChongzhiPresssed:(HomeMemberListTableViewCell*)cell;
- (void)didHomeHomeMemberListTableViewCellPresssed:(HomeMemberListTableViewCell*)cell;
@end

@interface HomeMemberListTableViewCell : UITableViewCell

@property(nonatomic, weak)id<HomeMemberListTableViewCellDelegate> delegate;

@property(nonatomic, strong)CDMemberCard* card;

@property(nonatomic, weak)IBOutlet UIImageView* avatarImageView;
@property(nonatomic, strong, readonly)NSIndexPath* indexPath;

@property(nonatomic)BOOL isSelected;

- (void)setCard:(CDMemberCard *)card indexPath:(NSIndexPath*)indexPath;

@end
