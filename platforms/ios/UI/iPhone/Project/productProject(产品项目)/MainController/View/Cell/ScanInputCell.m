//
//  ScanInputCell.m
//  ds
//
//  Created by lining on 2016/10/28.
//
//

#import "ScanInputCell.h"

@interface ScanInputCell ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineTailingConstraint;
@end

@implementation ScanInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setLineLeadingConstant:(CGFloat)lineLeadingConstant
{
    self.lineTailingConstraint.constant = lineLeadingConstant;
}

- (void)setLineTailingConstant:(CGFloat)lineTailingConstant
{
    self.lineTailingConstraint.constant = lineTailingConstant;
}


- (IBAction)scanBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didScanBtnPressedAtIndexPath:)]) {
        [self.delegate didScanBtnPressedAtIndexPath:self.indexPath];
    }
}

@end
