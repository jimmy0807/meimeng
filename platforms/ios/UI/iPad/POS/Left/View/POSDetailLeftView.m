//
//  HomeDetailLeftView.m
//  Boss
//
//  Created by lining on 15/10/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "POSDetailLeftView.h"
#import "UIView+Frame.h"
#import "POSLeftTopCell.h"
#import "POSLeftProductCell.h"
#import "UIImage+Resizable.h"
#import "BSDeleteOperateItemRequest.h"
#import "BSPosOperateCancelRequest.h"
#import "CBLoadingView.h"
#import "UILabel+Copy.h"

#define kViewWidth  420
#define kTitleHeight 75

typedef enum kSection
{
    kSection_product,
    kSection_consume,
    kSection_coupon,
    kSection_num
}kSection;

@interface POSDetailLeftView ()
@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@property(nonatomic, strong) NSArray *posProducts;
@property(nonatomic, strong) NSArray *consumeProducts;
@property(nonatomic, strong) NSArray *couponProducts;
@property(nonatomic, strong) NSIndexPath *alertIndexPath;
@property(nonatomic, weak) IBOutlet UIButton* cancelButton;
@property(nonatomic, weak) IBOutlet UILabel* cancelLabel;
@end

@implementation POSDetailLeftView

+ (instancetype)createView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"POSDetailLeftView" owner:self options:nil];
    POSDetailLeftView *detailLeftView =[nibs objectAtIndex:0];
    [detailLeftView initial];
    return detailLeftView;
}

- (void) initial
{
//    self.titleBgView.image = [[UIImage imageNamed:@"pad_navi_background.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 2, 10, 2)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self initData];
}

- (void) initData
{
    self.posProducts = [[BSCoreDataManager currentManager] fetchPosProductsWithOperate:self.operate];
//    self.consumeProducts = [[BSCoreDataManager currentManager] fetchConsumeProductsWithOperate:self.operate];
    self.consumeProducts = [[BSCoreDataManager currentManager] fetchConsumeProductsInCardWithOperate:self.operate];
    self.couponProducts = [[BSCoreDataManager currentManager] fetchPosCouponProductsWithOPerate:self.operate];
//    self.couponProducts = self.operate.
    if ( [self.operate.state isEqualToString:@"cancel"] )
    {
        self.cancelButton.hidden = YES;
        self.cancelLabel.text = @"已撤销";
    }
    else
    {
        self.cancelButton.hidden = NO;
        self.cancelLabel.text = @"撤销单据";
    }
    self.titleLabel.isCopyable = YES;
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    [self initData];
}

- (void)reloadLeftView
{
    [self initData];
    self.titleLabel.text = self.operate.name;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![self.operate.type isEqualToString:@"消费"]) {
        return 1;
    }
    return kSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self.operate.type isEqualToString:@"消费"]) {
        return 2;
    }
    else
    {
        if (section == kSection_product) {
            return self.posProducts.count + 1;
        }
        else if (section == kSection_consume)
        {
            return self.consumeProducts.count;
        }
        else if (section == kSection_coupon)
        {
            return self.couponProducts.count;
        }
    }
   
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    
    if (indexPath.row == 0 && indexPath.section == kSection_product) {
        static NSString *identifier = @"POSLeftTopCell";
        POSLeftTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [POSLeftTopCell createCell];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.operate = self.operate;
        if (self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row == indexPath.row) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pos_product_cell_h.png"]];
        }
        else
        {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_normal_button_n.png"]];
        }
        return cell;
    }
    else
    {
        static NSString *identifier = @"POSLeftProductCell";
        POSLeftProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [POSLeftProductCell createCell];
            cell.backgroundColor = [UIColor clearColor];
           
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        cell.rightDetailLabel.text = @"";
        
        if (self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row == indexPath.row) {
            
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pos_product_cell_h.png"]];
        }
        else
        {
            cell.backgroundView = nil;
        }
        if (![self.operate.type isEqualToString:@"消费"]) {
            cell.nameLabel.text = self.operate.type;
            cell.countLabel.text = [NSString stringWithFormat:@"x %d",1];
            cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.operate.amount floatValue]];
            cell.priceLabel.text = [NSString stringWithFormat:@"单价：￥%.2f",[self.operate.amount floatValue]];
            cell.discountLabel.text = [NSString stringWithFormat:@"折扣: %@",@10];
            cell.typeLabel.text = [NSString stringWithFormat:@"类型：%@",self.operate.type];
            if (self.operate.commissions.count > 0) {
                cell.tagImgView.hidden = true;
            }
            else
            {
                if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
                {
                    cell.tagImgView.hidden = true;
                }
                else
                {
                    cell.tagImgView.hidden = false;
                }
            }
        }
        else
        {
            if (section == kSection_product) {
                CDPosProduct *product = [self.posProducts objectAtIndex:indexPath.row - 1];
                
                if ([self hasAssignCommission:product]) {
                    cell.tagImgView.hidden = true;
                }
                else
                {
                    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
                    {
                        cell.tagImgView.hidden = true;
                    }
                    else
                    {
                        cell.tagImgView.hidden = false;
                    }
                }
                cell.posProduct = product;
                
            }
            else if (section == kSection_consume)
            {
                CDPosConsumeProduct *consumeProduct = [self.consumeProducts objectAtIndex:indexPath.row];
                if ([self hasAssignCommission:consumeProduct]) {
                    cell.tagImgView.hidden = true;
                }
                else
                {
                    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
                    {
                        cell.tagImgView.hidden = true;
                    }
                    else
                    {
                        cell.tagImgView.hidden = false;
                    }
                }
                cell.posProduct = consumeProduct;
                if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
                {
                    cell.rightDetailLabel.text = @"本次使用";
                }
                
                cell.buweiLabel.text = consumeProduct.part_display_name;
            }
            else if (section == kSection_coupon)
            {
                CDPosCouponProduct *couponProduct = [self.couponProducts objectAtIndex:indexPath.row];
                if ([self hasAssignCommission:couponProduct]) {
                    cell.tagImgView.hidden = true;
                }
                else
                {
                    cell.tagImgView.hidden = false;
                }
                cell.posProduct = couponProduct;
            }

        }
        return cell;
    }
}

- (Boolean) hasAssignCommission:(CDPosBaseProduct *)posProduct
{
    for (CDPosCommission *commission in self.operate.commissions.array) {
        if ([commission.product_id integerValue] == [posProduct.product_id integerValue]) {
            return true;
        }
    }
    return false;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        return 170;
    }
    else
    {
        return 134;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row == indexPath.row) {
        return;
    }
    self.selectedIndexPath = indexPath;
    
    [tableView reloadData];
    if (indexPath.row == 0 && indexPath.section == kSection_product) {
        if ([self.delegate respondsToSelector:@selector(didSelectedOperate:)]) {
            [self.delegate didSelectedOperate:self.operate];
        }
        return;
    }
    else
    {
        if (![self.operate.type isEqualToString:@"消费"]) {
            if ([self.delegate respondsToSelector:@selector(didSelectedPosProduct:)]) {
                [self.delegate didSelectedPosProduct:nil];
            }
            return ;
        }
        else
        {
            if (indexPath.section == kSection_product) {
                CDPosProduct *product = [self.posProducts objectAtIndex:indexPath.row - 1];
                if ([self.delegate respondsToSelector:@selector(didSelectedPosProduct:)]) {
                    [self.delegate didSelectedPosProduct:product];
                }
            }
            else if (indexPath.section == kSection_consume)
            {
                CDPosConsumeProduct *consumeProduct = [self.consumeProducts objectAtIndex:indexPath.row ];
                if ([self.delegate respondsToSelector:@selector(didSelectedPosProduct:)]) {
                    [self.delegate didSelectedPosProduct:consumeProduct];
                }
            }
            else if (indexPath.section == kSection_coupon)
            {
                CDPosCouponProduct *couponProduct = [self.couponProducts objectAtIndex:indexPath.row];
                if ([self.delegate respondsToSelector:@selector(didSelectedPosProduct:)]) {
                    [self.delegate didSelectedPosProduct:couponProduct];
                }
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == kSection_consume )
    {
        return YES;
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除吗 删除后不能恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertIndexPath = indexPath;
        [v show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 )
    {
        NSIndexPath* indexPath = self.alertIndexPath;
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        if (indexPath.section == kSection_product)
        {
            CDPosProduct *product = [self.posProducts objectAtIndex:indexPath.row - 1];
            [params setObject:product.line_id forKey:@"product_line_id"];
        }
        else if (indexPath.section == kSection_consume)
        {
            CDPosConsumeProduct *consumeProduct = [self.consumeProducts objectAtIndex:indexPath.row ];
            [params setObject:consumeProduct.line_id forKey:@"comsume_line_id"];
        }
        else if (indexPath.section == kSection_coupon)
        {
            CDPosCouponProduct *couponProduct = [self.couponProducts objectAtIndex:indexPath.row];
            [params setObject:couponProduct.line_id forKey:@"coupon_line_id"];
        }
        
        [params setObject:self.operate.operate_id forKey:@"operate_id"];
        
        BSDeleteOperateItemRequest* request = [[BSDeleteOperateItemRequest alloc] initWithParams:params operate:self.operate];
        [request execute];
    }
}

- (IBAction)backBtnPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didBackBtnPressed)]) {
        [self.delegate didBackBtnPressed];
    }
}

- (IBAction)printBtnPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didPrintBtnPressed)]) {
        [self.delegate didPrintBtnPressed];
    }
}

- (IBAction)giveBtnPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didGiveBtnPressed)]) {
        [self.delegate didGiveBtnPressed];
    }
}

- (IBAction)editPosBtnPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didEditPosOperateBtnPressed)]) {
        [self.delegate didEditPosOperateBtnPressed];
    }
}

- (IBAction)didCancelOperateBtnPressed:(UIButton *)sender
{
    if ( self.operate.note.length == 0 )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请在右边填写财务备注" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [v show];
        return;
    }
    
    BSPosOperateCancelRequest* request = [[BSPosOperateCancelRequest alloc] initWithParams:@{@"note":self.operate.note,@"operate_id":self.operate.operate_id} operate:self.operate];
    [request execute];
    
    [[CBLoadingView shareLoadingView] show];
}

@end
