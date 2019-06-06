//
//  MemberFeedbackDetailViewController.m
//  Boss
//
//  Created by lining on 16/8/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFeedbackDetailViewController.h"
#import "BSEditCell.h"
#import "MemberTezhengCell.h"
#import "TextViewCell.h"

typedef enum InfoSection
{
    InfoSection_one,
    InfoSection_two,
    InfoSection_num
}InfoSection;


typedef enum kSectionOneRow
{
    InfoSection_row_no,
    InfoSection_row_employee,
    InfoSection_row_member,
    InfoSection_row_date,
    InfoSection_row_num,
}kSectionOneRow;

@interface MemberFeedbackDetailViewController ()
@property (nonatomic, strong) MemberTezhengCell *cell;
@end

@implementation MemberFeedbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.cell = [MemberTezhengCell createCell];
    self.cell.contentLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 20;
    if (self.type == kFeedbackDetailType_Create) {
//        self.feedback = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberFeedback"];
    }
    else
    {
//        self.feedback
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.feedback.note.length > 0) {
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
            cell.titleLabel.text = @"消费单号";
            cell.contentField.text = self.feedback.operate_name;
            cell.arrowImageView.hidden = false;
        }
        else if (row == InfoSection_row_employee)
        {
            cell.titleLabel.text = @"做护理的员工";
            cell.contentField.text = self.feedback.employee_name;
            cell.arrowImageView.hidden = false;
        }
        else if (row == InfoSection_row_member)
        {
            cell.titleLabel.text = @"反馈人";
            cell.contentField.text = self.feedback.member.memberName;
        }
        else if (row == InfoSection_row_date)
        {
            cell.titleLabel.text = @"反馈时间";
            cell.contentField.text = self.feedback.last_update;
        }
        
        return cell;
    }
    else
    {
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewCell"];
        if (cell == nil) {
            cell = [TextViewCell createCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textView.textColor = [UIColor grayColor];
        }
       
        cell.textView.text = self.feedback.note;
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
        return 100;
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
//    if (indexPath.section == InfoSection_one && indexPath.row == InfoSection_row_courseAmount) {
//        MemberCouponProductViewController *couponProductVC = [[MemberCouponProductViewController alloc] init];
//        couponProductVC.couponCard = self.couponCard;
//        [self.navigationController pushViewController:couponProductVC animated:YES];
//    }
}



#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
