//
//  AttributePriceCell.m
//  ds
//
//  Created by lining on 2016/11/8.
//
//

#import "AttributePriceCell.h"

@implementation AttributePriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceTextField.delegate = self;
    self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceTextField.clearsOnBeginEditing = true;
    self.priceTextField.placeholder = @"附加价格";
    self.priceTextField.textColor = [UIColor grayColor];
    
    [self.titleBtn setTitleColor:COLOR(0, 167, 254, 1) forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setAttributeValue:(BSAttributeValue *)attributeValue
{
    _attributeValue = attributeValue;
    self.priceTextField.text = [NSString stringWithFormat:@"¥%.2f",attributeValue.attributeValueExtraPrice];
    [self.titleBtn setTitle:attributeValue.attributeValueName forState:UIControlStateNormal];
}


#pragma makr -
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGFloat priceValue = textField.text.floatValue;
    textField.text = [NSString stringWithFormat:@"¥%.2f",priceValue];
    self.attributeValue.attributeValueExtraPrice = priceValue;
    if ([self.delegate respondsToSelector:@selector(didEndEditAttributeValue:)]) {
        [self.delegate didEndEditAttributeValue:self.attributeValue];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
