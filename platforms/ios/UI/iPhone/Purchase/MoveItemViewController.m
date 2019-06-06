//
//  ApproveProductViewController.m
//  Boss
//
//  Created by lining on 15/7/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MoveItemViewController.h"
#import "ProductCountView.h"
#import "UIImage+Resizable.h"
#import "BSEditCell.h"
#import "BSItemCell.h"
#import "BSFetchOrderLinesRequest.h"
#import "CBLoadingView.h"
#import "BSFetchMoveDetailRequest.h"
#import "BSHandlePurchaseOrderRequest.h"
#import "CBMessageView.h"
#import "PurchaseOrderViewController.h"

#define kBottomViewHeight  73
#define kMarginSize 16
#define kPicHeight  240
#define kNameHeight 60
#define kOtherHeight 50

typedef enum section_one_row
{
    section_row_name,
    section_row_count,
    section_row_src,
    section_row_dest,

    section_row_num,

}section_one_row;


@interface MoveItemViewController ()<UITableViewDataSource,UITableViewDelegate,ProductCountViewDelegate>
{
    BOOL isFirstLoadView;
    
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableDictionary *cacheParams;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSMutableDictionary *expandDict;
@end

@implementation MoveItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    
    self.navigationItem.title = @"待入库产品";
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    isFirstLoadView = true;
    [self initData];
    
    [self registerNofitificationForMainThread:kBSMoveDoneReponse];
    [self registerNofitificationForMainThread:kBSFetchMoveProductResponse];
    [self registerNofitificationForMainThread:kBSFetchMoveDetailResponse];
    [self registerNofitificationForMainThread:kBSTranslatePurchaseOrderResponse];
    [self registerNofitificationForMainThread:kBSInputPurchaseOrderResponse];
    
    self.expandDict = [NSMutableDictionary dictionary];
    

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
    [self.view addSubview:bottomView];
    bottomView.autoresizingMask = 0xff;
    UIImage *normalImg = [[UIImage imageNamed:@"order_btn_add.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 160, 10, 20)];
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(kMarginSize, (kBottomViewHeight - normalImg.size.height)/2.0, self.view.frame.size.width - 2*kMarginSize, normalImg.size.height);
    
    [bottomBtn setTitle:@"确定入库" forState:UIControlStateNormal];
    bottomBtn.autoresizingMask = 0xff & ~UIViewAutoresizingFlexibleHeight;
    [bottomBtn addTarget:self action:@selector(bottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bottomBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [bottomView addSubview:bottomBtn];
    
}


- (void)initData
{
    BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
    if ([self.moveOrder.item_ids componentsSeparatedByString:@","].count == 0) {
        return;
    }
    self.dataArray = [dataManager fetchPurchaseMoveOrderItemsWithItemIds:[self.moveOrder.item_ids componentsSeparatedByString:@","]];
}

#pragma mark - CBBackButtonItemDelegate
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    [[BSCoreDataManager currentManager] rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - button action
-(void)bottomBtnPressed:(UIButton *)btn
{
    NSLog(@"bottom button pressed");
    
    [[CBLoadingView shareLoadingView] show];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (CDPurchaseOrderMoveItem *item in self.dataArray) {

        [params setObject:@{@"quantity":item.count} forKey:[NSString stringWithFormat:@"%@",item.item_id]];
    }
    
    BSHandlePurchaseOrderRequest *request = [[BSHandlePurchaseOrderRequest alloc] initWithID:self.moveOrder.transfer_id type:HandleType_moveDone];
    request.params = params;
    [request execute];
}

#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMoveProductResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
//        self.oldOrderLines = [NSMutableArray arrayWithArray:self.purchaseOrder.orderlines.array];
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self initData];
            [self.tableView reloadData];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
    
    else if ([notification.name isEqualToString:kBSMoveDoneReponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        NSDictionary *retDict = notification.userInfo;
        if ([[retDict numberValueForKey:@"rc"] integerValue] == 0) {
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[PurchaseOrderViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                    break;
                }
            }
            [[[CBMessageView alloc] initWithTitle:@"入库成功"] show];
        }
        else
        {
            CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:[retDict stringValueForKey:@"rm"]];
            [msgView show];
        }
    }
    else if ([notification.name isEqualToString:kBSInputPurchaseOrderResponse])
    {
        //第一次入库
        
        NSDictionary *retDict = notification.userInfo;
        if ([[retDict numberValueForKey:@"rc"] integerValue] == 0) {
            self.moveOrder = notification.object;
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[retDict stringValueForKey:@"rm"]] show];
            [[CBLoadingView shareLoadingView] hide];
        }

    }
    else if ([notification.name isEqualToString:kBSTranslatePurchaseOrderResponse])
    {
        BSFetchMoveDetailRequest *request = [[BSFetchMoveDetailRequest alloc] initWithMoveOrder:self.moveOrder];
        [request execute];
    }
    else if ([notification.name isEqualToString:kBSFetchMoveDetailResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        if ([[self.expandDict objectForKey:@(section)] boolValue]) {
             return section_row_num;
        }
        else
        {
            return 1;
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        static NSString *cell_top = @"cell_top";
        
        BSEditCell *topCell = [tableView dequeueReusableCellWithIdentifier:cell_top];
        if (topCell == nil) {
            topCell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_top];

        }
        topCell.titleLabel.text = @"入库单号";
        topCell.contentField.text = self.moveOrder.name;
        return topCell;
    }
    else
    {
        CDPurchaseOrderMoveItem *moveItem = [self.dataArray objectAtIndex:section - 1];
        if (row == section_row_name) {
            static NSString *cell_name = @"cell_name";
            BSItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_name];
            if (cell == nil) {
                cell = [[BSItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_name];
                
                CGRect titleFrame = cell.titleLabel.frame;
                titleFrame.size.width = titleFrame.size.width - 3;
                cell.titleLabel.frame = titleFrame;
                
                UIImage *image = [UIImage imageNamed:@"purchase_down.png"];
                cell.arrowImageView.image = [UIImage imageNamed:@"purchase_down.png"];
                cell.arrowImageView.highlightedImage = [UIImage imageNamed:@"purchase_up.png"];
               
                cell.arrowImageView.frame = CGRectMake(IC_SCREEN_WIDTH - 10 - image.size.width ,(60 - image.size.height)/2.0, image.size.width ,image.size.height);
            }
            
            cell.titleLabel.text = moveItem.product.itemName;
            cell.detailLabel.text = [NSString stringWithFormat:@"内部编号: %@",moveItem.product.defaultCode? moveItem.product.defaultCode:@"暂无"];
            [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:moveItem.product.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
            
            cell.arrowImageView.highlighted = [[self.expandDict objectForKey:@(indexPath.section)] boolValue];
            
            return cell;
        }
        else if (row == section_row_count)
        {
            static NSString *cell_pic = @"cell_count";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_pic];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_pic];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, (kOtherHeight - 20)/2.0, 200, 20)];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.text = @"实际入库数量";
                nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
                nameLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
                [cell.contentView addSubview:nameLabel];
                
                ProductCountView *countView = [[ProductCountView alloc] initWithPoint:CGPointMake(self.tableView.frame.size.width - 3*36-kMarginSize, (kOtherHeight - 27)/2.0) count:[moveItem.count integerValue]];
                countView.tag = 101;
                countView.minCount = 0;
                countView.delegate = self;
                [cell.contentView addSubview:countView];
                
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kOtherHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
                lineImageView.backgroundColor = [UIColor clearColor];
                lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
                [cell.contentView addSubview:lineImageView];
            }
            ProductCountView *countView = (ProductCountView *)[cell.contentView viewWithTag:101];
            countView.indexPath = indexPath;
            countView.maxCount = [moveItem.count integerValue];
            countView.count = [moveItem.count integerValue];
        
            return cell;
        }
        else
        {
            static NSString *otherIdentifier = @"otherIdentifier";
            BSEditCell *otherCell = [tableView dequeueReusableCellWithIdentifier:otherIdentifier];
            if (otherCell == nil) {
                otherCell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherIdentifier];
                otherCell.contentField.delegate = self;
            }
            otherCell.contentField.enabled = false;
            if (row == section_row_src)
            {
                otherCell.titleLabel.text = @"源库位";
                otherCell.contentField.text = moveItem.src_location_name;
            }
            else if (row == section_row_dest)
            {
                otherCell.titleLabel.text = @"目的库位";
                otherCell.contentField.text = moveItem.dest_location_name;
            }
            return otherCell;
        }
    }
}



#pragma mark - ProductCountViewDelegate
-(void)countChanged:(ProductCountView *)countView
{
    NSInteger index = countView.indexPath.section - 1;
    CDPurchaseOrderMoveItem *item = self.dataArray[index];
    item.count = [NSNumber numberWithInt:countView.count];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return kOtherHeight;
    }
    else
    {
        if (row == section_row_name) {
            return kNameHeight;
        }
        else
        {
            return kOtherHeight;
        }
    }
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
    if (indexPath.row == 0) {
        NSNumber *isExpand = [self.expandDict objectForKey:@(indexPath.section)];
        
        [self.expandDict setObject:@(![isExpand boolValue]) forKey:@(indexPath.section)];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
