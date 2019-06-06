//
//  AddProductViewController.m
//  Boss
//
//  Created by lining on 15/6/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AddProductViewController.h"
#import "UIImage+Resizable.h"
#import "BSEditCell.h"
#import "AddProductCell.h"
#import "ProjectViewController.h"
#import "ProductDetailViewController.h"

#define kPicCellHeight  90
#define kMarginSize  16
#define kLogoSize   40
#define kBottomViewHeight 200
#define kBottomLabelViewHeight 130
#define kBottomBtnViewHeight 70
#define kLabelHeight 30


@interface AddProductViewController ()<UITableViewDataSource,UITableViewDelegate,AddProductCellDelegate>
{
    BOOL isFirstLoadView;
    NSInteger currentSelectedRow;
    
    UILabel *unTaxLabel;
    UILabel *taxLabel;
    UILabel *totalLabel;

}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *noView;
@property(nonatomic, strong) UIView *productView;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) NSMutableDictionary *cachePicParams;
@property(nonatomic, assign) CGFloat totalMoney;
@property(nonatomic, assign) CGFloat untaxMoney;
@property(nonatomic, assign) CGFloat taxMoney;

@end

@implementation AddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"添加产品";
    isFirstLoadView = true;
    
    
    self.totalMoney = [self.purchaseOrder.amount_total floatValue];
    self.taxMoney = [self.purchaseOrder.amount_tax floatValue];
    self.untaxMoney = [self.purchaseOrder.amount_untax floatValue];
    
    currentSelectedRow = -1;
    [self registerNofitificationForMainThread:kCreateOrderLine];
    [self registerNofitificationForMainThread:kEidtOrderLine];
    [self registerNofitificationForMainThread:kBSPurchaseItemSelectFinish];
    
    self.orderLines = [NSMutableArray arrayWithArray:self.purchaseOrder.orderlines.array];
//    [self initOrderLines];
    
//    self.orderProducts = [NSMutableArray array];
//    
//    for (CDPurchaseOrderLine *orderline in orderlines) {
//        OrderProduct *orderProduct = [[OrderProduct alloc] initWithCDProductValue:productValue];
//        [self.orderProducts addObject:orderProduct];
//    }
    
    self.cachePicParams = [NSMutableDictionary dictionary];
    

}

- (void) initOrderLines
{
    BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
    [dataManager deleteObjects:self.orderLines];

    self.orderLines = [NSMutableArray array];
    for (CDPurchaseOrderLine *oldLine in self.purchaseOrder.orderlines.array) {
        CDPurchaseOrderLine *newLine = [dataManager insertEntity:@"CDPurchaseOrderLine"];
        newLine.line_id = oldLine.line_id;
        newLine.count = oldLine.count;
        newLine.date = oldLine.date;
        newLine.tax = oldLine.tax;
        newLine.total_tax = oldLine.total_tax;
        newLine.total_untax = oldLine.total_untax;
        newLine.totalMoney = oldLine.totalMoney;
        newLine.order = oldLine.order;
        newLine.product = oldLine.product;
        newLine.tax = oldLine.tax;
        [self.orderLines addObject:newLine];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    if (isFirstLoadView) {
        
        [self initNoView];
        [self initView];
        [self initData];
        
        isFirstLoadView = false;
    }
}

#pragma mark - init view & data
- (void)initView
{
    
    self.productView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.productView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kBottomViewHeight) style:UITableViewStylePlain];
    
    //    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.productView addSubview:self.tableView];
    
    
    [self initBottomBtn];
    
}

- (void)initBottomBtn
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, self.view.frame.size.width, kBottomViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.productView addSubview:bottomView];
    
    UIView *labelView = [self bottomLabelView];
    [bottomView addSubview:labelView];
    

    CGFloat btnWidth = (self.view.frame.size.width - 2*kMarginSize - 2)/2.0;
    
    UIImage *leftImg = [[UIImage imageNamed:@"order_btn_short_ok.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 70, 10, 10)];
    
    CGFloat yCoord = (kBottomBtnViewHeight - leftImg.size.height)/2.0 + labelView.frame.size.height;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(kMarginSize, yCoord, btnWidth, leftImg.size.height);
    [leftBtn setBackgroundImage:leftImg forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(sureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomView addSubview:leftBtn];
    
    
    UIImage *rightImg = [[UIImage imageNamed:@"order_btn_short_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 70, 10, 10)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kMarginSize + btnWidth + 2, leftBtn.frame.origin.y, btnWidth, rightImg.size.height);
    [rightBtn setBackgroundImage:rightImg forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [rightBtn setTitle:@"     继续添加" forState:UIControlStateNormal];
    [bottomView addSubview:rightBtn];
}

- (UIView *) bottomLabelView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kBottomLabelViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    CGFloat yCoord = kMarginSize;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, self.view.frame.size.width/2.0, kLabelHeight)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"未含税金额:";
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor grayColor];
    [bottomView addSubview:label1];
    
    unTaxLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0 + 5, yCoord, self.view.frame.size.width/2.0 - 20, kLabelHeight)];
    unTaxLabel.backgroundColor = [UIColor clearColor];
    unTaxLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.purchaseOrder.amount_untax floatValue]];
    unTaxLabel.textAlignment = NSTextAlignmentRight;
    unTaxLabel.font = [UIFont systemFontOfSize:14];
    unTaxLabel.textColor = [UIColor grayColor];
    [bottomView addSubview:unTaxLabel];
    
    yCoord += kLabelHeight;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, self.view.frame.size.width/2.0, kLabelHeight)];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"税:";
    label2.textAlignment = NSTextAlignmentRight;
    label2.font = [UIFont boldSystemFontOfSize:14];
    label2.textColor = [UIColor grayColor];
    [bottomView addSubview:label2];
    
    taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(unTaxLabel.frame.origin.x, yCoord, unTaxLabel.frame.size.width, kLabelHeight)];
    taxLabel.backgroundColor = [UIColor clearColor];
    taxLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.purchaseOrder.amount_tax floatValue]];
    taxLabel.textAlignment = NSTextAlignmentRight;
    taxLabel.font = [UIFont systemFontOfSize:14];
    taxLabel.textColor = [UIColor grayColor];
    [bottomView addSubview:taxLabel];
    
    
    
    yCoord += kLabelHeight + 10;
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, yCoord, self.tableView.frame.size.width, 0.5)];
    lineImgView.backgroundColor = [UIColor clearColor];
    lineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [bottomView addSubview:lineImgView];
    
    
    yCoord += kLabelHeight/2 - 2;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, self.view.frame.size.width/2.0, kLabelHeight)];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"共计:";
    label3.textAlignment = NSTextAlignmentRight;
    label3.font = [UIFont systemFontOfSize:14];
    label3.textColor = [UIColor grayColor];
    [bottomView addSubview:label3];
    
    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(unTaxLabel.frame.origin.x, yCoord, unTaxLabel.frame.size.width, kLabelHeight)];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.purchaseOrder.amount_total floatValue]];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.font = [UIFont systemFontOfSize:20];
    totalLabel.textColor = [UIColor redColor];
    [bottomView addSubview:totalLabel];
    
    return bottomView;
}

- (void)initNoView
{
    self.noView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.noView];
    
    UIImage *defaultImg = [UIImage imageNamed:@"sub_items_is_none.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - defaultImg.size.width)/2.0, (self.view.frame.size.height - defaultImg.size.height)/2.0, defaultImg.size.width, defaultImg.size.height)];
    imgView.image = defaultImg;
    [self.noView addSubview:imgView];
    
    UIImage *normalImg = [[UIImage imageNamed:@"order_btn_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 160, 10, 20)];
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(kMarginSize, self.view.frame.size.height - kMarginSize/2.0 - normalImg.size.height, self.view.frame.size.width - 2*kMarginSize, normalImg.size.height);
    [bottomBtn setTitle:@"添加" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bottomBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [self.noView addSubview:bottomBtn];
}

- (void) initData
{
    if (self.orderLines.count > 0) {
        self.noView.hidden = true;
        self.productView.hidden = false;
        
    }
    else
    {
        self.noView.hidden = false;
        self.productView.hidden = true;
    }

}

#pragma mark - Button Action

- (void) sureBtnPressed:(UIButton *)btn
{
    self.purchaseOrder.amount_total = [NSNumber numberWithFloat:self.totalMoney];
//    self.purchaseOrder.products = [NSOrderedSet orderedSetWithArray:self.dataArray];
    self.purchaseOrder.amount_untax = [NSNumber numberWithFloat:self.untaxMoney];
    self.purchaseOrder.amount_tax = [NSNumber numberWithFloat:self.taxMoney];
    
    self.purchaseOrder.orderlines = [NSOrderedSet orderedSetWithArray:self.orderLines];
    
    if ([self.delegate respondsToSelector:@selector(didSureBtnPressed:)]) {
        [self.delegate didSureBtnPressed:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) addBtnPressed:(UIButton *)btn
{
    ProjectViewController *projectViewController = [[ProjectViewController alloc] initWithViewType:kProjectSelectPurchase existItemIds:nil];
    [self.navigationController pushViewController:projectViewController animated:YES];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kCreateOrderLine]) {
        CDPurchaseOrderLine *orderline = (CDPurchaseOrderLine *)notification.object;
        [self.orderLines addObject:orderline];
        /*
        OrderProduct *orderProduct = [[OrderProduct alloc] initWithCDProductValue:productValue];
        [self.dataArray addObject:productValue];
        [self.orderProducts addObject:orderProduct];
         */
        
        [self initData];
        [self.tableView reloadData];
        
        [self resetPrice];
        
    }
    else if ([notification.name isEqualToString:kEidtOrderLine])
    {
        [self.tableView reloadData];
        [self resetPrice];
    }
    else if ([notification.name isEqualToString:kBSPurchaseItemSelectFinish])
    {
        CDProjectItem *item = (CDProjectItem *)notification.object;
        ProductDetailViewController *productVC = [[ProductDetailViewController alloc] initWithNibName:NIBCT(@"ProductDetailViewController") bundle:nil];
        productVC.item = item;
        [self.navigationController pushViewController:productVC animated:YES];
    }
}
#pragma mark - resetPrice

- (void)resetPrice
{
    self.totalMoney = 0.0;
    self.untaxMoney = 0.0;
    self.taxMoney = 0.0;
    for (CDPurchaseOrderLine *orderLine in self.orderLines) {
//        self.totalMoney += [orderLine.totalMoney floatValue];
        CGFloat totalMoney = [orderLine.totalMoney floatValue];
        CGFloat total_untax = totalMoney/(1+[orderLine.tax.amount floatValue]);
        CGFloat total_tax = totalMoney - total_untax;
        
        self.totalMoney += totalMoney;
        self.untaxMoney += total_untax;
        self.taxMoney   += total_tax;
    }
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalMoney];
    taxLabel.text = [NSString stringWithFormat:@"￥%.2f",self.taxMoney];
    unTaxLabel.text = [NSString stringWithFormat:@"￥%.2f",self.untaxMoney];
}


#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderLines.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"common_identifier";
    AddProductCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[AddProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier width:self.tableView.frame.size.width canExpand:false];
        cell.delegate = self;
    }
    CDPurchaseOrderLine *orderline = [self.orderLines objectAtIndex:indexPath.row];
    cell.nameLabel.text = orderline.product.itemName;
//    cell.detailLabel.text = [NSString stringWithFormat:@"￥%@/%@ %@",orderline.price,orderline.product.uomName,LS(orderline.product.type)];
    cell.detailLabel.text = [NSString stringWithFormat:@"内部编号: %@",orderline.product.defaultCode];
    cell.countLabel.text = [NSString stringWithFormat:@"x%@",orderline.count];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[orderline.total_untax floatValue]];
    cell.orderLine = orderline;
    cell.indexPath = indexPath;
    if (currentSelectedRow == indexPath.row) {
        cell.isExpand = true;
    }
    else
    {
        cell.isExpand = false;
    }
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:orderline.product.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        
//        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.orderLines removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self performSelector:@selector(reloadTableView) withObject:self afterDelay:0.3];
        [self resetPrice];
        
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == currentSelectedRow) {
        return [AddProductCell heightWithExpand:true];
    }
    else
    {
        return [AddProductCell heightWithExpand:false];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    return kSearchBarHeight;
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
//    if (indexPath.row == currentSelectedRow) {
//        
//        currentSelectedRow = -1;
//    }
//    else
//    {
//        currentSelectedRow = indexPath.row;
//    }
//    [self.tableView reloadData];
    //    CDProvider *provider = [self.dataArray objectAtIndex:indexPath.row];
    
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] initWithNibName:NIBCT(@"ProductDetailViewController") bundle:nil];
    detailVC.orderLine = [self.orderLines objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}



#pragma mark - AddProductCellDelegate
-(void)didExpandBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == currentSelectedRow)
    {
        currentSelectedRow = -1;
    }
    else
    {
        currentSelectedRow = indexPath.row;
    }
    [self.tableView reloadData];
}

-(void)didCountChanged
{
    self.totalMoney = 0.0;
    for (CDPurchaseOrderLine *orderline in self.orderLines) {
        self.totalMoney += [orderline.totalMoney floatValue] ;
    }
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalMoney];
}

@end
