//
//  MemberFollowInfoDataSource.m
//  Boss
//
//  Created by lining on 16/5/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFollowInfoDataSource.h"
#import "MemberFollowProductCell.h"

typedef enum kSection
{
    kSection_zero,
    kSection_one,
    kSection_two,
    kSection_three,
    kSection_four,
    kSection_five,
    kSection_num
}kSection;

typedef enum kSection_zero_row
{
    section_row_month,
    section_zero_row_num
}kSection_zero_row;

typedef enum kSection_one_row
{
    section_row_card_amount,
    section_row_yuan_amount,
    section_one_row_num
}kSection_one_row;

typedef enum kSction_two_row
{
    section_row_first_week,
    section_row_second_week,
    section_row_third_week,
    section_row_forth_week,
    section_row_two_margin,
    section_row_yingye,
    section_row_consume,
    section_row_sale,
    section_row_chongzhi,
    section_two_row_num
}kSction_two_row;

typedef enum kSection_three_row
{
    
    section_three_row_num
}kSection_three_row;

typedef enum kSection_four_row
{
    section_row_last_month_yingye,
    section_row_last_month_consume,
    section_row_last_month_sale,
    section_row_last_month_chongzhi,
    section_row_four_margin,
    section_row_last_month_day,
    section_row_last_month_count,
    section_four_row_num
}kSection_four_row;

typedef enum kSection_five_row
{
    
    section_five_row_num
}kSection_five_row;

@implementation MemberFollowInfoDataSource
#pragma mark - UITableViewDataSource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_zero) {
        return section_zero_row_num;
    }
    if (section == kSection_one) {
        return section_one_row_num;
    }
    else if (section == kSection_two)
    {
        return section_two_row_num;
    }
    else if (section == kSection_three)
    {
        return section_three_row_num;
    }
    else if (section == kSection_four)
    {
        return section_four_row_num;
    }
    else if (section == kSection_five)
    {
        return section_five_row_num;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    MemberFollowProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberFollowProductCell"];
    if (cell == nil) {
        cell = [MemberFollowProductCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.otherLabel.text = @"";
    cell.valueLabel.textColor = [UIColor grayColor];
    cell.nameLabel.textColor = COLOR(72, 72, 72, 1);
    cell.nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    if (section == kSection_zero) {
        if (row == section_row_month) {
            cell.valueLabel.textColor = COLOR(72, 72, 72, 1);
            cell.nameLabel.text = @"月份";
            cell.valueLabel.text = self.follow.period_name;
        }
        
    }
    else if (section == kSection_one) {
        
        if (row == section_row_card_amount) {
            cell.nameLabel.text = @"卡内余额";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",self.follow.card_amount.floatValue];
        }
        else if (row == section_row_yuan_amount)
        {
            cell.nameLabel.text = @"院余";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",self.follow.cource_amount.floatValue];
        }
        
        
    }
    else if (section == kSection_two)
    {
        if (row == section_row_first_week)
        {
            cell.nameLabel.text = @"第一周到店次数";
            cell.valueLabel.text = [NSString stringWithFormat:@"%@",self.follow.first_week_come_count];
        }
        else if (row == section_row_second_week)
        {
            cell.nameLabel.text = @"第二周到店次数";
            cell.valueLabel.text = [NSString stringWithFormat:@"%@",self.follow.second_week_come_count];
        }
        else if (row == section_row_third_week)
        {
            cell.nameLabel.text = @"第三周到店次数";
            cell.valueLabel.text = [NSString stringWithFormat:@"%@",self.follow.third_week_come_count];
        }
        else if (row == section_row_forth_week)
        {
            cell.nameLabel.text = @"第四周到店次数";
            cell.valueLabel.text = [NSString stringWithFormat:@"%@",self.follow.fourth_week_come_count];
        }
        else if (row == section_row_two_margin)
        {
            cell.contentView.backgroundColor = COLOR(245, 245, 245, 1);
            cell.nameLabel.text = @"";
            cell.valueLabel.text = @"";
        }
        else if (row == section_row_yingye)
        {
            cell.nameLabel.text = @"营业额";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.follow.yye_amount floatValue]];
        }
        else if (row == section_row_consume)
        {
            cell.nameLabel.text = @"项目消耗";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.follow.hlxf_amount floatValue]];
        }
        else if (row == section_row_sale)
        {
            cell.nameLabel.text = @"产品销售";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.follow.cpxs_amount floatValue]];
        }
        else if (row == section_row_chongzhi)
        {
            NSLog(@"充值");
            cell.nameLabel.text = @"充值";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.follow.czje_amount floatValue]];
        }


    }
    else if (section == kSection_three)
    {
    }
    else if (section == kSection_four)
    {
        if (row == section_row_last_month_yingye)
        {
            cell.nameLabel.text = @"上月营业额";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.follow.last_yye_amount floatValue]];
        }
        else if (row == section_row_last_month_consume)
        {
            cell.nameLabel.text = @"上月项目消耗";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.follow.last_hlxf_amount floatValue]];
        }
        else if (row == section_row_last_month_sale)
        {
            cell.nameLabel.text = @"上月产品销售";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.follow.last_month_cpxs_amount floatValue]];
        }
        else if (row == section_row_last_month_chongzhi)
        {
            cell.nameLabel.text = @"上月充值额";
            cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.follow.last_czje_amount floatValue]];
        }
        else if (row == section_row_four_margin)
        {
            cell.contentView.backgroundColor = COLOR(245, 245, 245, 1);
            cell.nameLabel.text = @"";
            cell.valueLabel.text = @"";
        }
        else if (row == section_row_last_month_day) {
            cell.nameLabel.text = @"最后到店日";
            cell.valueLabel.text = [NSString stringWithFormat:@"%d号",[self.follow.last_month_come_day integerValue]];
        }
        else if (row == section_row_last_month_count)
        {
            cell.nameLabel.text = @"到店总次数";
            cell.valueLabel.text = [NSString stringWithFormat:@"%d次",[self.follow.last_month_come_count integerValue]];
        }
    }
    else if (section == kSection_five)
    {
        
    }
    return  cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kSection_two && row == section_row_two_margin) {
        return 20;
    }
    else if (section == kSection_four && row == section_row_four_margin)
    {
        return 20;
    }
   return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kSection_zero || section == kSection_three) {
        return 0;
    }
    else if (section == kSection_two ||  section == kSection_four)
    {
        return 40;
    }
    
    return 20;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    if (section == kSection_two ||  section == kSection_four)
    {
        view.backgroundColor = COLOR(245, 245, 245, 245);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, (40 - 20)/2.0, IC_SCREEN_WIDTH - 30, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor grayColor];
        [view addSubview:label];
        if (section == kSection_two) {
            label.text = [NSString stringWithFormat:@"数据截止日期: %@",self.follow.follow_date];
        }
        else if (section == kSection_four)
        {
            label.text = @"上月";
        }
    }
    return view;
}

@end
