//
//  ProviderViewController.m
//  Boss
//
//  Created by lining on 15/6/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ProviderViewController.h"
#import "BSFetchProviderRequest.h"
#import "ProviderDetailViewController.h"
#import "CreateProviderViewController.h"
#import "CBLoadingView.h"

#define kCellHeight  60
#define kMarginSize  20
#define kLogoSize   40

@interface ProviderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isFirstLoadView;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSMutableDictionary *cachePicParams;
@end

@implementation ProviderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"供应商";
    isFirstLoadView = true;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self initData];
    [self registerNofitificationForMainThread:kBSFetchProviderRequest];
    [self registerNofitificationForMainThread:kBSCreateProviderResponse];
    
//    if (self.dataArray.count == 0) {
//       
//    }
    [[CBLoadingView shareLoadingView] show];
    BSFetchProviderRequest *request = [[BSFetchProviderRequest alloc] init];
    [request execute];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (isFirstLoadView) {
        [self initView];
        isFirstLoadView = false;
    }
}

#pragma mark - init view & data
- (void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

- (void) initData
{
    BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
    self.dataArray = [dataManager fetchAllProviders];
    
}


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    NSLog(@"right button pressed");
//    CreatePurchaseOrderViewController *createPurchaseVC = [[CreatePurchaseOrderViewController alloc] initWithNibName:NIBCT(@"CreatePurchaseOrderViewController") bundle:nil];
//    [self.navigationController pushViewController:createPurchaseVC animated:YES];
    CreateProviderViewController *createProviderVC = [[CreateProviderViewController alloc] initWithNibName:NIBCT(@"CreateProviderViewController") bundle:nil];
    [self.navigationController pushViewController:createProviderVC animated:YES];
}

#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchProviderRequest]) {
        [[CBLoadingView shareLoadingView] hide];
        [self initData];
        [self.tableView reloadData];
    }
    else if ([notification.name isEqualToString:kBSCreateProviderResponse])
    {
        BSFetchProviderRequest *request = [[BSFetchProviderRequest alloc] init];
        [request execute];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"indentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_n"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_h"]];
        
        
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0, IC_SCREEN_WIDTH, 0.5)];
        topLine.backgroundColor = [UIColor clearColor];
        topLine.tag = 99;
        topLine.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [cell.contentView addSubview:topLine];
        
        UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginSize, (kCellHeight - kLogoSize)/2.0, kLogoSize, kLogoSize)];
        logoImgView.image = [UIImage imageNamed:@"order_provider_logo.png"];
        logoImgView.tag = 100;
        logoImgView.layer.cornerRadius = kLogoSize/2.0;
        logoImgView.layer.masksToBounds = YES;
        [cell.contentView addSubview:logoImgView];
        
        UIImage *arrowImage = [UIImage imageNamed:@"project_item_arrow"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize + kLogoSize + kMarginSize, kCellHeight/2.0 - 20.0 + 2.0, self.tableView.frame.size.width - 15 - arrowImage.size.width, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.tag = 101;
        titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [cell.contentView addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, kCellHeight/2.0 + 2.0, titleLabel.frame.size.width, 20.0)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:13.0];
        detailLabel.tag = 102;
        detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [cell.contentView addSubview:detailLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 15 - arrowImage.size.width, (kCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        arrowImageView.backgroundColor = [UIColor clearColor];
        arrowImageView.image = arrowImage;
        [cell.contentView addSubview:arrowImageView];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [cell.contentView addSubview:lineImageView];
        
    }
    
    UIImageView *topLine = (UIImageView *)[cell.contentView viewWithTag:99];
    UIImageView *logoImgView = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:102];
    topLine.hidden = YES;
    
    
    CDProvider *provider = [self.dataArray objectAtIndex:indexPath.row];
    
    [logoImgView setImageWithName:provider.logoName tableName:@"res.partner" filter:provider.provider_id fieldName:@"image" writeDate:provider.write_date placeholderImage:[UIImage imageNamed:@"order_provider_logo.png"] cacheDictionary:self.cachePicParams];
    
    
    titleLabel.text = provider.name;
    NSLog(@"provider name： %@",provider.name);
    NSMutableString *detailString = [NSMutableString string];
    
    if (provider.telephone.length > 0 &&![provider.telephone isEqualToString:@"0"] ) {
        [detailString appendString:provider.telephone];
    }
    else if (provider.phone.length > 0 &&![provider.phone isEqualToString:@"0"])
    {
        [detailString appendString:provider.phone];
    }
    else if (provider.fax.length > 0 && ![provider.fax isEqualToString:@"0"])
    {
        [detailString appendString:provider.fax];
    }
    if (detailString.length == 0) {
        [detailString appendString:@"暂无"];
    }
    detailLabel.text = [NSString stringWithFormat:@"联系方式: %@",detailString];
    if (indexPath.row == 0) {
        topLine.hidden = NO;
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
    //    return kSearchBarHeight;
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CDProvider *provider = [self.dataArray objectAtIndex:indexPath.row];
    
    ProviderDetailViewController *providerVC = [[ProviderDetailViewController alloc] initWithNibName:NIBCT(@"ProviderDetailViewController") bundle:nil];
    providerVC.provider = provider;
    [self.navigationController pushViewController:providerVC animated:YES];
    
}




@end
