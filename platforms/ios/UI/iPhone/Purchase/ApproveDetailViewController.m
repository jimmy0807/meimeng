//
//  ApproveDetailViewController.m
//  Boss
//  审核页
//  Created by lining on 15/6/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ApproveDetailViewController.h"
#import "UIImage+Resizable.h"
#import "CBMessageView.h"   
#import "CBLoadingView.h"
#import "BSEditCell.h"
#import "ApproveStateViewController.h"
#import "PurchaseProductsViewController.h"
#import "BSFetchOrderLinesRequest.h"
#import "BSHandlePurchaseOrderRequest.h"
#import "CBMessageView.h"

#define kBottomViewHeight  73
#define kMarginSize 20


typedef enum OrderSection
{
    OrderSection_top,
    OrderSection_one,
    OrderSection_two,
   
    OrderSection_num,
    OrderSection_three
}OrderSection;


typedef enum SectionRowOne
{
    SectionRowOne_no,
    SectionRowOne_date,
    SectionRowOne_provider,
    SectionRowOne_warehouse,
    SectionRowOne_storage,
    SectionRowOne_num
}SectionRowOne;


typedef enum SectionRowTwo
{
    SectionRowTwo_total,
    SectionRowTwo_productList,
    SectionRowTwo_num
}SectionRowTwo;


typedef enum SectionRowThree
{
    SectionRowThree_approve,
    SectionRowThree_num
}SectionRowThree;


@interface ApproveDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isFirstLoadView;
    
}
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation ApproveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    self.hideKeyBoardWhenClickEmpty = true;
    
    if (self.type == kType_approving)
    {
        self.navigationItem.title = @"审核详情";
    }
    else if (self.type == kType_done)
    {
         self.navigationItem.title = self.purchaseOrder.name;
    }
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;

//    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"撤回"];
//    rightButtonItem.delegate = self;
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    [self registerNofitificationForMainThread:kBSFetchOrderLinesResponse];
    [self registerNofitificationForMainThread:kBSConfirmedPurchaseOrderResponse];
    [self registerNofitificationForMainThread:kBSCancelPurchaseOrderResponse];
    NSArray *order_line = [self.purchaseOrder.order_line componentsSeparatedByString:@","];
    if (order_line.count > 0) {
        BSFetchOrderLinesRequest *req = [[BSFetchOrderLinesRequest alloc] initWithOrder:self.purchaseOrder order_line:order_line];
        [req execute];
        [[CBLoadingView shareLoadingView] show];
    }
    
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

#pragma mark - init View & Data
- (void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kBottomViewHeight) style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask =0xff& ~UIViewAutoresizingFlexibleTopMargin;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    if (self.type == kType_approving) {
        [self initBottomView];
       
    }
    else
    {
         self.tableView.frame = self.view.bounds;
    }
    
}
- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, self.view.frame.size.width, kBottomViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    CGFloat btnWidth = (self.view.frame.size.width - 2*kMarginSize - 2)/2.0;
    
    UIImage *leftImg = [[UIImage imageNamed:@"order_btn_short_ok.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 70, 10, 10)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(kMarginSize, (kBottomViewHeight - leftImg.size.height)/2.0, btnWidth, leftImg.size.height);
    [leftBtn setBackgroundImage:leftImg forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(sureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitle:@"审核通过" forState:UIControlStateNormal];
    [bottomView addSubview:leftBtn];
    
    
    UIImage *rightImg = [[UIImage imageNamed:@"order_btn_short_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 70, 10, 10)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kMarginSize + btnWidth + 2, leftBtn.frame.origin.y, btnWidth, rightImg.size.height);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setBackgroundImage:rightImg forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rejectBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"  驳回" forState:UIControlStateNormal];
    [bottomView addSubview:rightBtn];
}



- (void)initData
{
    
}


#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    NSLog(@"提交");

    
}


#pragma mark - Button Action

- (void) sureBtnPressed:(UIButton *)btn
{
    NSLog(@"审核通过");
    [[CBLoadingView shareLoadingView] show];
    BSHandlePurchaseOrderRequest *req = [[BSHandlePurchaseOrderRequest alloc] initWithPurchaseOrder:self.purchaseOrder type:HandleType_confirm];
    [req execute];
}

- (void) rejectBtnPressed:(UIButton *)btn
{
    NSLog(@"驳回");
    [[CBLoadingView shareLoadingView] show];
    BSHandlePurchaseOrderRequest *req = [[BSHandlePurchaseOrderRequest alloc] initWithPurchaseOrder:self.purchaseOrder type:HandleType_cancel];
    [req execute];
}


#pragma mark - AddProductViewControllerDelegate
-(void)didSureBtnPressed
{
    [self.tableView reloadData];
}


#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchOrderLinesResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
       
        [self.tableView reloadData];
    }
    else if ([notification.name isEqualToString:kBSConfirmedPurchaseOrderResponse] || [notification.name isEqualToString:kBSCancelPurchaseOrderResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
    }
    

}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return OrderSection_num;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == OrderSection_top) {
        if (self.type == kType_approving) {
            return 1;
        }
        else if (self.type == kType_done)
        {
            return 0;
        }
    }
    else if (section == OrderSection_one) {
        return SectionRowOne_num;
    }
    else if (section == OrderSection_two)
    {
        return SectionRowTwo_num;
    }
    else if (OrderSection_three)
    {
        return SectionRowThree_num;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == OrderSection_top) {
        CGFloat margin = 16;
        if (row == 0) {
            static NSString *cell_top = @"cell_top_one";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_top];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_top];
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 50/2.0-16, self.tableView.frame.size.width - 2*margin, 20)];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.text = @"采购订单";
                nameLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
                nameLabel.font = [UIFont boldSystemFontOfSize:15];
                nameLabel.tag = 101;
                [cell.contentView addSubview:nameLabel];
                
                UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 50/2.0, nameLabel.frame.size.width, 20)];
                detailLabel.tag = 102;
                detailLabel.backgroundColor = [UIColor clearColor];
                detailLabel.font = [UIFont boldSystemFontOfSize:13];
                detailLabel.textColor = [UIColor grayColor];
                [cell.contentView addSubview:detailLabel];
                
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 50-0.5, self.view.frame.size.width, 0.5)];
                lineImageView.backgroundColor = [UIColor clearColor];
                lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
                [cell.contentView addSubview:lineImageView];
            }
            
            UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:101];
            UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:102];
            nameLabel.text = self.purchaseOrder.name;
            detailLabel.text = [NSString stringWithFormat:@"申请人: %@",self.purchaseOrder.validator_name];
            return cell;
        }
        else if (row == 1)
        {
            static NSString *cell_top = @"cell_top_two";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_top];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_top];
                
                UIImage *dotImg = [UIImage imageNamed:@"order_dot_red.png"];
                UIImageView *dotImgView = [[UIImageView alloc] initWithFrame:CGRectMake(margin-3, (49-dotImg.size.height)/2.0, dotImg.size.width, dotImg.size.height)];
                dotImgView.image = dotImg;
                dotImgView.tag = 101;
                [cell.contentView addSubview:dotImgView];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*margin-8 + dotImg.size.width, (49-20)/2.0, self.tableView.frame.size.width - 2*margin, 20)];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
                nameLabel.text = @"审核状态";
                nameLabel.font = [UIFont boldSystemFontOfSize:15];
                nameLabel.tag = 102;
                [cell.contentView addSubview:nameLabel];
                
                UIImage *arrowImg = [UIImage imageNamed:@"bs_common_arrow"];
                
                UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, (49-20)/2.0, self.tableView.frame.size.width-100-arrowImg.size.width - 20, 20)];
                detailLabel.tag = 103;
                detailLabel.backgroundColor = [UIColor clearColor];
                detailLabel.font = [UIFont boldSystemFontOfSize:13];
                detailLabel.textAlignment = NSTextAlignmentRight;
                detailLabel.textColor = [UIColor grayColor];
                [cell.contentView addSubview:detailLabel];
                
                
                
                UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 10 - arrowImg.size.width,(49-arrowImg.size.height)/2.0,arrowImg.size.width, arrowImg.size.height)];
                arrowImgView.image = arrowImg;
                arrowImgView.tag = 104;
                [cell.contentView addSubview:arrowImgView];
                
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 49 - 0.5, self.view.frame.size.width, 0.5)];
                lineImageView.backgroundColor = [UIColor clearColor];
                lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
                [cell.contentView addSubview:lineImageView];
            }
            
            UIImage *dotImg;
            dotImg = [UIImage imageNamed:@"order_dot_red.png"];
            dotImg = [UIImage imageNamed:@"order_dot_blue.png"];
            dotImg = [UIImage imageNamed:@"order_dot_gray.png"];
            
//            UIImageView *dotImgView = (UIImageView *)[cell.contentView viewWithTag:101];
            UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:102];
            UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:103];
//            UIImageView *arrowImgView = (UIImageView *)[cell.contentView viewWithTag:104];
            
            
            nameLabel.text = @"审核状态";
            detailLabel.text = @"通过";
            return cell;

        }
        else if (row == 2)
        {
            static NSString *cell_top = @"cell_top_three";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_top];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_top];
                
                UIImage *img = [UIImage imageNamed:@"order_btn_selected_n.png"];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(margin-1, (49-img.size.height)/2.0, img.size.width, img.size.height)];
                imgView.image = img;
                [cell.contentView addSubview:imgView];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*margin + img.size.width - 4, (49-20)/2.0, self.tableView.frame.size.width - 2*margin, 20)];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.text = @"采购订单";
                nameLabel.textColor = [UIColor grayColor];
                nameLabel.font = [UIFont boldSystemFontOfSize:13];
                nameLabel.tag = 101;
                [cell.contentView addSubview:nameLabel];
                
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 49 - 0.5, self.view.frame.size.width, 0.5)];
                lineImageView.backgroundColor = [UIColor clearColor];
                lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
                [cell.contentView addSubview:lineImageView];
                
            }
            
            UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:101];
           
            nameLabel.text = @"娜美同意了此审批";
            return cell;

        }
    }
    else
    {
        static NSString *indentifier = @"indentifier";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.contentField.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0, IC_SCREEN_WIDTH, 0.5)];
            topLine.backgroundColor = [UIColor clearColor];
            topLine.tag = 100;
            topLine.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [cell.contentView addSubview:topLine];
        }
        
        UIImageView *topLine = (UIImageView *)[cell.contentView viewWithTag:100];
        topLine.hidden = YES;
        cell.contentField.enabled = false;
        cell.contentField.textColor = [UIColor grayColor];
        //    cell.contentField.backgroundColor = [UIColor orangeColor];
        
        if (row == 0) {
            topLine.hidden = NO;
        }
        if (section == OrderSection_one)
        {
            if (row == SectionRowOne_no)
            {
                cell.contentField.tag = 1001;
                cell.contentField.enabled = true;
                cell.titleLabel.text = @"编号";
//                cell.contentField.placeholder = @"请输入...";
                if (self.purchaseOrder.orderNo) {
                    cell.contentField.text = @"暂无";
                }
                else
                {
                     cell.contentField.text = self.purchaseOrder.orderNo;
                }
               
            }
            else if (row == SectionRowOne_date)
            {
                cell.titleLabel.text = @"日期";
                if (self.purchaseOrder.date_order) {
                    cell.contentField.text = [self.purchaseOrder.date_order substringToIndex:10];
                }
                else
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    cell.contentField.text = [dateFormat stringFromDate:[NSDate date]];
                    self.purchaseOrder.date_order = cell.contentField.text;
                }
                
            }
            else if (row == SectionRowOne_provider)
            {
                cell.titleLabel.text = @"供应商";
                cell.contentField.placeholder = @"请选择";
                cell.contentField.text = self.purchaseOrder.provider.name;
            }
            else if (row == SectionRowOne_storage)
            {
                cell.titleLabel.text = @"仓位";
                cell.contentField.placeholder = @"请选择";
                cell.contentField.text = self.purchaseOrder.storage.name;
            }
            else if (row == SectionRowOne_warehouse)
            {
                cell.titleLabel.text = @"仓库";
                cell.contentField.placeholder = @"请选择";
                cell.contentField.text = self.purchaseOrder.warehouse.pick_name;
            }
        }
        else if (section == OrderSection_two)
        {
            if (row == SectionRowTwo_total)
            {
                cell.titleLabel.text = @"共计";
                cell.contentField.textColor = [UIColor redColor];
                cell.contentField.text = [NSString stringWithFormat:@"￥%@",self.purchaseOrder.amount_total];
                cell.arrowImageView.hidden = YES;
            }
            else if (row == SectionRowTwo_productList)
            {
                cell.titleLabel.text = @"采购商品列表";
                cell.contentField.text = [NSString stringWithFormat:@"%d",self.purchaseOrder.orderlines.count];
            }
        }
        else if (section == OrderSection_three)
        {
            if (row == SectionRowThree_approve) {
                cell.titleLabel.text = @"审批人";
                cell.contentField.text = @"娜美";
            }
        }
        cell.arrowImageView.hidden = YES;
        cell.contentField.enabled = false;
        return cell;

    }
    return nil;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == OrderSection_top) {
        return 50.0;
    }
    else
    {
        return 50.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    return kSearchBarHeight;
    if (self.type == kType_approving) {
        if (section == OrderSection_one) {
            return 35;
        }
    }
    else
    {
        if (section == OrderSection_top) {
            return 1;
        }
        if (section == OrderSection_one) {
            return 35;
        }
    }
    
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view = [[UILabel alloc] init];
    view.backgroundColor = [UIColor clearColor];
    if (section == OrderSection_one) {
        view.backgroundColor = COLOR(245, 245, 245, 1);
        view.text = @"   基本信息";
        view.textColor = [UIColor grayColor];
        view.font = [UIFont boldSystemFontOfSize:14];
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == OrderSection_top) {
        if (indexPath.row == 1) {
            ApproveStateViewController *stateVC = [[ApproveStateViewController alloc] initWithNibName:NIBCT(@"ApproveStateViewController") bundle:nil];
            [self.navigationController pushViewController:stateVC animated:YES];
        }
    }
    else if (indexPath.section == OrderSection_two)
    {
        if (indexPath.row == SectionRowTwo_productList) {
            PurchaseProductsViewController *productsVC = [[PurchaseProductsViewController alloc] initWithNibName:NIBCT(@"PurchaseProductsViewController") bundle:nil];
            productsVC.purchaseOrder = self.purchaseOrder;
            [self.navigationController pushViewController:productsVC animated:YES];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    int section = textField.tag / 100;
    //    int row = textField.tag % 100;
    if (textField.tag == 1001) {
        self.purchaseOrder.orderNo = textField.text;
    }
}

#pragma mark - Mermory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
