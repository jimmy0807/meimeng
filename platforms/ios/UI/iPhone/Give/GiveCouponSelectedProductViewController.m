//
//  GiveCouponSelectedProductViewController.m
//  Boss
//
//  Created by lining on 16/9/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveCouponSelectedProductViewController.h"
#import "GiveProjectCell.h"
#import "BSFetchGiveProjectRequest.h"
#import "SelectedItemCell.h"

@interface GiveCouponSelectedProductViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *selectedItemDict;

@end

@implementation GiveCouponSelectedProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = @"选择项目";
    
    self.selectedItems = [NSMutableArray array];
    self.selectedItemDict = [NSMutableDictionary dictionary];
    
    [self reloadData];
    
    [self registerNofitificationForMainThread:kBSFetchGiveProjectResponse];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectedItemCell" bundle:nil] forCellReuseIdentifier:@"SelectedItemCell"];
}

#pragma mark - reloadData
- (void)reloadData
{
    self.itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:[NSArray arrayWithObject:[NSNumber numberWithInt:kPadBornCategoryProject]] categoryIds:nil existItemIds:self.existIds keyword:nil priceAscending:YES];
    
    [self.tableView reloadData];
}

#pragma mark - sendRequest
- (void)sendRequest
{
    BSFetchGiveProjectRequest *request = [[BSFetchGiveProjectRequest alloc] init];
    [request execute];
}

#pragma mark - receivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    NSInteger ret = [[notification.userInfo numberValueForKey:@"rc"] integerValue];
    if (ret == 0) {
        [self reloadData];
    }
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
    SelectedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectedItemCell"];
//    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    CDProjectItem *projectItem = [self.itemArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = projectItem.itemName;
    cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[projectItem.totalPrice floatValue]];
    cell.imgView.highlighted = [[self.selectedItemDict objectForKey:@(indexPath.row)] boolValue];
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



#pragma mark - btn action
- (IBAction)sureBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSureSeletedItems:)]) {
        [self.delegate didSureSeletedItems:self.selectedItems];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
