//
//  AgencyInfoViewController.m
//  Boss
//
//  Created by lining on 15/6/30.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AgencyInfoViewController.h"

#define kMarginSize     12
#define kCellHeight     60

@interface AgencyInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL isFirstLoadView;
    
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation AgencyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    self.hideKeyBoardWhenClickEmpty = true;
    
    self.navigationItem.title = @"代办提醒";
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
        
        CGFloat xCoord = kMarginSize;
        
        UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(xCoord, (kCellHeight - 36)/2.0, 48, 36)];
        picView.image = [UIImage imageNamed:@"project_item_default_48_36"];
        picView.tag = 101;
        picView.layer.masksToBounds = YES;
        picView.layer.cornerRadius = 40/2.0;
        [cell.contentView addSubview:picView];
        
        
        xCoord += 40 + kMarginSize/2.0;
        
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, kCellHeight/2.0, 150, 20.0)];
        nameLabel.highlighted = NO;
        nameLabel.tag = 102;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [cell.contentView addSubview:nameLabel];
        
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, kCellHeight/2.0 - 20, 150, 20.0)];
        detailLabel.tag = 103;
        detailLabel.highlighted = NO;
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:13.0];
        detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [cell.contentView addSubview:detailLabel];
        
        UIImage *stateImage = [UIImage imageNamed:@"order_wait_approve.png"];
        UIImageView *stateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - stateImage.size.width - kMarginSize, (kCellHeight - stateImage.size.height)/2.0, stateImage.size.width, stateImage.size.height)];
        stateImgView.image = stateImage;
        stateImgView.tag = 104;
        [cell.contentView addSubview:stateImgView];
        
        UIImage *arrowImg = [UIImage imageNamed:@"bs_common_arrow.png"];
        
        UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - kMarginSize - arrowImg.size.width, (kCellHeight - arrowImg.size.height)/2.0, arrowImg.size.width, arrowImg.size.height)];
        arrowImgView.image = arrowImg;
        arrowImgView.tag = 105;
        [cell.contentView addSubview:arrowImgView];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.5, self.view.frame.size.width,kCellHeight - 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [cell.contentView addSubview:lineImageView];
    }
    
    UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:101];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:102];
     UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:103];
    UIImageView *stateImgView = (UIImageView *)[cell.contentView viewWithTag:104];
    UIImageView *arrowImgView = (UIImageView *)[cell.contentView viewWithTag:105];
 
    picView.backgroundColor = [UIColor clearColor];
    stateImgView.backgroundColor = [UIColor clearColor];
    arrowImgView.backgroundColor = [UIColor clearColor];
    detailLabel.text = @"05-04 14:24";
    nameLabel.text = @"娜美 同意";
    
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
