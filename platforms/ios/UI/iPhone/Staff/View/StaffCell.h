//
//  StaffCell.h
//  Boss
//
//  Created by lining on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StaffCellDelegate <NSObject>
@optional
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface StaffCell : UITableViewCell
@property(nonatomic, strong) UIImageView *headImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *IDLable;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong) UIImageView *lineImgView;

@property(nonatomic, assign) id<StaffCellDelegate>delegate;

+(CGFloat)height;

@end
