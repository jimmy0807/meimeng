//
//  MemberCardExchangeViewController.m
//  Boss
//  卡交换
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardExchangeViewController.h"
#import "BSEditCell.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "BSMemberCardOperateRequest.h"

typedef enum kSection
{
    kSection_one,
    kSection_num,
    kSection_two,
}kSection;
typedef enum kSectionRow
{
    kSectionRow_mainCardNo,
    kSectionRow_fuCardNo,
    kSectionRow_remark,
    kSectionRow_num,
    
}kSectionRow;


@interface MemberCardExchangeViewController ()
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *cardNo;
@end

@implementation MemberCardExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"卡交换";
    
    self.sureBtn.enabled = false;
    self.hideKeyBoardWhenClickEmpty = true;
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
}

- (void)setCardNo:(NSString *)cardNo
{
    _cardNo = cardNo;
    if (cardNo.length > 0) {
        self.sureBtn.enabled = true;
    }
    else
    {
        self.sureBtn.enabled = false;
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_one) {
        return kSectionRow_num;
    }
    else if (section == kSection_two)
    {
        return 1;
    }
   return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentField.delegate = self;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    cell.arrowImageView.hidden = true;
    cell.scanButton.hidden = true;
    cell.contentField.enabled = false;
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
//    cell.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
    cell.contentField.tag = indexPath.section * 100 + indexPath.row;
    
    if (section == kSection_one) {
        if (row == kSectionRow_mainCardNo) {
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
            cell.titleLabel.text = @"主卡号";
            cell.contentField.text = self.card.cardNo;
            cell.contentField.enabled = false;
            
        }
        else if (row == kSectionRow_fuCardNo)
        {
            
            cell.titleLabel.text = @"副卡编号";
            cell.contentField.enabled = true;
            cell.scanButton.hidden = true;
            cell.contentField.text = self.cardNo;
            
        }
        
        if (row == kSectionRow_remark)
        {
            cell.titleLabel.text = @"备注";
            cell.contentField.enabled = true;
            cell.contentField.text = self.remark;
        }
    }
    else
    {    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    
    if (section == 0) {
        if (row == kSectionRow_mainCardNo) {
            
        }
        else if (row == kSectionRow_fuCardNo)
        {
            NSLog(@"新卡号: %@",textField.text);
            self.cardNo = textField.text;
        }
        else if (row == kSectionRow_remark)
        {
            NSLog(@"备注: %@",textField.text);
            self.remark = textField.text;
        }
    }
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)sureBtnPressed:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.card.cardID forKey:@"card_id"];
    [params setObject:self.cardNo forKey:@"refer_no"];
    if (self.remark.length != 0)
    {
        [params setObject:self.remark forKey:@"remark"];
    }
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateReplacement];
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
//            self.card.cardNo = self.cardNo;
//            self.card.cardNumber = self.cardNo;
            [[[CBMessageView alloc] initWithTitle:@"换卡成功"] show];
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

@end
