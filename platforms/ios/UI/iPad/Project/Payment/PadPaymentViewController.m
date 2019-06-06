//
//  PadPaymentViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/11/3.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadPaymentViewController.h"
#import "PadProjectConstant.h"
#import "PadMorePayModeCell.h"
#import "CBLoadingView.h"
#import "BSMemberCardOperateRequest.h"
#import "PadOperateSuccessViewController.h"
#import "PadCashRegisterView.h"
#import "PosAccountManager.h"
#import "PadPaymodeParams.h"
#import "BSUserDefaultsManager.h"
#import "NSString+Additions.h"
#import "BSFetchRestaurantTableRequest.h"
#import "YimeiSignBeforeOperationViewController.h"
#import "BSFetchOperateRequest.h"
#import "BSPrintPosOperateRequest.h"
#import "BSPrintPosOperateRequestNew.h"
#import "BSFetchMemberDetailReqeustN.h"
#import "BNScanCodeViewController.h"
#import "BSAlipayTradeRequest.h"
#import "BSAlipayRefundRequest.h"
#import "BSProjectItemUpdateAvailableRequest.h"

typedef enum kPadPaymentSectionType
{
    kPadPaymentSectionPayment,
    kPadPaymentSectionPayMode,
    kPadPaymentSectionCount
}kPadPaymentSectionType;

@interface PadPaymentViewController ()<PayBankManagerDelegate,BNScanCodeDelegate>
{
    BOOL isAnimation;
    BOOL isTotalScreen;
    BOOL isWePosSupport;
    NSInteger bankCancelTag;
    BOOL notShowConfirmVc;
}

@property (nonatomic, strong) CDPosOperate *posOperate;

@property (nonatomic, strong) NSMutableArray *payments;
@property (nonatomic, strong) NSMutableArray *paymodes;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, strong) NSMutableArray *morePaymodes;
@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, assign) CGFloat tempAmount;
@property (nonatomic, assign) NSInteger currentContent;

@property (nonatomic, assign) BOOL isCash;
@property (nonatomic, assign) BOOL isBank;
@property (nonatomic, assign) BOOL isPoint;
@property (nonatomic, assign) BOOL isMemberCard;
@property (nonatomic, assign) BOOL isCouponCard;
@property (nonatomic, assign) CGFloat cashAmount;
@property (nonatomic, assign) CGFloat pointAmount;
@property (nonatomic, assign) CGFloat cardAmount;
@property (nonatomic, assign) CGFloat couponAmount;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITableView *paymentTableView;
@property (nonatomic, strong) UITableView *morePaymodeTableView;

@property (nonatomic, strong) UIButton *totalScreenButton;
@property (nonatomic, strong) UIButton *backConfirmButton;
@property (nonatomic, strong) PadCashRegisterView *cashRegisterView;

@property (nonatomic, strong) NSMutableDictionary *alipayParams;

@end

@implementation PadPaymentViewController

- (id)initWithPosOperate:(CDPosOperate *)posOperate
{
    self = [super initWithNibName:@"PadPaymentViewController" bundle:nil];
    if (self)
    {
        self.posOperate = posOperate;
        
        self.totalAmount = 0.0;
        self.currentContent = -1;
        self.payments = [NSMutableArray array];
        self.morePaymodes = [NSMutableArray array];
        self.params = [NSMutableArray array];
        if (!self.posOperate.member.isDefaultCustomer.boolValue)
        {
            [self.morePaymodes addObject:@"now_arrears_amount"];
        }
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchPOSPayMode]];
        for (NSInteger i = 0; i < mutableArray.count; i++)
        {
            CDPOSPayMode *paymode = [mutableArray objectAtIndex:i];
            if (paymode.mode.integerValue == kPadPayModeTypeCard)
            {
                if (self.posOperate.member.isDefaultCustomer.boolValue)
                {
                    [mutableArray removeObject:paymode];
                    i--;
                }
                else
                {
                    [mutableArray removeObject:paymode];
                    [mutableArray insertObject:paymode atIndex:0];
                }
            }
            else if (paymode.mode.integerValue == kPadPayModeTypeCoupon)
            {
                if (self.posOperate.member.isDefaultCustomer.boolValue)
                {
                    [mutableArray removeObject:paymode];
                    i--;
                }
                else if (self.posOperate.couponCard == nil || self.posOperate.couponCard.remainAmount.floatValue == 0)
                {
                    [self.morePaymodes addObject:paymode];
                    [mutableArray removeObject:paymode];
                    i--;
                }
            }
            else if (paymode.mode.integerValue == kPadPayModeTypePoint)
            {
                if (self.posOperate.member.isDefaultCustomer.boolValue)
                {
                    [mutableArray removeObject:paymode];
                    i--;
                }
            }
        }
        self.paymodes = [NSMutableArray arrayWithArray:mutableArray];
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
                if ( isWePosSupport )
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
                NSLog(@"%@", self.posOperate.memberCard);
                if (self.posOperate.memberCard.balance.floatValue == 0)
                {
                    params.isDisable = YES;
                }
                else
                {
                    params.isMemberCard = YES;
                    params.memberCardAmount = self.posOperate.memberCard.balance.floatValue;
                }
            }
            else if (paymode.mode.integerValue == kPadPayModeTypeCoupon)
            {
                if (self.posOperate.couponCard.remainAmount.floatValue == 0)
                {
                    params.isDisable = YES;
                }
                else
                {
                    params.isCouponCard = YES;
                    params.couponCardAmount = self.posOperate.couponCard.remainAmount.floatValue;
                }
            }
            else if (paymode.mode.integerValue == kPadPayModeTypePoint)
            {
                if (self.posOperate.memberCard.points.floatValue == 0)
                {
                    params.isPoint = YES;
                    params.isDisable = YES;
                }
                else
                {
                    params.isPoint = YES;
                    params.pointAmount = self.posOperate.memberCard.points.floatValue * self.posOperate.memberCard.priceList.points2Money.floatValue;
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
    
    notShowConfirmVc = FALSE;
    
    bankCancelTag = -1;
    isWePosSupport = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.vepos.wyzft://"]];
    
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    self.maskView.delegate = self;
    
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    [self registerNofitificationForMainThread:kBSAlipayTradeResponse];
    [self registerNofitificationForMainThread:kBSAlipayRefundResponse];
    if (self.isGuadan)
    {
        self.view.backgroundColor = [UIColor clearColor];
        [self didConfirmButtonClick:nil];
        return;
    }
//    if (self.isAddItem)
//    {
//        self.view.backgroundColor = [UIColor clearColor];
//        [self didConfirmButtonClick:nil];
//        return;
//    }
    self.paymentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight - 32.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.paymentTableView.backgroundColor = [UIColor clearColor];
    self.paymentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.paymentTableView.delegate = self;
    self.paymentTableView.dataSource = self;
    self.paymentTableView.showsVerticalScrollIndicator = NO;
    self.paymentTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.paymentTableView];
    
    CGFloat originY = self.view.frame.size.height - 32.0 - 60.0 - 32.0;
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
    
    self.morePaymodeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight - self.morePaymodes.count * kPadMorePayModeCellHeight, self.view.frame.size.width, self.morePaymodes.count * kPadMorePayModeCellHeight) style:UITableViewStylePlain];
    self.morePaymodeTableView.backgroundColor = [UIColor clearColor];
    self.morePaymodeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.morePaymodeTableView.delegate = self;
    self.morePaymodeTableView.dataSource = self;
    self.morePaymodeTableView.scrollEnabled = NO;
    self.morePaymodeTableView.showsVerticalScrollIndicator = NO;
    self.morePaymodeTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.morePaymodeTableView];
    
    [self initNaviBar];
}

- (void)initNaviBar
{
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
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, self.view.frame.size.width - 2 * kPadNaviHeight, kPadNaviHeight)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [navi addSubview:self.titleLabel];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.backgroundColor = [UIColor clearColor];
    self.addButton.frame = CGRectMake(self.view.frame.size.width - kPadNaviHeight - 32.0 - 20.0, 0.0, kPadNaviHeight + 32.0, kPadNaviHeight);
    [self.addButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    self.addButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.addButton setTitle:LS(@"PadMorePaymentMode") forState:UIControlStateNormal];
    [self.addButton setTitleColor:COLOR(168.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(didAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    
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
    self.isPoint = NO;
    self.isMemberCard = NO;
    self.isCouponCard = NO;
    self.cashAmount = 0.0;
    self.cardAmount = 0.0;
    self.couponAmount = 0.0;
    self.pointAmount = 0.0;
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
            else if (paymode.mode.integerValue == kPadPayModeTypeCard)
            {
                self.isMemberCard = YES;
                self.cardAmount += [[dict objectForKey:@"amount"] floatValue];
            }
            else if (paymode.mode.integerValue == kPadPayModeTypeCoupon)
            {
                self.isCouponCard = YES;
                self.couponAmount += [[dict objectForKey:@"amount"] floatValue];
            }
            else if (paymode.mode.integerValue == kPadPayModeTypePoint)
            {
                self.isPoint = YES;
                self.pointAmount += [[dict objectForKey:@"amount"] floatValue];
            }
        }
    }
    
    //    if ( self.isBank && isWePosSupport )
    //    {
    //        self.backButton.hidden = YES;
    //        self.backConfirmButton.alpha = 1.0;
    //    }
    //    else
    //    {
    //        self.backButton.hidden = NO;
    //        self.backConfirmButton.alpha = 1.0;
    //    }
    
    NSLog(@"%@",self.posOperate.amount);
    CGFloat diff = self.posOperate.amount.doubleValue - self.totalAmount;
    if ( diff > 0 )
    {
        if ( diff <= 0.02)
        {
            
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadUnPaidMoney"), (CGFloat)0];
        }
        else
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadUnPaidMoney"), self.posOperate.amount.doubleValue - self.totalAmount];
        }
    }
    else
    {
        if ( diff >= -0.02 )
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadUnPaidMoney"), (CGFloat)0];
        }
        else
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadChangeMoney"), self.totalAmount - self.posOperate.amount.doubleValue];
        }
    }
    self.tempAmount = MAX(self.posOperate.amount.doubleValue - self.totalAmount, 0.0);
    NSString* temp = [NSString stringWithFormat:@"%.2f", self.tempAmount];
    self.tempAmount = [temp doubleValue];
    
    if (self.morePaymodes.count == 0)
    {
        self.addButton.hidden = YES;
        self.morePaymodeTableView.hidden = YES;
    }
    [self.paymentTableView reloadData];
    
    if (!self.isCash && fabs(self.posOperate.amount.doubleValue - self.totalAmount) > 0.02)
    {
        self.confirmButton.enabled = NO;
    }
    
    if (self.isCash && self.posOperate.amount.doubleValue - self.totalAmount > 0.02)
    {
        self.confirmButton.enabled = NO;
    }
    else
    {
        self.confirmButton.enabled = YES;
    }
}

- (void)didBackButtonClick:(id)sender
{
    if (self.payments.count == 0)
    {
        if ( self.isBuyItemAndNotUse )
        {
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        else
        {
            [self.maskView hidden];
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
    for (NSDictionary *dict in self.payments)
    {
        NSObject *object = [dict objectForKey:@"mode"];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            if (paymode.mode.integerValue == kPadPayModeTypeBankCard )
            {
                NSString* serialNo = [dict objectForKey:@"bankNo"];
                if ( serialNo.length > 0 )
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"请先把银行卡支付的取消"
                                                                       delegate:nil
                                                              cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
        }
    }
    
    //[self refundAllMoney];
    
    if ( self.isBuyItemAndNotUse )
    {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else
    {
        self.maskView.delegate = nil;
        [self.maskView hidden];
    }
}

- (void)didAddButtonClick:(id)sender
{
    if (isAnimation)
    {
        return;
    }
    
    isAnimation = YES;
    if (self.morePaymodeTableView.frame.origin.y == kPadNaviHeight)
    {
        [UIView animateWithDuration:0.32 animations:^{
            self.morePaymodeTableView.frame = CGRectMake(self.morePaymodeTableView.frame.origin.x, kPadNaviHeight - self.morePaymodeTableView.frame.size.height, self.morePaymodeTableView.frame.size.width, self.morePaymodeTableView.frame.size.height);
        } completion:^(BOOL finished) {
            isAnimation = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.32 animations:^{
            self.morePaymodeTableView.frame = CGRectMake(self.morePaymodeTableView.frame.origin.x, kPadNaviHeight, self.morePaymodeTableView.frame.size.width, self.morePaymodeTableView.frame.size.height);
        } completion:^(BOOL finished) {
            isAnimation = NO;
        }];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    if (ABS([[self.titleLabel.text substringFromIndex:5] floatValue]) > 0)
    {
        if ([self.titleLabel.text containsString:@"找零"])
        {
            
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"还有尚未支付的金额"
                                                               delegate:nil
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] && !self.isBuyItemAndNotUse )
    {
        if ( self.posOperate.firstKeshi )
        {
            [params setObject:self.posOperate.firstKeshi.keshi_id forKey:@"departments_id"];
            
            BOOL bShowAlert = FALSE;
            for (int i = 0; i < self.posOperate.products.count; i++)
            {
                CDPosProduct *product = (CDPosProduct *)[self.posOperate.products objectAtIndex:i];
                
                if ( product.product.bornCategory.integerValue == kPadBornCategoryProject )
                {
                    bShowAlert = TRUE;
                    break;
                }
            }
            
            for (int i = 0; i < self.posOperate.useItems.count; i++)
            {
                CDCurrentUseItem *useItem = [self.posOperate.useItems objectAtIndex:i];
                if ( useItem.projectItem.bornCategory.integerValue == kPadBornCategoryProject )
                {
                    bShowAlert = TRUE;
                    break;
                }
            }
            
            if ( !bShowAlert )
            {
                notShowConfirmVc = TRUE;
                self.posOperate.firstKeshi = nil;
            }
        }
        else
        {
            BOOL bShowAlert = FALSE;
            for (int i = 0; i < self.posOperate.products.count; i++)
            {
                CDPosProduct *product = (CDPosProduct *)[self.posOperate.products objectAtIndex:i];
                
                if ( product.product.bornCategory.integerValue == kPadBornCategoryProject && ![self isMultiKeshi])
                {
                    bShowAlert = TRUE;
                    break;
                }
            }
            
            for (int i = 0; i < self.posOperate.useItems.count; i++)
            {
                CDCurrentUseItem *useItem = [self.posOperate.useItems objectAtIndex:i];
                if ( useItem.projectItem.bornCategory.integerValue == kPadBornCategoryProject && ![self isMultiKeshi])
                {
                    bShowAlert = TRUE;
                    break;
                }
            }
            
            if ( bShowAlert && [self.orignalOperateID integerValue] == 0 )
            {
                UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请先去选择科室" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [v show];
                return;
            }
            
            BOOL isContainingUse = NO;
            for (CDPosProduct *product in self.posOperate.products)
            {
                CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.product_id forKey:@"itemID"];
                if (projectItem.bornCategory.integerValue == kPadBornCategoryProject)
                {
                    isContainingUse = YES;
                }
            }
            if (self.posOperate.useItems.count > 0 || isContainingUse)
            {
                notShowConfirmVc = FALSE;
            }
            else
            {
                notShowConfirmVc = TRUE;
            }
        }
        
        if ( self.posOperate.doctor_id )
        {
            [params setObject:self.posOperate.doctor_id forKey:@"doctor_id"];
        }
        
        if ( [self.posOperate.yimei_shejizongjianID integerValue] > 0 )
        {
            [params setObject:self.posOperate.yimei_shejizongjianID forKey:@"director_employee_id"];
        }
        
        if ( [self.posOperate.yimei_guwenID integerValue] > 0 )
        {
            [params setObject:self.posOperate.yimei_guwenID forKey:@"employee_id"];
        }
        
        if ( [self.posOperate.yimei_shejishiID integerValue] > 0 )
        {
            [params setObject:self.posOperate.yimei_shejishiID forKey:@"designers_id"];
        }
    }
    
    [[CBLoadingView shareLoadingView] show];
    
    if ( [self.posOperate.memberCard.cardID integerValue] > 0 )
    {
        [params setObject:self.posOperate.memberCard.cardID forKey:@"card_id"];
    }
    
    if (self.posOperate.couponCard.cardID.integerValue == 0)
    {
        [params setObject:[NSArray array] forKey:@"coupon_ids"];
    }
    else
    {
        NSArray *array = @[@(0), @(NO),@{@"coupon_id":self.posOperate.couponCard.cardID,@"consume_money":[NSNumber numberWithFloat:(self.posOperate.couponCard.amount.floatValue-self.posOperate.couponCard.remainAmount.floatValue)]}];
        [params setObject:@[array] forKey:@"coupon_ids"];
    }
    
    if ((self.posOperate.orderState.integerValue == kPadOrderDraft || self.posOperate.orderState.integerValue == kPadOrderSubmit) && self.posOperate.orderID.integerValue != 0)
    {
        [params setObject:self.posOperate.orderID forKey:@"pad_order_id"];
    }
    if (self.posOperate.member.isDefaultCustomer.boolValue && self.posOperate.book)
    {
        [params setObject:[NSString stringWithFormat:@"%@, %@, %@", LS(@"PadDefaultCustomer"), self.posOperate.book.booker_name, self.posOperate.book.telephone] forKey:@"remark"];
    }
    
    NSMutableArray *reserveIds = [NSMutableArray array];
    NSMutableDictionary* couponCardsProductParams = [NSMutableDictionary dictionary];
    
    if (self.posOperate.book != nil && self.posOperate.book.book_id.integerValue != 0)
    {
        [reserveIds addObject:self.posOperate.book.book_id];
    }
    for (CDCurrentUseItem *useItem in self.posOperate.useItems)
    {
        if (useItem.book != nil && useItem.book.book_id.integerValue != 0)
        {
            [reserveIds addObject:useItem.book.book_id];
        }
    }
    for (CDPosProduct *product in self.posOperate.products)
    {
        if (product.book != nil && product.book.book_id.integerValue != 0)
        {
            [reserveIds addObject:product.book.book_id];
        }
    }
    if (reserveIds.count != 0)
    {
        [params setObject:reserveIds forKey:@"reservation_ids"];
    }
    
    CGFloat arrearsAmount = 0.0;
    CGFloat cardSnapAmount = 0.0;
    NSMutableArray *statementIds = [NSMutableArray array];
    
    for (int i = 0; i < self.payments.count; i++)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[self.payments objectAtIndex:i];
        NSObject *object = [dict objectForKey:@"mode"];
        CGFloat amount = [[dict objectForKey:@"amount"] floatValue];
        if ([object isKindOfClass:[NSString class]])
        {
            arrearsAmount = [[dict objectForKey:@"amount"] floatValue];
        }
        else if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CGFloat points = 0.0;
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            if (paymode.mode.integerValue == kPadPayModeTypeCard)
            {
                cardSnapAmount = [[dict objectForKey:@"amount"] floatValue];
            }
            else if (paymode.mode.integerValue == kPadPayModeTypeCash)
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
                        nonCashPaymentAmount += [[dict objectForKey:@"amount"] floatValue];
                    }
                    
                    if (amount > self.posOperate.amount.doubleValue - nonCashPaymentAmount)
                    {
                        amount = self.posOperate.amount.doubleValue - nonCashPaymentAmount;
                    }
                }
                
                if ( nonCashPaymentAmount == 0  && amount > self.posOperate.amount.doubleValue )
                {
                    amount = self.posOperate.amount.doubleValue;
                }
            }
            else if (paymode.mode.integerValue == kPadPayModeTypeCoupon)
            {
                NSMutableArray* tempArray = [NSMutableArray array];
                [couponCardsProductParams setObject:tempArray forKey:self.posOperate.couponCard.cardID];
                NSArray *array = @[@(0), @(NO), @{@"consume_money":@(amount), @"coupon_id":self.posOperate.couponCard.cardID,@"lines":tempArray}];
                [params setObject:@[array] forKey:@"coupon_ids"];
            }
            else if ( paymode.mode.integerValue == kPadPayModeTypePoint )
            {
                points = floor(amount / self.posOperate.memberCard.priceList.points2Money.floatValue + 0.5);
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"point":@(-points), @"journal_id":paymode.payID}];
                [statementIds addObject:array];
                continue;
            }
            else if ( paymode.mode.integerValue == kPadPayModeTypeBankCard )
            {
                NSString* serialNo = [dict objectForKey:@"bankNo"];
                serialNo = serialNo.length > 0 ? serialNo : @"";
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"bank_serial_number":serialNo,@"pos_type":[dict objectForKey:@"pos_type"], @"journal_id":paymode.payID}];
                [statementIds addObject:array];
                continue;
            }
#if 1
            else if ( paymode.mode.integerValue == kPadPayModeTypeAlipay || paymode.mode.integerValue == kPadPayModeTypeWeChat )
            {
                NSString* record = [dict objectForKey:@"pos_type"];
                NSInteger r = [record integerValue];
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"pay_transaction_id":@(r), @"journal_id":paymode.payID}];
                [statementIds addObject:array];
                continue;
            }
#endif
            NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"journal_id":paymode.payID}];
            [statementIds addObject:array];
        }
    }
    
    [params setObject:statementIds forKey:@"statement_ids"];
    [params setObject:@(arrearsAmount) forKey:@"now_arrears_amount"];
    
    NSMutableArray *productLineIds = [NSMutableArray array];
    NSMutableArray *consumeIds = [NSMutableArray array];
    
    NSMutableArray *departmentArray = [[NSMutableArray alloc] init];
    NSLog(@"%@",self.posOperate);
    NSString *doctor = [NSString stringWithFormat:@"%@",self.posOperate.doctorids];
    NSString *roomid = [NSString stringWithFormat:@"%@",self.posOperate.departmentids];
    NSString *remark = [NSString stringWithFormat:@"%@",self.posOperate.remark];
    NSString *productids = [NSString stringWithFormat:@"%@",self.posOperate.productids];
    
    if (self.posOperate.departmentids)
    {
        for(int i = 0; i < [doctor componentsSeparatedByString:@","].count; i++)
        {
            NSMutableDictionary *departmentDict = [[NSMutableDictionary alloc] init];
            [departmentDict setValue:[roomid componentsSeparatedByString:@","][i] forKey:@"departments_id"];
            if ([[doctor componentsSeparatedByString:@","][i] intValue] == 0)
            {
                [departmentDict setValue:@(NO) forKey:@"doctor_id"];
            }
            else
            {
                [departmentDict setValue:@([[doctor componentsSeparatedByString:@","][i] intValue]) forKey:@"doctor_id"];
            }
            [departmentDict setValue:[remark componentsSeparatedByString:@","][i] forKey:@"remark"];
            NSString *prod = [productids componentsSeparatedByString:@","][i];
            [departmentDict setValue:[prod componentsSeparatedByString:@"|"] forKey:@"product_ids"];
            [departmentArray addObject:departmentDict];
        }
//        [params setObject:departmentArray forKey:@"department_ids"];
    }
//    else {
        for (int i = 0; i < self.posOperate.products.count; i++)
        {
            CDPosProduct *product = (CDPosProduct *)[self.posOperate.products objectAtIndex:i];
            NSLog(@"%@",product);
            NSMutableDictionary *departmentDict = [[NSMutableDictionary alloc] init];
            BOOL isSettled = NO;
            for (int j = 0; j < departmentArray.count; j++)
            {
                if(departmentArray.count == 0)
                {
                    break;
                }
                else
                {
                    if (product.product.departments_id != nil) {
                        if ([product.product.departments_id intValue] != 0)
                        {
                            if(product.product.departments_id.integerValue == [[departmentArray[j] objectForKey:@"departments_id"] integerValue])
                            {
                                NSMutableArray *prodIds = [NSMutableArray arrayWithArray:[departmentArray[j] objectForKey:@"product_ids"]];
                                [prodIds addObject:product.product_id];
                                [departmentArray[j] setObject:prodIds forKey:@"product_ids"];
                                isSettled = YES;
                            }
                        }
                        else
                        {
                            if(product.product.category.departments_id.integerValue == [[departmentArray[j] objectForKey:@"departments_id"] integerValue])
                            {
                                NSMutableArray *prodIds = [NSMutableArray arrayWithArray:[departmentArray[j] objectForKey:@"product_ids"]];
                                [prodIds addObject:product.product_id];
                                [departmentArray[j] setObject:prodIds forKey:@"product_ids"];
                                isSettled = YES;
                            }
                        }
                    }
                    else if(product.product.category.departments_id.integerValue == [[departmentArray[j] objectForKey:@"departments_id"] integerValue])
                    {
                        NSMutableArray *prodIds = [NSMutableArray arrayWithArray:[departmentArray[j] objectForKey:@"product_ids"]];
                        [prodIds addObject:product.product_id];
                        [departmentArray[j] setObject:prodIds forKey:@"product_ids"];
                        isSettled = YES;
                    }
                }
            }
            if (!isSettled)
            {
                [departmentDict setValue:product.product.category.departments_id forKey:@"departments_id"];
                [departmentDict setValue:@(NO) forKey:@"doctor_id"];
                [departmentDict setValue:@"" forKey:@"remark"];
                [departmentDict setValue:@[[NSString stringWithFormat:@"%@",product.product_id]] forKey:@"product_ids"];
                if (product.product.bornCategory.integerValue == kPadBornCategoryProject)
                {
                    [departmentArray addObject:departmentDict];
                }
            }
        }
        for (int i = 0; i < self.posOperate.useItems.count; i++)
        {
            CDCurrentUseItem *useItem = [self.posOperate.useItems objectAtIndex:i];
            NSMutableDictionary *departmentDict = [[NSMutableDictionary alloc] init];
            BOOL isSettled = NO;
            for (int j = 0; j < departmentArray.count; j++)
            {
                if(departmentArray.count == 0)
                {
                    break;
                }
                else
                {
                    if (useItem.projectItem.departments_id != nil) {
                        if ([useItem.projectItem.departments_id intValue] != 0)
                        {
                            if(useItem.projectItem.departments_id.integerValue == [[departmentArray[j] objectForKey:@"departments_id"] integerValue])
                            {
                                NSMutableArray *prodIds = [NSMutableArray arrayWithArray:[departmentArray[j] objectForKey:@"product_ids"]];
                                [prodIds addObject:useItem.itemID];
                                [departmentArray[j] setObject:prodIds forKey:@"product_ids"];
                                isSettled = YES;
                            }
                        }
                        else
                        {
                            if(useItem.projectItem.category.departments_id.integerValue == [[departmentArray[j] objectForKey:@"departments_id"] integerValue])
                            {
                                NSMutableArray *prodIds = [NSMutableArray arrayWithArray:[departmentArray[j] objectForKey:@"product_ids"]];
                                [prodIds addObject:useItem.itemID];
                                [departmentArray[j] setObject:prodIds forKey:@"product_ids"];
                                isSettled = YES;
                            }
                        }
                    }
                    else if(useItem.projectItem.category.departments_id.integerValue == [[departmentArray[j] objectForKey:@"departments_id"] integerValue])
                    {
                        NSMutableArray *prodIds = [NSMutableArray arrayWithArray:[departmentArray[j] objectForKey:@"product_ids"]];
                        [prodIds addObject:useItem.itemID];
                        [departmentArray[j] setObject:prodIds forKey:@"product_ids"];
                        isSettled = YES;
                    }
                }
            }
            if (!isSettled)
            {
                BOOL isFind = FALSE;
                for ( NSDictionary* d in departmentArray )
                {
                    NSNumber* dID = d[@"departments_id"];
                    if ( [dID integerValue] == [useItem.projectItem.category.departments_id integerValue] )
                    {
                        isFind = TRUE;
                        break;
                    }
                }
                if ( !isFind )
                {
                    [departmentDict setValue:useItem.projectItem.category.departments_id forKey:@"departments_id"];
                    [departmentDict setValue:@(NO) forKey:@"doctor_id"];
                    [departmentDict setValue:@"" forKey:@"remark"];
                    [departmentDict setValue:@[[NSString stringWithFormat:@"%@",useItem.itemID]] forKey:@"product_ids"];
                    [departmentArray addObject:departmentDict];
                }
            }
        }
//        for(int i = 0; i < [doctor componentsSeparatedByString:@","].count; i++)
//        {
//            NSMutableDictionary *departmentDict = [[NSMutableDictionary alloc] init];
//            [departmentDict setValue:[roomid componentsSeparatedByString:@","][i] forKey:@"departments_id"];
//            [departmentDict setValue:@(NO) forKey:@"doctor_id"];
//            [departmentDict setValue:[remark componentsSeparatedByString:@","][i] forKey:@"remark"];
//            NSString *prod = [productids componentsSeparatedByString:@","][i];
//            [departmentDict setValue:[prod componentsSeparatedByString:@"|"] forKey:@"product_ids"];
//            [departmentArray addObject:departmentDict];
//        }
        if (departmentArray.count > 0)
        {
            [params setObject:departmentArray forKey:@"department_ids"];
        }
//    }
    for (int i = 0; i < self.posOperate.products.count; i++)
    {
        CDPosProduct *product = (CDPosProduct *)[self.posOperate.products objectAtIndex:i];
        NSMutableArray* buweiArray = [NSMutableArray array];
        for ( CDYimeiBuwei* buwei in product.yimei_buwei )
        {
            NSArray* array = @[@(0), @(NO), @{@"name":buwei.name,@"qty":buwei.count}];
            [buweiArray addObject:array];
        }
        
        NSArray *array = [NSArray array];
        if (cardSnapAmount > product.product_price.floatValue * product.product_qty.integerValue)
        {
            array = @[@(0), @(NO), @{@"product_id":product.product_id, @"price_unit":product.product_price, @"qty":product.product_qty, @"card_pay_amount":@(product.product_price.floatValue * product.product_qty.integerValue), @"is_deposit":@(NO),@"part_ids":buweiArray,@"item_qty":product.change_qty ? product.change_qty : @(0), @"coupon_deduction":product.coupon_deduction, @"coupon_id":product.coupon_id ? product.coupon_id : @(0), @"point_deduction":product.point_deduction}];
            cardSnapAmount -= product.product_price.floatValue * product.product_qty.integerValue;
        }
        else
        {
            array = @[@(0), @(NO), @{@"product_id":product.product_id, @"price_unit":[NSNumber numberWithFloat:(product.product_price.floatValue*product.product_qty.floatValue-product.coupon_deduction.floatValue-product.point_deduction.floatValue)/product.product_qty.floatValue], @"qty":product.product_qty, @"card_pay_amount":@(cardSnapAmount), @"is_deposit":@(NO),@"part_ids":buweiArray,@"item_qty":product.change_qty ? product.change_qty : @(0), @"coupon_deduction":product.coupon_deduction, @"coupon_id":product.coupon_id ? product.coupon_id : @(0), @"point_deduction":product.point_deduction}];
            cardSnapAmount = 0;
        }
        [productLineIds addObject:array];
        
        if ( !self.isBuyItemAndNotUse && product.product.bornCategory.integerValue == kPadBornCategoryProject)
        {
            NSArray *array = @[@(0), @(NO), @{@"product_id":product.product_id, @"lines_id":@(NO), @"consume_qty":product.product_qty, @"qty":@(0), @"part_ids":buweiArray, @"parent_id":@(NO)}];
            [consumeIds addObject:array];
        }
    }
    
    for (int i = 0; i < self.posOperate.useItems.count; i++)
    {
        CDCurrentUseItem *useItem = [self.posOperate.useItems objectAtIndex:i];
        NSMutableArray* buweiArray = [NSMutableArray array];
#if 0
        if ( useItem.yimei_buwei.count == 0 )
        {
            for (int i = 0; i < self.posOperate.products.count; i++)
            {
                CDPosProduct *product = (CDPosProduct *)[self.posOperate.products objectAtIndex:i];
                if ( [product.product_id isEqual:useItem.itemID] )
                {
                    for ( CDYimeiBuwei* buwei in product.yimei_buwei )
                    {
                        NSArray* array = @[@(0), @(NO), @{@"name":buwei.name,@"qty":buwei.count}];
                        [buweiArray addObject:array];
                    }
                }
                break;
            }
        }
        else
        {
            for ( CDYimeiBuwei* buwei in useItem.yimei_buwei )
            {
                NSArray* array = @[@(0), @(NO), @{@"name":buwei.name,@"qty":buwei.count}];
                [buweiArray addObject:array];
            }
        }
#else
        for ( CDYimeiBuwei* buwei in useItem.yimei_buwei )
        {
            NSArray* array = @[@(0), @(NO), @{@"name":buwei.name,@"qty":buwei.count}];
            [buweiArray addObject:array];
        }
#endif
        if (useItem.type.integerValue == kPadUseItemPurchasing || useItem.type.integerValue == kPadUseItemCurrentPurchase)
        {
            NSArray *array = @[@(0), @(NO), @{@"product_id":useItem.itemID, @"lines_id":@(NO), @"consume_qty":useItem.useCount, @"qty":useItem.useCount,@"part_ids":buweiArray,@"parent_id":useItem.parent_id}];
            [consumeIds addObject:array];
        }
        else if (useItem.type.integerValue == kPadUseItemMemberCardProject)
        {
            NSArray *array = @[@(0), @(NO), @{@"product_id":useItem.itemID, @"lines_id":useItem.cardProject.productLineID, @"consume_qty":useItem.useCount, @"qty":useItem.useCount, @"part_ids":buweiArray,@"parent_id":useItem.parent_id}];
            [consumeIds addObject:array];
        }
        else if (useItem.type.integerValue == kPadUseItemCouponCardProject)
        {
            NSArray *array = @[@(0), @(NO), @{@"product_id":useItem.itemID, @"coupon_lines_id":useItem.couponProject.productLineID, @"consume_qty":useItem.useCount, @"qty":useItem.useCount,@"part_ids":buweiArray,@"parent_id":useItem.parent_id}];
            [consumeIds addObject:array];
            
            NSMutableArray* couponLines = couponCardsProductParams[self.posOperate.couponCard.cardID];
            if ( couponLines )
            {
                [couponLines addObject:@[@(0),@(FALSE),@{@"product_id":useItem.itemID, @"consume_qty":useItem.useCount,@"coupon_lines_id":useItem.couponProject.productLineID,@"part_ids":buweiArray}]];
            }
            else
            {
                couponLines = [NSMutableArray array];
                [couponLines addObject:@[@(0),@(FALSE),@{@"product_id":useItem.itemID, @"consume_qty":useItem.useCount,@"coupon_lines_id":useItem.couponProject.productLineID,@"part_ids":buweiArray}]];
                NSArray *array = @[@(0), @(NO),@{@"coupon_id":self.posOperate.couponCard.cardID,@"lines":couponLines}];
                [params setObject:@[array] forKey:@"coupon_ids"];
            }
        }
    }
    
    [params setObject:consumeIds forKey:@"consume_line_ids"];
    [params setObject:productLineIds forKey:@"product_line_ids"];
    
    //[params setObject:self.posOperate.secondKeshi.doctor_id forKey:@"doctor_id"];
    [params setObject:self.posOperate.amount forKey:@"revenue_amount"];
    [params setObject:@(self.totalAmount) forKey:@"paid_amount"];
    [params setObject:@(self.totalAmount - self.posOperate.amount.doubleValue) forKey:@"change_amount"];
    
    //添加MemberID
    if (self.posOperate.member_id) {
        [params setObject:self.posOperate.member_id forKey:@"member_id"];
    }

    if ( self.posOperate.occupy_restaurant_id )
    {
        [params setObject:self.posOperate.occupy_restaurant_id forKey:@"table_line_id"];
    }
    
    if ( self.posOperate.remark.length > 0 )
    {
        [params setObject:self.posOperate.remark forKey:@"remark"];
    }
    
    if ( self.posOperate.note.length > 0 )
    {
        [params setObject:self.posOperate.note forKey:@"note"];
    }
    [params setObject:@(self.isGuadan) forKey:@"is_post_checkout"];
    if (self.isGuadanPay)
    {
        //[params setObject:@(TRUE) forKey:@"is_post_checkout"];
        BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateGuadanPay];
        request.operate = self.posOperate;
        request.orignalOperateID = self.orignalOperateID;
        [request execute];
    }
    else
    {
        BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateCashier];
        request.operate = self.posOperate;
        request.orignalOperateID = self.orignalOperateID;
        [request execute];
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
            for (CDPosProduct *product in self.posOperate.products) {
                if ([product.product.bornCategory integerValue] == kPadBornCategoryProduct)
                {
                    BSProjectItemUpdateAvailableRequest *request = [[BSProjectItemUpdateAvailableRequest alloc] init];
                    request.fetchProductIDs = [NSMutableArray arrayWithObject:product.product_id];
                    [request execute];
                }
            }
            if ( self.orignalOperateID.integerValue > 0 )
            {
                
//                if (self.isAddItem)
//                {
//                    [self.outNavigationController popViewControllerAnimated:NO];
//                    [self.outNavigationController popViewControllerAnimated:YES];
//                }
//                else
//                {
                    [self.outNavigationController popViewControllerAnimated:YES];
//                }
                [self.maskView hidden];
                
                [[BSCoreDataManager currentManager] deleteObject:self.posOperate];
                [[BSCoreDataManager currentManager] save:nil];
                
                return;
            }
            
            if ( [[PersonalProfile currentProfile].isYiMei boolValue] && !notShowConfirmVc )
            {
                YimeiSignBeforeOperationViewController* vc = [[YimeiSignBeforeOperationViewController alloc] initWithNibName:@"YimeiSignBeforeOperationViewController" bundle:nil];
                self.posOperate.operate_id = [notification.object objectForKey:@"operate_id"];
                vc.operate = self.posOperate;
                vc.YimeiSignBeforeOperationViewControllerFinished = ^(void)
                {
                    [self.maskView removeSubviews];
                    double payamount = 0.0;
                    WeakSelf;
                    if (!weakSelf.isGuadan) {
                        payamount = self.posOperate.amount.doubleValue;
                    }
                    PadOperateSuccessViewController *viewController = [[PadOperateSuccessViewController alloc] initWithOperateType:kPadPosOperatePaymentSuccess detail:@"" amount:payamount];
                    viewController.member = self.posOperate.member;
                    viewController.card = self.posOperate.memberCard;
                    self.posOperate.operate_id = [notification.object objectForKey:@"operate_id"];
                    viewController.operateID = [notification.object objectForKey:@"operate_id"];
                    viewController.maskView = self.maskView;
                    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
                    self.maskView.navi.navigationBarHidden = YES;
                    self.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
                    [self.maskView addSubview:self.maskView.navi.view];
                    
                    //                    if ( self.posOperate.occupy_restaurant_id )
                    //                    {
                    //                        BSFetchRestaurantTableRequest* request = [[BSFetchRestaurantTableRequest alloc] initWithLastUpdate];
                    //                        [request execute];
                    //                    }
                };
                if (self.isGuadan)
                {
                    [self.maskView.navi pushViewController:vc animated:NO];
                }
                else
                {
                    [self.maskView.navi pushViewController:vc animated:YES];
                }
#if 0
                if ( [PersonalProfile currentProfile].printIP.length > 2 )
                {
                    BSPrintPosOperateRequestNew* request = [[BSPrintPosOperateRequestNew alloc] init];
                    request.operateID = self.posOperate.operate_id;
                    request.openCashBox = self.isCash;
                    [request execute];
                }
                else
                {
                    if ( ![[PersonalProfile currentProfile].isYiMei boolValue] )
                    {
                        [[BSPrintPosOperateRequest alloc] printWithPosOperateID:self.posOperate.operate_id];
                    }
                }
#endif
                //BSFetchOperateRequest *request = [[BSFetchOperateRequest alloc] initWithOperateIds:@[self.posOperate.operate_id]];
                //[request execute];
            }
            else
            {
                if (self.isGuadan)
                {
                    [self.maskView hidden];
                    self.maskView = nil;
                }
                [self.maskView removeSubviews];
                PadOperateSuccessViewController *viewController = [[PadOperateSuccessViewController alloc] initWithOperateType:kPadPosOperatePaymentSuccess detail:@"" amount:self.posOperate.amount.doubleValue];
                viewController.member = self.posOperate.member;
                viewController.card = self.posOperate.memberCard;
                viewController.memberID = [NSNumber numberWithInt:self.posOperate.member_id.intValue];
                viewController.cardID = [NSNumber numberWithInt:self.posOperate.card_id.intValue];
                viewController.operateID = [notification.object objectForKey:@"operate_id"];
                viewController.maskView = self.maskView;
                viewController.memberID = [NSNumber numberWithInt:self.posOperate.memberCard.member.memberID.intValue];
                self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
                self.maskView.navi.navigationBarHidden = YES;
                self.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
                [self.maskView addSubview:self.maskView.navi.view];
                
                if ( self.posOperate.occupy_restaurant_id )
                {
                    BSFetchRestaurantTableRequest* request = [[BSFetchRestaurantTableRequest alloc] initWithLastUpdate];
                    [request execute];
                }
#if 0
                if ( [PersonalProfile currentProfile].printIP.length > 2 )
                {
                    BSPrintPosOperateRequestNew* request = [[BSPrintPosOperateRequestNew alloc] init];
                    request.operateID = viewController.operateID;
                    request.openCashBox = self.isCash;
                    [request execute];
                }
                else
                {
                    [[BSPrintPosOperateRequest alloc] printWithPosOperateID:viewController.operateID];
                }
#endif
            }

            ///self.posOperate.member.memberID=nil的话会报缺少参数错误 
            if (self.posOperate.member.memberID!=nil) {
                BSFetchMemberDetailRequestN *memberCardRequest = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:self.posOperate.member.memberID];
                [memberCardRequest execute];
            }
           

        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(self.isGuadan || self.isAddItem)
            {
                [self.maskView hidden];
                self.maskView = nil;
                [self.maskView removeSubviews];
            }
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
    else if ([notification.name isEqualToString:kBSAlipayTradeResponse] )
    {
        NSDictionary* params = notification.userInfo;
        NSNumber* errorCode = params[@"errcode"];
        if ( errorCode && [errorCode integerValue] == 0 )
        {
            NSString* tradeNo = params[@"data"][@"trade_no"];
            NSNumber* record = params[@"data"][@"record"];
            BSAlipayTradeRequest* request = notification.object;
            CGFloat amount = [self.alipayParams[@"total_amount"] floatValue];
            if ( amount > 0 )
            {
                [self didPadCashRegisterSuccessWithPaymode:request.paymode amount:amount bankNo:tradeNo pos_type:[record stringValue]];
            }
            else
            {
                NSInteger wxAmount = [self.alipayParams[@"total_fee"] integerValue];
                tradeNo = params[@"data"][@"out_trade_no"];
                [self didPadCashRegisterSuccessWithPaymode:request.paymode amount:1.0 * wxAmount / 100 bankNo:tradeNo pos_type:[record stringValue]];
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:params[@"errmsg"]
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else if ([notification.name isEqualToString:kBSAlipayRefundResponse] )
    {
        NSDictionary* params = notification.userInfo;
        NSNumber* errorCode = params[@"errcode"];
        if ( errorCode && [errorCode integerValue] == 0 )
        {
            BSAlipayRefundRequest* request = (BSAlipayRefundRequest*)notification.object;
            NSDictionary *dict = [self.payments objectAtIndex:request.paymentIndex];
            [self.payments removeObject:dict];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:request.paymentIndex inSection:kPadPaymentSectionPayment];
                [self.paymentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            });
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:params[@"errmsg"]
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
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
    if (tableView == self.paymentTableView)
    {
        return kPadPaymentSectionCount;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.paymentTableView)
    {
        if (section == kPadPaymentSectionPayment)
        {
            return self.payments.count;
        }
        else if (section == kPadPaymentSectionPayMode)
        {
            return self.paymodes.count;
        }
    }
    else if (tableView == self.morePaymodeTableView)
    {
        return self.morePaymodes.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.paymentTableView)
    {
        if (indexPath.section == kPadPaymentSectionPayment)
        {
            return kPadPaymentCellHeight;
        }
        else if (indexPath.section == kPadPaymentSectionPayMode)
        {
            return kPadPayModeCellHeight;
        }
    }
    else if (tableView == self.morePaymodeTableView)
    {
        return kPadMorePayModeCellHeight;
    }
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.paymentTableView)
    {
        if (section == kPadPaymentSectionPayment)
        {
            return 36.0;
        }
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == self.paymentTableView)
    {
        if (section == kPadPaymentSectionPayment)
        {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadPaymentCellWidth, kPadPaymentCellHeight)];
            footerView.backgroundColor = [UIColor clearColor];
            
            return footerView;
        }
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.paymentTableView)
    {
        if (indexPath.section == kPadPaymentSectionPayment)
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
            }
            
            return cell;
        }
        else if (indexPath.section == kPadPaymentSectionPayMode)
        {
            NSString *CellIdentifier = [NSString stringWithFormat:@"PadPayModeCellIdentifier%d", indexPath.row];
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
                NSLog(@"%@",self.posOperate.memberCard);
                CDPOSPayMode *paymode = (CDPOSPayMode *)object;
                cell.paymodeLabel.text = paymode.payName;
                if (paymode.mode.integerValue == kPadPayModeTypeCard)
                {
                    cell.paymodeLabel.text = [NSString stringWithFormat:LS(@"PadMemberCardOverageRemind"), paymode.payName, self.posOperate.memberCard.balance.floatValue];
                    if (self.posOperate.memberCard.balance.floatValue > 0.02) {
                        PadPaymodeParams *params = [self.params objectAtIndex:cell.index];
                        if (params.isDisable)
                        {
                            params.isDisable = NO;
                        }
                    }
                }
                else if (paymode.mode.integerValue == kPadPayModeTypeCoupon)
                {
                    cell.paymodeLabel.text = [NSString stringWithFormat:LS(@"PadCouponCardOverageRemind"), paymode.payName, self.posOperate.couponCard.remainAmount.floatValue];
                }
                else if (paymode.mode.integerValue == kPadPayModeTypePoint)
                {
                    cell.paymodeLabel.text = [NSString stringWithFormat:LS(@"PadMemberCardPointPaymentRemind"), paymode.payName, self.posOperate.memberCard.points.floatValue, self.posOperate.memberCard.points.floatValue * self.posOperate.memberCard.priceList.points2Money.floatValue];
                    if (self.posOperate.memberCard.points.floatValue > 0.02) {
                        PadPaymodeParams *params = [self.params objectAtIndex:cell.index];
                        if (params.isDisable)
                        {
                            params.isDisable = NO;
                        }
                    }
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
    }
    else if (tableView == self.morePaymodeTableView)
    {
        static NSString *CellIdentifier = @"PadMorePayModeCellIdentifier";
        PadMorePayModeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadMorePayModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSObject *object = [self.morePaymodes objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *paymodestr = (NSString *)object;
            cell.titleLabel.text = LS(paymodestr);
        }
        else if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            cell.titleLabel.text = paymode.payName;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.paymentTableView)
    {
        if (indexPath.section == kPadPaymentSectionPayment)
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
    else if (tableView == self.morePaymodeTableView)
    {
        NSObject *object = [self.morePaymodes objectAtIndex:indexPath.row];
        [self.morePaymodes removeObject:object];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.morePaymodeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.morePaymodeTableView reloadData];
                self.morePaymodeTableView.frame = CGRectMake(self.morePaymodeTableView.frame.origin.x, self.morePaymodeTableView.frame.origin.y, self.morePaymodeTableView.frame.size.width, self.morePaymodes.count * kPadMorePayModeCellHeight);
                if (self.morePaymodes.count == 0)
                {
                    self.addButton.hidden = YES;
                    self.morePaymodeTableView.hidden = YES;
                }
                else
                {
                    [self didAddButtonClick:nil];
                }
            });
        });
        
        [self.paymodes addObject:object];
        PadPaymodeParams *params = [[PadPaymodeParams alloc] init];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            if (paymode.mode.integerValue == kPadPayModeTypeCoupon)
            {
                if (self.posOperate.couponCard.remainAmount.floatValue == 0)
                {
                    params.isDisable = YES;
                }
                else
                {
                    params.isCouponCard = YES;
                    params.couponCardAmount = self.posOperate.couponCard.remainAmount.floatValue;
                }
            }
        }
        
        [self.params addObject:params];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.paymodes.count - 1) inSection:kPadPaymentSectionPayMode];
        [self.paymentTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        
        if ( paymode.mode.integerValue == kPadPayModeTypeBankCard && isWePosSupport )
        {
            NSString* amount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"amount"]];
            NSString* bankNo = [dict objectForKey:@"bankNo"];
            
            if ( bankNo.length > 0 )
            {
                NSString* pos_type = [dict objectForKey:@"pos_type"];
                NSString *device = @"";
                
                PayBankAccountType type = PayBankAccountType_BlueTooth;
                if ( [pos_type isEqualToString:@"audio"] )
                {
                    type = PayBankAccountType_Audio;
                }
                
                if ( type == PayBankAccountType_BlueTooth )
                {
                    NSDictionary *dict = [BSUserDefaultsManager sharedManager].mPadPosMachineRecord;
                    device = [dict objectForKey:@"name"];
                    if (device.length == 0)
                    {
                        [self didPadSettingWithType:kPadSettingViewPosMachine];
                        return;
                    }
                }
                
                bankCancelTag = cell.index;
                [[PayBankManager sharedManager] payWithAccountType:type price:[NSString stringWithFormat:@"%.2f",amount] device:[device urlEncode] bankNo:bankNo delegate:self];
                return;
            }
            
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
            //                                                                message:LS(@"银行卡支付成功后不能取消")
            //                                                               delegate:nil
            //                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
            //                                                      otherButtonTitles:nil, nil];
            //            [alertView show];
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
#if 1
        NSObject *object = [dict objectForKey:@"mode"];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            
            if ( paymode.mode.integerValue == kPadPayModeTypeAlipay )
            {
                NSString* bankNo = [dict objectForKey:@"bankNo"];
                
                NSMutableDictionary* alipayParams = [NSMutableDictionary dictionary];
                alipayParams[@"payment_id"] = paymode.payment_acquirer_id;
                alipayParams[@"method"] = @"alipay.trade.refund";
                alipayParams[@"trade_no"] = bankNo;
                alipayParams[@"out_request_no"] = @"system_generates";
                alipayParams[@"body"] = @"Pad收银";
                alipayParams[@"refund_amount"] = [dict objectForKey:@"amount"];
                alipayParams[@"refund_reason"] = @"退款";
                alipayParams[@"operator_id"] = [PersonalProfile currentProfile].userID;
                alipayParams[@"store_id"] = [PersonalProfile currentProfile].getCurrentStoreID;
                alipayParams[@"terminal_id"] = [PersonalProfile currentProfile].getCurrentStoreID;
                
                BSAlipayRefundRequest* request = [[BSAlipayRefundRequest alloc] initWithParams:alipayParams];
                request.paymentIndex = alertView.tag;
                [request execute];
            }
            else if ( paymode.mode.integerValue == kPadPayModeTypeWeChat )
            {
                NSString* bankNo = [dict objectForKey:@"bankNo"];
                
                NSMutableDictionary* alipayParams = [NSMutableDictionary dictionary];
                alipayParams[@"payment_id"] = paymode.payment_acquirer_id;
                alipayParams[@"out_trade_no"] = bankNo;
                alipayParams[@"out_refund_no"] = @"system_generates";
                alipayParams[@"device_info"] = [PersonalProfile currentProfile].deviceString;
                alipayParams[@"refund_fee"] = @((int)([[dict objectForKey:@"amount"] floatValue] * 100));
                alipayParams[@"total_fee"] = @((int)([[dict objectForKey:@"amount"] floatValue] * 100));
                alipayParams[@"op_user_id"] = [PersonalProfile currentProfile].userID;
                
                BSAlipayRefundRequest* request = [[BSAlipayRefundRequest alloc] initWithParams:alipayParams];
                request.paymentIndex = alertView.tag;
                [request execute];
            }
            else
            {
                [self.payments removeObject:dict];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:kPadPaymentSectionPayment];
                    [self.paymentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadData];
                    });
                });
            }
        }
        else
        {
            [self.payments removeObject:dict];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:kPadPaymentSectionPayment];
                [self.paymentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            });
        }
#endif
    }
}

- (void)refundAllMoney
{
    for (NSMutableDictionary *dict in self.payments)
    {
        NSObject *object = [dict objectForKey:@"mode"];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            
            if ( paymode.mode.integerValue == kPadPayModeTypeAlipay )
            {
                NSString* bankNo = [dict objectForKey:@"bankNo"];
                
                NSMutableDictionary* alipayParams = [NSMutableDictionary dictionary];
                alipayParams[@"payment_id"] = paymode.payment_acquirer_id;
                alipayParams[@"method"] = @"alipay.trade.refund";
                alipayParams[@"trade_no"] = bankNo;
                alipayParams[@"out_request_no"] = @"system_generates";
                alipayParams[@"body"] = @"Pad收银";
                alipayParams[@"refund_amount"] = [dict objectForKey:@"amount"];
                alipayParams[@"refund_reason"] = @"退款";
                alipayParams[@"operator_id"] = [PersonalProfile currentProfile].userID;
                alipayParams[@"store_id"] = [PersonalProfile currentProfile].getCurrentStoreID;
                alipayParams[@"terminal_id"] = [PersonalProfile currentProfile].getCurrentStoreID;
                
                BSAlipayRefundRequest* request = [[BSAlipayRefundRequest alloc] initWithParams:alipayParams];
                [request execute];
            }
            else if ( paymode.mode.integerValue == kPadPayModeTypeWeChat )
            {
                NSString* bankNo = [dict objectForKey:@"bankNo"];
                
                NSMutableDictionary* alipayParams = [NSMutableDictionary dictionary];
                alipayParams[@"payment_id"] = paymode.payment_acquirer_id;
                alipayParams[@"out_trade_no"] = bankNo;
                alipayParams[@"out_refund_no"] = @"system_generates";
                alipayParams[@"device_info"] = [PersonalProfile currentProfile].deviceString;
                alipayParams[@"refund_fee"] = @((int)([[dict objectForKey:@"amount"] floatValue] * 100));
                alipayParams[@"total_fee"] = @((int)([[dict objectForKey:@"amount"] floatValue] * 100));
                alipayParams[@"op_user_id"] = [PersonalProfile currentProfile].userID;
                
                BSAlipayRefundRequest* request = [[BSAlipayRefundRequest alloc] initWithParams:alipayParams];
                [request execute];
            }
        }
    }
}

#pragma mark -
#pragma mark PadPayModeCell Methods

- (void)reloadPadPaymodeCell:(PadPayModeCell *)cell
{
    PadPaymodeParams *params = [self.params objectAtIndex:cell.index];
    if (params.isDisable)
    {
        if ( params.isPoint )
        {
            cell.amountTextField.text = @"没有可用积分";
        }
        else
        {
            cell.amountTextField.text = LS(@"PadMemberCardInsufficient");
        }
        
        cell.amountTextField.enabled = NO;
        
        return;
    }
    
    cell.amountTextField.enabled = YES;
    if (params.didEdited && params.currentAmount != 0)
    {
        cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", params.currentAmount];
    }
    else
    {
        CGFloat amount = self.tempAmount;
        if (params.isMemberCard)
        {
            amount = params.memberCardAmount - self.cardAmount;
        }
        else if (params.isBank)
        {
            amount = params.maxAmount;
        }
        else if (params.isCouponCard)
        {
            amount = params.couponCardAmount - self.couponAmount;
        }
        else if (params.isPoint)
        {
            NSLog(@"%f",params.pointAmount);
            amount = params.pointAmount - self.pointAmount;
        }
        
        cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", MIN(self.tempAmount, amount)];
    }
}


#pragma mark -
#pragma mark PadPayModeCellDelegate Methods

- (void)didPadPaymodeCellContentClick:(PadPayModeCell *)cell
{
    if ( [self.posOperate.amount doubleValue] == 0 )
        return;
    
    if (self.currentContent != -1)
    {
        PadPayModeCell *lastCell = (PadPayModeCell *)[self.paymentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentContent inSection:kPadPaymentSectionPayMode]];
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
        if (params.isMemberCard && params.memberCardAmount - self.cardAmount < self.tempAmount)
        {
            cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", params.memberCardAmount - self.cardAmount];
        }
        else if (params.isCouponCard && params.couponCardAmount - self.couponAmount < self.tempAmount)
        {
            cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", params.couponCardAmount - self.couponAmount];
        }
        else if (params.isPoint && params.pointAmount - self.pointAmount < self.tempAmount)
        {
            cell.amountTextField.text = [NSString stringWithFormat:@"¥ %.2f", params.pointAmount - self.pointAmount];
        }
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
            else
            {
                amount = params.currentAmount;
            }
        }
        else
        {
            amount = MIN(self.tempAmount, params.maxAmount);
        }
    }
    else if (params.isMemberCard)
    {
        if (params.didEdited && params.currentAmount != 0)
        {
            if (params.currentAmount > params.memberCardAmount)
            {
                params.didEdited = NO;
                params.currentAmount = 0.0;
                [self reloadPadPaymodeCell:cell];
                return NO;
            }
            else
            {
                amount = params.currentAmount;
            }
        }
        else
        {
            amount = MIN(self.tempAmount, params.memberCardAmount - self.cardAmount);
        }
    }
    else if (params.isCouponCard)
    {
        if (params.didEdited && params.currentAmount != 0)
        {
            if (params.currentAmount > params.couponCardAmount)
            {
                params.didEdited = NO;
                params.currentAmount = 0.0;
                [self reloadPadPaymodeCell:cell];
                return NO;
            }
            else
            {
                amount = params.currentAmount;
            }
        }
        else
        {
            amount = MIN(self.tempAmount, params.couponCardAmount - self.couponAmount);
        }
    }
    else if (params.isPoint)
    {
        if (params.didEdited && params.currentAmount != 0)
        {
            if (params.currentAmount > params.pointAmount)
            {
                params.didEdited = NO;
                params.currentAmount = 0.0;
                [self reloadPadPaymodeCell:cell];
                return NO;
            }
            else
            {
                amount = params.currentAmount;
            }
        }
        else
        {
            amount = MIN(self.tempAmount, params.pointAmount - self.pointAmount);
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
    
    if (!params.isCash && self.totalAmount - self.cashAmount + amount > self.posOperate.amount.doubleValue)
    {
        params.currentAmount = self.posOperate.amount.doubleValue - self.totalAmount + self.cashAmount;
        [self reloadPadPaymodeCell:cell];
        return NO;
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.payments.count - 1) inSection:kPadPaymentSectionPayment];
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
            
            if (amount + cardAmount - self.posOperate.memberCard.balance.floatValue > 0.02)
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
            
            if (amount + couponAmount - self.posOperate.couponCard.remainAmount.floatValue > 0.02)
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
            if ( !isWePosSupport )
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
            //            for (NSMutableDictionary *dict in self.payments)
            //            {
            //                if ([[dict objectForKey:@"mode"] isKindOfClass:[CDPOSPayMode class]])
            //                {
            //                    CDPOSPayMode *mode = (CDPOSPayMode *)[dict objectForKey:@"mode"];
            //                    if (mode.mode.integerValue == kPadPayModeTypeCash)
            //                    {
            //                        [dict setObject:@([[dict objectForKey:@"amount"] floatValue] + amount) forKey:@"amount"];
            //                        [self reloadData];
            //                        return YES;
            //                    }
            //                }
            //            }
        }
#if 1
        else if (paymode.mode.integerValue == kPadPayModeTypeAlipay)
        {
            self.alipayParams = [NSMutableDictionary dictionary];
            self.alipayParams[@"payment_id"] = paymode.payment_acquirer_id;
            self.alipayParams[@"method"] = @"alipay.trade.pay";
            self.alipayParams[@"subject"] = @"Pad收银";
            self.alipayParams[@"body"] = @"Pad收银";
            self.alipayParams[@"total_amount"] = @(amount);
            self.alipayParams[@"undiscountable_amount"] = @(amount);
            self.alipayParams[@"operator_id"] = [PersonalProfile currentProfile].userID;
            self.alipayParams[@"store_id"] = [PersonalProfile currentProfile].getCurrentStoreID;
            self.alipayParams[@"terminal_id"] = [PersonalProfile currentProfile].deviceString;
            self.alipayParams[@"timeout_express"] = @"15m";
            self.alipayParams[@"out_trade_no"] = @"system_generates";
            
            BNScanCodeViewController* vc = [[BNScanCodeViewController alloc] initWithDelegate:self];
            vc.paymode = paymode;
            [self.outNavigationController pushViewController:vc animated:true];
            //[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
            return NO;
        }
        else if (paymode.mode.integerValue == kPadPayModeTypeWeChat)
        {
            self.alipayParams = [NSMutableDictionary dictionary];
            self.alipayParams[@"payment_id"] = paymode.payment_acquirer_id;
            self.alipayParams[@"body"] = @"Pad收银";
            self.alipayParams[@"total_fee"] = @((int)(amount * 100));
            self.alipayParams[@"device_info"] = [PersonalProfile currentProfile].deviceString;
            self.alipayParams[@"out_trade_no"] = @"system_generates";
            
            BNScanCodeViewController* vc = [[BNScanCodeViewController alloc] initWithDelegate:self];
            vc.paymode = paymode;
            [self.outNavigationController pushViewController:vc animated:true];
            
            return NO;
        }
#endif
        else if (paymode.mode.integerValue == kPadPayModeTypePoint)
        {
            CGFloat pointAmount = 0.0;
            for (NSObject *object in self.payments)
            {
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *dict = (NSMutableDictionary *)object;
                    NSObject *mObject = [dict objectForKey:@"mode"];
                    if ([mObject isKindOfClass:[CDPOSPayMode class]])
                    {
                        CDPOSPayMode *mode = (CDPOSPayMode *)mObject;
                        if (mode.mode.integerValue == kPadPayModeTypePoint)
                        {
                            pointAmount = [[dict objectForKey:@"amount"] floatValue] + amount;
                            [dict setObject:@(pointAmount) forKey:@"amount"];
                            [self reloadData];
                            return YES;
                        }
                    }
                }
            }
            
            //            CGFloat tse = self.posOperate.memberCard.balance.floatValue;
            //            if (amount + pointAmount - self.posOperate.memberCard.balance.floatValue > 0.001)
            //            {
            ////                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
            ////                                                                    message:LS(@"PadMemberCardPointInsufficient")
            ////                                                                   delegate:nil
            ////                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
            ////                                                          otherButtonTitles:nil, nil];
            ////                [alertView show];
            //                return YES;
            //            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:paymode, @"mode", @(amount), @"amount", nil];
        [self.payments addObject:dict];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.payments.count - 1) inSection:kPadPaymentSectionPayment];
        [self.paymentTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    params.didEdited = NO;
    [self reloadData];
    
    return YES;
}

- (void)doAlipayRequest:(CDPOSPayMode*)paymode
{
    NSMutableArray* productArray = [NSMutableArray array];
    
    for (int i = 0; i < self.posOperate.products.count; i++)
    {
        CDPosProduct *product = (CDPosProduct *)[self.posOperate.products objectAtIndex:i];
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        if ( self.alipayParams[@"total_fee"] ) //微信
        {
            params[@"goods_id"] = product.product_id;
            params[@"goods_name"] = product.product_name;
            params[@"goods_num"] = product.product_qty;
            params[@"goood_category"] = @(0);
            params[@"price"] = product.product_price;
            params[@"body"] = product.product_name;
        }
        else
        {
            params[@"goods_id"] = product.product_id;
            params[@"goods_name"] = product.product_name;
            params[@"quantity"] = product.product_qty;
            params[@"goood_category"] = @(0);
            params[@"price"] = product.product_price;
            params[@"body"] = product.product_name;
        }
        
        [productArray addObject:params];
    }
    
    if ( self.alipayParams[@"total_fee"] ) //微信
    {
        self.alipayParams[@"detail"] = productArray;
    }
    else
    {
        self.alipayParams[@"goods_detail"] = productArray;
    }
    
    BSAlipayTradeRequest* request = [[BSAlipayTradeRequest alloc] initWithParams:self.alipayParams];
    request.paymode = paymode;
    [request execute];
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:paymode, @"mode", @(amount), @"amount", bankNo, @"bankNo",pos_type, @"pos_type", nil];
    [self.payments addObject:dict];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.payments.count - 1) inSection:kPadPaymentSectionPayment];
    [self.paymentTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self reloadData];
    for (int i = 0; i < self.paymodes.count; i++)
    {
        NSObject *object = [self.paymodes objectAtIndex:i];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            if (paymode.mode.integerValue == kPadPayModeTypeBankCard || paymode.mode.integerValue == kPadPayModeTypeWeChat || paymode.mode.integerValue == kPadPayModeTypeAlipay )
            {
                PadPayModeCell *cell = [self.paymentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kPadPaymentSectionPayMode]];
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
    PadPayModeCell *cell = [self.paymentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:kPadPaymentSectionPayMode]];
    BOOL shouldHide = [self didPadPayModeCellConfirm:cell];
    if (shouldHide)
    {
        [cell hideInputViews];
    }
}

- (void)pleaseSetUserName:(PayBankAccountType)type
{
    bankCancelTag = -1;
    [self didPadSettingWithType:kPadSettingViewPayAccount];
}

- (void)pleaseInstallVePos
{
    if ( bankCancelTag >= 0 && self.payments.count > bankCancelTag)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您没有安装手机POS专家 确定要直接取消吗" delegate:self cancelButtonTitle:LS(@"PadDeletePaymentCancel") otherButtonTitles:LS(@"PadDeletePaymentConfirm"), nil];
        alertView.tag = bankCancelTag;
        bankCancelTag = -1;
        [alertView show];
    }
}

- (void)tradeSuccess:(NSString*)bankNo
{
    if ( bankCancelTag >= 0 && self.payments.count > bankCancelTag)
    {
        NSDictionary *dict = [self.payments objectAtIndex:bankCancelTag];
        [self.payments removeObject:dict];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bankCancelTag inSection:kPadPaymentSectionPayment];
        bankCancelTag = -1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.paymentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        });
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"单据撤销成功"
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)tradeFailed:(NSString *)errorMesage
{
    bankCancelTag = -1;
    
    [self didPadCashRegisterFailed:errorMesage];
}

- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result;
{
    self.outNavigationController.navigationBarHidden = YES;
    if ( result.length > 0 )
    {
        self.alipayParams[@"auth_code"] = result;
        [self doAlipayRequest:viewController.paymode];
    }
}

- (void)didScanCodeViewControllerBack
{
    self.outNavigationController.navigationBarHidden = YES;
}

- (BOOL)isMultiKeshi
{
    if ([[PersonalProfile currentProfile].multiKeshiSetting intValue] == 0)
    {
        return [PersonalProfile currentProfile].is_multi_department;
    } 
    else if ([[PersonalProfile currentProfile].multiKeshiSetting intValue] == 1)
    {
        return NO;
    }
    else if ([[PersonalProfile currentProfile].multiKeshiSetting intValue] == 2)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end

