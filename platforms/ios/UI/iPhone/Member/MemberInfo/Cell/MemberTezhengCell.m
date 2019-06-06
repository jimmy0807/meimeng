//
//  MemberTezhengCell.m
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberTezhengCell.h"

@interface MemberTezhengCell ()
@property (strong, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tailingConstraint;

@end

@implementation MemberTezhengCell


+ (instancetype)createCell
{
    MemberTezhengCell *cell = [self loadFromNib];
    cell.arrowImgViewHidden = true;
    return cell;
}

- (void)setArrowImgViewHidden:(BOOL)arrowImgViewHidden
{
    if (arrowImgViewHidden) {
        self.arrowImgView.hidden = true;
        [self.contentView addConstraint:self.tailingConstraint];
    }
    else
    {
        self.arrowImgView.hidden = false;
        [self.contentView removeConstraint:self.tailingConstraint];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    NSLog(@"---%s--",__FUNCTION__);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
