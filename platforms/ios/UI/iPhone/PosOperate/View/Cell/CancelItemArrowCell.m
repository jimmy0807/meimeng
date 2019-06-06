//
//  CancelItemArrowCell.m
//  Boss
//
//  Created by lining on 16/9/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CancelItemArrowCell.h"

@implementation CancelItemArrowCell

- (IBAction)cancelBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didCancelBtnPressedAtIndexPath:)]) {
        [self.delegate didCancelBtnPressedAtIndexPath:self.indexPath];
    }
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
