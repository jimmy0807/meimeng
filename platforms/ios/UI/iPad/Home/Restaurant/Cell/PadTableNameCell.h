//
//  PadTableNameCell.h
//  Boss
//
//  Created by XiaXianBing on 16-2-25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadTableNameCellWidth      300.0
#define kPadTableNameCellHeight     120.0

@protocol PadTableNameCellDelegate <NSObject>
- (void)didTableNameChanged:(NSString*)name;
@end

@interface PadTableNameCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, assign) id<PadTableNameCellDelegate> delegate;

@end
