//
//  PadBookProjectViewController.m
//  Boss
//
//  Created by lining on 15/12/16.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadBookProjectViewController.h"

@interface PadBookProjectViewController ()
@property (strong, nonatomic) NSArray *itemArray;
@end

@implementation PadBookProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = true;

    self.itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:[NSArray arrayWithObject:[NSNumber numberWithInt:kPadBornCategoryProject]] categoryIds:nil existItemIds:nil keyword:nil priceAscending:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GiveProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 52)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 101;
        [cell.contentView addSubview:label];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
    CDProjectItem *projectItem = [self.itemArray objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
    label.text = projectItem.itemName;
    
    [self cellBg:cell withRow:indexPath.row minRow:0 maxRow:self.itemArray.count - 1];
    return cell;
}

- (void)cellBg:(UITableViewCell *)cell withRow:(int)row minRow:(int)minRow maxRow:(int)maxRow
{
    if (minRow == maxRow) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
        return;
    }
    if (row == minRow) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
    else if (row == maxRow)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
    else
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectedProjectItem:)]) {
        CDProjectItem *projectItem = [self.itemArray objectAtIndex:indexPath.row];
        [self.delegate didSelectedProjectItem:projectItem];
    }
    [self.navigationController popViewControllerAnimated:YES];

}



- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
