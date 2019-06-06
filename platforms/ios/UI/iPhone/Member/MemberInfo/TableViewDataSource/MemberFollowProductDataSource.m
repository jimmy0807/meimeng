//
//  MemberFollowProductDataSource.m
//  Boss
//
//  Created by lining on 16/5/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

typedef enum kSection
{
    kSection_main,
    kSection_other,
    kSection_num
}kSection;

#import "MemberFollowProductDataSource.h"
#import "MemberFollowProductCell.h"
#import "UIView+Frame.h"

@implementation MemberFollowProductDataSource

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_main) {
        if (self.mainProducts.count > 0) {
            return self.mainProducts.count + 1;
        }
        return 0;
    }
    else if (section == kSection_other)
    {
        if (self.otherProducts.count > 0) {
            return self.otherProducts.count + 1;
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *identifier = @"MemberFollowProductCell";
    MemberFollowProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [MemberFollowProductCell createCell];
    }
    cell.nameLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);

    if (section == kSection_main) {
        if (row == 0) {
            cell.nameLabel.textColor = [UIColor grayColor];
            cell.nameLabel.text = @"护理疗程院余(截止上月底/次数)";
            cell.valueLabel.text = @"";
        }
        else
        {
            CDMemberFollowProduct *followProduct = [self.mainProducts objectAtIndex:row - 1];
            cell.nameLabel.text = followProduct.product_name;
            cell.valueLabel.text = [NSString stringWithFormat:@"%@次",followProduct.qty];
        }
    }
    else if (section == kSection_other)
    {
        if (row == 0) {
            cell.nameLabel.textColor = [UIColor grayColor];
            cell.nameLabel.text = @"其它疗程项目";
            cell.valueLabel.text = @"";
        }
        else
        {
//            NSString *name = [self.otherProducts objectAtIndex:row-1];
//            cell.titleLabel.text = name;
//            cell.contentField.text = @"";
            CDMemberFollowProduct *followProduct = [self.otherProducts objectAtIndex:row - 1];
            cell.nameLabel.text = followProduct.product_name;
            cell.valueLabel.text = [NSString stringWithFormat:@"%@次",followProduct.qty];
        }
    }
    
    return  cell;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kSection_main) {
        if (self.mainProducts.count > 0) {
            return 20;
        }
        return 0;
    }
    else if (section == kSection_other)
    {
        if (self.otherProducts.count > 0) {
            return 20;
        }
        return 0;
    }
    return 20;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

@end
