//
//  SpecificationAddPropertyBoomView.m
//  Boss
//
//  Created by jiangfei on 16/7/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationAddPropertyBoomView.h"
@interface SpecificationAddPropertyBoomView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
@implementation SpecificationAddPropertyBoomView
+(instancetype)specificationBoomView
{
    SpecificationAddPropertyBoomView *boom = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
   
    return boom;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textField.delegate = self;
    UIView *leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, 0, 10, 1);
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.font = projectContentFont;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.returnKeyType = UIReturnKeyDone;
}
-(void)setPlaceHold:(NSString *)placeHold
{
    _placeHold = placeHold;
    self.textField.placeholder = placeHold;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_beginEditBlock) {
        _beginEditBlock(YES);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_beginEditBlock) {
        _beginEditBlock(NO);
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    if ([_delegate respondsToSelector:@selector(specificationAddPropertyBoomViewCompletionWithText:)]) {
        [_delegate specificationAddPropertyBoomViewCompletionWithText:self.textField.text];
    }
    self.textField.text = nil;
    return YES;
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    //[self.textField endEditing:YES];
    NSLog(@"确定...");
    if ([_delegate respondsToSelector:@selector(specificationAddPropertyBoomViewCompletionWithText:)]) {
        [_delegate specificationAddPropertyBoomViewCompletionWithText:self.textField.text];
    }
    self.textField.text = nil;
}


@end
