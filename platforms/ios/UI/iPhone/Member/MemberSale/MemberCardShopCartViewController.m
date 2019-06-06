//
//  MemberCardShopCartViewController.m
//  Boss
//
//  Created by lining on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardShopCartViewController.h"
#import "MemberCardCell.h"
#import "GoodsModel.h"
#import "OperateManager.h"
#import "BottomPayView.h"
#import "ShopCartCell.h"
#import "MemberCardPayModeViewController.h"
#import "EditShopCartViewController.h"

typedef enum kSection
{
    kSection_Buy,
    kSection_Use,
    kSection_Num
}kSection;

@interface MemberCardShopCartViewController ()<BottomPayViewDelegate>
{
    BNRightButtonItem *rightItem;
    BOOL isEdit;
}

@property (nonatomic, strong) BottomPayView *payView;
@property (nonatomic, strong) ShopCartCell *cartCell;
@end

@implementation MemberCardShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
  
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    

    
    self.title = @"购物车";
    
    [self initPayView];
    
    
    self.cartCell = [ShopCartCell createCell];
    self.cartCell.titleLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 50 - 12*2 - 12;
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 20)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableHeaderView;
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 20)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFooterView;
    
    [self registerNofitificationForMainThread:@"kShopCartDataChanged"];
    
}

#pragma mark 初始化底部的结算View
- (void) initPayView
{
    self.payView = [[[NSBundle mainBundle]loadNibNamed:@"BottomPayView" owner:nil options:nil]lastObject];
    self.payView.delegate = self;
    self.payView.operate = self.operateManager.posOperate;
    [self.bottomView addSubview:self.payView];
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - BottomPayViewDelegate
- (void)didGuaDanOperate:(CDPosOperate *)operate
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.operateManager guaDan];
}

- (void)didPayOperate:(CDPosOperate *)operate
{
//    
//    if (self.operateManager.posOperate.member.isDefaultCustomer.boolValue)
//    {
//        BOOL isCourses = NO;
//        for (int i = 0; i < self.operateManager.posOperate.products.count; i++)
//        {
//            CDPosBaseProduct *product = [self.operateManager.posOperate.products objectAtIndex:i];
//            if ( product.product.bornCategory.integerValue == kPadBornCategoryCourses || product.product.bornCategory.integerValue == kPadBornCategoryPackage || product.product.bornCategory.integerValue == kPadBornCategoryPackageKit)
//            {
//                isCourses = YES;
//                break;
//            }
//        }
//        
//        if (isCourses)
//        {
//            UIImage *image = [UIImage imageNamed:@"select_member_card_1"];
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - image.size.width)/2.0, (IC_SCREEN_HEIGHT - image.size.height)/2.0, image.size.width, image.size.height)];
//            imageView.userInteractionEnabled = YES;
//            imageView.backgroundColor = [UIColor clearColor];
//            imageView.image = image;
//            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.backgroundColor = [UIColor clearColor];
//            button.frame = CGRectMake(18.0, 274.0, 298.0, 60.0);
//            [button addTarget:self action:@selector(didSelectMemberCard:) forControlEvents:UIControlEventTouchUpInside];
//            [imageView addSubview:button];
//          
//            NSLog(@"提示选会员");
//            
//            return;
//        }
//    }
//    
//    if (!self.operateManager.posOperate.member.isDefaultCustomer.boolValue && self.operateManager.posOperate.memberCard == nil && self.operateManager.posOperate.couponCard == nil )
//    {
//        if (self.operateManager.posOperate.member.card.count == 1)
//        {
//            self.operateManager.posOperate.memberCard = [self.operateManager.posOperate.member.card objectAtIndex:0];
//        }
//        else
//        {
//            UIImage *image = [UIImage imageNamed:@"select_member_card_2"];
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - image.size.width)/2.0, (IC_SCREEN_HEIGHT - image.size.height)/2.0, image.size.width, image.size.height)];
//            imageView.userInteractionEnabled = YES;
//            imageView.backgroundColor = [UIColor clearColor];
//            imageView.image = image;
//            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.backgroundColor = [UIColor clearColor];
//            button.frame = CGRectMake(18.0, 274.0, 298.0, 60.0);
//            [button addTarget:self action:@selector(didSelectMemberCard:) forControlEvents:UIControlEventTouchUpInside];
//            [imageView addSubview:button];
//            NSLog(@"提示选一张会员卡");
//        }
//        
//        return;
//    }
    
//    if (self.data.posOperate.member.isDefaultCustomer.boolValue)
//    {
//        if (self.data.posOperate.member.card.count != 0)
//        {
//            self.data.posOperate.memberCard = [self.data.posOperate.member.card objectAtIndex:0];
//        }
//    }

    MemberCardPayModeViewController *payModeVC = [[MemberCardPayModeViewController alloc] init];
    payModeVC.operateType = kPadMemberCardOperateCashier;
    payModeVC.posOperate = self.operateManager.posOperate;
    [self.navigationController pushViewController:payModeVC animated:YES];
    
}

- (void)didShopCartOperate:(CDPosOperate *)operate
{
    return;
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"kShopCartDataChanged"]) {
        [self.operateManager reloadPosOperate];
        [self.tableView reloadData];
        self.payView.operate = self.operateManager.posOperate;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.operateManager.posOperate.useItems.count == 0 ) {
        return 1;
    }
    return kSection_Num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_Buy)
    {
        return self.operateManager.posOperate.products.count;
    }
    else if (section == kSection_Use) {
        return self.operateManager.posOperate.useItems.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartCell"];
    if (cell == nil) {
        cell = [ShopCartCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (section == kSection_Buy) {
        CDPosProduct *product = (CDPosProduct *)[self.operateManager.posOperate.products.array objectAtIndex:row];
        [self cell:cell buyItem:product];
        
        if (row == self.operateManager.posOperate.products.count - 1) {
            cell.lineImgView.hidden = true;
        }
        else
        {
            cell.lineImgView.hidden = false;
        }
        
    }
    else if (section == kSection_Use)
    {
        CDCurrentUseItem *useItem = (CDCurrentUseItem *)[self.operateManager.posOperate.useItems.array objectAtIndex:row];
        
        [self cell:cell useItem:useItem];
        
        if (row == self.operateManager.posOperate.useItems.count - 1) {
            cell.lineImgView.hidden = true;
        }
        else
        {
            cell.lineImgView.hidden = false;
        }
    }
    
    
    return cell;
}

- (void)cell:(ShopCartCell *)cell buyItem:(CDPosProduct *)product
{
    if (product.defaultCode.length != 0 && ![product.defaultCode isEqualToString:@"0"])
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"[%@]%@", product.defaultCode, product.product.itemName];
    }
    else
    {
        cell.titleLabel.text = product.product.itemName;
    }
    
    cell.countLable.text = [NSString stringWithFormat:@"x %d", product.product_qty.integerValue];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", product.product_price.floatValue * product.product_qty.integerValue];
    
    [cell.imgeView sd_setImageWithURL:[NSURL URLWithString:product.product.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledSmallImage"]];
}

- (void)cell:(ShopCartCell *)cell useItem:(CDCurrentUseItem *)useItem
{
    if (useItem.defaultCode.length != 0 && ![useItem.defaultCode isEqualToString:@"0"])
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"[%@]%@", useItem.defaultCode, useItem.projectItem.itemName];
    }
    else
    {
        cell.titleLabel.text = useItem.projectItem.itemName;
    }
    cell.countLable.text = [NSString stringWithFormat:@"x %d", useItem.useCount.integerValue];
    cell.priceLabel.text = @"卡内项目";
    
    
    [cell.imgeView sd_setImageWithURL:[NSURL URLWithString:useItem.projectItem.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledSmallImage"]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (section == kSection_Buy) {
//            CDPosProduct *product = (CDPosProduct *)[self.operateManager.posOperate.products objectAtIndex:indexPath.row];
            
            NSMutableOrderedSet *buyItems = [NSMutableOrderedSet orderedSetWithOrderedSet:self.operateManager.posOperate.products];
            [buyItems removeObjectAtIndex:row];
            
            self.operateManager.posOperate.products = buyItems;
        }
        else if (section == kSection_Use)
        {
            NSMutableOrderedSet *useItems = [NSMutableOrderedSet orderedSetWithOrderedSet:self.operateManager.posOperate.useItems];
            [useItems removeObjectAtIndex:row];
            
            self.operateManager.posOperate.useItems = useItems;
            
//            CDPosProduct *product = (CDPosProduct *)[self.operateManager.posOperate.products objectAtIndex:indexPath.row];
            if (useItems.count == 0) {
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                return;
            }
        }
        [self.operateManager reloadPosOperate];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.payView.operate = self.operateManager.posOperate;
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 85;
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    if (section == kSection_Buy) {
//        CDPosProduct *product = (CDPosProduct *)[self.operateManager.posOperate.products.array objectAtIndex:row];
//        
//       
//        [self cell:self.cartCell buyItem:product];
//        
//    }
//    else if (section == kSection_Use)
//    {
//        CDCurrentUseItem *useItem = (CDCurrentUseItem *)[self.operateManager.posOperate.useItems.array objectAtIndex:row];
//        
//        [self cell:self.cartCell useItem:useItem];
//    }
//
//    CGFloat height = [self.cartCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    NSLog(@"height: %.2f",height);
//    
//
//    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   if (section == kSection_Use)
    {
        if (self.operateManager.posOperate.useItems.count != 0) {
            return 40;
        }
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = COLOR(245, 245, 245, 1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, (40 - 20)/2.0, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    
    if (section == kSection_Use)
    {
        label.text = @"本次使用";
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    EditShopCartViewController *editCartVC = [[EditShopCartViewController alloc] init];
    if (section == kSection_Buy) {
        CDPosProduct *product = (CDPosProduct *)[self.operateManager.posOperate.products.array objectAtIndex:row];
        editCartVC.product = product;
    }
    else if (indexPath.section == kSection_Use)
    {
        CDCurrentUseItem *useItem = (CDCurrentUseItem *)[self.operateManager.posOperate.useItems.array objectAtIndex:row];
        editCartVC.useItem = useItem;
    }
    editCartVC.member = self.operateManager.posOperate.member;
    [self.navigationController pushViewController:editCartVC animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
