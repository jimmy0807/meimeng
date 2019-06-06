//
//  ProductPicCell.m
//  ds
//
//  Created by lining on 2016/10/28.
//
//

#import "ProductPicCell.h"

@implementation ProductPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)picBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedPicBtnPressed)]) {
        [self.delegate didSelectedPicBtnPressed];
    }
}

@end
