//
//  HomeDetailRightView.m
//  Boss
//
//  Created by lining on 15/10/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "POSDetailRightView.h"
#import "PayInfoCell.h"
#import "UIView+Frame.h"
#import "BSYimeiEditPosOperateRequest.h"
#import "CBMessageView.h"

#define kViewWidth 604
#define kTitleHeight 75


@interface POSDetailRightView ()<UITextViewDelegate>
@property(strong,nonatomic) NSArray *cardProducts;
@property(strong,nonatomic) NSArray *couponProducts;
@property(weak,nonatomic) IBOutlet UIButton* confirmButton;
@property(weak,nonatomic) UITextView* remarkTextField;
@property(weak,nonatomic) UITextView* noteTextField;
@end

@implementation POSDetailRightView


+ (instancetype)createView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"POSDetailRightView" owner:self options:nil];
    POSDetailRightView *rightView = [nibs objectAtIndex:0];
    [rightView initial];
    return rightView;
}

- (void) initial
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 100, 40)];
    l.text = @"支付明细";
    l.textColor = COLOR(153, 174, 175,1);
    l.font = [UIFont systemFontOfSize:16];
    self.tableView.tableHeaderView = l;
    
    if ( ![self.operate.progre_status isEqualToString:@"done"] )
    {
        [self setFooter];
    }
    
    [self registerNofitificationForMainThread:kEidtPosOperateResponse];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kEidtPosOperateResponse] )
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            CBMessageView* v = [[CBMessageView alloc] initWithTitle:@"备注已修改"];
            [v show];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

- (void)setFooter
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 800)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 100, 20)];
    label.text = @"备注";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = COLOR(153, 174, 175,1);
    label.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label];
    
    UITextView* textField = [[UITextView alloc] initWithFrame:CGRectMake(0, 60, self.tableView.frame.size.width, 180)];
    textField.delegate = self;
    textField.layer.borderColor = COLOR(234, 234, 234, 1).CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.masksToBounds = TRUE;
    [bgView addSubview:textField];
    self.remarkTextField = textField;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 270, 100, 20)];
    label.text = @"财务备注";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = COLOR(153, 174, 175,1);
    label.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label];
    
    textField = [[UITextView alloc] initWithFrame:CGRectMake(0, 300, self.tableView.frame.size.width, 180)];
    textField.delegate = self;
    textField.layer.borderColor = COLOR(234, 234, 234, 1).CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.masksToBounds = TRUE;
    [bgView addSubview:textField];
    self.noteTextField = textField;
    
    self.tableView.tableFooterView = bgView;
    
    self.confirmButton.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ( self.noteTextField == textView )
    {
        self.operate.note = self.noteTextField.text;
    }
    self.confirmButton.hidden = (self.noteTextField.text.length > 0 || self.remarkTextField.text.length > 0 ) ? FALSE : TRUE;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ( self.noteTextField == textView )
    {
        self.operate.note = self.noteTextField.text;
    }
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    [self initData];
    
    self.remarkTextField.text = operate.remark;
    self.noteTextField.text = operate.note;
}


- (void) initData
{
    self.cardProducts = [[BSCoreDataManager currentManager] fetchPosMemberCardProductWithOperate:self.operate];
    self.couponProducts = [[BSCoreDataManager currentManager] fetchPosCouponProductsWithOPerate:self.operate];
}

- (void)reloadRightView
{
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.operate.payInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CDPosOperatePayInfo *payInfo = [self.operate.payInfos objectAtIndex:section];
    if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCard)
    {
        if (self.cardProducts.count > 0)
        {
            return self.cardProducts.count + 1 + 2; // +1:为会员卡 +2：为会员卡类型 消费门店
        }
        else
        {
            return 1;
        }
    }
    else if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCoupon)
    {
        if (self.couponProducts.count > 0)
        {
            return self.couponProducts.count + 1 + 2;// +1:为优惠券 +2：为会员卡类型 消费门店
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return 1;
    }
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    CDPosOperatePayInfo *payInfo = [self.operate.payInfos objectAtIndex:section];
    
    UITableViewCell *cell = nil;
    if (row > 0) {
        if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCard || payInfo.payMode.mode.integerValue == kPadPayModeTypeCoupon)
        {
            static NSString *identifer = @"cardConsumCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundView = cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_consum_cell_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, tableView.width - 20*2, 20)
                                       ];
                titleLabel.tag = 101;
                titleLabel.adjustsFontSizeToFitWidth = TRUE;
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.font = [UIFont systemFontOfSize:12];
                titleLabel.textColor = [UIColor grayColor];
                [cell.contentView addSubview:titleLabel];
                
                UIImageView *lineImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pos_consume_cell_line.png"]];
                lineImgView.width = tableView.width;
                lineImgView.tag = 102;
                [cell.contentView addSubview:lineImgView];
            }
            
            NSArray *prodcuts = nil;
            if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCard)
            {
                prodcuts = self.cardProducts;
            }
            else
            {
                prodcuts = self.couponProducts;
            }
            
            UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
            UIImageView *lineImgView = (UIImageView *)[cell.contentView viewWithTag:102];
            lineImgView.hidden = true;
            //        titleLabel.textAlignment
            titleLabel.y = 2;
            if (row <= prodcuts.count) {
                CDPosBaseProduct *baseProduct = [prodcuts objectAtIndex:row - 1];
                
                if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCard)
                {
                    titleLabel.text = [NSString stringWithFormat:@"卡内消费: %@  x%d",baseProduct.product_name,[baseProduct.product_qty integerValue]];
                }
                else
                {
                    titleLabel.text = [NSString stringWithFormat:@"券内消费: %@  x%d",baseProduct.product_name,[baseProduct.product_qty integerValue]];
                }
                
                if (row == 1) {
                    titleLabel.y = 18;
                }
            }
            else
            {
                if (row == prodcuts.count + 1) {
                    if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCard) {
                        titleLabel.text = [NSString stringWithFormat:@"卡名: %@",payInfo.card_name];
                    }
                    else
                    {
                        CDPosCouponProduct *couponProduct = [prodcuts lastObject];
                        titleLabel.text = [NSString stringWithFormat:@"优惠券号: %@",couponProduct.coupon.coupon_no];
                    }
                    
                }
                else
                {
                    titleLabel.text = [NSString stringWithFormat:@"门店: %@",payInfo.shop_name];
                    if (section == self.operate.payInfos.count - 1) {
                        lineImgView.hidden = false;
                    }
                    lineImgView.y = 35 - 1;
                }
            }
            
        }
    }
    else
    {
        static NSString *identifier = @"PayInfoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            
            cell = [PayInfoCell createCell];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ( payInfo.pay_note.length > 1 )
        {
            ((PayInfoCell *)cell).nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",payInfo.statement_name,payInfo.pay_note];
        }
        else
        {
            ((PayInfoCell *)cell).nameLabel.text = payInfo.statement_name;
        }
        
        ((PayInfoCell *)cell).moneyLabel.text = [NSString stringWithFormat:@"%.2f",[payInfo.pay_amount floatValue]];
       
    }

    // 设置背景
    if (row == 0) {
        if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCard || payInfo.payMode.mode.integerValue == kPadPayModeTypeCoupon)
        {
            NSArray *products = nil;
            if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCard)
            {
                products = self.cardProducts;
            }
            else
            {
                products = self.couponProducts;
            }
            if (section == 0) {
                if (self.operate.payInfos.count == 1 && products.count == 0) {
                    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                }
                else
                {
                    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                }
            }
            else if (section == self.operate.payInfos.count - 1)
            {
                if (self.operate.payInfos.count - 1 == section && products.count == 0) {
                    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                }
                else
                {
                    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                }
            }
            else
            {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
            }
        }
        else
        {
            [self cellBg:cell withRow:section minRow:0 maxRow:self.operate.payInfos.count - 1];
        }

    }
    
    return cell;
}



- (void)cellBg:(UITableViewCell *)cell withRow:(int)row minRow:(int)minRow maxRow:(int)maxRow
{
    if (minRow == maxRow) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
        return;
    }
    if (row == minRow) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
    else if (row == maxRow)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
    else
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPosOperatePayInfo *payInfo = [self.operate.payInfos objectAtIndex:indexPath.section];
    if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCard && indexPath.row > 0) {
        if (indexPath.row == 1) {
            return 38;
        }
        else if (indexPath.row == self.cardProducts.count + 2)
        {
            return 35;
        }
        return 22;
    }
    else if (payInfo.payMode.mode.integerValue == kPadPayModeTypeCoupon && indexPath.row > 0)
    {
        if (indexPath.row == 1) {
            return 38;
        }
        else if (indexPath.row == self.cardProducts.count + 2)
        {
            return 35;
        }
        return 22;
    }
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectedAtIndexPath:)]) {
//        [self.delegate didSelectedAtIndexPath:indexPath];
    }
}

- (IBAction)didConfirmButtonPressed:(id)sender
{
    BSYimeiEditPosOperateRequest* request = [[BSYimeiEditPosOperateRequest alloc] initWithPosOperate:self.operate params:@{@"remark":self.remarkTextField.text,@"note":self.noteTextField.text}];
    [request execute];
    
    self.operate.remark = self.remarkTextField.text;
    self.operate.note = self.noteTextField.text;
}

@end
