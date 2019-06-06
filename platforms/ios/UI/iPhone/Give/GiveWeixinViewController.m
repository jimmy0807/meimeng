//
//  GiveWeixinViewController.m
//  Boss
//
//  Created by lining on 16/9/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveWeixinViewController.h"
#import "InputTextFieldCell.h"
#import "SendStyleRadioCell.h"
#import "TextFieldCell.h"
#import "CBMessageView.h"
#import "FetchWXCouponCardQrUrlRequest.h"
#import "FetchWXCouponCardAddressUrlRequest.h"
#import "CBLoadingView.h"
#import "BSSuccessBtnView.h"
#import "BSSuccessViewController.h"
#import "PosOperateDetailViewController.h"
#import "PhoneGiveViewController.h"
#import "MemberViewController.h"

typedef enum Section
{
    Section_one,
    Section_two,
    Section_num
}Section;




@interface GiveWeixinViewController ()<RadioCellDelegate,BSSuccessViewControllerDelegate>
{
    int section_row_send,section_row_phone,section_row_tip,section_two_num;
}
@property (strong, nonatomic) NSString *memberPhone;
@property (nonatomic, assign) BOOL directSend;
@property (nonatomic, assign) NSInteger kucun;
@property (nonatomic, strong) NSString *qrCodeUrl;

@end

@implementation GiveWeixinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = self.WXTemplate.title;
    
    self.memberPhone = self.givePeople.mobile;
    
    self.kucun = self.WXTemplate.current_quantity;
    
    self.directSend = true;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InputTextFieldCell" bundle:nil] forCellReuseIdentifier:@"InputTextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SendStyleRadioCell" bundle:nil] forCellReuseIdentifier:@"SendStyleRadioCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self registerNofitificationForMainThread:kFetchWXCouponCardQrUrlResponse];
    [self registerNofitificationForMainThread:kFetchWXCouponCardAddressUrlResponse];
}

- (void)setDirectSend:(BOOL)directSend
{
    _directSend = directSend;
    if (_directSend) {
        section_row_send = 0;
        section_row_phone = 1;
        section_row_tip = 2;
        section_two_num = 3;
    }
    else
    {
        section_row_phone = -1;
        section_row_send = 0;
        section_row_tip = 1;
        section_two_num = 2;
    }
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchWXCouponCardQrUrlResponse]) {
        [[CBLoadingView shareLoadingView] hide];
        NSNumber *ret = [notification.userInfo numberValueForKey:@"rc"];
        if (ret.integerValue == 0  ) {
//            [CBMessageView alloc] initWith
            BSSuccessViewController *successVC  = [BSSuccessViewController createViewControllerWithTopTip:nil contentTitle:@"赠送成功" detailTitle:@"优惠券1张"];
            successVC.operate = self.givePeople.operate;
            successVC.member = self.givePeople.member;
            successVC.delegate = self;
            successVC.style = ViewShowStyle_Give;
            [self.navigationController pushViewController:successVC animated:YES];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
    else if ([notification.name isEqualToString:kFetchWXCouponCardAddressUrlResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        NSDictionary* retDict = notification.userInfo;
        if ([retDict isKindOfClass:[NSDictionary class]])
        {
            NSNumber *errorRet = [retDict numberValueForKey:@"errcode"];
            if (errorRet.integerValue == 0)
            {
                NSDictionary* params = retDict[@"data"];
                if ( [params isKindOfClass:[NSDictionary class]] )
                {
                    self.qrCodeUrl = params[@"url"];
                    NSLog(@"url: %@",self.qrCodeUrl);
                    
                    BSSuccessViewController *successVC  = [BSSuccessViewController createViewControllerWithQRUrl:self.qrCodeUrl];
                    successVC.style = ViewShowStyle_Give;
                    successVC.operate = self.givePeople.operate;
                    successVC.member = self.givePeople.member;
                    successVC.delegate = self;
                    [self.navigationController pushViewController:successVC animated:YES];
                    
                }
                else
                {
                    [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
                }
            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Section_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == Section_one) {
        return 1;
    }
    else if (section == Section_two)
    {
        return section_two_num;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == Section_one) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"总库存";
        cell.valueTextFiled.delegate = self;
        cell.valueTextFiled.text = [NSString stringWithFormat:@"%@",self.kucun];
        cell.valueTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        cell.valueTextFiled.tag = 100 * section + row;
        return cell;
    }
    else if (section == Section_two)
    {
        if (row == section_row_send) {
            SendStyleRadioCell *radioCell = [tableView dequeueReusableCellWithIdentifier:@"SendStyleRadioCell"];
            radioCell.selectionStyle = UITableViewCellSelectionStyleNone;
            radioCell.delegate = self;
            radioCell.isDirectSend = self.directSend;
            return radioCell;
        }
        else if (row == section_row_phone)
        {
            InputTextFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InputTextFieldCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.placeholder = @"请输入您的电话号码";
            cell.textField.tag = 100 * section + row;
            cell.textField.text = self.memberPhone;
            cell.textField.delegate = self;
            if (self.memberPhone.length == 0) {
                NSLog(@"_______________");
                [self performSelector:@selector(textFieldBecomeFirstResponser:) withObject:cell.textField afterDelay:0.5];
                [cell.textField becomeFirstResponder];
            }
            return cell;
        }
        else if (row == section_row_tip)
        {
//            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
            cell.textLabel.textColor = [UIColor redColor];
            if (self.directSend) {
                cell.textLabel.text = @"提示：在微信公众号中领取优惠券";
            }
            else
            {
                cell.textLabel.text = @"提示：生成二维码，扫一扫领取优惠券";
            }
            return cell;
        }
    }
    return nil;
}

- (void)textFieldBecomeFirstResponser:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == Section_one) {
        return 50;
    }
    else if (section == Section_two)
    {
        if (row == section_row_send) {
            return 50;
        }
        else if (row == section_row_phone)
        {
            return 55;
        }
        else if (row == section_row_tip)
        {
            return 40;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    return view;
}

#pragma mark - RadioCellDelegate
- (void)isDirectedSend:(BOOL)isDirectSend
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.directSend = isDirectSend;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:Section_two] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    if (section == Section_one) {
        self.kucun = textField.text.integerValue;
        textField.text = [NSString stringWithFormat:@"%d",self.kucun];
    }
    else if (section == Section_two)
    {
        if (row == section_row_phone) {
            self.memberPhone = textField.text;
        }
    }
}

#pragma mark - btn action
- (IBAction)sendBtnPressed:(id)sender {
    if (self.directSend) {
        if (self.memberPhone.length == 0) {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"直接赠送需要填写电话号码"];
            [messageView show];
        }
        FetchWXCouponCardQrUrlRequest *request = [[FetchWXCouponCardQrUrlRequest alloc] initWithWxCardTemplates:@[self.WXTemplate] phoneNumber:self.memberPhone];
        [request execute];
        [[CBLoadingView shareLoadingView] show];
    }
    else
    {
        FetchWXCouponCardAddressUrlRequest *reqeust = [[FetchWXCouponCardAddressUrlRequest alloc] initWithWxCardTemplates:@[self.WXTemplate] phoneNumber:self.memberPhone];
        [reqeust execute];
        [[CBLoadingView shareLoadingView] show];
    }
}

#pragma mark - BSSuccessViewControllerDelegate
- (void)didCashierBtnPressed
{
   [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPushToCashier object:nil];
}



- (void)didAssignBtnPressed
{
    BOOL hasOperate;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[PosOperateDetailViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            hasOperate = true;
            break;
        }
    }
    if (!hasOperate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushToAssign object:nil];
    }
}

- (void)didSendBtnPressed
{
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[PhoneGiveViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
    
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
