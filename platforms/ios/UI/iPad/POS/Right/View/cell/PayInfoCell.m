//
//  PayInfoCell.m
//  Boss
//
//  Created by lining on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PayInfoCell.h"
#import "UIView+LoadNib.h"

@implementation PayInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.nameLabel.adjustsFontSizeToFitWidth = TRUE;
}

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
