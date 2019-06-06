//
//  PadPayAccountDefaultCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadSettingConstant.h"

#define kPadPayAccountDefaultCellWidth      (kPadSettingRightSideViewWidth - 2 * 32.0)
#define kPadPayAccountDefaultCellHeight      60.0

@class PadPayAccountDefaultCell;
@protocol PadPayAccountDefaultCellDelegate <NSObject>
- (void)didPadPayAccountAddButtonClick:(PadPayAccountDefaultCell *)cell;
@end

@interface PadPayAccountDefaultCell : UITableViewCell

@property (nonatomic, assign) kPadPayAccountType accountType;
@property (nonatomic, assign) id<PadPayAccountDefaultCellDelegate> delegate;

@end
