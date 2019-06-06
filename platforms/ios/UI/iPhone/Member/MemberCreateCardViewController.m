//
//  MemberCreateCardViewController.m
//  Boss
//
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "MemberCardDetailViewController.h"
#import "MemberPayViewController.h"
#import "MemberPay.h"
#import "BNRightButtonItem.h"
#import "MemberDetailViewController.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "BSMemberCardOperateRequest.h"
#import "BSCommonSelectedItemViewController.h"
#import "MemberCreateCardViewController.h"
#import "MemberViewController.h"

typedef enum CardTypeRow
{
    CardTypeRow_Type,
    CardTypeRow_CardNo
}CardTypeRow;

typedef enum CardMoneyRow
{
    CardMoneyRow_QichongMoney,
    CardMoneyRow_PayMoney,
    CardMoneyRow_GiveMoney,
    CardMoneyRow_Count
}CardMoneyRow;

@interface MemberCreateCardViewController ()<UITableViewDelegate,UITableViewDataSource,BSCommonSelectedItemViewControllerDelegate,BNRightButtonItemDelegate,UITextFieldDelegate,MemberPayViewControllerDelegate>
{
    NSInteger CreateCardSection_Type;
    NSInteger CreateCardSection_Money;
    NSInteger CreateCardSection_Qiankuan; //欠款
    NSInteger CreateCardSection_Count;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong)NSArray* priceArray;

@end

@implementation MemberCreateCardViewController
- (NSMutableArray *)cardInfoArray
{
    if(_cardInfoArray==nil)
    {
        return _cardInfoArray = [[NSMutableArray alloc]init];
    }
    else
    {
        return _cardInfoArray;
    }
}

- (NSMutableArray *)cardTypeArray
{
    if(_cardTypeArray==nil)
    {
        return _cardTypeArray = [[NSMutableArray alloc]init];
    }
    return _cardTypeArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initSelectList];
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    
    if(self.operateType == CardOperateRecharge)
    {
        CreateCardSection_Type = -1;
        CreateCardSection_Money = 0;
        CreateCardSection_Qiankuan = 1; //欠款
        CreateCardSection_Count = 2;
        
        [self initDataWithCard:self.card];
    }
    else
    {
        CreateCardSection_Type = 0;
        CreateCardSection_Money = 1;
        CreateCardSection_Qiankuan = 2; //欠款
        CreateCardSection_Count = 3;
        
        [self initData];
        
    }
    
    [self initNavigationBar];
}

- (void)initData
{
    self.selectList = [[NSMutableDictionary alloc]init];
    [self.cardInfoArray removeAllObjects];
    [self.cardTypeArray removeAllObjects];
    NSMutableArray *cardName = [[NSMutableArray alloc]initWithArray:@[@"会员卡类型",@"卡号"]];
    if ( self.priceArray.count == 1 )
    {
        self.priceList = self.priceArray[0];
        NSMutableArray *cardInfo = [[NSMutableArray alloc]initWithArray:@[self.priceList.name,self.randomString]];
        [self.cardInfoArray addObject:cardInfo];
        
        NSString* startMoney = [NSString stringWithFormat:@"%@",self.priceList.start_money];
        NSMutableArray *cardValue1 = [[NSMutableArray alloc]initWithArray:@[startMoney,@"",@"0.00"]];
        [self.cardInfoArray addObject:cardValue1];
    }
    else
    {
        NSMutableArray *cardInfo = [[NSMutableArray alloc]initWithArray:@[@"",self.randomString]];
        [self.cardInfoArray addObject:cardInfo];
        
        NSMutableArray *cardValue1 = [[NSMutableArray alloc]initWithArray:@[@"",@"",@"0.00"]];
        [self.cardInfoArray addObject:cardValue1];
    }
    
    [self.cardTypeArray addObject:cardName];
    
    NSMutableArray *cardValue = [[NSMutableArray alloc]initWithArray:@[@"起冲金额",@"充值金额",@"赠送金额"]];
    
    
    [self.cardTypeArray addObject:cardValue];
    
    
    NSMutableArray *cardMoney = [[NSMutableArray alloc]initWithArray:@[@"本次欠款金额"]];
    NSMutableArray *cardMone1 = [[NSMutableArray alloc]initWithArray:@[[NSString stringWithFormat:@"%@",self.needMoney==nil?@(0):self.needMoney]]];
    
    [self.cardTypeArray addObject:cardMoney];
    [self.cardInfoArray addObject:cardMone1];
}

- (void)initDataWithCard:(CDMemberCard *)card
{
    self.card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.card.cardID forKey:@"cardID"];
    self.selectList = [[NSMutableDictionary alloc]init];
    [self.cardInfoArray removeAllObjects];
    [self.cardTypeArray removeAllObjects];
    
    self.priceList = card.priceList;
    
    NSMutableArray *cardValue = [[NSMutableArray alloc]initWithArray:@[@"续冲金额",@"充值金额",@"赠送金额"]];
    NSMutableArray *cardValue1 = [[NSMutableArray alloc]initWithArray:@[[NSString stringWithFormat:@"%@",card.priceList.refill_money],@"",@"",@"0.00"]];
    
    [self.cardTypeArray addObject:cardValue];
    [self.cardInfoArray addObject:cardValue1];
}

- (void)initSelectList
{
    NSArray *posArray = [[BSCoreDataManager currentManager]fetchItems:@"CDPOSPayMode" sortedByKey:@"payID"];
    for(CDPOSPayMode *payMode in posArray)
    {
        if(payMode.mode.integerValue != kPadPayModeTypeCard && payMode.mode.integerValue != kPadPayModeTypeCoupon && payMode.mode.integerValue != kPadPayModeTypeOtherCoupon)
        {
            [self.selectList setObject:payMode.statementID forKey:payMode.payName];
        }
    }
    
    self.priceArray = [[BSCoreDataManager currentManager] fetchCanUsePriceList];
    for(CDMemberPriceList *priceList in self.priceArray)
    {
        [self.selectList setObject:priceList.priceID forKey:priceList.name];
    }
}

- (void)initNavigationBar
{
    self.navigationItem.title = (self.operateType == CardOperateCreate) ? @"开卡" : @"充值";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    self.tableView.backgroundColor = [UIColor clearColor];
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    BNRightButtonItem *item = [[BNRightButtonItem alloc]initWithTitle:@"完成"];
    item.delegate = self;
    self.navigationItem.rightBarButtonItem = item;
}


-(void)didItemBackButtonPressed:(UIButton*)sender
{
    [self popBack];
}

- (void)popBack
{
    if (self.isFromCreateMember) {
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MemberViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo objectForKey:@"rc"] integerValue] == 0)
        {
            CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.memberID forKey:@"memberID"];
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[NSString stringWithFormat:@"会员%@开卡成功",member.memberName]];
            [messageView show];
            if (self.operateType == CardOperateCreate)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSPopMemberDetailVCUpdate object:nil];
            }
            else
            {
                MemberCardDetailViewController *cardDetail = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObject:self]-1];
                [cardDetail getData];
            }
//            [self.navigationController popViewControllerAnimated:YES];
            [self popBack];
        }
        else
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.25];
            [view showInView:self.view];
        }
    }
}


#pragma UITableViewDataSource and UITableViewDelegte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.cardTypeArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == CreateCardSection_Type)
    {
        if (indexPath.row == CardTypeRow_Type)
        {
            if (self.operateType == CardOperateCreate)
            {
                if ( self.priceArray.count ==  1 )
                {
                    cell.arrowImageView.hidden = YES;
                }
                cell.contentField.placeholder = @"请选择";
            }
            else
            {
                cell.arrowImageView.hidden = YES;
            }
        }
        else if (indexPath.row == CardTypeRow_CardNo)
        {
            cell.arrowImageView.hidden = YES;
        }
    }
    else if( indexPath.section == CreateCardSection_Money )
    {
        if ( indexPath.row == CardMoneyRow_QichongMoney )
        {
            cell.arrowImageView.hidden = YES;
        }
        else if ( indexPath.row == CardMoneyRow_PayMoney )
        {
            cell.contentField.placeholder = @"请选择支付方式";
            cell.contentField.textColor = [UIColor redColor];
        }
        else if ( indexPath.row == CardMoneyRow_GiveMoney )
        {
            cell.contentField.enabled = YES;
            cell.contentField.keyboardType = UIKeyboardTypeDecimalPad;
            cell.contentField.text = [NSString stringWithFormat:@"%@",self.give_money==nil?@(0.00):self.give_money];
        }
    }
    else if( indexPath.section == CreateCardSection_Qiankuan )
    {
        cell.contentField.enabled = YES;
        cell.contentField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    cell.titleLabel.text = self.cardTypeArray[indexPath.section][indexPath.row];
    cell.contentField.text = self.cardInfoArray[indexPath.section][indexPath.row];
    cell.contentField.delegate = self;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cardTypeArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndexPath = indexPath;
    BSEditCell *cell = (BSEditCell *)[tableView cellForRowAtIndexPath:indexPath];
    if( indexPath.section == CreateCardSection_Type && indexPath.row == CardTypeRow_Type && self.operateType == CardOperateCreate && self.priceArray.count != 1)
    {
        BSCommonSelectedItemViewController *selectView = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        NSArray *priceArray = [[BSCoreDataManager currentManager] fetchCanUsePriceList];
        NSMutableArray *priceList = [[NSMutableArray alloc]init];
        for(CDMemberPriceList *price in priceArray)
        {
            [priceList addObject:price.name];
        }
        selectView.dataArray = priceList;
        selectView.userData = selectView.dataArray;
        selectView.currentSelectIndex = [priceList indexOfObject:cell.contentField.text];
        selectView.delegate = self;
        
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        
        [self.navigationController pushViewController:selectView animated:YES];
    }
    else if( indexPath.section == CreateCardSection_Money && indexPath.row == CardMoneyRow_PayMoney )
    {
        if( self.priceList == nil )
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"请选择会员卡类型"];
            [view showInView:self.view];
            return;
        }
        
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        
        MemberPayViewController *payViewController = [[MemberPayViewController alloc]initWithNibName:NIBCT(@"MemberPayViewController") bundle:nil];
        if(self.payModes==nil)
        {
            NSArray *priceArray = [[BSCoreDataManager currentManager]fetchItems:@"CDPOSPayMode" sortedByKey:@"payID"];
            NSMutableArray *payArray = [[NSMutableArray alloc]init];
            for(CDPOSPayMode *payMode in priceArray)
            {
                if(payMode.mode.integerValue != kPadPayModeTypeCard && payMode.mode.integerValue != kPadPayModeTypeCoupon && payMode.mode.integerValue != kPadPayModeTypeOtherCoupon)
                {
                    MemberPay *pay = [[MemberPay alloc]init];
                    pay.payID = payMode.statementID;
                    pay.payName = payMode.payName;
                    [payArray addObject:pay];
                }
            }
            payViewController.MemberPays = payArray;
        }
        else
        {
            payViewController.MemberPays = self.payModes;
        }
        payViewController.delegate = self;
        [self.navigationController pushViewController:payViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma BSCommonSelectitemviewController delegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    NSArray *priceArray = [[BSCoreDataManager currentManager] fetchCanUsePriceList];
    self.priceList = priceArray[index];
    NSString *startMoney = [NSString stringWithFormat:@"%@",self.priceList.start_money];
    [self.cardInfoArray[self.selectIndexPath.section] replaceObjectAtIndex:self.selectIndexPath.row withObject:userData[index]];
    [self.cardInfoArray[CreateCardSection_Money] replaceObjectAtIndex:CardMoneyRow_QichongMoney withObject:startMoney];
    [self.tableView reloadData];
}

-(void)didRightBarButtonItemClick:(id)sender
{
    [self.tableView reloadData];
    if([self didParamLegal])
    {
        [[CBLoadingView shareLoadingView] show];
        
        NSMutableArray *statememtIds = [[NSMutableArray alloc]init];
        for(MemberPay *memberPay in self.statements)
        {
            NSArray *array = @[@(0), @(NO), @{@"amount": @([memberPay.payMoney floatValue] + [self.give_money floatValue]), @"statement_id":memberPay.payID,  @"point":@(0)}];
            [statememtIds addObject:array];
        }
        
        if(self.operateType == CardOperateCreate)
        {
            NSDictionary *params = @{@"no":self.randomString, @"member_id":self.memberID, @"pricelist_id":self.priceList.priceID, @"now_arrears_amount":self.needMoney == nil?@(0):self.needMoney, @"statement_ids":statememtIds};
            BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateCreate];
            [request execute];
        }
        else
        {
            NSDictionary *params = @{@"card_id":self.card.cardID, @"now_arrears_amount":@(0), @"statement_ids":statememtIds};
            BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateRecharge];
            [request execute];
        }
    }
}

- (BOOL)didParamLegal
{
    if(self.operateType == CardOperateCreate)
    {
        if(self.priceList==nil)
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"请选择会员卡类型"];
            [view showInView:self.view];
            return NO;
        }
        else if (self.statements.count==0 && self.priceList.start_money.floatValue > 0)
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"支付方式不能为空"];
            [view showInView:self.view];
            return NO;
        }
        else if ([self.payAmount floatValue] + [self.needMoney floatValue]<[self.priceList.start_money floatValue])
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"充值金额必须大于起冲金额"];
            [view showInView:self.view];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        if([self.payAmount floatValue]<[self.card.priceList.refill_money floatValue])
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"充值金额必须大于续冲金额"];
            [view showInView:self.view];
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

#pragma UITextFieldDelegate 
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    BSEditCell *cell = nil;
    if(IS_SDK8)
    {
        cell = (BSEditCell *)textField.superview.superview;
    }
    else
    {
        cell = (BSEditCell *)textField.superview.superview.superview;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if( indexPath.section == CreateCardSection_Qiankuan )
    {
        self.needMoney = @([textField.text floatValue]);
    }
    else
    {
        self.give_money = @([textField.text floatValue]);
    }
    
    [self.cardInfoArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:textField.text];
    return YES;
}

#pragma MemPayViewControllerDelegate 
-(void)didChoosedPayModeWithAmount:(NSNumber *)amount payModes:(NSArray *)payModes
{
    self.payModes = payModes;
    self.payAmount = amount;
    self.statements = [[NSMutableArray alloc]init];
    NSMutableString *payString = [[NSMutableString alloc]init];
    for( MemberPay *memberPay in self.payModes )
    {
        if( memberPay.payMoney != nil && ![memberPay.payMoney isEqualToString:@"0"] )
        {
            [self.statements addObject:memberPay];
            [payString appendString:[NSString stringWithFormat:@"%@ ",memberPay.payName]];
        }
    }
    
    [self.cardInfoArray[CreateCardSection_Money] replaceObjectAtIndex:CardMoneyRow_PayMoney withObject:[NSString stringWithFormat:@"%.02f",[amount floatValue]]];
    [self.tableView reloadData];
}

@end
