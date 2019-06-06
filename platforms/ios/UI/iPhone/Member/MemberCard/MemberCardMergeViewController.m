//
//  MemberCardMergeViewController.m
//  Boss
//  并卡
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardMergeViewController.h"
#import "BSEditCell.h"
#import "CardMergeCell.h"
#import "BSMemberCardOperateRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"

typedef enum kSection
{
    kSection_cardInfo,
    kSection_cardProject,
    kSection_num
}kSection;

typedef enum kSectionRow
{
    kSectionRow_mainCardNo,
    kSectionRow_fuCardNo,
    KSectionRow_remark,
    kSectionRow_num
}kSectionRow;

@interface MemberCardMergeViewController ()
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *fuCardNo;
@end

@implementation MemberCardMergeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.sureBtn.enabled = false;
    self.hideKeyBoardWhenClickEmpty = true;
    
    self.navigationItem.title = @"并卡";
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
}

- (void)setFuCardNo:(NSString *)fuCardNo
{
    _fuCardNo = fuCardNo;
    if (fuCardNo.length > 0) {
        self.sureBtn.enabled = true;
    }
    else
    {
        self.sureBtn.enabled = false;
    }
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0)
        {
            [[[CBMessageView alloc] initWithTitle:@"并卡成功"] show];
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_cardInfo) {
        return kSectionRow_num;
    }
    else
    {
        return self.card.projects.array.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentField.enabled = true;
        cell.contentField.delegate = self;
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.arrowImageView.hidden = true;
    cell.scanButton.hidden = true;
    
    cell.contentField.tag = indexPath.section * 100 + indexPath.row;
    
    if (section == kSection_cardInfo) {
        if (row == kSectionRow_mainCardNo) {
            cell.titleLabel.text = @"主卡号";
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
            cell.contentField.text = self.card.cardNo;
            cell.contentField.enabled = false;
            
        }
        
        else if (row == kSectionRow_fuCardNo)
        {
            cell.titleLabel.text = @"副卡编号";
            cell.scanButton.hidden = true; //暂时隐藏
            cell.contentField.text = self.fuCardNo;
            cell.contentField.enabled = true;
        }
        else if (row == KSectionRow_remark)
        {
            cell.titleLabel.text = @"备注";
//            cell.contentField.text = ;
            cell.contentField.enabled = true;
            cell.contentField.text = self.remark;
        }
    }
    else if (section == kSection_cardProject)
    {
        CardMergeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardMergeCell"];
        if (cell == nil) {
            cell = [CardMergeCell createCell];
        }
        CDMemberCardProject *project = [self.card.projects.array objectAtIndex:indexPath.row];
        cell.nameLabel.text = project.projectName;
        cell.discountLabel.text = [NSString stringWithFormat:@"折扣：%.2f",[project.discount floatValue]];
       
        cell.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",[project.projectPrice floatValue]];
        cell.countLabel.text = [NSString stringWithFormat:@"%@/%@次",project.remainQty,project.purchaseQty];
        return cell;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    else
    {
        return 80;
    }
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            NSLog(@"副卡号: %@",textField.text);
            self.fuCardNo = textField.text;
        }
        else if (row == KSectionRow_remark)
        {
            NSLog(@"备注: %@",textField.text);
            self.remark = textField.text;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)hideTipButtonPressed:(id)sender {
    
    self.topView.hidden = true;
    [self.view removeConstraint:self.topMarginToTipViewConstraint];
//    self.topViewHeight.constant = 0;
    [UIView animateWithDuration:0.28 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)sureBtnPressed:(UIButton *)sender {
    NSLog(@"sureBtnPressed");
    if (self.fuCardNo.length == 0)
    {
        return;
    }
    
    CDMemberCard *referCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.fuCardNo forKey:@"cardNumber"];
    if (!referCard || referCard.cardID.integerValue == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"副卡不存在"
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.card.cardID forKey:@"card_id"];
    [params setObject:referCard.cardID forKey:@"refer_card_id"];
    if (self.remark.length != 0)
    {
        [params setObject:self.remark forKey:@"remark"];
    }
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateMerger];
    [request execute];
}
@end
