//
//  BSCommonSelectedItemViewController.m
//  Boss
//
//  Created by jimmy on 15/7/3.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCommonSelectedItemViewController.h"
#import "BSSelectCell.h"

@interface BSCommonSelectedItemViewController ()
@property(nonatomic, strong)IBOutlet UITableView *tableView;
@end

@implementation BSCommonSelectedItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    if ( self.hasAddButton )
    {
        BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
        rightButtonItem.delegate = self;
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.navigationItem.title = @"请选择";
  
    
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.tableView.tableHeaderView = headerView;
    
    [self registerNofitificationForMainThread:kBSCommomSelectedDataChanged];
    if (self.notificationName) {
        [self registerNofitificationForMainThread:self.notificationName];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSSelectCellIdentifier";
    BSSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.titleLabel.text = self.dataArray[indexPath.row];
    if ( indexPath.row == self.currentSelectIndex )
    {
        cell.selectImageView.hidden = NO;
    }
    else
    {
        cell.selectImageView.hidden = YES;
    }
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( indexPath.row == self.currentSelectIndex )
        return;
    
    self.currentSelectIndex = indexPath.row;
    
    [tableView reloadData];
    
    [self.delegate didSelectItemAtIndex:indexPath.row userData:self.userData];
    
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.1];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(didAddButtonPressed:)] )
    {
        [self.delegate didAddButtonPressed:self.userData];
    }
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadData
{
    [self.tableView reloadData];
}


#pragma mark - notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSCommomSelectedDataChanged]) {
        self.userData = [notification.userInfo objectForKey:@"userData"];
        self.dataArray = [notification.userInfo objectForKey:@"dataArray"];
        [self reloadData];
    }
    else if ([notification.name isEqualToString:self.notificationName])
    {
        if ([self.delegate respondsToSelector:@selector(willReloadViewController:)]) {
            
            [self.delegate willReloadViewController:self];
            [self reloadData];
        }
        
    }
    
}

@end
