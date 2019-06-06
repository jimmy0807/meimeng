//
//  PadPayAccountExistCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadSettingConstant.h"

#define kPadPayAccountExistCellWidth      (kPadSettingRightSideViewWidth - 2 * 32.0)
#define kPadPayAccountExistCellHeight      152.0

@class PadPayAccountExistCell;
@protocol PadPayAccountExistCellDelegate <NSObject>
- (void)didPadPayAccountDeleteButtonClick:(PadPayAccountExistCell *)cell;
@end

@interface PadPayAccountExistCell : UITableViewCell

@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, assign) kPadPayAccountType accountType;
@property (nonatomic, assign) id<PadPayAccountExistCellDelegate> delegate;

@end
