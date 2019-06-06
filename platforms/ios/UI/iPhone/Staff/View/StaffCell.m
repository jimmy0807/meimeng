//
//  StaffCell.m
//  Boss
//
//  Created by lining on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "StaffCell.h"
#import "UIImage+Resizable.h"

#define kMarginSize 15
#define kCellHeight 60

@implementation StaffCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *normalImg = [[UIImage imageNamed:@"staff_listbg_N.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 100, 10, 20)];
        UIImage *highlightImg = [[UIImage imageNamed:@"staff_listbg_H.png"]imageResizableWithCapInsets:UIEdgeInsetsMake(10, 100, 10, 20)];
        
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, kCellHeight);
        [bgBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
        [bgBtn setBackgroundImage:highlightImg forState:UIControlStateHighlighted];
        [bgBtn addTarget:self action:@selector(bgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bgBtn];
        
        UIImage *defaultImg = [UIImage imageNamed:@"user_default.png"];
        self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginSize + 1.5, (kCellHeight - defaultImg.size.height)/2.0, defaultImg.size.width, defaultImg.size.height)];
        self.headImgView.image = defaultImg;
        [self.contentView addSubview:self.headImgView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.frame.size.width + self.headImgView.frame.origin.x + kMarginSize + 5, kMarginSize/2.0+4, 200, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.IDLable = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x + 18, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y-1, 100, 20)];
        self.IDLable.backgroundColor = [UIColor clearColor];
        self.IDLable.font = [UIFont systemFontOfSize:13];
        self.IDLable.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.IDLable];
        
        
        UIImage *accesoryImg = [UIImage imageNamed:@"user_arrow.png"];
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - accesoryImg.size.width - 10, (kCellHeight - accesoryImg.size.height)/2.0, accesoryImg.size.width, accesoryImg.size.height)];
        accessoryImgView.image = accesoryImg;
        [self.contentView addSubview:accessoryImgView];
        
        UIImage *lineImg = [[UIImage imageNamed:@"staff_line.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 1)];
        self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kCellHeight - 1, IC_SCREEN_WIDTH, 1)];
        self.lineImgView.image = lineImg;
        [self.contentView addSubview:self.lineImgView];
    }
    
    return self;
}

+ (CGFloat)height
{
    return kCellHeight;
}

- (void)bgBtnPressed:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didSelectedAtIndexPath:)]) {
        [self.delegate didSelectedAtIndexPath:self.indexPath];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
