//
//  CreatePanDianViewController.m
//  Boss
//
//  Created by lining on 15/9/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "CreatePanDianViewController.h"
#import "UIImage+Resizable.h"
#import "BSEditCell.h"
#import "BSFetchPanDianItemRequest.h"
#import "CBLoadingView.h"
#import "PanDianLineHead.h" 
#import "PanDianLineCell.h"
#import "PurchaseSelectedViewController.h"
#import "ProjectViewController.h"
#import "BSAutoPandianRequest.h"
#import "BSHandlePanDianRequest.h"
#import "CBMessageView.h"
#import "BSCommonSelectedItemViewController.h"
#import "BSAutoPandianRequest.h"

#import "BNScanCodeViewController.h"

#define kBottomViewHeight  73
#define kMarginSize 20

@interface CreatePanDianViewController ()<UITableViewDataSource,UITableViewDelegate,PanDianLineCellDelegate,PurchaseSelectedDelegate,BSCommonSelectedItemViewControllerDelegate,ProjectItemPanDianDelegate,BNScanCodeDelegate,QRCodeViewDelegate>
{
    BNRightButtonItem *rightButtonItem;
    NSInteger currentSelectedSection;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIView *confirmView;


@property(nonatomic, strong) NSMutableArray *panDianItems;
@property(nonatomic, strong) NSMutableArray *oldPanDianItems;
@property(nonatomic, strong) NSMutableDictionary *cachePicParams;
@property(nonatomic, strong) NSMutableDictionary *dataDict;
@property(nonatomic, strong) NSMutableArray *keys;

@property(nonatomic, strong) NSMutableDictionary *itemParams;
@property(nonatomic, strong) NSMutableDictionary *params;
@property(nonatomic, strong) NSMutableDictionary *infoParams;

@property(nonatomic, strong) NSMutableDictionary *foldDict;

@property(nonatomic, strong) NSMutableDictionary *itemLineDict;
@property(nonatomic, strong) NSMutableDictionary *itemcountDict;

@property(nonatomic, strong) NSString *orginName;
@property(nonatomic, strong) NSNumber *originLocation_id;
@property(nonatomic, strong) NSString *orginFilter;

@property(nonatomic, strong) NSMutableArray *addItems;
@property(nonatomic, strong) NSMutableArray *removeItems;
@property(nonatomic, strong) NSMutableDictionary *editItemsDict;

@property(nonatomic, assign) BOOL needPanDian;
@property(nonatomic, assign) BOOL needConfirm;

@property(nonatomic, strong) NSIndexPath *scrollToIndexPath;
@property(nonatomic, strong) UIView *scanView;

@end

@implementation CreatePanDianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    self.hideKeyBoardWhenClickEmpty = true;
    
    self.foldDict = [NSMutableDictionary dictionary];
    self.cachePicParams = [NSMutableDictionary dictionary];
    
    self.addItems = [NSMutableArray array];
    self.removeItems = [NSMutableArray array];
    self.editItemsDict = [NSMutableDictionary dictionary];
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    currentSelectedSection = -1;
    
    [self registerNofitificationForMainThread:kBSPurchaseItemSelectFinish];
    
     self.panDianItems = [NSMutableArray array];
     rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"保存"];
     rightButtonItem.delegate = self;
    if (self.type == PanDianType_create) {
        self.title = @"创建盘点";

        self.panDian = [[BSCoreDataManager currentManager] insertEntity:@"CDPanDian"];
        
    }
    else
    {
        if (self.type == PanDianType_edit) {
            self.title = @"编辑盘点";
        }
        else if (self.type == PanDianType_confirm)
        {
            self.title = @"审核盘点";
        }
        else if (self.type == PanDianType_look)
        {
            self.title = @"查看盘点";
        }
        
        [self initOrgin];
        
        NSArray *line_ids = [self.panDian.line_ids componentsSeparatedByString:@","];
        
        if (line_ids.count > 0 && ![self.panDian.state isEqualToString:@"draft"]) {
            
            [[CBLoadingView shareLoadingView] show];
            BSFetchPanDianItemRequest *request = [[BSFetchPanDianItemRequest alloc] initWithItemIds:line_ids];
            [request execute];
            
            self.panDianItems = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchPanDianItemsWithIds:line_ids]];
        }
        
    }
    [self initDataDict];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    [self initView];
    
    [self registerNofitificationForMainThread:kBSFetchSinglePanDianResponse];
    [self registerNofitificationForMainThread:kBSAutoPanDianResponse];
    [self registerNofitificationForMainThread:kBSCreatePanDianResponse];
    [self registerNofitificationForMainThread:kBSFetchPanDianItemResponse];
    [self registerNofitificationForMainThread:kBSConfirmPanDianResponse];
    [self registerNofitificationForMainThread:kBSCancelConfirmPanDianResponse];
    [self registerNofitificationForMainThread:kBSEditPanDianResponse];
    
    NSArray *unuserArray = [[BSCoreDataManager currentManager] fetchPanDianItemsWithIds:@[@0]];
    [[BSCoreDataManager currentManager] deleteObjects:unuserArray];
    [self initScanView];
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
    if (self.type == PanDianType_create || [self.panDian.state isEqualToString:@"draft"] || self.type == PanDianType_look) {
        NSLog(@"没有");
    }
    else
    {
        self.tableView.tableFooterView = [self footView];
    }
    [self.view addSubview:self.tableView];
  
    [self initBottomView];
    [self initBottomConfirmView];
    
    
    if (self.type == PanDianType_create || self.type == PanDianType_edit)
    {
        self.confirmView.hidden = true;
    }
    else if (self.type == PanDianType_confirm)
    {
        self.bottomView.hidden = true;
        
    }
    else if (self.type == PanDianType_look)
    {
        self.tableView.frame = self.view.bounds;
        self.confirmView.hidden = true;
        self.bottomView.hidden = true;
    }
}


- (UIView *)footView
{
    CGFloat height = 40;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, height)];
//    view.autoresizingMask = 0xff&~UIViewAutoresizingFlexibleTopMargin;
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *topLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0, IC_SCREEN_WIDTH, 0.5)];
    topLineImgView.backgroundColor = [UIColor clearColor];
    topLineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [view addSubview:topLineImgView];
    
    UIImage *addImg = [UIImage imageNamed:@"navi_add_h"];
    
    UILabel *label = [[UILabel alloc] init];
//    label.autoresizingMask = 0xff&~UIViewAutoresizingFlexibleTopMargin;

    label.font = [UIFont systemFontOfSize:12];
    label.text = @"添加盘点产品";
    label.textColor = COLOR(104, 171, 245, 1);
    [label sizeToFit];
    
    CGFloat x = (IC_SCREEN_WIDTH - (addImg.size.width + 2 + label.frame.size.width))/2.0;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, (height - addImg.size.height)/2.0, addImg.size.width, addImg.size.height)];
    imgView.image = addImg;
//    imgView.autoresizingMask = 0xff&~UIViewAutoresizingFlexibleTopMargin;
    [view addSubview:imgView];
    
    x += 2 + imgView.frame.size.width;
    
    label.frame = CGRectMake(x, (height - label.frame.size.height)/2.0, label.frame.size.width, label.frame.size.height);
    [view addSubview:label];

    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, height - 0.5, IC_SCREEN_WIDTH, 0.5)];
    lineImgView.backgroundColor = [UIColor clearColor];
    lineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [view addSubview:lineImgView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = view.bounds;
    [view addSubview:button];
    [button addTarget:self action:@selector(addItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (void)initScanView
{
    self.scanView = [[UIView alloc] init];
    self.scanView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scanView];
    
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.equalTo(@50);
    }];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
    label.text = @"盘点明细";
    [self.scanView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.leading.offset(16);
    }];
    
    
    UIImage* scanImage = [UIImage imageNamed:@"navi_scan_h"];
    UIButton* scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton setImage:scanImage forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(didScanButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scanView addSubview:scanButton];
    
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.trailing.offset(-16);
    }];
    
    
//    scanButton.frame = CGRectMake(IC_SCREEN_WIDTH - scanImage.size.width - 16,( 50 - scanImage.size.height ) / 2, scanImage.size.width, scanImage.size.height);
//    
//    scanButton.tag = 10001;

    self.scanView.hidden = true;
}

- (void)initBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, IC_SCREEN_WIDTH, kBottomViewHeight)];
    //    bottomView.autoresizingMask = 0xff;
    self.bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
   
    [self.view addSubview:self.bottomView];

    
    UIImage *normalImg = [[UIImage imageNamed:@"order_btn_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 160, 10, 20)];
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(kMarginSize, (kBottomViewHeight - normalImg.size.height)/2.0, self.bottomView.frame.size.width - 2*kMarginSize, normalImg.size.height);
//    bottomBtn.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bottomBtn setTitle:@"自动盘点" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [self.bottomView addSubview:bottomBtn];
}


- (void)initBottomConfirmView
{
    self.confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, IC_SCREEN_WIDTH, kBottomViewHeight)];
    self.confirmView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.confirmView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.confirmView];
    
    CGFloat btnWidth = (IC_SCREEN_WIDTH - 2*kMarginSize - 2)/2.0;
    
    UIImage *leftImg = [[UIImage imageNamed:@"order_btn_short_ok.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 70, 10, 10)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    leftBtn.frame = CGRectMake(kMarginSize, (kBottomViewHeight - leftImg.size.height)/2.0, btnWidth, leftImg.size.height);
    [leftBtn setBackgroundImage:leftImg forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(sureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitle:@"审核盘点" forState:UIControlStateNormal];
    [self.confirmView addSubview:leftBtn];
    
    
    UIImage *rightImg = [[UIImage imageNamed:@"order_btn_short_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 70, 10, 10)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kMarginSize + btnWidth + 2, leftBtn.frame.origin.y, btnWidth, rightImg.size.height);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setBackgroundImage:rightImg forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"取消盘点" forState:UIControlStateNormal];
    [self.confirmView addSubview:rightBtn];
}

- (void) initOrgin
{
    self.orginName = self.panDian.name;
    self.originLocation_id = self.panDian.storage.storage_id;
    self.orginFilter = self.panDian.filter;
}

- (void) initDataDict
{
    
    self.dataDict = [NSMutableDictionary dictionary];
    self.keys = [NSMutableArray array];
    
    self.itemLineDict = [NSMutableDictionary dictionary];
    self.itemcountDict = [NSMutableDictionary dictionary];
    
    NSArray *line_ids = [self.panDian.line_ids componentsSeparatedByString:@","];
    if (line_ids.count > 0) {
        self.panDianItems = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchPanDianItemsWithIds:line_ids]];

        for (CDPanDianItem *item in self.panDianItems) {
            [self addDataDict:item];
        }
    }
}


- (void)addDataDict:(CDPanDianItem *)item
{
    NSString *key;
    if (item.projectItem.templateName == nil) {
        key = item.projectItem.itemName;
    }
    else
    {
        key  = item.projectItem.templateName;
        
    }
   
    if (key.length == 0) {
        return;
    }
    NSLog(@"templateId: %@  templateName: %@",item.projectItem.templateID,item.projectItem.templateName);
    NSMutableArray *array = [self.dataDict objectForKey:key];
    
    if (array == nil) {
        array = [NSMutableArray array];
        [self.keys addObject:key];
        [self.dataDict setObject:array forKey:key];
    }

    [self.itemcountDict setObject:item.fact_count forKey:item.projectItem.itemID];
    [self.itemLineDict setObject:item.item_id forKey:item.projectItem.itemID];
    
    [array addObject:item];
    
    
    
    self.scrollToIndexPath = [NSIndexPath indexPathForRow:array.count inSection:self.keys.count + PanDianSection_num - 1];
    NSLog(@"滚动到： %@",self.scrollToIndexPath);
   
}



#pragma mark - UIButton action

- (void)didItemBackButtonPressed:(UIButton *)sender
{
    
    if (self.type == PanDianType_create) {
        [[BSCoreDataManager currentManager] deleteObject:self.panDian];
        [[BSCoreDataManager currentManager] save:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [self popToPanDianVCRefresh];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    if (self.type == HandlePanDian_create) {
        if ([self infoParamsIsOK]) {
            BSHandlePanDianRequest *reqest = [[BSHandlePanDianRequest alloc] initWithPanDian:self.panDian type:HandlePanDian_create];
            reqest.params = [self createParams];
            [reqest execute];
        }
    }
    else
    {
        NSMutableDictionary *params = [self editInfoParams];
        NSArray *itemLines = [self panDianItemLinesParams];
        if (itemLines.count > 0) {
            params[@"line_ids"] = [self panDianItemLinesParams];
        }
        if (itemLines.count > 0) {
            NSLog(@"修改");
            BSHandlePanDianRequest *request = [[BSHandlePanDianRequest alloc] initWithPanDian:self.panDian type:HandlePanDian_edit];
            request.params = params;
            [request execute];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}

- (void)bottomBtnPressed:(UIButton *)btn
{
    NSLog(@"查询盘点");
    
    if ([self infoParamsIsOK]) {
        [[CBLoadingView shareLoadingView] show];
        if (self.type == HandlePanDian_create) {
            BSHandlePanDianRequest *request = [[BSHandlePanDianRequest alloc] initWithPanDian:self.panDian type:HandlePanDian_create];
            request.params = [self createParams];
            self.needPanDian = true;
            [request execute];
        }
        else if ([self.panDian.state isEqualToString:@"draft"])
        {
            NSMutableDictionary *params = [self editParams];
            if (params.allKeys.count > 0) {
                NSLog(@"有更改，现更改再盘点");
                BSHandlePanDianRequest *request = [[BSHandlePanDianRequest alloc] initWithPanDian:self.panDian type:HandlePanDian_edit];
                request.params = params;
                self.needPanDian = true;
                [request execute];
            }
            else
            {
                BSAutoPandianRequest *request = [[BSAutoPandianRequest alloc] initWithPanDian:self.panDian];
                [request execute];
            }
        }
    }
    
    
    NSLog(@"bottom btn pressed");
}

- (void)addItemPressed:(UIButton *)btn
{
//    ProjectViewController *projectViewController = [[ProjectViewController alloc] initWithViewType:kProjectSelectPurchase existItemIds:nil];
//    [self.navigationController pushViewController:projectViewController animated:YES];
    
    ProjectViewController *projectVC = [[ProjectViewController alloc] initWithParams:self.itemcountDict delegate:self];
    [self.navigationController pushViewController:projectVC animated:YES];
}

- (void)sureBtnPressed:(UIButton *)btn
{
    NSMutableDictionary *params = [self editInfoParams];
    NSArray *itemLines = [self panDianItemLinesParams];
    if (itemLines.count > 0) {
        params[@"line_ids"] = [self panDianItemLinesParams];
    }
    [[CBLoadingView shareLoadingView] show];
    if (params.allKeys.count > 0) {
        
        BSHandlePanDianRequest *request = [[BSHandlePanDianRequest alloc] initWithPanDian:self.panDian type:HandlePanDian_edit];
        request.params = params;
//        request.needConfirm = true;
        self.needConfirm = true;
        [request execute];
        
    }
    else
    {
        BSHandlePanDianRequest *request = [[BSHandlePanDianRequest alloc] initWithPanDian:self.panDian type:HandlePanDian_confirmed];
        [request execute];
    }
    NSLog(@"right btn pressed");
}

- (void)cancelBtnPressed:(UIButton *)btn
{
    NSLog(@"cancel btn pressed");
    BSHandlePanDianRequest *request = [[BSHandlePanDianRequest alloc] initWithPanDian:self.panDian type:HandlePanDian_cancel];
    [request execute];
}


#pragma mark - Request & Params

- (NSMutableDictionary *)createParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"move_ids"] = @[];
    params[@"product_id"] = [NSNumber numberWithBool:false];
    params[@"partner_id"] = [NSNumber numberWithBool:false];
    params[@"company_id"] = [PersonalProfile currentProfile].businessId;
    params[@"filter"] = self.panDian.filter;
    params[@"package_id"] = [NSNumber numberWithBool:false];
    params[@"period_id"] = [NSNumber numberWithBool:false];
    params[@"line_ids"] = [NSNumber numberWithBool:false];
    params[@"lot_id"] = [NSNumber numberWithBool:false];
    params[@"location_id"] = self.panDian.storage.storage_id;
    params[@"name"] = self.panDian.name;
    return params;
}

- (BOOL)infoParamsIsOK
{
    if (self.panDian.name == nil) {
        CBMessageView *message= [[CBMessageView alloc]initWithTitle:@"名字不能为空" afterTimeHide:1.25];
        [message showInView:self.view];
        return NO;
    }
    else if (self.panDian.storage == nil)
    {
        CBMessageView *message= [[CBMessageView alloc]initWithTitle:@"盘点库位不能为空" afterTimeHide:1.25];
        [message showInView:self.view];
        return NO;
    }
    return  YES;
}

- (NSMutableDictionary *)editParams
{
    NSMutableDictionary *params = [self editInfoParams];
    NSArray *itemLines = [self panDianItemLinesParams];
    if (itemLines.count > 0) {
        params[@"line_ids"] = [self panDianItemLinesParams];
    }
    return params;
}


- (NSMutableDictionary *)editInfoParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (![self.panDian.name isEqualToString: self.orginName]) {
        params[@"name"] = self.panDian.name;
    }
    if (![self.panDian.filter isEqualToString: self.orginFilter]) {
        params[@"filter"] = self.panDian.filter;
    }
    if (self.panDian.storage.storage_id.integerValue != self.originLocation_id.integerValue) {
        params[@"location_id"] = self.panDian.storage.storage_id;
    }
//    NSArray *itemLines = [self panDianItemLinesParams];
//    if (itemLines.count > 0) {
//        params[@"line_ids"] = [self panDianItemLinesParams];
//    }
    return params;
}

- (NSMutableArray *)panDianItemLinesParams
{
    if (self.editItemsDict.allKeys.count == 0 && self.addItems.count == 0 && self.removeItems.count == 0) {
        return nil;
    }
    
    NSMutableArray *itemLinesParam = [NSMutableArray array];
    for (CDPanDianItem *item in self.panDianItems) {
        
        NSDictionary *editDict = [self.editItemsDict objectForKey:item.item_id];
        if (editDict) {
            NSArray *subArray = @[[NSNumber numberWithInteger:kBSDataUpdate],item.item_id,editDict];
            [itemLinesParam addObject:subArray];
        }
        else
        {
            NSArray *subArray = @[[NSNumber numberWithInteger:kBSDataLinked],item.item_id,[NSNumber numberWithBool:false]];
            [itemLinesParam addObject:subArray];
        }
    }
    
    for (CDPanDianItem *item in self.addItems) {
        NSMutableArray *subArray = [NSMutableArray array];
        [subArray addObject:[NSNumber numberWithInteger:kBSDataAdded]];
        [subArray addObject:[NSNumber numberWithBool:false]];
        NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
        subDict[@"partner_id"] =  [NSNumber numberWithBool:false];
        subDict[@"product_id"] =  item.projectItem.itemID;
        subDict[@"product_uom_id"] =  item.projectItem.uomID;
        subDict[@"prod_lot_id"] =  [NSNumber numberWithBool:false];
        subDict[@"package_id"] = [NSNumber numberWithBool:false];
        subDict[@"product_qty"] =  item.fact_count;
        subDict[@"location_id"] =  self.panDian.storage.storage_id;
       
        [subArray addObject:subDict];
        
        [itemLinesParam addObject:subArray];
    }
    
    for (CDPanDianItem *item in self.removeItems) {
        NSArray *subArray = @[[NSNumber numberWithInteger:kBSDataDelete],item.item_id,[NSNumber numberWithBool:false]];
        [itemLinesParam addObject:subArray];
    }
    
    return itemLinesParam;
}

#pragma mark - ReloadView
- (void) reloadView
{
    if (self.type != PanDianType_look) {
        self.tableView.tableFooterView = [self footView];
        self.bottomView.hidden = true;
        self.confirmView.hidden = false;
        self.type = PanDianType_confirm;
        [self initDataDict];
        [self.tableView reloadData];
    }
}

#pragma mark - notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchPanDianItemResponse]) {
        [[CBLoadingView shareLoadingView] hide];
        [self reloadView];
    }
    else if ([notification.name isEqualToString:kBSPurchaseItemSelectFinish])
    {
        CDProjectItem *projectItem = (CDProjectItem *)notification.object;
        CDPanDianItem *panItem = [[BSCoreDataManager currentManager] insertEntity:@"CDPanDianItem"];
        panItem.projectItem = projectItem;
        panItem.product_name = projectItem.itemName;
        panItem.product_id = projectItem.itemID;
        [self addDataDict:panItem];
        [self.tableView reloadData];
        
        if (self.scrollToIndexPath) {
           [self.tableView scrollToRowAtIndexPath:self.scrollToIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }

        [self.addItems addObject:panItem];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([notification.name isEqualToString:kBSCreatePanDianResponse])
    {
        NSLog(@"创建盘点的通知");
        if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] == 0) {
            if (self.needPanDian) {
                NSLog(@"开始自动盘点");
                [[[BSAutoPandianRequest alloc] initWithPanDian:self.panDian] execute];
            }
            else
            {
                [[CBLoadingView shareLoadingView] hide];
                [[[CBMessageView alloc] initWithTitle:@"盘点创建成功"] show];
                [self popToPanDianVCRefresh];
            }
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([notification.name isEqualToString:kBSEditPanDianResponse])
    {
        NSLog(@"编辑盘点的通知");
        if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] == 0) {
            if (self.needPanDian) {
                NSLog(@"开始自动盘点");
                [[[BSAutoPandianRequest alloc] initWithPanDian:self.panDian] execute];
            }
            else if (self.needConfirm)
            {
                NSLog(@"确认审核");
                [[[BSHandlePanDianRequest alloc] initWithPanDian:self.panDian type:HandlePanDian_confirmed] execute];
            }
            else
            {
                [[CBLoadingView shareLoadingView] hide];
                [[[CBMessageView alloc] initWithTitle:@"盘点保存成功"] show];
                [self popToPanDianVCRefresh];
            }
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
            [self popToPanDianVCRefresh];
        }

    }
    else if ([notification.name isEqualToString:kBSAutoPanDianResponse])
    {
         NSLog(@"自动盘点通知");
         if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] != 0)
         {
             [[CBLoadingView  shareLoadingView] hide];
             [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
//             [self.navigationController popViewControllerAnimated:YES];
         }
    }
    else if ([notification.name isEqualToString:kBSFetchSinglePanDianResponse])
    {
        NSLog(@"拿一个盘点的通知");
        if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] != 0)
        {
            [[CBLoadingView  shareLoadingView] hide];
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
    else if ([notification.name isEqualToString:kBSCancelConfirmPanDianResponse])
    {
        NSLog(@"取消审核盘点通知");
        [[CBLoadingView  shareLoadingView] hide];
        if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] == 0)
        {
            [[[CBMessageView alloc] initWithTitle:@"取消审核成功"] show];
            
            [self popToPanDianVCRefresh];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];

        }

    }
    else if ([notification.name isEqualToString:kBSConfirmPanDianResponse])
    {
        NSLog(@"审核盘点通知");
        [[CBLoadingView  shareLoadingView] hide];
        if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] == 0)
        {
            [[[CBMessageView alloc] initWithTitle:@"审核成功"] show];
            
            [self popToPanDianVCRefresh];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
   
}

#pragma mark - pop to refresh 
- (void)popToPanDianVCRefresh
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.6];
    [[NSNotificationCenter defaultCenter] postNotificationName:PopToPanDianVCRefresh object:nil];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"offset: %@",NSStringFromCGPoint(scrollView.contentOffset));
    if (scrollView.contentOffset.y < 190) {
        self.scanView.hidden = true;
    }
    else
    {
        self.scanView.hidden = false;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return PanDianSection_num + self.keys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == PanDianSection_one) {
        return SectionRowOne_num;
    }
    else if (section == PanDianSection_two)
    {
        return 1;
    }
    else
    {
//        if (currentSelectedSection == section) {
//             int idx = section - PanDianSection_num;
//             NSString *key = [self.keys objectAtIndex:idx];
//             NSArray *items = [self.dataDict objectForKey:key];
//             return items.count + 1;
//        }
//        else
//        {
//            return 1;
//        }
        
        if ([[self.foldDict objectForKey:@(section)] boolValue]) {
            return 1;
        }
        else
        {
            int idx = section - PanDianSection_num;
            NSString *key = [self.keys objectAtIndex:idx];
            NSArray *items = [self.dataDict objectForKey:key];
//            if (items.count == 1) {
//                return items.count;
//            }
            return items.count + 1;
        }
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section < PanDianSection_num)
    {
        if (section == PanDianSection_one)
        {
            static NSString *indentifier = @"indentifier22";
            BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            if (cell == nil) {
                cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                cell.contentField.delegate = self;
            }
            
            cell.arrowImageView.hidden = false;
            cell.arrowImageView.image = [UIImage imageNamed:@"bs_common_arrow.png"];
            cell.contentField.enabled = false;
            
            if (row == SectionRowOne_name)
            {
                cell.contentField.tag = 1001;
                cell.contentField.enabled = true;
                cell.titleLabel.text = @"盘点单名称";
                cell.contentField.placeholder = @"请输入...";
                cell.contentField.text = self.panDian.name;
            }
            else if (row == SectionRowOne_company)
            {
                cell.titleLabel.text = @"盘点公司";
                
                cell.contentField.placeholder = @"请选择...";
                cell.contentField.text = self.panDian.storage.displayName;
                
            }
            else if (row == SectionRowOne_location)
            {
                cell.titleLabel.text = @"仓库";
                cell.contentField.placeholder = @"请选择";
                cell.contentField.text = self.panDian.storage.displayName;
            }
            else if (row == SectionRowOne_type)
            {
                cell.titleLabel.text = @"盘点对";
                cell.contentField.placeholder = @"请选择";
                if (self.panDian.filter) {
                    if ([self.panDian.filter isEqualToString:@"none"]) {
                        cell.contentField.text = @"所有产品";
                    }
                    else
                    {
                        cell.contentField.text = @"手动";
                    }
                }
                else
                {
                    cell.contentField.text = @"所有产品";
                }
                
            }
            if (!(self.type == HandlePanDian_create || [self.panDian.state isEqualToString:@"draft"])) {
                cell.contentField.enabled = false;
                cell.arrowImageView.hidden = true;
            }
            
            return cell;
        }
        else
        {
            static NSString *indentifier = @"indentifier5";
            BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            if (cell == nil)
            {
                cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                cell.contentField.delegate = self;
                
                UIImage* scanImage = [UIImage imageNamed:@"navi_scan_h"];
                UIButton* scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
                scanButton.frame = CGRectMake(IC_SCREEN_WIDTH - scanImage.size.width - 16,( 50 - scanImage.size.height ) / 2, scanImage.size.width, scanImage.size.height);
                [scanButton setImage:scanImage forState:UIControlStateNormal];
                [scanButton addTarget:self action:@selector(didScanButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                scanButton.tag = 10001;
                [cell.contentView addSubview:scanButton];
            }
            
            UIButton *scanBtn = [cell.contentView viewWithTag:10001];
            if (self.type == PanDianType_confirm) {
                scanBtn.hidden = false;
            }
            else
            {
                scanBtn.hidden = true;
            }
            
            cell.arrowImageView.hidden = false;
            if (section == PanDianSection_two) {
                cell.titleLabel.text = @"盘点明细";
                cell.contentField.text = @"";
                cell.arrowImageView.image = [UIImage imageNamed:@"navi_add_n.png"];
            }
            
            return cell;
        }
    }
    else
    {
        int idx = section - PanDianSection_num;
    
        NSString *key = [self.keys objectAtIndex:idx];
        NSArray *items = [self.dataDict objectForKey:key];
        
        if (row == 0) {
//            if (items.count == 1) {
//                static NSString *identifier = @"identifier";
//                PanDianLineCell *lineCell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                if (lineCell == nil) {
//                    lineCell = [[PanDianLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier width:self.tableView.frame.size.width hasImgView:true];
//                    lineCell.delegate = self;
//                    lineCell.nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
//                }
//                
//                NSArray *panItems = [self.dataDict objectForKey:[self.keys objectAtIndex:idx]];
//                CDPanDianItem *item = [panItems objectAtIndex:row];
//                
//                lineCell.indexPath = indexPath;
//                lineCell.nameLabel.text = key;
//                lineCell.defaultCountLabel.text = [NSString stringWithFormat:@"实际数量: %@",item.fact_count];
//                lineCell.countField.text = [NSString stringWithFormat:@"%@",item.fact_count];
//                
//                CDProjectTemplate *template = item.projectItem.projectTemplate;
//                [lineCell.picView setImageWithName:template.imageNameMedium tableName:@"product.template" filter:template.templateID fieldName:@"image_medium" writeDate:template.lastUpdate placeholderString:@"project_item_default_48_36" cacheDictionary:self.cachePicParams];
//                
//                return lineCell;
//            }
//            else
            {
                static NSString *headIdentifer = @"headIdentifer";
                PanDianLineHead *headCell = [tableView dequeueReusableCellWithIdentifier:headIdentifer];
                if (headCell == nil) {
                    headCell = [[PanDianLineHead alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headIdentifer width:self.tableView.frame.size.width];
                    
                }
                CDPanDianItem *panItem = [items objectAtIndex:0];
                headCell.nameLabel.text = key;
                CDProjectTemplate *template = panItem.projectItem.projectTemplate;
                [headCell.picView sd_setImageWithURL:[NSURL URLWithString:template.imageUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
                if (section == currentSelectedSection) {
                    headCell.arrowImageView.highlighted = true;
                }
                else
                {
                    headCell.arrowImageView.highlighted = false;
                }
                
                if ([[self.foldDict objectForKey:@(section)] boolValue]) {
                    headCell.arrowImageView.highlighted = false;
                }
                else
                {
                    headCell.arrowImageView.highlighted = true;
                }
                
                return headCell;
            }
            
        }
        else
        {
            static NSString *cellIdentifier = @"cellIdentifier";
            PanDianLineCell *lineCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (lineCell == nil) {
                lineCell = [[PanDianLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier width:self.tableView.frame.size.width];
                lineCell.delegate = self;
            }
            
            NSArray *panItems = [self.dataDict objectForKey:[self.keys objectAtIndex:idx]];
            CDPanDianItem *item = [panItems objectAtIndex:row - 1];
            
            lineCell.indexPath = indexPath;
            lineCell.nameLabel.text = item.product_name;
            lineCell.defaultCountLabel.text = [NSString stringWithFormat:@"实际数量: %@",item.fact_count];
            lineCell.countField.text = [NSString stringWithFormat:@"%@",item.fact_count];
            NSLog(@"盘点数量： %@",item.fact_count);
            if (currentSelectedSection == section && row == 1) {
                lineCell.lineImgView.hidden = true;
            }
            else
            {
                lineCell.lineImgView.hidden = false;
            }
            if (self.type == PanDianType_look) {
                lineCell.countField.enabled = false;
            }
            else
            {
                lineCell.countField.enabled = true;
            }
            return lineCell;
        }
    }
    return nil;
}

- (void)didScanButtonPressed:(id)sender
{
    
    
    if (IS_SDK7)
    {
        BNScanCodeViewController *viewController = [[BNScanCodeViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else
    {
    }
}

- (void)didQRBackButtonClick:(QRCodeView *)qrCodeView
{
    
}

- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result
{
    [self searchProduct:result];
}

- (void)searchProduct:(NSString*)result
{
    CDProjectItem* item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:result forKey:@"barcode"];
    if ( item )
    {
        [self didEditPanDianWithProjectItem:item addAmount:1];
    }
    else
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"" message:@"很抱歉 没有该产品" delegate:self cancelButtonTitle:@"" otherButtonTitles:@"我知道了", nil];
        [v show];
    }
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == PanDianType_create || self.type == PanDianType_edit || self.type == PanDianType_confirm) {
        if (indexPath.section >= PanDianSection_num) {
            
//            int idx = indexPath.section - PanDianSection_num;
            
//            NSString *key = [self.keys objectAtIndex:idx];
//            NSArray *items = [self.dataDict objectForKey:key];
            if (indexPath.row == 0 ) {
//                if (items.count == 1) {
//                    return true;
//                }
//                else
//                {
//                    return false;
//                }
                return false;
                
            }
            return true;
        }
    }
    
    return false;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        
        NSString *key = [self.keys objectAtIndex:section - PanDianSection_num];
        NSMutableArray *items = [self.dataDict objectForKey:key];
        
        
        
        int rowIdx = row - 1;
        CDPanDianItem *item = [items objectAtIndex:rowIdx];
        if ([item.item_id integerValue] > 0) {
            [self.removeItems addObject:item];
            [self.panDianItems removeObject:item];
        }
        else
        {
            [self.addItems removeObject:item];
            [[BSCoreDataManager currentManager] deleteObject:item];
        }
        
        [items removeObjectAtIndex:rowIdx];
        [self.itemcountDict removeObjectForKey:item.projectItem.itemID];
      
        if (items.count == 0) {
//            [tableView beginUpdates];
            [self.keys removeObjectAtIndex:(section - PanDianSection_num)];
            [self.dataDict removeObjectForKey:key];
            currentSelectedSection = -1;
            self.foldDict = [NSMutableDictionary dictionary];
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];

        }
//        else if (items.count == 1)
//        {
//            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
        else
        {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    
    if (section < PanDianSection_num) {
        return 50;
    }
    else
    {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < PanDianSection_num) {
         return 20;
    }
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section < PanDianSection_num) {
        if (!(self.type == HandlePanDian_create || [self.panDian.state isEqualToString:@"draft"])) {
            NSLog(@"不可更改");
            return;
        }
        if (section == PanDianSection_one) {
            if (row == SectionRowOne_location) {
                PurchaseSelectedViewController *selectedVC = [[PurchaseSelectedViewController alloc] initWithNibName:NIBCT(@"PurchaseSelectedViewController") bundle:nil];
                selectedVC.type = SelectedType_storage;
                selectedVC.selectedObject = self.panDian.storage;
                selectedVC.delegate = self;
                [self.navigationController pushViewController:selectedVC animated:YES];
            }
            else if (row == SectionRowOne_type)
            {
                BSCommonSelectedItemViewController *selectedView = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
                selectedView.delegate = self;
                selectedView.dataArray = [[NSMutableArray alloc]initWithArray:@[@"所有产品",@"手动"]];
                BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                selectedView.userData = selectedView.dataArray;
                NSString *str = cell.contentField.text;
                selectedView.currentSelectIndex = [selectedView.dataArray indexOfObject:str];
                [self.navigationController pushViewController:selectedView animated:YES];
            }
        }
        else if (section == PanDianSection_two)
        {
            
        }
    }
    else
    {
        if (row == 0) {
            if (currentSelectedSection == section) {
                currentSelectedSection = -1;
            }
            else
            {
                currentSelectedSection = section;
            }
            BOOL fold = [[self.foldDict objectForKey:@(section)] boolValue];
            [self.foldDict setObject:@(!fold) forKey:@(section)];
            
            [self.tableView reloadData];
        }
        else
        {
            
        }
    }
    
}





#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.panDian.name = textField.text;
}

#pragma mark - PanDianLineCellDelegate
- (void) textFieldDidEndEdit:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"text: %@  atIndexPath: %@",text, indexPath);
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *items = [self.dataDict objectForKey:[self.keys objectAtIndex:section - PanDianSection_num]];

//    int rowIdx = row;
//    if (items.count > 1) {
//        rowIdx = row - 1;
//    }
    int rowIdx = row - 1;
    CDPanDianItem *item = [items objectAtIndex:rowIdx];
    
    
    item.fact_count =[NSNumber numberWithInt:[text integerValue]];
    
    [self.itemcountDict setObject:item.fact_count forKey:item.projectItem.itemID];
    
    
    if ([item.item_id integerValue] > 0) {
        if ([item.orgin_count integerValue] == [item.fact_count integerValue]) {
            NSMutableDictionary *subDict = [self.editItemsDict objectForKey:item.item_id];
            [subDict removeObjectForKey:@"product_qty"];
            if (subDict.allKeys == 0) {
                [self.editItemsDict removeObjectForKey:item.item_id];
            }
        }
        else
        {
            NSMutableDictionary *subDict = [self.editItemsDict objectForKey:item.item_id];
            if (!subDict) {
                subDict = [NSMutableDictionary dictionary];
                [self.editItemsDict setObject:subDict forKey:item.item_id];
            }
            [subDict setObject:item.fact_count forKey:@"product_qty"];
        }
    }
}



#pragma mark - PurchaseSelectedDelegate
-(void)didSelectedManageObject:(NSManagedObject *)object withType:(SelectedType)type
{
    CDStorage *storage = (CDStorage *)object;
    self.panDian.storage = storage;
    [self.tableView reloadData];
    
}

#pragma mark - BSCommonSelectedItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    NSArray *fitlers = userData;
    NSString *filter = [fitlers objectAtIndex:index];
    
    if ([filter isEqualToString:@"所有产品"])
    {
        self.panDian.filter = @"none";
    }
    else
    {
        self.panDian.filter = @"partial";
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SectionRowOne_type inSection: PanDianSection_one]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ProjectPanDianItemDelegate
- (void)didAddPanDianWithProjectItem:(CDProjectItem *)item
{
    NSLog(@"didAddPanDianWithProjectItem");
    CDProjectItem *projectItem = item;
    CDPanDianItem *panItem = [[BSCoreDataManager currentManager] insertEntity:@"CDPanDianItem"];
    panItem.projectItem = projectItem;
    panItem.product_name = projectItem.itemName;
    panItem.product_id = projectItem.itemID;
    [self addDataDict:panItem];
    
    [self.itemcountDict setObject:@(1) forKey:panItem.projectItem.itemID];
    
    [self.tableView reloadData];
    
    if (self.scrollToIndexPath) {
        [self.tableView scrollToRowAtIndexPath:self.scrollToIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
//    NSLog(@"_____________1______________%@",panItem);
    
    
    CDPanDianItem *panDianItem = [[BSCoreDataManager currentManager] findEntity:@"CDPanDianItem" withPredicateString:[NSString stringWithFormat:@"item_id=%@ && projectItem.itemID=%@",@(0),item.itemID]];
    
//    NSLog(@"_____________2______________%@",panDianItem);
    
    if (panItem != panDianItem) {
        NSLog(@"______________________不是同一个_______________________");
    }
    
    [self.addItems addObject:panItem];
}
- (void)didDeletePanDianWithProjectItem:(CDProjectItem *)item
{
    NSLog(@"didDeletePanDianWithProjectItem");
    NSString *key = nil;
    if (item.templateName == nil) {
        key = item.itemName;
    }
    else
    {
        key  = item.templateName;
        
    }
    NSNumber *line_id = [self.itemLineDict objectForKey:item.itemID];
    CDPanDianItem *panDianItem = [[BSCoreDataManager currentManager] findEntity:@"CDPanDianItem" withPredicateString:[NSString stringWithFormat:@"item_id=%@ && projectItem.itemID=%@",line_id,item.itemID]];
    if (line_id.integerValue > 0) {
        [self.removeItems addObject:panDianItem];
        [self.panDianItems removeObject:panDianItem];
    }
    else
    {
        [self.addItems removeObject:panDianItem];
        [[BSCoreDataManager currentManager] deleteObject:panDianItem];
    }
    
    
    [self.itemcountDict removeObjectForKey:item.itemID];
    NSMutableArray *items = [self.dataDict objectForKey:key];
    [items removeObject:panDianItem];
    if (items.count == 0) {
        [self.keys removeObject:key];
       
        [self.dataDict removeObjectForKey:key];
        currentSelectedSection = -1;
    }
    self.foldDict = [NSMutableDictionary dictionary];
    [self.tableView reloadData];
}

- (void)didEditPanDianWithProjectItem:(CDProjectItem *)item addAmount:(NSInteger)amount
{
    NSNumber* countNumber = self.itemcountDict[item.itemID];
    if  ( countNumber )
    {
        [self didEditPanDianWithProjectItem:item withAmount:[countNumber integerValue] + 1];
    }
    else
    {
        [self didAddPanDianWithProjectItem:item];
        [self didEditPanDianWithProjectItem:item withAmount:1];
    }
}

- (void)didEditPanDianWithProjectItem:(CDProjectItem *)item withAmount:(NSInteger)amount
{
    NSLog(@"didEditPanDianWithProjectItem:  %d",amount);
    
    NSString *key = nil;
    if (item.templateName == nil) {
        key = item.itemName;
    }
    else
    {
        key  = item.templateName;
    }
    
    NSNumber *line_id = [self.itemLineDict objectForKey:item.itemID];
    CDPanDianItem *panDianItem = [[BSCoreDataManager currentManager] findEntity:@"CDPanDianItem" withPredicateString:[NSString stringWithFormat:@"item_id=%@ && projectItem.itemID=%@",line_id,item.itemID]];

    panDianItem.fact_count =[NSNumber numberWithInt:amount];
    
    [self.itemcountDict setObject:@(amount) forKey:panDianItem.projectItem.itemID];
    
    if ([panDianItem.item_id integerValue] > 0) {
        if ([panDianItem.orgin_count integerValue] == [panDianItem.fact_count integerValue]) {
            NSMutableDictionary *subDict = [self.editItemsDict objectForKey:panDianItem.item_id];
            [subDict removeObjectForKey:@"product_qty"];
            if (subDict.allKeys == 0) {
                [self.editItemsDict removeObjectForKey:panDianItem.item_id];
            }
        }
        else
        {
            NSMutableDictionary *subDict = [self.editItemsDict objectForKey:panDianItem.item_id];
            if (!subDict) {
                subDict = [NSMutableDictionary dictionary];
                [self.editItemsDict setObject:subDict forKey:panDianItem.item_id];
            }
            [subDict setObject:panDianItem.fact_count forKey:@"product_qty"];
        }
    }

    [self.tableView reloadData];
    
    NSInteger section = [self.keys indexOfObject:key] + PanDianSection_num - 1;
    NSInteger row = [[self.dataDict objectForKey:key] indexOfObject:item];
    
    self.scrollToIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
