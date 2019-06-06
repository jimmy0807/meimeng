//
//  ApproveStateViewController.m
//  Boss
//
//  Created by lining on 15/6/30.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ApproveStateViewController.h"

#define kMarginSize     20
#define kCellHeight     60

@interface ApproveStateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isFirstLoadView;
    
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation ApproveStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    self.hideKeyBoardWhenClickEmpty = true;
    
    self.navigationItem.title = @"审批状态";
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    isFirstLoadView = true;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
        [self initView];
        isFirstLoadView = false;
    }
}

#pragma mark - init View & Data
- (void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask =0xff& ~UIViewAutoresizingFlexibleTopMargin;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}


- (void)initData
{
    
}


#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    
}

#pragma mark -
#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataArray.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_identifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_n"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_h"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat xCoord = kMarginSize/2;
        
        UIImage *dotLineImg = [UIImage imageNamed:@"order_dot_gray_line.png"];
        UIImageView *dotLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(xCoord, 0, dotLineImg.size.width, kCellHeight)];
        dotLineImgView.tag = 101;
        dotLineImgView.image = dotLineImg;
        [cell.contentView addSubview:dotLineImgView];
        
        
        xCoord += dotLineImg.size.width+4;
        
        UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(xCoord, (kCellHeight - 36)/2.0, 48, 36)];
        picView.image = [UIImage imageNamed:@"project_item_default_48_36"];
        picView.tag = 102;
        picView.layer.masksToBounds = YES;
        picView.layer.cornerRadius = 40/2.0;
        [cell.contentView addSubview:picView];
        
        
        xCoord += 40 + kMarginSize/2.0;
        
        
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, kCellHeight/2.0 - 20, 150, 20.0)];
        dateLabel.tag = 103;
        dateLabel.highlighted = NO;
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:13.0];
        dateLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [cell.contentView addSubview:dateLabel];
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, kCellHeight/2.0, dateLabel.frame.size.width, 20.0)];
        nameLabel.highlighted = NO;
        nameLabel.tag = 104;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [cell.contentView addSubview:nameLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(picView.frame.origin.x, 0.5, self.view.frame.size.width - picView.frame.origin.x, 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        lineImageView.tag = 100;
        [cell.contentView addSubview:lineImageView];
    }
    
    UIImage *dotLineImg;
    dotLineImg = [UIImage imageNamed:@"order_dot_gray_line.png"];
    dotLineImg = [UIImage imageNamed:@"order_dot_blue_line.png"];
    dotLineImg = [UIImage imageNamed:@"order_dot_red_line.png"];
    
    UIImageView *lineImgView = (UIImageView *)[cell.contentView viewWithTag:100];
    UIImageView *dotLineImgView = (UIImageView *)[cell.contentView viewWithTag:101];
    UIImageView *picImgView = (UIImageView *)[cell.contentView viewWithTag:102];
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:104];
    
    dotLineImgView.backgroundColor = [UIColor clearColor];
    picImgView.backgroundColor = [UIColor clearColor];
    
    lineImgView.hidden = false;
    dateLabel.text = @"05-04 14:24";
    nameLabel.text = @"娜美 同意";
  
    
    if (indexPath.row == 0) {
        lineImgView.hidden = true;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view = [[UILabel alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Mermory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
