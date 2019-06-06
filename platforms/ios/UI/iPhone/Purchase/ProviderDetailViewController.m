//
//  ProviderDetailViewController.m
//  Boss
//
//  Created by lining on 15/6/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ProviderDetailViewController.h"
#import "BSEditCell.h"
#import "UIImage+Resizable.h"
#import "CreatePurchaseOrderViewController.h"

#define kCellHeight         60
#define kMarginSize         20
#define kLogoSize           60
#define kTopCellHeigth      130
#define kBottomViewHeight   73

typedef enum cell_row
{
    cell_row_top,
    cell_row_fax,
    cell_row_website,
    cell_row_address,
    cell_row_num
}cell_row;

@interface ProviderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isFirstLoadView;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSMutableDictionary *cachePicParams;
@end

@implementation ProviderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"供应商详情";
    isFirstLoadView = true;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
        [self initView];
        isFirstLoadView = false;
    }
}


#pragma mark - init view & data
- (void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kBottomViewHeight) style:UITableViewStylePlain];
    //    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self initBottomView];
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, self.view.frame.size.width, kBottomViewHeight)];
    bottomView.autoresizingMask = 0xff;
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    UIImage *normalImg = [[UIImage imageNamed:@"order_btn_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 160, 10, 20)];
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(kMarginSize, (kBottomViewHeight - normalImg.size.height)/2.0, self.view.frame.size.width - 2*kMarginSize, normalImg.size.height);
    bottomBtn.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    [bottomBtn setTitle:@"选择" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bottomBtn addTarget:self action:@selector(bottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [bottomView addSubview:bottomBtn];
}

- (void)initData
{
    
}

#pragma mark - button action
-(void)bottomBtnPressed:(UIButton *)btn
{
    NSLog(@"bottom button pressed");
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[CreatePurchaseOrderViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedProviderResponse object:self.provider];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cell_row_num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == cell_row_top) {
        static NSString *identifier = @"top_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_provider_top@2x.png"]];
            UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginSize, (kTopCellHeigth - kLogoSize)/2.0, kLogoSize, kLogoSize)];
            logoImgView.image = [UIImage imageNamed:@"order_provider_logo.png"];
            logoImgView.tag = 100;
            logoImgView.layer.cornerRadius = kLogoSize/2.0;
            logoImgView.layer.masksToBounds = YES;
            [cell.contentView addSubview:logoImgView];
            
            
            UIImage *arrowImage = nil;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize + kLogoSize + kMarginSize, kTopCellHeigth/2.0 - 20.0 + 2.0, self.tableView.frame.size.width - 15 - arrowImage.size.width, 20.0)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:16.0];
            titleLabel.tag = 101;
            titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
            [cell.contentView addSubview:titleLabel];
            
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, kTopCellHeigth/2.0 + 2.0, titleLabel.frame.size.width, 20.0)];
            detailLabel.backgroundColor = [UIColor clearColor];
            detailLabel.font = [UIFont systemFontOfSize:13.0];
            detailLabel.tag = 102;
            detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
            [cell.contentView addSubview:detailLabel];
            
            UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kTopCellHeigth - 0.5, IC_SCREEN_WIDTH, 0.5)];
            bottomLine.backgroundColor = [UIColor clearColor];
            
            bottomLine.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [cell.contentView addSubview:bottomLine];
            
        }
        
        UIImageView *logoImgView = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:102];
        titleLabel.text = self.provider.name;
        NSMutableString *detailString = [NSMutableString string];
        if (self.provider.telephone.length > 0 &&![self.provider.telephone isEqualToString:@"0"] ) {
            [detailString appendString:self.provider.telephone];
        }
        else if (self.provider.phone.length > 0 &&![self.provider.phone isEqualToString:@"0"])
        {
            [detailString appendString:self.provider.phone];
        }
        else if (self.provider.fax.length > 0 && ![self.provider.fax isEqualToString:@"0"])
        {
            [detailString appendString:self.provider.fax];
        }
        if (detailString.length == 0) {
            [detailString appendString:@"暂无"];
        }
        detailLabel.text = [NSString stringWithFormat:@"联系方式: %@",detailString];
        
//        detailLabel.text = [NSString stringWithFormat:@"%@ %@",self.provider.title,self.provider.telephone];
        [logoImgView setImageWithName:self.provider.name tableName:@"res.partner" filter:self.provider.provider_id fieldName:@"image" writeDate:self.provider.write_date placeholderImage:[UIImage imageNamed:@"order_provider_logo.png"] cacheDictionary:self.cachePicParams];
        return cell;
    }
    else
    {
        static NSString *identifier = @"cell";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.contentField.enabled = false;
        cell.contentField.placeholder = @"暂无";
        if (indexPath.row == cell_row_fax) {
            cell.titleLabel.text = @"传真";
            if ( self.provider.fax.length > 0 && ![self.provider.fax isEqualToString:@"0"] ) {
                cell.contentField.text = self.provider.fax;
            }
            
        }
        else if (indexPath.row == cell_row_website)
        {
            cell.titleLabel.text = @"网址";
            if ( self.provider.website.length > 0 && ![self.provider.website isEqualToString:@"0"] ) {
                cell.contentField.text = self.provider.website;
            }
        }
        else if (indexPath.row == cell_row_address)
        {
            cell.titleLabel.text = @"地区";
            if ( self.provider.address.length > 0 && ![self.provider.address isEqualToString:@"0"] ) {
                cell.contentField.text = self.provider.address;
            }
        }
        return cell;
    }

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kTopCellHeigth;
    }
    else
    {
        return 50.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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
    
//    CDProvider *provider = [self.dataArray objectAtIndex:indexPath.row];
    

}

@end
