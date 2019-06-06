//
//  PadCardOperateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadCardOperateViewController.h"
#import "PadProjectConstant.h"
#import "BSMemberCardOperateRequest.h"
#import "CBLoadingView.h"
#import "PadPaymodeParams.h"
#import "PadOperateSuccessViewController.h"

typedef enum kPadCardOperateSectionType
{
    kPadCardOperateSectionPayment,
    kPadCardOperateSectionPayMode,
    kPadCardOperateSectionCount
}kPadCardOperateSectionType;

@interface PadCardOperateViewController ()
{
    BOOL isTotalScreen;
}

@property (nonatomic, strong) NSArray *arrears;
@property (nonatomic, assign) CGFloat arrearsAmount;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDCouponCard *couponCard;
@property (nonatomic, strong) CDMemberPriceList *priceList;
@property (nonatomic, assign) kPadMemberCardOperateType operateType;

@property (nonatomic, strong) NSDictionary *upgradeParams;
@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, strong) NSMutableArray *payments;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, assign) CGFloat tempAmount;
@property (nonatomic, strong) NSArray *paymodes;
@property (nonatomic, assign) NSInteger currentContent;

@property (nonatomic, assign) BOOL isCash;
@property (nonatomic, assign) BOOL isBank;
@property (nonatomic, assign) CGFloat cashAmount;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) PadCashRegisterView *cashRegisterView;
@property (nonatomic, strong) UITableView *paymentTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *totalScreenButton;
@property (nonatomic, strong) UIButton *backConfirmButton;

@end


@implementation PadCardOperateViewController

// kPadMemberCardOperateCreate: 开卡
- (id)initWithMember:(CDMember *)member priceList:(CDMemberPriceList *)priceList cardNumber:(NSString *)number
{
    self = [super initWithNibName:@"PadCardCreateViewController" bundle:nil];
    if (self)
    {
        self.operateType = kPadMemberCardOperateCreate;
        self.member = member;
        self.cardNumber = number;
        self.priceList = priceList;
        
        [self initData];
    }
    
    return self;
}

// kPadMemberCardOperateRecharge:充值;
- (id)initWithMember:(CDMember *)member memberCard:(CDMemberCard *)memberCard operateType:(kPadMemberCardOperateType)operateType
{
    self = [super initWithNibName:@"PadCardCreateViewController" bundle:nil];
    if (self)
    {
        self.operateType = operateType;
        self.member = member;
        self.memberCard = memberCard;
        self.priceList = memberCard.priceList;
        self.cardNumber = memberCard.cardNumber;
        
        [self initData];
    }
    
    return self;
}

// kPadMemberCardOperateRepayment:还款
- (id)initWithMember:(CDMember *)member memberCard:(CDMemberCard *)memberCard arrears:(NSArray *)arrears
{
    self = [super initWithNibName:@"PadCardCreateViewController" bundle:nil];
    if (self)
    {
        self.operateType = kPadMemberCardOperateRepayment;
        self.member = member;
        self.memberCard = memberCard;
        self.priceList = memberCard.priceList;
        self.cardNumber = memberCard.cardNumber;
        self.arrears = arrears;
        self.arrearsAmount = 0.0;
        for (int i = 0; i < self.arrears.count; i++)
        {
            CDMemberCardArrears *arrears = [self.arrears objectAtIndex:i];
            self.arrearsAmount += arrears.unRepaymentAmount.floatValue;
        }
        
        [self initData];
    }
    
    return self;
}

// kPadMemberCardOperateUpgrade: 卡升级
- (id)initWithMemberCard:(CDMemberCard *)memberCard params:(NSDictionary *)params
{
    self = [super initWithNibName:@"PadCardCreateViewController" bundle:nil];
    if (self)
    {
        self.memberCard = memberCard;
        self.upgradeParams = params;
        self.operateType = kPadMemberCardOperateUpgrade;
        
        [self initData];
    }
    
    return self;
}

- (void)initData
{
    self.totalAmount = 0.0;
    self.currentContent = -1;
    self.payments = [NSMutableArray array];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *arrays = [[BSCoreDataManager currentManager] fetchPOSPayMode];
    for (CDPOSPayMode *paymode in arrays)
    {
        if (paymode.mode.integerValue == kPadPayModeTypeCard || paymode.mode.integerValue == kPadPayModeTypeCoupon || paymode.mode.integerValue == kPadPayModeTypePoint)
        {
            continue;
        }
        else
        {
            [mutableArray addObject:paymode];
        }
    }
    
    if (self.operateType == kPadMemberCardOperateCreate || self.operateType == kPadMemberCardOperateRecharge)
    {
        [mutableArray addObject:@"now_arrears_amount"];
    }
    
    self.paymodes = [NSArray arrayWithArray:mutableArray];
    self.params = [NSMutableArray array];
    for (int i = 0; i < self.paymodes.count; i++)
    {
        PadPaymodeParams *params = [[PadPaymodeParams alloc] init];
        NSObject *object = [self.paymodes objectAtIndex:i];
        if ([object isKindOfClass:[NSString class]])
        {
            [self.params addObject:params];
            continue;
        }
        
        CDPOSPayMode *paymode = (CDPOSPayMode *)[self.paymodes objectAtIndex:i];
        if (paymode.mode.integerValue == kPadPayModeTypeCash)
        {
            params.isCash = YES;
        } 
        else if (paymode.mode.integerValue == kPadPayModeTypeBankCard)
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
        else if (paymode.mode.integerValue == kPadPayModeTypeCard)
        {
            if (self.memberCard.balance.floatValue == 0)
            {
                params.isDisable = YES;
            }
            else
            {
                params.isMemberCard = YES;
                params.memberCardAmount = self.memberCard.balance.floatValue;
            }
        }
        [self.params addObject:params];
    }
    
    [self reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.maskView.delegate = self;
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    
    self.paymentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight - 32.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.paymentTableView.backgroundColor = [UIColor clearColor];
    self.paymentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.paymentTableView.delegate = self;
    self.paymentTableView.dataSource = self;
    self.paymentTableView.showsVerticalScrollIndicator = NO;
    self.paymentTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.paymentTableView];
    
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
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight + 32.0, 0.0, self.view.frame.size.width - 2 * kPadNaviHeight - 2 * 32.0, kPadNaviHeight)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [navi addSubview:self.titleLabel];
    
    UILabel *startMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 160.0 - 20.0, 0.0, 160.0, kPadNaviHeight)];
    startMoneyLabel.backgroundColor = [UIColor clearColor];
    startMoneyLabel.textAlignment = NSTextAlignmentRight;
    startMoneyLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    startMoneyLabel.font = [UIFont systemFontOfSize:16.0];
    if (self.operateType == kPadMemberCardOperateCreate)
    {
        startMoneyLabel.text = [NSString stringWithFormat:LS(@"PadCardStartAmount"), self.priceList.start_money.integerValue];
    }
    else if (self.operateType == kPadMemberCardOperateRecharge)
    {
        startMoneyLabel.text = [NSString stringWithFormat:LS(@"PadCardRefillAmount"), self.priceList.refill_money.integerValue];
    }
    else if (self.operateType == kPadMemberCardOperateRepayment)
    {
        startMoneyLabel.text = [NSString stringWithFormat:LS(@"PadCardRepaymentAmount"), self.arrearsAmount];
    }
    else if (self.operateType == kPadMemberCardOperateUpgrade)
    {
        startMoneyLabel.text = @"";
    }
    [navi addSubview:startMoneyLabel];
    
    CGFloat originY = self.paymentTableView.frame.origin.y + self.paymentTableView.frame.size.height;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, self.view.frame.size.width, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.view addSubview:lineImageView];
    originY += 32.0;
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = [UIColor clearColor];
    self.confirmButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0);
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
    self.totalScreenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.totalScreenButton.backgroundColor = [UIColor clearColor];
    self.totalScreenButton.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.maskView.delegate = nil;
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
    
    if (self.totalAmount == 0)
    {
        self.titleLabel.text = LS(@"PadCardPaymentSelectPayMode");
        if (self.operateType == kPadMemberCardOperateRepayment)
        {
            self.titleLabel.text = LS(@"PadCardRepaymentSelectPayMode");
        }
        else if (self.operateType == kPadMemberCardOperateUpgrade)
        {
            self.titleLabel.text = LS(@"PadCardUpgradeSelectPayMode");
        }
    }
    else
    {
        if (self.operateType == kPadMemberCardOperateCreate)
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPrePaidAmount"), self.totalAmount];
        }
        else if (self.operateType == kPadMemberCardOperateRecharge)
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPrePaidAmount"), self.totalAmount];
        }
        else if (self.operateType == kPadMemberCardOperateRepayment)
        {
            if (self.totalAmount <= self.arrearsAmount)
            {
                self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPreRepaymentAmount"), self.totalAmount];
            }
            else
            {
                self.titleLabel.text = [NSString stringWithFormat:LS(@"PadChangeMoney"), self.totalAmount - self.memberCard.arrearsAmount.floatValue - self.memberCard.courseArrearsAmount.floatValue];
            }
        }
        else if (self.operateType == kPadMemberCardOperateUpgrade)
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPrePaidAmount"), self.totalAmount];
        }
    }
    
    CGFloat amount = 0.0;
    if (self.operateType == kPadMemberCardOperateCreate)
    {
        amount = self.priceList.start_money.floatValue;
    }
    else if (self.operateType == kPadMemberCardOperateRecharge)
    {
        amount = self.priceList.refill_money.floatValue;
    }
    else if (self.operateType == kPadMemberCardOperateRepayment)
    {
        amount = self.arrearsAmount;
    }
    else if (self.operateType == kPadMemberCardOperateUpgrade)
    {
        amount = self.priceList.start_money.floatValue;
    }
    self.tempAmount = MAX(amount - self.totalAmount, 0.0);
    [self.paymentTableView reloadData];
    
    self.confirmButton.enabled = YES;
    if (self.operateType == kPadMemberCardOperateCreate)
    {
        if (self.totalAmount < self.priceList.start_money.floatValue)
        {
            self.confirmButton.enabled = NO;
        }
    }
    else if (self.operateType == kPadMemberCardOperateRecharge)
    {
        if (self.totalAmount < self.priceList.refill_money.floatValue)
        {
            self.confirmButton.enabled = NO;
        }
    }
    else if (self.operateType == kPadMemberCardOperateRepayment)
    {
        if (self.totalAmount == 0)
        {
            self.confirmButton.enabled = NO;
        }
    }
}

- (void)didBackButtonClick:(id)sender
{
    if (self.payments.count == 0)
    {
        if (self.operateType == kPadMemberCardOperateCreate || self.operateType == kPadMemberCardOperateRepayment)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.operateType == kPadMemberCardOperateRecharge)
        {
            [self.maskView hidden];
        }
        else if (self.operateType == kPadMemberCardOperateUpgrade)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
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
    if (self.operateType == kPadMemberCardOperateCreate)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.operateType == kPadMemberCardOperateRecharge || self.operateType == kPadMemberCardOperateRepayment)
    {
        [self.maskView hidden];
    }
    else if (self.operateType == kPadMemberCardOperateUpgrade)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    NSDictionary *params = [NSDictionary dictionary];
    if (self.operateType == kPadMemberCardOperateCreate || self.operateType == kPadMemberCardOperateRecharge || self.operateType == kPadMemberCardOperateUpgrade)
    {
        CGFloat arrearsAmount = 0.0;
        NSMutableArray *statememtIds = [NSMutableArray array];
        if (self.payments.count == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请确认您输入了有效的金额" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        for (int i = 0; i < self.payments.count; i++)
        {
            NSMutableDictionary *dict = (NSMutableDictionary *)[self.payments objectAtIndex:i];
            NSObject *object = [dict objectForKey:@"mode"];
            if ([object isKindOfClass:[NSString class]])
            {
                arrearsAmount = [[dict objectForKey:@"amount"] floatValue];
            }
            else if ([object isKindOfClass:[CDPOSPayMode class]])
            {
                CDPOSPayMode *paymode = (CDPOSPayMode *)object;
                CGFloat amount = [[dict objectForKey:@"amount"] floatValue];
                if ( paymode.mode.integerValue == kPadPayModeTypeBankCard )
                {
                    NSString* serialNo = [dict objectForKey:@"bankNo"];
                    serialNo = serialNo.length > 0 ? serialNo : @"";
                    NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"bank_serial_number":serialNo,@"pos_type":[dict objectForKey:@"pos_type"]}];
                    [statememtIds addObject:array];
                }
                else
                {
                    NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID}];
                    [statememtIds addObject:array];
                }
            }
        }
        
        if (self.operateType == kPadMemberCardOperateCreate)
        {
            params = @{@"no":self.cardNumber, @"member_id":self.member.memberID, @"pricelist_id":self.priceList.priceID, @"now_arrears_amount":@(arrearsAmount), @"statement_ids":statememtIds, @"commission_ids": @[], @"invalid_date":@(NO), @"default_code":@(NO), @"remark":@(NO)};
        }
        else if (self.operateType == kPadMemberCardOperateRecharge)
        {
            params = @{@"card_id":self.memberCard.cardID, @"now_arrears_amount":@(arrearsAmount), @"statement_ids":statememtIds};
        }
        else if (self.operateType == kPadMemberCardOperateUpgrade)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.upgradeParams];
            [dict setObject:statememtIds forKey:@"statement_ids"];
            params = [NSDictionary dictionaryWithDictionary:dict];
        }
    }
    else if (self.operateType == kPadMemberCardOperateRepayment)
    {
        if (self.totalAmount == 0)
        {
            return;
        }
        
        for (CDMemberCardArrears *arrears in self.arrears)
        {
            arrears.tempAmount = @(arrears.unRepaymentAmount.floatValue);
        }
        
        NSMutableArray *repaymentIds = [NSMutableArray array];
        NSMutableArray *mutableArrears = [NSMutableArray arrayWithArray:self.arrears];
        // "type":[arrears]-充值欠款 [course_arrears]-消费欠款
        // NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"arrearsType" ascending:YES];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:YES];
        NSArray *sortArray = [NSArray arrayWithObject:descriptor];
        [mutableArrears sortUsingDescriptors:sortArray];
        for (NSInteger i = 0; i < mutableArrears.count; i++)
        {
            CDMemberCardArrears *arrears = [mutableArrears objectAtIndex:i];
            if (arrears.unRepaymentAmount.floatValue == 0)
            {
                continue;
            }
            
            for (int j = 0; j < self.payments.count; j++)
            {
                NSMutableDictionary *dict = [self.payments objectAtIndex:j];
                CDPOSPayMode *paymode = [dict objectForKey:@"mode"];
                CGFloat payAmount = [[dict objectForKey:@"amount"] floatValue];
                if (paymode.mode.integerValue == kPadPayModeTypeCash)
                {
                    CGFloat nonCashPaymentAmount = 0.0;
                    for (NSObject *payment in self.payments)
                    {
                        NSDictionary *dict = (NSDictionary *)payment;
                        if ([[dict objectForKey:@"mode"] isKindOfClass:[CDPOSPayMode class]])
                        {
                            CDPOSPayMode *mode = (CDPOSPayMode *)[dict objectForKey:@"mode"];
                            if (mode.mode.integerValue == kPadPayModeTypeCash)
                            {
                                continue;
                            }
                        }
                        nonCashPaymentAmount += [[dict objectForKey:@"amount"] floatValue];
                        if (payAmount > self.memberCard.arrearsAmount.floatValue + self.memberCard.courseArrearsAmount.floatValue - nonCashPaymentAmount)
                        {
                            payAmount = self.memberCard.arrearsAmount.floatValue + self.memberCard.courseArrearsAmount.floatValue - nonCashPaymentAmount;
                        }
                    }
                }
                
                if (arrears.tempAmount.floatValue == payAmount)
                {
                    NSArray *array = @[@(0), @(NO), @{@"repayment_amount":@(payAmount), @"arrears_id":arrears.arrearsID, @"name":arrears.arrearsName, @"journal_id":paymode.payID}];
                    [repaymentIds addObject:array];
                    
                    [mutableArrears removeObject:arrears];
                    [self.payments removeObject:dict];
                    
                    i--;
                    break;
                }
                else if (arrears.tempAmount.floatValue < payAmount)
                {
                    CGFloat amount = arrears.tempAmount.floatValue;
                    NSArray *array = @[@(0), @(NO), @{@"repayment_amount":@(amount), @"arrears_id":arrears.arrearsID, @"name":arrears.arrearsName, @"journal_id":paymode.payID}];
                    [repaymentIds addObject:array];
                    
                    [mutableArrears removeObject:arrears];
                    [dict setObject:@(payAmount - amount) forKey:@"amount"];
                    
                    i--;
                    break;
                }
                else if (arrears.tempAmount.floatValue > payAmount)
                {
                    NSArray *array = @[@(0), @(NO), @{@"repayment_amount":@(payAmount), @"arrears_id":arrears.arrearsID, @"name":arrears.arrearsName, @"journal_id":paymode.payID}];
                    [repaymentIds addObject:array];
                    
                    arrears.tempAmount = @(arrears.tempAmount.floatValue - payAmount);
                    [self.payments removeObject:dict];
                    
                    j--;
                    continue;
                }
            }
        }
        params = @{@"card_id":self.memberCard.cardID, @"repayment_ids":repaymentIds};
    }
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:self.operateType];
    [request execute];
}


#pragma mark -
#pragma mark PadMaskViewDelegate Methods

- (void)didPadMaskViewBackgroundClick:(PadMaskView *)maskView
{
    [self didTotalScreenButtonClick:nil];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
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
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kPadCardOperateSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPadCardOperateSectionPayment)
    {
        return self.payments.count;
    }
    else if (section == kPadCardOperateSectionPayMode)
    {
        return self.paymodes.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPadCardOperateSectionPayment)
    {
        return kPadPaymentCellHeight;
    }
    else if (indexPath.section == kPadCardOperateSectionPayMode)
    {
        return kPadPayModeCellHeight;
    }
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == kPadCardOperateSectionPayment)
    {
        return 36.0;
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kPadCardOperateSectionPayment)
    {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadPaymentCellWidth, kPadPaymentCellHeight)];
        footerView.backgroundColor = [UIColor clearColor];
        
        return footerView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPadCardOperateSectionPayment)
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
        NSObject *object = [dict objectForKey:@"mode"];
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *paymodestr = (NSString *)object;
            cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPaymemtTitle"), LS(paymodestr), [[dict objectForKey:@"amount"] floatValue]];
        }
        else if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPaymemtTitle"), paymode.payName, [[dict objectForKey:@"amount"] floatValue]];
            cell.cancelButton.hidden = NO;
            if (paymode.mode.integerValue == kPadPayModeTypeBankCard && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.vepos.wyzft://"]])
            {
                cell.cancelButton.hidden = YES;
            }
        }
        
        return cell;
    }
    else if (indexPath.section == kPadCardOperateSectionPayMode)
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
        NSObject *object = [self.paymodes objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *paymodestr = (NSString *)object;
            cell.paymodeLabel.text = LS(paymodestr);
            [cell.contentButton setTitle:LS(paymodestr) forState:UIControlStateNormal];
        }
        else if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            cell.paymodeLabel.text = paymode.payName;
            if (paymode.mode.integerValue == kPadPayModeTypeCard)
            {
                cell.paymodeLabel.text = [NSString stringWithFormat:LS(@"PadMemberCardOverageRemind"), paymode.payName, self.memberCard.balance.floatValue];
            }
            else if (paymode.mode.integerValue == kPadPayModeTypeCoupon)
            {
                cell.paymodeLabel.text = [NSString stringWithFormat:LS(@"PadCouponCardOverageRemind"), paymode.payName, self.couponCard.remainAmount.floatValue];
            }
            else if (paymode.mode.integerValue == kPadPayModeTypePoint)
            {
                cell.paymodeLabel.text = [NSString stringWithFormat:LS(@"PadMemberCardPointPaymentRemind"), paymode.payName, self.memberCard.points.floatValue, self.memberCard.points.floatValue * self.memberCard.priceList.points2Money.floatValue];
            }
            else
            {
                cell.paymodeLabel.text = paymode.payName;
            }
            [cell.contentButton setTitle:paymode.payName forState:UIControlStateNormal];
        }
        
        [self reloadPadPaymodeCell:cell];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kPadCardOperateSectionPayment)
    {
        NSDictionary *dict = [self.payments objectAtIndex:indexPath.row];
        NSObject *object = [dict objectForKey:@"mode"];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            if (paymode.mode.integerValue == kPadPayModeTypeBankCard)
            {
                return;
            }
        }
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
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:kPadCardOperateSectionPayment];
            [self.paymentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if (params.currentAmount == 0.0)
    {
        if (params.isBank)
        {
            self.tempAmount = MIN(self.tempAmount, params.maxAmount);
        }
        cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", self.tempAmount];
    }
    else
    {
        if (params.isBank)
        {
            params.currentAmount = MIN(params.currentAmount, params.maxAmount);
        }
        cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", params.currentAmount];
    }
}


#pragma mark -
#pragma mark PadPayModeCellDelegate Methods

- (void)didPadPaymodeCellContentClick:(PadPayModeCell *)cell
{
    if (self.currentContent != -1)
    {
        PadPayModeCell *lastCell = (PadPayModeCell *)[self.paymentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentContent inSection:kPadCardOperateSectionPayMode]];
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
    
    if (params.currentAmount == 0.0)
    {
        cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", self.tempAmount];
    }
    else
    {
        cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", params.currentAmount];
    }
}

- (BOOL)didPadPayModeCellConfirm:(PadPayModeCell *)cell
{
    PadPaymodeParams *params = [self.params objectAtIndex:cell.index];
    CGFloat amount = 0.0;
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
            amount = params.currentAmount;
        }
        else
        {
            amount = MIN(self.tempAmount, params.maxAmount);
        }
    }
    else
    {
        amount = (params.didEdited && params.currentAmount != 0) ? params.currentAmount : self.tempAmount;
    }
    
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.payments.count - 1) inSection:kPadCardOperateSectionPayment];
        [self.paymentTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    else if ([object isKindOfClass:[CDPOSPayMode class]])
    {
        CDPOSPayMode *paymode = (CDPOSPayMode *)object;
        if (paymode.mode.integerValue == kPadPayModeTypeCard)
        {
            CGFloat cardAmount = 0.0;
            for (NSObject *object in self.payments)
            {
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = (NSDictionary *)object;
                    NSObject *mObject = [dict objectForKey:@"mode"];
                    if ([mObject isKindOfClass:[CDPOSPayMode class]])
                    {
                        CDPOSPayMode *mode = (CDPOSPayMode *)mObject;
                        if (mode.mode.integerValue == kPadPayModeTypeCard)
                        {
                            cardAmount += [[dict objectForKey:@"amount"] floatValue];
                        }
                    }
                }
            }
            
            if (amount + cardAmount - self.memberCard.balance.floatValue > 0.001)
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
//                                                                    message:LS(@"PadMemberCardInsufficient")
//                                                                   delegate:nil
//                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
//                                                          otherButtonTitles:nil, nil];
//                [alertView show];
                return YES;
            }
        }
        else if (paymode.mode.integerValue == kPadPayModeTypeCoupon)
        {
            CGFloat couponAmount = 0.0;
            for (NSObject *object in self.payments)
            {
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = (NSDictionary *)object;
                    NSObject *mObject = [dict objectForKey:@"mode"];
                    if ([mObject isKindOfClass:[CDPOSPayMode class]])
                    {
                        CDPOSPayMode *mode = (CDPOSPayMode *)mObject;
                        if (mode.mode.integerValue == kPadPayModeTypeCoupon)
                        {
                            couponAmount += [[dict objectForKey:@"amount"] floatValue];
                        }
                    }
                }
            }
            
            if (amount + couponAmount - self.couponCard.remainAmount.floatValue > 0.001)
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
//                                                                    message:LS(@"PadMemberCardInsufficient")
//                                                                   delegate:nil
//                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
//                                                          otherButtonTitles:nil, nil];
//                [alertView show];
                return YES;
            }
        }
        else if (paymode.mode.integerValue == kPadPayModeTypeBankCard)
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.payments.count - 1) inSection:kPadCardOperateSectionPayment];
        [self.paymentTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
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

- (void)didPadCashRegisterSuccessWithPaymode:(CDPOSPayMode *)paymode amount:(CGFloat)amount bankNo:(NSString *)bankNo pos_type:(NSString*)pos_type
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:paymode, @"mode", @(amount), @"amount", bankNo, @"bankNo", pos_type, @"pos_type",nil];
    [self.payments addObject:dict];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.payments.count - 1) inSection:kPadCardOperateSectionPayment];
    [self.paymentTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self reloadData];
    for (int i = 0; i < self.paymodes.count; i++)
    {
        NSObject *object = [self.paymodes objectAtIndex:i];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            if (paymode.mode.integerValue == kPadPayModeTypeBankCard)
            {
                PadPayModeCell *cell = [self.paymentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kPadCardOperateSectionPayMode]];
                [cell hideInputViews];
            }
        }
    }
}


#pragma mark -
#pragma mark PadNumberKeyboardDelegate Methods

- (void)didPadNumberKeyboardDonePressed:(UITextField*)textField
{
    [textField resignFirstResponder];
    [self didTextFieldEditDone:textField];
}

- (void)didTextFieldEditDone:(UITextField *)textField
{
    [textField resignFirstResponder];
    PadPayModeCell *cell = [self.paymentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:kPadCardOperateSectionPayMode]];
    BOOL shouldHide = [self didPadPayModeCellConfirm:cell];
    if (shouldHide)
    {
        [cell hideInputViews];
    }
}

@end
