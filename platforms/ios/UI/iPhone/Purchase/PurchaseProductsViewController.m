//
//  PurchaseProductsViewController.m
//  Boss
//
//  Created by lining on 15/6/30.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "PurchaseProductsViewController.h"
#import "AddProductCell.h"

#define kBottomViewHeight 135
#define kLabelHeight 30
#define kMarginSize 10

@interface PurchaseProductsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isFirstLoadView;
    
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;
@end

@implementation PurchaseProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"采购商品列表";
    isFirstLoadView = true;
    
    self.dataArray = [NSMutableArray arrayWithArray:self.purchaseOrder.orderlines.array];
    
    self.cachePicParams = [NSMutableDictionary dictionary];
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

    UILabel *unTaxLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0 + 5, yCoord, self.view.frame.size.width/2.0 - 20, kLabelHeight)];
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
    
    UILabel *taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(unTaxLabel.frame.origin.x, yCoord, unTaxLabel.frame.size.width, kLabelHeight)];
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
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(unTaxLabel.frame.origin.x, yCoord, unTaxLabel.frame.size.width, kLabelHeight)];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.purchaseOrder.amount_total floatValue]];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.font = [UIFont systemFontOfSize:20];
    totalLabel.textColor = [UIColor redColor];
    [bottomView addSubview:totalLabel];
}



#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"common_identifier";
    AddProductCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[AddProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier width:self.tableView.frame.size.width canExpand:false];
//        cell.delegate = self;
        
    }
    CDPurchaseOrderLine *orderLine = [self.dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = orderLine.product.itemName;
    cell.detailLabel.text = [NSString stringWithFormat:@"￥%@/%@ %@",orderLine.price,orderLine.product.uomName,LS(orderLine.product.type)];
    cell.countLabel.text = [NSString stringWithFormat:@"x%@",orderLine.count];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",orderLine.total_untax];
    cell.orderLine = orderLine;
    cell.indexPath = indexPath;
    
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:orderLine.product.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AddProductCell heightWithExpand:false];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
