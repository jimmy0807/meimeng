//
//  MemberRecordDetailViewController.m
//  Boss
//
//  Created by lining on 16/4/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberRecordDetailViewController.h"
#import "BSEditCell.h"

@interface MemberRecordDetailViewController ()

@end

@implementation MemberRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowArray = self.sectionArray[section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentField.enabled = false;
        cell.arrowImageView.hidden = true;
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *rowArray = self.sectionArray[section];
    NSDictionary *dict = [rowArray objectAtIndex:row];
    
    cell.titleLabel.text = dict.allKeys.lastObject;
    cell.contentField.text = [NSString stringWithFormat:@"%@", dict.allValues.lastObject];
    
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

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
