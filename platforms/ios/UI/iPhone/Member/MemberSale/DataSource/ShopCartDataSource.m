//
//  ShopCartDataSource.m
//  Boss
//
//  Created by lining on 16/7/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ShopCartDataSource.h"
#import "ShopCartCell.h"
#import "OperateManager.h"

typedef enum kSection
{
    kSection_Buy,
    kSection_Use,
    kSection_Num
}kSection;

@interface ShopCartDataSource ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ShopCartDataSource

- (instancetype)initWithTableView:(UITableView *)tableView delegate:(id<ShopCartDataSouceDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.delegate = delegate;
    }
    
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([OperateManager shareManager].posOperate.useItems.count == 0 ) {
        return 1;
    }
    return kSection_Num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_Buy)
    {
        return [OperateManager shareManager].posOperate.products.count;
    }
    else if (section == kSection_Use) {
        return [OperateManager shareManager].posOperate.useItems.count;
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
        CDPosProduct *product = (CDPosProduct *)[[OperateManager shareManager].posOperate.products.array objectAtIndex:row];
        
        [self cell:cell buyItem:product];
        
    }
    else if (section == kSection_Use)
    {
        CDCurrentUseItem *useItem = (CDCurrentUseItem *)[[OperateManager shareManager].posOperate.useItems.array objectAtIndex:row];
        
        [self cell:cell useItem:useItem];
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
            //            CDPosProduct *product = (CDPosProduct *)[[OperateManager shareManager].posOperate.products objectAtIndex:indexPath.row];
            
            NSMutableOrderedSet *buyItems = [NSMutableOrderedSet orderedSetWithOrderedSet:[OperateManager shareManager].posOperate.products];
            [buyItems removeObjectAtIndex:row];
            
            [OperateManager shareManager].posOperate.products = buyItems;
        }
        else if (section == kSection_Use)
        {
            NSMutableOrderedSet *useItems = [NSMutableOrderedSet orderedSetWithOrderedSet:[OperateManager shareManager].posOperate.useItems];
            [useItems removeObjectAtIndex:row];
            
            [OperateManager shareManager].posOperate.useItems = useItems;
            
            //            CDPosProduct *product = (CDPosProduct *)[[OperateManager shareManager].posOperate.products objectAtIndex:indexPath.row];
            if (useItems.count == 0) {
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                return;
            }
        }
        [[OperateManager shareManager] reloadPosOperate];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kShopCartDataChanged object:nil];
//        self.payView.operate = [OperateManager shareManager].posOperate;
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
    //        CDPosProduct *product = (CDPosProduct *)[[OperateManager shareManager].posOperate.products.array objectAtIndex:row];
    //
    //
    //        [self cell:self.cartCell buyItem:product];
    //
    //    }
    //    else if (section == kSection_Use)
    //    {
    //        CDCurrentUseItem *useItem = (CDCurrentUseItem *)[[OperateManager shareManager].posOperate.useItems.array objectAtIndex:row];
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
        if ([OperateManager shareManager].posOperate.useItems.count != 0) {
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
    

    if (section == kSection_Buy) {
        CDPosProduct *product = (CDPosProduct *)[[OperateManager shareManager].posOperate.products.array objectAtIndex:row];
        if ([self.delegate respondsToSelector:@selector(didSelectedPosproduct:)]) {
            [self.delegate didSelectedPosproduct:product];
        }
    }
    else if (indexPath.section == kSection_Use)
    {
        CDCurrentUseItem *useItem = (CDCurrentUseItem *)[[OperateManager shareManager].posOperate.useItems.array objectAtIndex:row];
        if ([self.delegate respondsToSelector:@selector(didSelectedUseItem:)]) {
            [self.delegate didSelectedUseItem:useItem];
        }
    }
}


@end
