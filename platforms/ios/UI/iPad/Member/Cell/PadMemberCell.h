//
//  PadMemberCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadMemberCellHeight        178.0

@interface PadMemberCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *birthdayLabel;
@property (nonatomic, strong) UILabel *genderLabel;

@end
