//
//  AttributeLineHeadView.m
//  ds
//
//  Created by lining on 2016/11/3.
//
//

#import "AttributeLineHeadView.h"

@implementation AttributeLineHeadView


- (IBAction)deleteBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didLineHeadDeleteBtnPressedAtIndexPath:)]) {
        [self.delegate didLineHeadDeleteBtnPressedAtIndexPath:self.indexPath];
    }
    if ([self.delegate respondsToSelector:@selector(didLineHeadDeleteAttributeLine:)]) {
        [self.delegate didLineHeadDeleteAttributeLine:self.attributeLine];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
