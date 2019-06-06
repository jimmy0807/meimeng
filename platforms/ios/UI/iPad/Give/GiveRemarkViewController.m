//
//  GiveRemarkViewController.m
//  Boss
//
//  Created by lining on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "GiveRemarkViewController.h"

@interface GiveRemarkViewController ()
{
    bool isEdit;
}
@end

@implementation GiveRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.noKeyboardNotification = YES;
    isEdit = false;
    if (self.remark) {
        isEdit = true;
        self.textView.text = self.remark.text;
    }
    else
    {
        self.remark = [[Remark alloc] init];
    }
    if (self.type == kRemarkType_remark) {
        self.titleLabel.text = @"备注信息";
    }
    else
    {
        self.titleLabel.text = @"条款信息";
    }
    
    
        
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.remark.text = textField.text;
}

#pragma mark - button action

- (IBAction)backBtnPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureBtnPressed:(UIButton *)sender {
    [self.textView resignFirstResponder];
    self.remark.text = self.textView.text;
    if (isEdit) {
        if ([self.delegate respondsToSelector:@selector(didSureEditRemark:type:)]) {
            [self.delegate didSureEditRemark:self.remark type:self.type];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didSureAddRemark:type:)]) {
            [self.delegate didSureAddRemark:self.remark type:self.type];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
