//
//  MemberCardPayViewController.m
//  Boss
//
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardPayViewController.h"
#import "PayTopCell.h"
#import "PayCell.h"
#import "BSEditCell.h"
#import "CardPayCell.h"
#import "MemberCardChangeView.h"

typedef enum kSection
{
    kSection_top,
    kSection_pay,
    kSection_num,
    kSection_other,
}kSection;

@interface MemberCardPayViewController ()<CardPayCellDelegate>
@property (nonatomic, strong) NSArray *payModes;
@end

@implementation MemberCardPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.title = @"支付";
    self.payModes = [[BSCoreDataManager currentManager] fetchPOSPayModeSortByMode];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_top) {
        if (self.amount == 0) {
            return 0;
        }
        return 1;
    }
    else if (section == kSection_pay)
    {
        return self.payModes.count;
    }
    else if (section == kSection_other)
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == kSection_top) {
        static NSString *identifier = @"CardPayTopCell";
        PayTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [PayTopCell createCell];
        }
        if (self.operateType == kPadMemberCardOperateRecharge) {
            cell.titleLabel.text = @"充值";
        }
        else if (self.operateType == kPadMemberCardOperateUpgrade)
        {
            cell.titleLabel.text = @"卡升级";
        }
        cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.amount];
        return cell;
    }
    else if (section == kSection_pay)
    {
        CDPOSPayMode *payMode = [self.payModes objectAtIndex:indexPath.row];
        if (payMode.mode.integerValue == kPadPayModeTypeCard) {
            CardPayCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"CardPayCell"];
            if (payCell == nil) {
                payCell = [CardPayCell createCell];
                payCell.selectionStyle = UITableViewCellSelectionStyleNone;
                payCell.delegate = self;
                
            }
            return payCell;
        }
        else
        {
            static NSString *identifier = @"PayCell";
            PayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [PayCell createCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.payMoney.delegate = self;
            }
            
            if (payMode.mode.integerValue == kPadPayModeTypeCash) {
                cell.icon.image = [UIImage imageNamed:@"member_cash_icon.png"];
            }
            else if (payMode.mode.integerValue == kPadPayModeTypeBankCard)
            {
                cell.icon.image = [UIImage imageNamed:@"member_card_icon.png"];
                
            }
            else if (payMode.mode.integerValue == kPadPayModeTypeWeChat)
            {
                cell.icon.image = [UIImage imageNamed:@"member_weixin_icon.png"];
                
            }
            cell.payLabel.text = payMode.payName;
            return cell;
        }
    }
    else if (section == kSection_other)
    {
        static NSString *identifier = @"other_cell";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentField.enabled = false;
            cell.arrowImageView.hidden = true;
        }
        if (row == 0) {
            cell.titleLabel.text = @"积分";
        }
        else if (row == 1)
        {
            cell.titleLabel.text = @"本次欠款";
        }
        return cell;
    }
    return nil;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSection_top) {
        return 90;
    }
    else if (indexPath.section == kSection_pay)
    {
        if (indexPath.row == 0) {
            return 60;
        }
        return 50;
    }
    else if (indexPath.section == kSection_other)
    {
        return 50;
    }
    return 0;
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



#pragma mark - CardPayCellDelegate
- (void)changeCardPay
{
    [[MemberCardChangeView createView] show];
}


#pragma mark - button action
- (IBAction)didSureBtnPressed:(UIButton *)sender {
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
