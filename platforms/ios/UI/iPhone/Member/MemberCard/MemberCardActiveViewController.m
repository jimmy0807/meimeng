//
//  MemberCardActiveViewController.m
//  Boss
//  卡激活
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardActiveViewController.h"
#import "BSMemberCardOperateRequest.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"
#import "BSEditMemberCardRequest.h"

@interface MemberCardActiveViewController ()
@property (nonatomic, strong) NSString *remark;
@end

@implementation MemberCardActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"激活";
    
    self.hideKeyBoardWhenClickEmpty = true;
    self.markTextField.delegate = self;
    
    self.nameLabel.text = @" ";
    self.cardNoLabel.text = self.card.cardNo;
    self.typeLabel.text = self.card.priceList.name;
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    [self registerNofitificationForMainThread:kBSEditMemberCardResponse];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.remark = textField.text;
}

#pragma mark - button action
- (IBAction)sureBtnPressed:(id)sender
{
    [[CBLoadingView shareLoadingView] show];
    
    if ( self.card.state.integerValue == kPadMemberCardStateDraft )
    {
        BSEditMemberCardRequest *request = [[BSEditMemberCardRequest alloc] initWithCard:self.card];
        request.params = @{@"state":@"active"};
        [request execute];
    }
    else
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.card.cardID forKey:@"card_id"];
        if (self.remark.length != 0)
        {
            [params setObject:self.remark forKey:@"remark"];
        }
        
        BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateActive];
        [request execute];
    }
}

#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0)
        {
            [[[CBMessageView alloc] initWithTitle:@"激活成功"] show];
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
    else if ([notification.name isEqualToString:kBSEditMemberCardResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0)
        {
            self.card.state = @(kPadMemberCardStateActive);
            [[[CBMessageView alloc] initWithTitle:@"激活成功"] show];
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
}

@end
