//
//  BSOptionViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSOptionViewController.h"
#import "BSSelectCell.h"

#define kBSOptionCellHeight     50.0

@interface BSOptionViewController ()

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *selectedstr;
@property (nonatomic, strong) NSString *notification;

@end

@implementation BSOptionViewController

- (id)initWithTitle:(NSString *)title options:(NSArray *)options selectedstr:(NSString *)selectedstr notification:(NSString *)notification
{
    self = [super initWithNibName:NIBCT(@"BSOptionViewController") bundle:nil];
    if (self != nil)
    {
        self.title = title;
        self.options = options;
        
        self.selectedstr = selectedstr;
        self.notification = notification;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UITableView *optionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    optionTableView.backgroundColor = [UIColor clearColor];
    optionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    optionTableView.delegate = self;
    optionTableView.dataSource = self;
    optionTableView.showsVerticalScrollIndicator = NO;
    optionTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:optionTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    optionTableView.tableHeaderView = headerView;
}


#pragma mark -
#pragma mark Required Methods


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kBSOptionCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSSelectCellIdentifier";
    BSSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.titleLabel.text = LS([self.options objectAtIndex:indexPath.row]);
    if ([[self.options objectAtIndex:indexPath.row] isEqualToString:self.selectedstr])
    {
        cell.selectImageView.hidden = NO;
    }
    else
    {
        cell.selectImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedstr = [self.options objectAtIndex:indexPath.row];
    [tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self.selectedstr userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
