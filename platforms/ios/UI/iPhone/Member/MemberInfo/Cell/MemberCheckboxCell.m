//
//  MemberCheckboxCell.m
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCheckboxCell.h"
#import "Masonry.h"

@implementation MemberCheckboxCell

+ (instancetype)createCell
{
    MemberCheckboxCell *cell = [self loadFromNib];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    cell.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
    
    return cell;
}

- (void)setCanEdit:(bool)canEdit
{
    _canEdit = canEdit;
    if (_canEdit) {
        self.checkBoxImg.image = [UIImage imageNamed:@"member_checkbox_blue_n.png"];
        self.checkBoxImg.highlightedImage = [UIImage imageNamed:@"member_checkbox_blue_h.png"];
    }
    else
    {
        self.checkBoxImg.image = [UIImage imageNamed:@"member_checkbox_n.png"];
        self.checkBoxImg.highlightedImage = [UIImage imageNamed:@"member_checkbox_h.png"];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.canEdit = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)checkBtnPressed:(UIButton *)sender {
    if (!self.canEdit) {
        return;
    }
    self.checkBoxImg.highlighted = !self.checkBoxImg.highlighted;
    
    if ([self.delegate respondsToSelector:@selector(didCheckboxSelected:indexPath:)]) {
        [self.delegate didCheckboxSelected:self.checkBoxImg.highlighted indexPath:self.indexPath];
    }
}
@end
