//
//  PosAlloctionGiveViewController.m
//  Boss
//
//  Created by lining on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PosAlloctionGiveViewController.h"
#import "AlloctionGiveCell.h"

@interface PosAlloctionGiveViewController ()
@property(nonatomic, strong) NSMutableDictionary *selectedItemDict;
@end

@implementation PosAlloctionGiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = true;
    self.noKeyboardNotification = true;
    
    self.titleLabel.text = [NSString stringWithFormat:@"已选择%d件",self.giveCount];
    
    self.selectedItemDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.giveCount; i++) {
        [self.selectedItemDict setObject:[NSNumber numberWithBool:true] forKey:[NSNumber numberWithInteger:i]];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.maxGiveCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AlloctionGiveCell";
    AlloctionGiveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSLog(@"新建Cell");
        cell = [AlloctionGiveCell createCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        
    }
    cell.countLabel.text = [NSString stringWithFormat:@"%d件",1];
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.posProduct.money_total floatValue]/[self.posProduct.product_qty integerValue]];
    cell.isSelected = [[self.selectedItemDict objectForKey:@(indexPath.row)] boolValue];
    [self cellBg:cell withRow:indexPath.row minRow:0 maxRow:11];
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
    return 57;
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
    if (!isSelected) {
        self.giveCount ++;
    }
    else
    {
        self.giveCount --;
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"已选择%d件",self.giveCount];
    
    [self.selectedItemDict setObject:@(!isSelected) forKey:@(indexPath.row)];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - btn action
- (IBAction)backBtnPressed:(id)sender {
    NSLog(@"backBtnPressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureBtnPressed:(UIButton *)sender {
    NSLog(@"sureBtnPressed");
    if ([self.delegate respondsToSelector:@selector(didSureGiveCount:)]) {
        [self.delegate didSureGiveCount:self.giveCount];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
