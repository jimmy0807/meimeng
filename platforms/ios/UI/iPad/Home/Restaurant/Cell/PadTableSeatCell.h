//
//  PadTableSeatCell.h
//  Boss
//
//  Created by XiaXianBing on 16-2-25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadTableSeatCellWidth      300.0
#define kPadTableSeatCellHeight     120.0

@protocol PadTableSeatCellDelegate <NSObject>

- (void)didTableSeatsMinus;
- (void)didTableSeatsPlus;
- (void)didTableSeatsCountChanged:(NSInteger)count;

@end

@interface PadTableSeatCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, assign) id<PadTableSeatCellDelegate> delegate;

@end
