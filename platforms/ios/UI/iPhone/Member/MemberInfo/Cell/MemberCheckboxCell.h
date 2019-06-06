//
//  MemberCheckboxCell.h
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberBaseCell.h"

@protocol CheckBoxCellDelegate <NSObject>
@optional
- (void)didCheckboxSelected:(bool)selected indexPath:(NSIndexPath *)indexPath;

@end

@interface MemberCheckboxCell : UITableViewCell

+ (instancetype)createCell;


@property (assign, nonatomic) bool canEdit;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id <CheckBoxCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkBoxImg;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;
- (IBAction)checkBtnPressed:(UIButton *)sender;

@end
