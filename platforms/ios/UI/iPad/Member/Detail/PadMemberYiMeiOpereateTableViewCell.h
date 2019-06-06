//
//  PadMemberYiMeiOpereateTableViewCell.h
//  ds
//
//  Created by jimmy on 16/10/21.
//
//

#import <UIKit/UIKit.h>

@class PadMemberYiMeiOpereateTableViewCell;

@protocol PadMemberYiMeiOpereateTableViewCellDelegate <NSObject>
- (void)didPhotoButtonPressed:(PadMemberYiMeiOpereateTableViewCell*)cell;

// 点击术后照
- (void)didAfterPhotoButtonPressed:(PadMemberYiMeiOpereateTableViewCell*)cell;
@end

@interface PadMemberYiMeiOpereateTableViewCell : UITableViewCell

@property(nonatomic, strong)CDPosOperate* operate;
@property(nonatomic)BOOL expand;

@property(nonatomic, weak)id<PadMemberYiMeiOpereateTableViewCellDelegate> delegate;

@end
