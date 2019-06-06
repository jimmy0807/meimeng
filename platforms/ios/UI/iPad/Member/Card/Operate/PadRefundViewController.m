//
//  PadRefundViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadRefundViewController.h"
#import "PadProjectConstant.h"
#import "PadProjectCell.h"
#import "PadCardOperateCell.h"
#import "CBLoadingView.h"
#import "PadPaymodeParams.h"
#import "BNActionSheet.h"
#import "BSMemberCardOperateRequest.h"

typedef enum kPadRefundSectionType
{
    kPadRefundSectionPayment,
    kPadRefundSectionPayMode,
    kPadRefundSectionInvalid,
    kPadRefundSectionPoints,
    kPadRefundSectionCount
}kPadPaymentSectionType;

typedef enum kPadRefundInvalidRowType
{
    kPadRefundInvalidIsInvalid,
    kPadRefundInvalidRowCount
}kPadRefundInvalidRowType;

typedef enum kPadRefundPointsRowType
{
    kPadRefundPointsIsDeduction     = 0,
    kPadRefundPointsNormalCount     = 1,
    
    kPadRefundPointsPointsCount     = 1,
    kPadRefundPointsRowCount        = 2
}kPadRefundPointsRowType;

@interface PadRefundViewController () <BNActionSheetDelegate>
{
    BOOL isTotalScreen;
}

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) NSMutableArray *payments;
@property (nonatomic, strong) NSMutableArray *paymodes;
@property (nonatomic, strong) NSMutableArray *params;

@property (nonatomic, assign) BOOL isCash;
@property (nonatomic, assign) BOOL isBank;
@property (nonatomic, assign) CGFloat cashAmount;
@property (nonatomic, assign) BOOL isCardInvalid;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, assign) NSInteger currentContent;
@property (nonatomic, assign) BOOL isDeduction;
@property (nonatomic, assign) CGFloat deductionPoints;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *totalScreenButton;
@property (nonatomic, strong) UIButton *backConfirmButton;
@property (nonatomic, strong) UITableView *refundTableView;
@property (nonatomic, strong) PadCashRegisterView *cashRegisterView;

@property (nonatomic, strong)CDPOSPayMode *pointPaymode;
@end

@implementation PadRefundViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadRefundViewController" bundle:nil];
    if (self)
    {
        self.memberCard = memberCard;
        
        self.totalAmount = 0.0;
        self.isCardInvalid = NO;
        self.currentContent = -1;
        self.isDeduction = NO;
        self.payments = [NSMutableArray array];
        self.params = [NSMutableArray array];
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchPOSPayMode]];
        for (NSInteger i = 0; i < mutableArray.count; i++)
        {
            CDPOSPayMode *paymode = [mutableArray objectAtIndex:i];
            if (paymode.mode.integerValue != kPadPayModeTypeCash && paymode.mode.integerValue != kPadPayModeTypeBankCard)
            {
                [mutableArray removeObject:paymode];
                i--;
                if ( paymode.mode.integerValue == kPadPayModeTypePoint )
                {
                    self.pointPaymode = paymode;
                }
            }
        }
        self.paymodes = [NSMutableArray arrayWithArray:mutableArray];
        for (int i = 0; i < self.paymodes.count; i++)
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)[self.paymodes objectAtIndex:i];
            PadPaymodeParams *params = [[PadPaymodeParams alloc] init];
            if (paymode.mode.integerValue == kPadPayModeTypeBankCard)
            {
                params.isBank = YES;
                if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.vepos.wyzft://"]] )
                {
                    params.maxAmount = kPadProjectBankPayMaxAmount;
                }
                else
                {
                    params.maxAmount = 999999999;
                }
            }
            
            [self.params addObject:params];
        }
        
        [self reloadData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    
    self.refundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight - 32.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.refundTableView.backgroundColor = [UIColor clearColor];
    self.refundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refundTableView.delegate = self;
    self.refundTableView.dataSource = self;
    self.refundTableView.showsVerticalScrollIndicator = NO;
    self.refundTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.refundTableView];
    
    CGFloat originY = self.view.frame.size.height - 32.0 - 60.0 - 32.0;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, self.view.frame.size.width, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.view addSubview:lineImageView];
    originY += 32.0;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor clearColor];
    confirmButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0);
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    self.backButton.backgroundColor = [UIColor clearColor];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.alpha = 1.0;
    [navi addSubview:self.backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, self.view.frame.size.width - 2 * kPadNaviHeight, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadMemberCardReturnCard");
    [navi addSubview:titleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 160.0 - 20.0, 0.0, 160.0, kPadNaviHeight)];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    moneyLabel.font = [UIFont systemFontOfSize:16.0];
    //moneyLabel.text = [NSString stringWithFormat:LS(@"PadCardRemainAmount"), self.memberCard.amount.floatValue + self.memberCard.courseRemainAmount.floatValue];
    moneyLabel.text = [NSString stringWithFormat:LS(@"PadCardRemainAmount"), self.memberCard.amount.floatValue];
    [navi addSubview:moneyLabel];
    
    self.totalScreenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.totalScreenButton.backgroundColor = [UIColor clearColor];
    self.totalScreenButton.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    [self.totalScreenButton addTarget:self action:@selector(didTotalScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.totalScreenButton.hidden = YES;
    [self.view addSubview:self.totalScreenButton];
    
    self.backConfirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backConfirmButton.backgroundColor = COLOR(255.0, 60.0, 48.0, 1.0);
    self.backConfirmButton.frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    [self.backConfirmButton.layer setMasksToBounds:YES];
    [self.backConfirmButton.layer setCornerRadius:4.0];
    self.backConfirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.backConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backConfirmButton setTitle:LS(@"PadBackConfirmButton") forState:UIControlStateNormal];
    [self.backConfirmButton addTarget:self action:@selector(didBackConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.backConfirmButton.alpha = 0.0;
    [self.view addSubview:self.backConfirmButton];
    
    [self reloadData];
}

#pragma mark -
#pragma mark Required Methods

- (void)reloadData
{
    self.totalAmount = 0.0;
    self.isCash = NO;
    self.isBank = NO;
    self.cashAmount = 0.0;
    for (NSDictionary *dict in self.payments)
    {
        self.totalAmount += [[dict objectForKey:@"amount"] floatValue];
        NSObject *object = [dict objectForKey:@"mode"];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            if (paymode.mode.integerValue == kPadPayModeTypeBankCard)
            {
                self.isBank = YES;
            }
            else if (paymode.mode.integerValue == kPadPayModeTypeCash)
            {
                self.isCash = YES;
                self.cashAmount += [[dict objectForKey:@"amount"] floatValue];
            }
        }
    }
    
    if (self.isBank && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.vepos.wyzft://"]])
    {
        self.backButton.hidden = YES;
        self.backConfirmButton.alpha = 1.0;
    }
    else
    {
        self.backButton.hidden = NO;
        self.backConfirmButton.alpha = 1.0;
    }
    
    if (self.isBank && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.vepos.wyzft://"]])
    {
        self.backButton.hidden = YES;
        self.backConfirmButton.alpha = 1.0;
    }
    else
    {
        self.backButton.hidden = NO;
        self.backConfirmButton.alpha = 1.0;
    }
    
    [self.refundTableView reloadData];
}

- (void)didBackButtonClick:(id)sender
{
    if (self.payments.count == 0)
    {
        [self.maskView hidden];
        return;
    }
    
    self.backConfirmButton.frame = CGRectMake(16.0 + 96.0/2.0, (kPadNaviHeight - 36.0)/2.0 + 36.0/2.0, 0.0, 0.0);
    [UIView animateWithDuration:0.2 animations:^{
        self.backButton.alpha = 0.0;
        self.backButton.frame = CGRectMake(kPadNaviHeight/2.0, kPadNaviHeight/2.0, 0.0, 0.0);
        self.backConfirmButton.alpha = 1.0;
        self.backConfirmButton.frame = CGRectMake(16.0 - 8.0, (kPadNaviHeight - 36.0)/2.0 - 4.0, 96.0 + 16.0, 36.0 + 8.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backConfirmButton.frame = CGRectMake(16.0, (kPadNaviHeight - 36.0)/2.0, 96.0, 36.0);
        } completion:^(BOOL finished) {
            isTotalScreen = YES;
            self.totalScreenButton.hidden = NO;
        }];
    }];
}

- (void)didTotalScreenButtonClick:(id)sender
{
    if (!isTotalScreen)
    {
        return;
    }
    
    self.backButton.frame = CGRectMake(kPadNaviHeight/2.0 + 20.0, kPadNaviHeight/2.0, 0.0, 0.0);
    [UIView animateWithDuration:0.32 animations:^{
        self.backButton.alpha = 1.0;
        self.backButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
        self.backConfirmButton.alpha = 0.0;
        self.backConfirmButton.frame = CGRectMake(16.0 + 96.0/2.0, kPadNaviHeight/2.0, 0.0, 0.0);
    } completion:^(BOOL finished) {
        isTotalScreen = NO;
        self.totalScreenButton.hidden = YES;
    }];
}

- (void)didBackConfirmButtonClick:(id)sender
{
    self.maskView.delegate = nil;
    [self.maskView hidden];
}

- (void)didConfirmButtonClick:(id)sender
{
    if (self.isCardInvalid)
    {
        if (self.memberCard.amount.floatValue > 0 /* || self.memberCard.courseRemainAmount.floatValue > 0 */)
        {
            BNActionSheet *actionSheet = [[BNActionSheet alloc]
                                          initWithTitle:LS(@"PadRefundCardRemindOverage")
                                          items:@[LS(@"PadRefundCardSure")]
                                          cancelTitle:LS(@"Cancel")
                                          delegate:self];
            [actionSheet show];
        }
        else
        {
            BNActionSheet *actionSheet = [[BNActionSheet alloc]
                                          initWithTitle:LS(@"PadRefundCardRemindInfo")
                                          items:@[LS(@"PadRefundCardSure")]
                                          cancelTitle:LS(@"Cancel")
                                          delegate:self];
            [actionSheet show];
        }
        
        return;
    }
    
    [self didMemberCardRefund];
}

- (void)didMemberCardRefund
{
    if ( self.payments.count == 0 && self.isCardInvalid )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请输入金额" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.memberCard.cardID forKey:@"card_id"];
    [params setObject:@(self.isCardInvalid) forKey:@"is_card_cancel"];
    [params setObject:@(self.deductionPoints) forKey:@"points"];
    
    NSMutableArray *statementIds = [NSMutableArray array];
    
    BOOL pointReduced = FALSE;
    
    for (int i = 0; i < self.payments.count; i++)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[self.payments objectAtIndex:i];
        NSObject *object = [dict objectForKey:@"mode"];
        CGFloat amount = [[dict objectForKey:@"amount"] floatValue];
        CDPOSPayMode *paymode = (CDPOSPayMode *)object;
        if ( paymode.mode.integerValue == kPadPayModeTypeBankCard )
        {
            NSString* serialNo = [dict objectForKey:@"bankNo"];
            serialNo = serialNo.length > 0 ? serialNo : @"";
            if ( !pointReduced && self.deductionPoints > 0 )
            {
                pointReduced = TRUE;
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"bank_serial_number":serialNo,@"pos_type":[dict objectForKey:@"pos_type"], @"journal_id":paymode.payID, @"point":@(self.deductionPoints)}];
                [statementIds addObject:array];
            }
            else
            {
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"bank_serial_number":serialNo,@"pos_type":[dict objectForKey:@"pos_type"], @"journal_id":paymode.payID}];
                [statementIds addObject:array];
            }
        }
        else
        {
            if ( !pointReduced && self.deductionPoints > 0 )
            {
                pointReduced = TRUE;
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"journal_id":paymode.payID, @"point":@(self.deductionPoints)}];
                [statementIds addObject:array];
            }
            else
            {
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"journal_id":paymode.payID}];
                [statementIds addObject:array];
            }
        }
    }
    
    [params setObject:statementIds forKey:@"statement_ids"];
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateRefund];
    [request execute];
}


#pragma mark -
#pragma mark BNActionSheetDelegate Methods

- (void)bnActionSheet:(BNActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self didMemberCardRefund];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self.maskView hidden];
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

#pragma mark -
#pragma mark PadMaskViewDelegate Methods

- (void)didPadMaskViewBackgroundClick:(PadMaskView *)maskView
{
    [self didTotalScreenButtonClick:nil];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kPadRefundSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPadRefundSectionPayment)
    {
        return self.payments.count;
    }
    else if (section == kPadRefundSectionPayMode)
    {
        return self.paymodes.count;
    }
    else if (section == kPadRefundSectionInvalid)
    {
        return kPadRefundInvalidRowCount;
    }
    else if (section == kPadRefundSectionPoints)
    {
        if (self.isDeduction)
        {
            return kPadRefundPointsRowCount;
        }
        
        return kPadRefundPointsNormalCount;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPadRefundSectionPayment)
    {
        return kPadPaymentCellHeight;
    }
    else if (indexPath.section == kPadRefundSectionPayMode)
    {
        return kPadPayModeCellHeight;
    }
    else if (indexPath.section == kPadRefundSectionInvalid)
    {
        return kPadCardOperateSwitchCellHeight;
    }
    else if (indexPath.section == kPadRefundSectionPoints)
    {
        if (indexPath.row == kPadRefundPointsIsDeduction)
        {
            return kPadCardOperateSwitchCellHeight;
        }
        else if (indexPath.row == kPadRefundPointsPointsCount)
        {
            return kPadCardOperateCellHeight;
        }
    }
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == kPadRefundSectionPayment || section == kPadRefundSectionInvalid)
    {
        return 36.0;
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kPadRefundSectionPayment || section == kPadRefundSectionInvalid)
    {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadPaymentCellWidth, 36.0)];
        footerView.backgroundColor = [UIColor clearColor];
        
        return footerView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPadRefundSectionPayment)
    {
        static NSString *CellIdentifier = @"PadPaymentCellIdentifier";
        PadPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.index = indexPath.row;
        NSDictionary *dict = [self.payments objectAtIndex:indexPath.row];
        CDPOSPayMode *paymode = (CDPOSPayMode *)[dict objectForKey:@"mode"];
        cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPaymemtTitle"), paymode.payName, [[dict objectForKey:@"amount"] floatValue]];
        cell.cancelButton.hidden = NO;
        if (paymode.mode.integerValue == kPadPayModeTypeBankCard && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.vepos.wyzft://"]])
        {
            cell.cancelButton.hidden = YES;
        }
        
        return cell;
    }
    else if (indexPath.section == kPadRefundSectionPayMode)
    {
        static NSString *CellIdentifier = @"PadPayModeCellIdentifier";
        PadPayModeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadPayModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.index = indexPath.row;
        cell.amountTextField.tag = indexPath.row;
        CDPOSPayMode *paymode = (CDPOSPayMode *)[self.paymodes objectAtIndex:indexPath.row];
        cell.paymodeLabel.text = paymode.payName;
        [cell.contentButton setTitle:paymode.payName forState:UIControlStateNormal];
        
        [self reloadPadPaymodeCell:cell];
        
        return cell;
    }
    else if (indexPath.section == kPadRefundSectionInvalid)
    {
        static NSString *CellIdentifier = @"PadCardOperateSwitchCellIdentifier";
        PadCardOperateSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadCardOperateSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.indexPath = indexPath;
        cell.titleLabel.text = LS(@"PadSetMemberCardToBeInvalid");
        if (self.isCardInvalid)
        {
            cell.isSwitchOn = YES;
        }
        else
        {
            cell.isSwitchOn = NO;
        }
        
        return cell;
    }
    else if (indexPath.section == kPadRefundSectionPoints)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"PadCardOperateSwitchCellIdentifier";
            PadCardOperateSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadCardOperateSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            cell.indexPath = indexPath;
            cell.titleLabel.text = LS(@"PadMemberCardIsDeductionPoints");
            if (self.isDeduction)
            {
                cell.isSwitchOn = YES;
            }
            else
            {
                cell.isSwitchOn = NO;
            }
            
            return  cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"PadRefundCardOperateCellIdentifier";
            PadCardOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadCardOperateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.titleLabel.text = LS(@"PadMemberCardDeductionPoints");
            cell.contentTextField.tag = 999;
            cell.contentTextField.enabled = YES;
            cell.contentTextField.delegate = self;
            cell.contentTextField.userInteractionEnabled = YES;
            cell.contentTextField.textAlignment = NSTextAlignmentLeft;
            cell.contentTextField.keyboardType = UIKeyboardTypeDecimalPad;
            cell.contentTextField.text = [NSString stringWithFormat:@"%.2f", self.deductionPoints];
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kPadRefundSectionPayment)
    {
        NSDictionary *dict = [self.payments objectAtIndex:indexPath.row];
        CDPOSPayMode *paymode = (CDPOSPayMode *)[dict objectForKey:@"mode"];
        if (paymode.mode.integerValue == kPadPayModeTypeBankCard)
        {
            return;
        }
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.deductionPoints = textField.text.floatValue;
    [self.refundTableView reloadData];
}



#pragma mark -
#pragma mark PadCardOperateSwitchCellDelegate Methods

- (void)didPadCardOperateSwitchButtonClick:(PadCardOperateSwitchCell *)cell
{
    if (cell.indexPath.section == kPadRefundSectionInvalid)
    {
        self.isCardInvalid = cell.isSwitchOn;
    }
    else if (cell.indexPath.section == kPadRefundSectionPoints)
    {
        self.isDeduction = cell.isSwitchOn;
        if (self.isDeduction)
        {
            self.deductionPoints = 0.0;
        }
        [self.refundTableView reloadData];
    }
}


#pragma mark -
#pragma mark PadPaymentCellDelegate Methods

- (void)didPadPaymentCellCancel:(PadPaymentCell *)cell
{
    NSDictionary *dict = [self.payments objectAtIndex:cell.index];
    NSObject *object = [dict objectForKey:@"mode"];
    if ([object isKindOfClass:[CDPOSPayMode class]])
    {
        CDPOSPayMode *paymode = (CDPOSPayMode *)object;
        if (paymode.mode.integerValue == kPadPayModeTypeBankCard && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.vepos.wyzft://"]])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:LS(@"银行卡支付成功后不能取消")
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:LS(@"PadDeletePaymemtRemindInfo") delegate:self cancelButtonTitle:LS(@"PadDeletePaymentCancel") otherButtonTitles:LS(@"PadDeletePaymentConfirm"), nil];
    alertView.tag = cell.index;
    [alertView show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSDictionary *dict = [self.payments objectAtIndex:alertView.tag];
        [self.payments removeObject:dict];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:kPadRefundSectionPayment];
            [self.refundTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        });
    }
}



#pragma mark -
#pragma mark PadPayModeCell Methods

- (void)reloadPadPaymodeCell:(PadPayModeCell *)cell
{
    PadPaymodeParams *params = [self.params objectAtIndex:cell.index];
    if (params.isDisable)
    {
        cell.amountTextField.text = LS(@"PadMemberCardInsufficient");
        cell.amountTextField.enabled = NO;
        return;
    }
    
    cell.amountTextField.enabled = YES;
    cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", params.currentAmount];
}


#pragma mark -
#pragma mark PadPayModeCellDelegate Methods

- (void)didPadPaymodeCellContentClick:(PadPayModeCell *)cell
{
    if (self.currentContent != -1)
    {
        PadPayModeCell *lastCell = (PadPayModeCell *)[self.refundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentContent inSection:kPadRefundSectionPayMode]];
        [lastCell hideInputViews];
    }
    
    self.currentContent = cell.index;
    [self reloadPadPaymodeCell:cell];
}

- (void)didPadPaymodeCellCancelButtonClick:(PadPayModeCell *)cell
{
    PadPaymodeParams *params = [self.params objectAtIndex:cell.index];
    params.didEdited = NO;
    params.currentAmount = 0.0;
    [self reloadData];
}

- (void)didAmountTextFieldBeginEditing:(PadPayModeCell *)cell
{
    [self reloadPadPaymodeCell:cell];
    cell.amountTextField.text = @"";
}

- (void)didAmountTextFieldEndEditing:(PadPayModeCell *)cell
{
    PadPaymodeParams *params = [self.params objectAtIndex:cell.index];
    if (cell.amountTextField.text.length >= 2)
    {
        params.didEdited = YES;
        params.currentAmount = [[cell.amountTextField.text substringFromIndex:2] floatValue];
    }
    
    if ( params.currentAmount > self.memberCard.amount.floatValue /*+ self.memberCard.courseRemainAmount.floatValue*/ )
    {
        params.currentAmount = self.memberCard.amount.floatValue /*+ self.memberCard.courseRemainAmount.floatValue*/;
    }
    
    cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", params.currentAmount];
}

- (BOOL)didPadPayModeCellConfirm:(PadPayModeCell *)cell
{
    PadPaymodeParams *params = [self.params objectAtIndex:cell.index];
    if (params.isBank)
    {
        if (params.didEdited && params.currentAmount != 0)
        {
            if (params.currentAmount > params.maxAmount)
            {
                params.didEdited = NO;
                params.currentAmount = params.maxAmount;
                [self reloadPadPaymodeCell:cell];
                return NO;
            }
        }
    }
    
    CGFloat amount = params.currentAmount;
    if (amount == 0.0)
    {
        return YES;
    }
    
    NSObject *object = [self.paymodes objectAtIndex:cell.index];
    if ([object isKindOfClass:[NSString class]])
    {
        NSString *paymodestr = (NSString *)object;
        for (NSMutableDictionary *dict in self.payments)
        {
            if ([[dict objectForKey:@"mode"] isKindOfClass:[NSString class]] && [[dict objectForKey:@"mode"] isEqualToString:paymodestr])
            {
                [dict setObject:@([[dict objectForKey:@"amount"] floatValue] + amount) forKey:@"amount"];
                [self reloadData];
                return YES;
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:paymodestr, @"mode", @(amount), @"amount", nil];
        [self.payments addObject:dict];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.payments.count - 1) inSection:kPadRefundSectionPayment];
        [self.refundTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    else if ([object isKindOfClass:[CDPOSPayMode class]])
    {
        CDPOSPayMode *paymode = (CDPOSPayMode *)object;
        if (paymode.mode.integerValue == kPadPayModeTypeBankCard)
        {
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.vepos.wyzft://"]])
            {
                [self didPadCashRegisterSuccessWithPaymode:paymode amount:amount bankNo:@"" pos_type:@""];
                return YES;
            }
            
            self.cashRegisterView = [[PadCashRegisterView alloc] initWithPaymode:paymode amount:amount];
            self.cashRegisterView.delegate = self;
            self.maskView.userInteractionEnabled = YES;
            [self.maskView addSubview:self.cashRegisterView];
            return NO;
        }
        else if (paymode.mode.integerValue == kPadPayModeTypeCash)
        {
            for (NSMutableDictionary *dict in self.payments)
            {
                if ([[dict objectForKey:@"mode"] isKindOfClass:[CDPOSPayMode class]])
                {
                    CDPOSPayMode *mode = (CDPOSPayMode *)[dict objectForKey:@"mode"];
                    if (mode.mode.integerValue == kPadPayModeTypeCash)
                    {
                        [dict setObject:@([[dict objectForKey:@"amount"] floatValue] + amount) forKey:@"amount"];
                        [self reloadData];
                        return YES;
                    }
                }
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:paymode, @"mode", @(amount), @"amount", nil];
        [self.payments addObject:dict];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.payments.count - 1) inSection:kPadRefundSectionPayment];
        [self.refundTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    params.didEdited = NO;
    [self reloadData];
    
    return YES;
}


#pragma mark -
#pragma mark PadCashRegisterViewDelegate Methods

- (void)didPadSettingWithType:(kPadSettingViewType)type
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadSetPosMachineAndPayAccount object:@(type) userInfo:nil];
}

- (void)didPadCashRegisterFailed:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:LS(@"IKnewButtonTitle")
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didPadCashRegisterSuccessWithPaymode:(CDPOSPayMode *)paymode amount:(CGFloat)amount bankNo:(NSString *)bankNo pos_type:(NSString *)pos_type
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:paymode, @"mode", @(amount), @"amount", bankNo, @"bankNo", pos_type, @"pos_type", nil];
    [self.payments addObject:dict];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.payments.count - 1) inSection:kPadRefundSectionPayment];
    [self.refundTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self reloadData];
    for (int i = 0; i < self.paymodes.count; i++)
    {
        NSObject *object = [self.paymodes objectAtIndex:i];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            if (paymode.mode.integerValue == kPadPayModeTypeBankCard)
            {
                PadPayModeCell *cell = [self.refundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kPadRefundSectionPayMode]];
                [cell hideInputViews];
            }
        }
    }
}


#pragma mark -
#pragma mark PadNumberKeyboardDelegate Methods

- (void)didPadNumberKeyboardDonePressed:(UITextField*)textField
{
    [self didTextFieldEditDone:textField];
}

- (void)didTextFieldEditDone:(UITextField *)textField
{
    if (textField.tag == 999)
    {
        return;
    }
    
    PadPayModeCell *cell = [self.refundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:kPadRefundSectionPayMode]];
    BOOL shouldHide = [self didPadPayModeCellConfirm:cell];
    if (shouldHide)
    {
        [cell hideInputViews];
    }
}



@end
