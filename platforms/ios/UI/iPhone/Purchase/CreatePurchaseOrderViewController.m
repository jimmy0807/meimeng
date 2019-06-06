//
//  CreatePurchaseOrderViewController.m
//  Boss
//
//  Created by lining on 15/6/16.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "CreatePurchaseOrderViewController.h"
#import "BSEditCell.h"
#import "UIImage+Resizable.h"
#import "ProviderViewController.h"
#import "AddProductViewController.h"
#import "PurchaseSelectedViewController.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"
#import "BSHandlePurchaseOrderRequest.h"
#import "BSFetchOrderLinesRequest.h"
#import "DatePickerView.h"
#import "ProjectViewController.h"
#import "ProductDetailViewController.h"
#import "AddProductCell.h"


#define kBottomViewHeight  73
#define kMarginSize 20

#define kFootLabelViewHeight 115
#define kLabelHeight 30

@interface CreatePurchaseOrderViewController ()<UITableViewDataSource,UITableViewDelegate,PurchaseSelectedDelegate,AddProductViewControllerDelegate,DatePickerViewDelegate,UIAlertViewDelegate>
{
    BOOL isFirstLoadView;
    NSIndexPath *selectedIndexPath;
    
    UILabel *unTaxLabel;
    UILabel *taxLabel;
    UILabel *totalLabel;
    
//    BOOL isChanged;
    BOOL needCommit;
    
    BNRightButtonItem *rightButtonItem;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *oldOrderLines;
@property(nonatomic, strong) NSMutableArray *orderLines;
@property(nonatomic, strong) DatePickerView *pickerView;
@property(nonatomic, strong) NSMutableDictionary *cachePicParams;
@property(nonatomic, assign) BOOL isChanged;

@property(nonatomic, assign) CGFloat totalMoney;
@property(nonatomic, assign) CGFloat untaxMoney;
@property(nonatomic, assign) CGFloat taxMoney;

@end

@implementation CreatePurchaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    self.hideKeyBoardWhenClickEmpty = true;

    self.cachePicParams = [NSMutableDictionary dictionary];
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;

    if (self.type == OrderType_create) {
        self.navigationItem.title = LS(@"新建订单");
        rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"保存"];
        
        self.purchaseOrder = [[BSCoreDataManager currentManager] insertEntity:@"CDPurchaseOrder"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.purchaseOrder.date_order = [dateFormatter stringFromDate:[NSDate date]];
        self.oldOrderLines = [NSMutableArray arrayWithArray:self.purchaseOrder.orderlines.array];
        
        self.orderLines = [NSMutableArray arrayWithArray:self.oldOrderLines];
    }
    else
    {
        self.isChanged = false;
        if (self.type == OrderType_confirm) {
            self.navigationItem.title = LS(@"审核订单");
          
        }
        else if (self.type == OrderType_done)
        {
            self.navigationItem.title = LS(@"订单信息");
        }
        else
        {
            self.navigationItem.title = LS(@"编辑订单");
            rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"提交"];
        }
        
        
        
        self.oldOrderLines = [NSMutableArray arrayWithArray:self.purchaseOrder.orderlines.array];
        
        self.orderLines = [NSMutableArray arrayWithArray:self.oldOrderLines];
        
        NSArray *order_line = [self.purchaseOrder.order_line componentsSeparatedByString:@","];
        if (order_line.count > 0) {
            BSFetchOrderLinesRequest *req = [[BSFetchOrderLinesRequest alloc] initWithOrder:self.purchaseOrder order_line:order_line];
            [req execute];
            [[CBLoadingView shareLoadingView] show];
        }
        
    }
    
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    isFirstLoadView = true;
    
    [self registerNofitificationForMainThread:kSelectedProviderResponse];
    [self registerNofitificationForMainThread:kBSCreatePurchaseOrderResponse];
    [self registerNofitificationForMainThread:kBSFetchOrderLinesResponse];
    [self registerNofitificationForMainThread:kBSEditPurchaseOrderResponse];
    [self registerNofitificationForMainThread:kBSCommitPurchaseOrderResponse];
     [self registerNofitificationForMainThread:kBSPurchaseItemSelectFinish];
    
    [self registerNofitificationForMainThread:kCreateOrderLine];
    [self registerNofitificationForMainThread:kEidtOrderLine];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kBottomViewHeight) style:UITableViewStylePlain];
    self.tableView.autoresizingMask =0xff& ~UIViewAutoresizingFlexibleTopMargin;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [self bottomLabelView];
    
    if (self.type == OrderType_create || self.type == OrderType_eidt)
    {
        [self initBottomView];
//        [self initDatePicker];
    }
    else if (self.type == OrderType_confirm)
    {
        [self initBottomConfirmView];
        
    }
    else if (self.type == OrderType_done)
    {
        self.tableView.frame = self.view.bounds;
    }
    
}

- (UIView *) bottomLabelView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kFootLabelViewHeight)];
    bottomView.autoresizingMask = 0xff;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    CGFloat yCoord = kMarginSize/2.0;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, self.view.frame.size.width/2.0, kLabelHeight)];
    label1.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"未含税金额:";
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor grayColor];
    [bottomView addSubview:label1];
    
    unTaxLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0 + 5, yCoord, self.view.frame.size.width/2.0 - 20, kLabelHeight)];
    unTaxLabel.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    unTaxLabel.backgroundColor = [UIColor clearColor];
    unTaxLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.purchaseOrder.amount_untax floatValue]];
    unTaxLabel.textAlignment = NSTextAlignmentRight;
    unTaxLabel.font = [UIFont systemFontOfSize:14];
    unTaxLabel.textColor = [UIColor grayColor];
    [bottomView addSubview:unTaxLabel];
    
    yCoord += kLabelHeight;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, self.view.frame.size.width/2.0, kLabelHeight)];
    label2.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"税:";
    label2.textAlignment = NSTextAlignmentRight;
    label2.font = [UIFont boldSystemFontOfSize:14];
    label2.textColor = [UIColor grayColor];
    [bottomView addSubview:label2];
    
    taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(unTaxLabel.frame.origin.x, yCoord, unTaxLabel.frame.size.width, kLabelHeight)];
    taxLabel.backgroundColor = [UIColor clearColor];
    taxLabel.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    taxLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.purchaseOrder.amount_tax floatValue]];
    taxLabel.textAlignment = NSTextAlignmentRight;
    taxLabel.font = [UIFont systemFontOfSize:14];
    taxLabel.textColor = [UIColor grayColor];
    [bottomView addSubview:taxLabel];
    
    
    
    yCoord += kLabelHeight;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, self.view.frame.size.width/2.0, kLabelHeight)];
    label3.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"共计:";
    label3.textAlignment = NSTextAlignmentRight;
    label3.font = [UIFont boldSystemFontOfSize:14];
    label3.textColor = [UIColor grayColor];
    [bottomView addSubview:label3];
    
    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(unTaxLabel.frame.origin.x, yCoord, unTaxLabel.frame.size.width, kLabelHeight)];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.purchaseOrder.amount_total floatValue]];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.font = [UIFont systemFontOfSize:20];
    totalLabel.textColor = [UIColor redColor];
    [bottomView addSubview:totalLabel];
    

    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kFootLabelViewHeight-0.5, self.tableView.frame.size.width, 0.5)];
    lineImgView.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    lineImgView.backgroundColor = [UIColor clearColor];
    lineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [bottomView addSubview:lineImgView];
    
    return bottomView;
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, self.view.frame.size.width, kBottomViewHeight)];
    bottomView.autoresizingMask = 0xff;
    [self.view addSubview:bottomView];
//    bottomView.backgroundColor = [UIColor redColor];
    
//    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIImage *normalImg = [[UIImage imageNamed:@"order_btn_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 160, 10, 20)];
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(kMarginSize, (kBottomViewHeight - normalImg.size.height)/2.0, bottomView.frame.size.width - 2*kMarginSize, normalImg.size.height);
    bottomBtn.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bottomBtn setTitle:@"添加商品" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [bottomView addSubview:bottomBtn];
}

- (void)initBottomConfirmView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, IC_SCREEN_WIDTH, kBottomViewHeight)];
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    bottomView.backgroundColor = [UIColor whiteColor];
   
    [self.view addSubview:bottomView];
    
    CGFloat btnWidth = (IC_SCREEN_WIDTH - 2*kMarginSize - 2)/2.0;
    
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

- (void)showDatePicker
{
    if (self.pickerView) {
        
        [self.pickerView show];
        return;
    }
    NSString *dateString = [self.purchaseOrder.date_order substringToIndex:10];
    
    self.pickerView = [[DatePickerView alloc] initWithFrame:self.view.bounds dateString:dateString delegate:self];
    [self.view addSubview:self.pickerView];
    [self.pickerView show];
}

#pragma mark - button action
-(void)bottomBtnPressed:(UIButton *)btn
{
    //    NSLog(@"bottom button pressed");
    //    AddProductViewController *addVC = [[AddProductViewController alloc] initWithNibName:NIBCT(@"AddProductViewController") bundle:nil];
    //    addVC.purchaseOrder = self.purchaseOrder;
    //    addVC.delegate = self;
    //    [self.navigationController pushViewController:addVC animated:YES];
    ProjectViewController *projectViewController = [[ProjectViewController alloc] initWithViewType:kProjectSelectPurchase existItemIds:nil];
    [self.navigationController pushViewController:projectViewController animated:YES];
    
}

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
    
    BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SectionRowTwo_productList inSection:OrderSection_two]];
    cell.contentField.text = [NSString stringWithFormat:@"%d",self.orderLines.count];
}

#pragma mark - DatePickerViewDelegate

- (void)didValueChanged:(NSString *)dateString
{
    self.isChanged = true;
    self.purchaseOrder.date_order = dateString;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SectionRowOne_date inSection:OrderSection_one]] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - CBBackButtonItemDelegate
-(void)didItemBackButtonPressed:(UIButton*)sender
{

    if (self.type == OrderType_create) {
        [[BSCoreDataManager currentManager] deleteObject:self.purchaseOrder];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
//    else
//    {
//        if (self.isChanged) {
//            UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:@"是否保存更改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
//            [view show];
//            
//        }
//        else
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[BSCoreDataManager currentManager] rollback];
    }
    else
    {
        [self sendEditRequest];
    }
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
   
    if (self.type == OrderType_create) {
        NSLog(@"保存草稿");
        if (!self.purchaseOrder.provider || !self.purchaseOrder.warehouse) {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"请将创建订单所需的信息，填写完整"];
            [messageView show];
            return;
        }
        NSLog(@"保存订单");
        [[CBLoadingView shareLoadingView] show];
        [self sendCreateRequest];
    }
    else
    {
        [[CBLoadingView shareLoadingView] show];
        if (self.isChanged)
        {
            needCommit = true;
            NSLog(@"编辑订单");
            [self sendEditRequest];
        }
        else
        {
            NSLog(@"提交订单");
            [self sendCommitRequest];
        }
    }
   
}

- (void)setIsChanged:(BOOL)isChanged
{
    _isChanged = isChanged;
    if (self.type == OrderType_eidt) {
        if (isChanged) {
            rightButtonItem.btnTitle = @"保存";
        }
        else
        {
            rightButtonItem.btnTitle = @"提交";
        }
    }
    
}

#pragma mark - Request && Params
- (void)sendCreateRequest
{
    BSHandlePurchaseOrderRequest *request = [[BSHandlePurchaseOrderRequest alloc]initWithPurchaseOrder:self.purchaseOrder type:HandleType_create];
    request.params = [self editParams];
    [request execute];
}

- (void)sendEditRequest
{
    BSHandlePurchaseOrderRequest *request = [[BSHandlePurchaseOrderRequest alloc]initWithPurchaseOrder:self.purchaseOrder type:HandleType_edit];
    request.params = [self editParams];
    [request execute];
}

- (void)sendCommitRequest
{
    BSHandlePurchaseOrderRequest *orderRequest = [[BSHandlePurchaseOrderRequest alloc] initWithPurchaseOrder:self.purchaseOrder type:HandleType_commit];
    [orderRequest execute];
}

- (NSDictionary *)editParams
{
    NSMutableDictionary *filter = [NSMutableDictionary dictionary];
    filter[@"partner_id"] = self.purchaseOrder.provider.provider_id;
    if (self.purchaseOrder.orderNo) {
        filter[@"partner_ref"] = self.purchaseOrder.orderNo;
    }
    filter[@"company_id"] = [PersonalProfile currentProfile].businessId;  //编辑
    filter[@"picking_type_id"] = self.purchaseOrder.warehouse.pick_id;   //编辑
    filter[@"date_order"] = self.purchaseOrder.date_order;
    filter[@"related_location_id"] = self.purchaseOrder.warehouse.dest_location_id; //编辑
    
    filter[@"location_id"] = self.purchaseOrder.warehouse.dest_location_id;    //编辑
    
//    NSLog(@"location_id:%@",self.purchaseOrder.storage.storage_id);
    
    filter[@"pricelist_id"] = self.purchaseOrder.provider.product_pricelist_id;
    
//    NSLog(@"pricelist_id:%@",self.purchaseOrder.provider.product_pricelist_id);
    
    if ([PersonalProfile currentProfile].bshopId) {
        filter[@"shop_id"] = [PersonalProfile currentProfile].bshopId;
    }
    
    NSMutableArray *products = [NSMutableArray array];
    for (CDPurchaseOrderLine *orderline in self.orderLines) {
        
//        CDProductValue *productValue = orderProduct.productValue;
        
//        if ([productValue.line_id integerValue] == 0) {
            NSLog(@"新增");
            NSMutableDictionary *sub = [NSMutableDictionary dictionary];
            sub[@"product_id"] = orderline.product.itemID;
            sub[@"name"]= orderline.product.itemName;
            sub[@"product_uom"] = orderline.product.uomID;
            sub[@"product_qty"] = orderline.count;
            sub[@"price_unit"] = orderline.price;
            if (orderline.tax) {
                sub[@"taxes_id"] = @[@[[NSNumber numberWithInteger:kBSDataExist],[NSNumber numberWithBool:false],@[orderline.tax.tax_id]]];
            }
            sub[@"account_analytic_id"] = [NSNumber numberWithBool:false];
            sub[@"date_planned"] = orderline.date;
            
            NSArray *subArray = @[[NSNumber numberWithInteger:kBSDataAdded],[NSNumber numberWithBool:false],sub];
            
            [products addObject:subArray];

        }
//        else if ([self.oldProducts containsObject:productValue])
//        {
//            if (orderProduct.isEidt) {
//                NSLog(@"修改的");
////                NSArray *subArray = @[@1,productValue.line_id,@"修改的数据"];
//            }
//            else
//            {
//                NSArray *subArray = @[[NSNumber numberWithInteger:kBSDataLinked],productValue.line_id,[NSNumber numberWithBool:false]];
//                [products addObject:subArray];
//                NSLog(@"不变的");
//                
//            }
//            [self.oldProducts removeObject:productValue];
//        }
//    }
//    
    if (self.orderLines != nil) {
        for (CDPurchaseOrderLine *orderline in self.oldOrderLines) {
            //删除
            NSArray *subArray = @[[NSNumber numberWithInteger:kBSDataDelete],orderline.line_id,[NSNumber numberWithBool:false]];
            [products addObject:subArray];
            NSLog(@"将要删除的");
        }
    }
    
    if (products.count > 0) {
        filter[@"order_line"] = products;
    }
    
//    [[BSCoreDataManager currentManager] deleteObjects:self.orderLines];
    return filter;
}




#pragma mark - AddProductViewControllerDelegate
-(void)didSureBtnPressed:(AddProductViewController *)viewController
{
    self.orderLines = viewController.orderLines;
//    [self editParams];
    [self.tableView reloadData];
}

#pragma mark - PurchaseSelectedDelegate
-(void)didSelectedManageObject:(NSManagedObject *)object withType:(SelectedType)type
{
    self.isChanged = true;
    [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [[CBLoadingView shareLoadingView] hide];
    if ([notification.name isEqualToString:kSelectedProviderResponse]) {
        self.isChanged = true;
        CDProvider *provider = notification.object;
//        BOOL gt = provider.isFault | provider.isDeleted;
//        gt = self.purchaseOrder.isDeleted | provider.isFault;
       
        self.purchaseOrder.provider = provider;
      
        [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([notification.name isEqualToString:kBSCreatePurchaseOrderResponse]||[notification.name isEqualToString:kBSEditPurchaseOrderResponse])
    {
        
        NSDictionary *retDict = notification.userInfo;
        if ([[retDict numberValueForKey:@"rc"] integerValue] == 0) {
            if (needCommit) {
                NSLog(@"提交");
//                BSHandlePurchaseOrderRequest *orderRequest = [[BSHandlePurchaseOrderRequest alloc] initWithPurchaseOrder:self.purchaseOrder type:HandleType_commit];
//                [orderRequest execute];
                rightButtonItem.btnTitle = @"提交";
                self.isChanged = false;
                [[CBLoadingView shareLoadingView] hide];
            }
            else
            {
                [[CBLoadingView shareLoadingView] hide];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        else
        {
            [[CBLoadingView shareLoadingView] hide];
            CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:[retDict stringValueForKey:@"rm"]];
            [msgView show];
        }
    }
    else if ([notification.name isEqualToString:kBSCommitPurchaseOrderResponse])
    {
        NSDictionary *retDict = notification.userInfo;
        if ([[retDict numberValueForKey:@"rc"] integerValue] == 0) {
            NSLog(@"提交订单成功");
            [[CBLoadingView shareLoadingView] hide];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[CBLoadingView shareLoadingView] hide];
            CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:[retDict stringValueForKey:@"rm"]];
            [msgView show];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchOrderLinesResponse])
    {
        NSLog(@"收到通知");
        [[CBLoadingView shareLoadingView] hide];
        self.oldOrderLines = [NSMutableArray arrayWithArray:self.purchaseOrder.orderlines.array];
        self.orderLines = [NSMutableArray arrayWithArray:self.oldOrderLines];
        [self.tableView reloadData];
    }
    else if ([notification.name isEqualToString:kCreateOrderLine]) {
        
        self.isChanged = true;
        
        CDPurchaseOrderLine *orderline = (CDPurchaseOrderLine *)notification.object;
        [self.orderLines addObject:orderline];

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:OrderSection_two] withRowAnimation:UITableViewRowAnimationFade];
        //        [self performSelector:@selector(reloadTableView) withObject:self afterDelay:0.3];
        [self resetPrice];
        
    }
    else if ([notification.name isEqualToString:kEidtOrderLine])
    {
        self.isChanged = true;
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

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return OrderSection_num;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == OrderSection_one) {
        return SectionRowOne_num;
    }
    else if (section == OrderSection_two)
    {
        return self.orderLines.count + 1;
    }
    else if (OrderSection_three)
    {
        return SectionRowThree_num;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == OrderSection_two && row != 0) {
        static NSString *indentifier = @"product_identifier";
        AddProductCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[AddProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier width:self.tableView.frame.size.width canExpand:false];
            
        }
        CDPurchaseOrderLine *orderline = [self.orderLines objectAtIndex:indexPath.row-1];
        cell.nameLabel.text = orderline.product.itemName;
        //    cell.detailLabel.text = [NSString stringWithFormat:@"￥%@/%@ %@",orderline.price,orderline.product.uomName,LS(orderline.product.type)];
        
//        cell.detailLabel.text = [NSString stringWithFormat:@"内部编号: %@",orderline.product.defaultCode? orderline.product.defaultCode:@"暂无"];
        cell.detailLabel.text = [NSString stringWithFormat:@"数量: x%@",orderline.count];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",orderline.count];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[orderline.total_untax floatValue]];
        cell.orderLine = orderline;
        cell.indexPath = indexPath;
        
        [cell.picView sd_setImageWithURL:[NSURL URLWithString:orderline.product.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
        
        return cell;

    }
    else
    {
        static NSString *indentifier = @"indentifier";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.contentField.delegate = self;
            
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
        cell.arrowImageView.hidden = NO;
        if (row == 0) {
            topLine.hidden = NO;
        }
        if (self.type == OrderType_done) {
            cell.arrowImageView.hidden = YES;
        }
        if (section == OrderSection_one)
        {
                if (row == SectionRowOne_no)
                {
                    cell.contentField.tag = 1001;
                    cell.contentField.enabled = true;
                    cell.titleLabel.text = @"编号";
                    cell.contentField.placeholder = @"请输入...";
                    cell.contentField.text = self.purchaseOrder.orderNo;
                }
                else if (row == SectionRowOne_date)
                {
                    cell.titleLabel.text = @"日期";

                    cell.contentField.text = [self.purchaseOrder.date_order substringToIndex:10];
                    cell.contentField.placeholder = @"请选择...";
                    
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
            if (row == SectionRowTwo_productList)
            {
                cell.arrowImageView.hidden = true;
                cell.titleLabel.text = @"采购商品列表";
                cell.contentField.text = [NSString stringWithFormat:@"%d",self.orderLines.count];
            }
            //        else if (row == SectionRowTwo_total)
            //        {
            //            cell.titleLabel.text = @"共计";
            //            cell.contentField.textColor = [UIColor redColor];
            //            cell.contentField.text = [NSString stringWithFormat:@"￥%.2f",[self.purchaseOrder.amount_total floatValue]];
            //            cell.arrowImageView.hidden = YES;
            //        }
        }
 
        else if (section == OrderSection_three)
        {
            if (row == SectionRowThree_approve) {
                cell.titleLabel.text = @"审批人";
                cell.contentField.text = @"娜美";
            }
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == OrderType_create || self.type == OrderType_eidt) {
        if (indexPath.section == OrderSection_two && indexPath.row != 0) {
            return true;
        }
    }
    
    return false;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        
        //        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.orderLines removeObjectAtIndex:indexPath.row - 1];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//        [self performSelector:@selector(reloadTableView) withObject:self afterDelay:0.3];
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
    if (indexPath.section == OrderSection_two && indexPath.row != 0) {
        return [AddProductCell heightWithExpand:false];
    }
    return 50.0;
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
    if (self.type == OrderType_confirm || self.type == OrderType_done) {
        return;
    }
    if (!(indexPath.section == OrderSection_one && indexPath.row == SectionRowOne_date)) {
        if (!self.pickerView.hidden) {
            [UIView animateWithDuration:0.1 animations:^{
                CGRect frame = self.pickerView.frame;
                frame.origin.y = self.view.frame.size.height;
                self.pickerView.frame = frame;
            } completion:^(BOOL finished) {
                self.pickerView.hidden = YES;
            }];
        }
    }
    selectedIndexPath = indexPath;
    int row = indexPath.row;
    int section = indexPath.section;
    if (section == OrderSection_one)
    {
        if (row == SectionRowOne_no) {
            
        }
        else if (row == SectionRowOne_date)
        {
            [self showDatePicker];
        }
        else if (row == SectionRowOne_provider)
        {
            ProviderViewController *providerVC = [[ProviderViewController alloc] initWithNibName:NIBCT(@"ProviderViewController") bundle:nil];
            [self.navigationController pushViewController:providerVC animated:YES];
        }
        else if (row == SectionRowOne_storage || row == SectionRowOne_warehouse)
        {
            PurchaseSelectedViewController *selectedVC = [[PurchaseSelectedViewController alloc] initWithNibName:NIBCT(@"PurchaseSelectedViewController") bundle:nil];
            
            if (row == SectionRowOne_storage) {
                selectedVC.type = SelectedType_storage;
            }
            else
            {
                selectedVC.type = SelectedType_resposity;
            }
            selectedVC.delegate = self;
            selectedVC.purchaseOrder = self.purchaseOrder;
            [self.navigationController pushViewController:selectedVC animated:YES];
        }
    }
    else if (section == OrderSection_two)
    {
        if (row != SectionRowTwo_productList)
        {
//            AddProductViewController *addVC = [[AddProductViewController alloc] initWithNibName:NIBCT(@"AddProductViewController") bundle:nil];
//            addVC.purchaseOrder = self.purchaseOrder;
//            addVC.delegate = self;
//            [self.navigationController pushViewController:addVC animated:YES];
            ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] initWithNibName:NIBCT(@"ProductDetailViewController") bundle:nil];
            detailVC.orderLine = [self.orderLines objectAtIndex:indexPath.row-1];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    else if (section == OrderSection_three)
    {
        if (row == SectionRowThree_approve) {
            
        }
    }
}




#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    if (textField.tag == 1001) {
        self.purchaseOrder.orderNo = textField.text;
    }
}

#pragma mark - Mermory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
