//
//  GiveTicketProjectViewController.m
//  Boss
//
//  Created by lining on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "GiveTicketProjectViewController.h"
#import "GiveProjectCell.h"

@interface GiveTicketProjectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) NSMutableDictionary *selectedItemDict;
@end

@implementation GiveTicketProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedItemDict = [NSMutableDictionary dictionary];
    self.noKeyboardNotification = YES;
    
    self.itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:[NSArray arrayWithObject:[NSNumber numberWithInt:kPadBornCategoryProject]] categoryIds:nil existItemIds:self.existIds keyword:nil priceAscending:YES];
    
    self.selectedItems = [NSMutableArray array];
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
    GiveProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSLog(@"新建Cell");
        cell = [GiveProjectCell createCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        NSLog(@"重用");
    }
    CDProjectItem *projectItem = [self.itemArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = projectItem.itemName;
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[projectItem.totalPrice floatValue]];
    cell.isSelected = [[self.selectedItemDict objectForKey:@(indexPath.row)] boolValue];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isSelected = [[self.selectedItemDict objectForKey:@(indexPath.row)] boolValue];
    [self.selectedItemDict setObject:@(!isSelected) forKey:@(indexPath.row)];
    
    CDProjectItem *item = [self.itemArray objectAtIndex:indexPath.row];
    
    if (!isSelected) {
        [self.selectedItems addObject:item];
    }
    else
    {
        [self.selectedItems removeObject:item];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backBtnPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSureSeletedItems:)]) {
        [self.delegate didSureSeletedItems:self.selectedItems];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
