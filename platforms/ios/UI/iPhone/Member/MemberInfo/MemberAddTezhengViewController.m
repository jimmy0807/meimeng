//
//  MemberAddTezhengViewController.m
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberAddTezhengViewController.h"
#import "BSCreateExtendedRequest.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"
#import "BSFetchExtendRequest.h"

@interface MemberAddTezhengViewController ()<UITextViewDelegate>
{
    BNRightButtonItem *rightBtnItem;
}
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, assign) bool isChanged;

@end

@implementation MemberAddTezhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backButtonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;

    
    rightBtnItem= [[BNRightButtonItem alloc] initWithTitle:@"完成"];
    rightBtnItem.delegate = self;
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.title = @"新建属性";
    
    self.nameField.delegate = self;
    self.describleTextView.delegate = self;
    
    self.params = [NSMutableDictionary dictionary];
    
    [self registerNofitificationForMainThread:kBSCreateExtendedResponse];
}

- (void)setIsChanged:(bool)isChanged
{
    _isChanged = isChanged;
    if (self.params.allKeys.count > 0) {
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


#pragma mark - RightBarButtonPressed
- (void)didRightBarButtonItemClick:(id)sender
{
    if ([[self.params stringValueForKey:@"name"] length] == 0) {
        [[[CBMessageView alloc] initWithTitle:@"名字不能为空"] show];
    }
    BSCreateExtendedRequest *request = [[BSCreateExtendedRequest alloc] initWithParams:self.params];
    [request execute];
    [[CBLoadingView shareLoadingView] show];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSCreateExtendedResponse]) {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] == 0) {
            [[[CBMessageView alloc] initWithTitle:@"新建成功"] show];
            
            [[[BSFetchExtendRequest alloc] init] execute];
            
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@1 afterDelay:1.5];
        }
        else
        {
             [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self.params removeObjectForKey:@"name"];
        self.isChanged = true;
        return;
    }
    else
    {
        [self.params setObject:textField.text forKey:@"name"];
        self.isChanged = true;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [self.params removeObjectForKey:@"description"];
        self.isChanged = true;
        return;
    }
    else
    {
        [self.params setObject:textView.text forKey:@"description"];
        self.isChanged = true;
    }
}

- (IBAction)hideKeyboard:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
