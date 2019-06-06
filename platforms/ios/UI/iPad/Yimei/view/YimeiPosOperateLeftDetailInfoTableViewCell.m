//
//  YimeiPosOperateLeftDetailInfoTableViewCell.m
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import "YimeiPosOperateLeftDetailInfoTableViewCell.h"

@interface YimeiPosOperateLeftDetailInfoTableViewCell ()
@property(nonatomic, weak)IBOutlet UIImageView* seperateLine;
@end

@implementation YimeiPosOperateLeftDetailInfoTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.rightLabel.adjustsFontSizeToFitWidth = TRUE;
    self.leftLabel.adjustsFontSizeToFitWidth = TRUE;
}

- (void)showLine:(BOOL)show
{
    self.seperateLine.hidden = !show;
}

@end
