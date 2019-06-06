//
//  SelectListViewTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/4/21.
//
//

#import "SelectListViewTableViewCell.h"

@implementation SelectListViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rightLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
