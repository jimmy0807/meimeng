//
//  InputDiscountViewController.m
//  Boss
//
//  Created by lining on 16/8/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "InputDiscountViewController.h"

@interface InputDiscountViewController ()
@property (nonatomic, assign) CGFloat discount;
@end

@implementation InputDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = LS(@"输入折扣");
    
    self.hideKeyBoardWhenClickEmpty = true;
    
    self.discountTextField.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.discountTextField becomeFirstResponder];
}


#pragma mark - btn action
- (IBAction)sureBtnPressed:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [self.discountTextField resignFirstResponder];
    
//    self.discount = self.discountTextField.text.floatValue;
    if ([self.delegate respondsToSelector:@selector(inputDiscountDone:)]) {
        [self.delegate inputDiscountDone:self.discount];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.discount = textField.text.floatValue;
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
