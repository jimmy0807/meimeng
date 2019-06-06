//
//  PadProjectDetailAppointmentCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PadProjectDetailAppointmentCell;
@protocol PadProjectDetailAppointmentCellDelegate <NSObject>

- (void)didShowAndHideAppointmentPickerView:(PadProjectDetailAppointmentCell *)cell;

@end


#define kPadProjectDetailAppointmentCellHeight      88.0

@interface PadProjectDetailAppointmentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *timeTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, assign) id<PadProjectDetailAppointmentCellDelegate> delegate;

@end
