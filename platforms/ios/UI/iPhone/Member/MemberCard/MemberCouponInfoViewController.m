//
//  MemberCouponInfoViewController.m
//  Boss
//
//  Created by lining on 16/8/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCouponInfoViewController.h"
#import "BSEditCell.h"
#import "MemberTezhengCell.h"
#import "MemberCouponProductViewController.h"
#import "BSFetchCouponCardProductRequest.h"

typedef enum InfoSection
{
    InfoSection_one,
    InfoSection_two,
    InfoSection_num
}InfoSection;


typedef enum kSectionOneRow
{
    InfoSection_row_no,
    InfoSection_row_amount,
    InfoSection_row_courseAmount,
    InfoSection_row_date,
    InfoSection_row_num,
}kSectionOneRow;

@interface MemberCouponInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MemberTezhengCell *cell;
@end

@implementation MemberCouponInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = @"优惠券详情";
    
    self.cell = [MemberTezhengCell createCell];
    self.cell.contentLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 20;

}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.couponCard.remark.length > 0) {
        return InfoSection_num;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == InfoSection_one) {
        return InfoSection_row_num;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    if (section == InfoSection_one) {
        static NSString *identifier = @"cell";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentField.enabled = false;
            
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.contentField.font = [UIFont systemFontOfSize:13];
        }
        
        cell.arrowImageView.hidden = true;
        if (row == InfoSection_row_no) {
            cell.titleLabel.text = @"礼品券卡号";
            cell.contentField.text = self.couponCard.cardNumber;
        }
        else if (row == InfoSection_row_amount)
        {
            cell.titleLabel.text = @"礼品卡券金额";
            cell.contentField.text = [NSString stringWithFormat:@"￥%.2f",self.couponCard.remainAmount.floatValue];
        }
        else if (row == InfoSection_row_courseAmount)
        {
            cell.arrowImageView.hidden = false;
            cell.titleLabel.text = @"礼品券内项目价值";
            cell.contentField.text = [NSString stringWithFormat:@"￥%.2f",self.couponCard.courseRemainAmount.floatValue];
        }
        else if (row == InfoSection_row_date)
        {
            cell.titleLabel.text = @"有效期";
            cell.contentField.text = self.couponCard.invalidDate;
        }
        
        return cell;
    }
    else
    {
        MemberTezhengCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberTezhengCell"];
        if (cell == nil) {
            cell = [MemberTezhengCell createCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.nameLabel.text = @"使用条款";
        cell.contentLabel.text = self.couponCard.remark;
        return cell;
    }

    return nil;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == InfoSection_one) {
        return 50;
    }
    else
    {
        self.cell.nameLabel.text = @"使用条款";
        self.cell.contentLabel.text = self.couponCard.remark;
        CGFloat height = [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        NSLog(@"height: %d",height);
        return height;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == InfoSection_one && indexPath.row == InfoSection_row_courseAmount) {
        MemberCouponProductViewController *couponProductVC = [[MemberCouponProductViewController alloc] init];
        couponProductVC.couponCard = self.couponCard;
        [self.navigationController pushViewController:couponProductVC animated:YES];
    }
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
