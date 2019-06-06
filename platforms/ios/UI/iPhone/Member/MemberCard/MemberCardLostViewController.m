//
//  MemberCardLostViewController.m
//  Boss
//
//  Created by lining on 16/6/15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardLostViewController.h"
#import "BSMemberCardOperateRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"

@interface MemberCardLostViewController ()
@property (nonatomic, strong) NSString *remark;
@end

@implementation MemberCardLostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"挂失";
    
    self.hideKeyBoardWhenClickEmpty = true;
    self.markTextField.delegate = self;
    
    self.nameLabel.text = @" ";
    self.cardNoLabel.text = self.card.cardNo;
    self.typeLabel.text = self.card.priceList.name;
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.remark = textField.text;
}

#pragma mark - button action
- (IBAction)sureBtnPressed:(id)sender {
    NSLog(@"确认");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.card.cardID forKey:@"card_id"];
    if (self.remark.length != 0)
    {
        [params setObject:self.remark forKey:@"remark"];
    }
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateLost];
    [request execute];
}

#pragma mark NSNotification Methods
- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0)
        {
            [[[CBMessageView alloc] initWithTitle:@"挂失成功"] show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
