//
//  YimeiPosOperateLeftDetailFumaTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/5/25.
//
//

#import "YimeiPosOperateLeftDetailFumaTableViewCell.h"

@implementation YimeiPosOperateLeftDetailFumaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didRightLabelPressed:(id)sender
{
    self.rightLabelClick();
}

@end
