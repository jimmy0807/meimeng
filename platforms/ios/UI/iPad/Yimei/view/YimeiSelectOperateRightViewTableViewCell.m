//
//  YimeiSelectOperateRightViewTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/4/24.
//
//

#import "YimeiSelectOperateRightViewTableViewCell.h"

@implementation YimeiSelectOperateRightViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didButtonPressed:(UIButton*)sender
{
    self.selectedAtIndex(sender.tag - 1000);
}

@end
