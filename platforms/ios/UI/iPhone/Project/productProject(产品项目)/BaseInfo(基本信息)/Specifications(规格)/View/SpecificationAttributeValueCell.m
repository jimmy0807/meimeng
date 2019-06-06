//
//  AttributeValueCell.m
//  Boss
//
//  Created by jiangfei on 16/7/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationAttributeValueCell.h"
#import "KeyBordAccessoryView.h"
#import "CDProjectAttributePrice.h"
@interface SpecificationAttributeValueCell ()<UITextFieldDelegate,KeyBordAccessoryViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *attributeLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@end
@implementation SpecificationAttributeValueCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    // Initialization code
    self.priceTextField.delegate = self;
    self.priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    KeyBordAccessoryView *accessView = [KeyBordAccessoryView keyBordAccessoryView];
    accessView.accessoryDelegate = self;
    self.priceTextField.inputAccessoryView = accessView;
    self.priceTextField.returnKeyType = UIReturnKeyDone;
    self.priceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.attributeLabel.textColor = specificationColor;
}
-(void)keyBordAccessoryViewCompleteItemClick
{
    [self.priceTextField endEditing:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.priceTextField endEditing:YES];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setAttributeValue:(CDProjectAttributeValue *)attributeValue
{
    _attributeValue = attributeValue;
   
    self.attributeLabel.text = attributeValue.attributeValueName;
    
    CDProjectAttributePrice *attributePrice = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttributePrice" withValue:attributeValue.attributeValueID forKey:[NSString stringWithFormat:@"templateID == %@ && attributeValueID", self.attributeLine.templateID]];
   
    self.priceTextField.text = [NSString stringWithFormat:@"￥%0.2f",[attributePrice.extraPrice floatValue]];
}
@end
