//
//  SwitchCell.m
//  meim
//
//  Created by lining on 2016/12/14.
//
//

#import "SwitchCell.h"
#import "BSButton.h"

@interface SwitchCell ()
@property (strong, nonatomic) IBOutlet BSButton *swithBtn;

@end

@implementation SwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    self.swithBtn.selected = isOn;
}

- (IBAction)switchBtnPressed:(id)sender {
    self.isOn = !self.isOn;
    if ([self.delegate respondsToSelector:@selector(switchBtnValueChanged:)]) {
        [self.delegate switchBtnValueChanged:self.isOn];
    }
}

@end
