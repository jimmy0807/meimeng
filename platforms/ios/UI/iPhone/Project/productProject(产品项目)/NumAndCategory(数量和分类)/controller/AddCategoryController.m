//
//  addLargeCategoryController.m
//  Boss
//
//  Created by jiangfei on 16/6/7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "AddCategoryController.h"
#import "BSPosCategoryCreateRequest.h"
#import "MBProgressHUD+MJ.h"
@interface AddCategoryController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sequenceTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *xuhaoLabel;

@end

@implementation AddCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    if (self.parentCategory == nil) {
        self.title = @"新增大分类";
    }
    else
    {
        self.title = @"新增小分类";
    }

    [self initView];
   

    [self registerNofitificationForMainThread:kBSPosCategoryCreateResponse];
}

#pragma mark - initView
- (void)initView
{
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.sequenceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.nameLabel.font = projectTitleFont;
//    self.xuhaoLabel.font = self.nameLabel.font;
//    self.nameTextField.font = projectContentFont;
//    self.sequenceTextField.font = self.nameTextField.font;
    
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    self.sequenceTextField.returnKeyType = UIReturnKeyDone;
    
    self.nameTextField.delegate = self;
    self.sequenceTextField.delegate = self;
    
    self.nameTextField.tag = 101;
    self.sequenceTextField.tag = 101;
}

#pragma mark - receivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0)
    {
        [MBProgressHUD showSuccess:@"添加完成"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [MBProgressHUD  showError:notification.userInfo[@"rm"]];
    }

}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 102) {
        textField.text = [NSString stringWithFormat:@"%d",textField.text.integerValue];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - button action
- (IBAction)sureBtnClick:(UIButton *)sender {
   
    if (self.nameTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入名称"];
        return;
    }
    BSPosCategoryCreateRequest *request = [[BSPosCategoryCreateRequest alloc] initWithPosCategoryName:self.nameTextField.text parent:self.parentCategory sequence:@([self.sequenceTextField.text integerValue])];
      [request execute];
}
@end
