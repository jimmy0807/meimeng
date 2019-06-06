//
//  AllocationCell.m
//  Boss
//
//  Created by lining on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "AllocationCell.h"
#import "UIView+LoadNib.h"


@implementation AllocationCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)deleteBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didDeleteBtnPressed:)]) {
        [self.delegate didDeleteBtnPressed:self.indexPath];
    }
}
@end
