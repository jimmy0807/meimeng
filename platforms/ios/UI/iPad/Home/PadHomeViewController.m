//
//  PadHomeViewController.m
//  BornPOS
//
//  Created by XiaXianBing on 15/10/8.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadHomeViewController.h"
#import "PadProjectViewController.h"
#import "PadSettingViewController.h"
#import "PadMemberAndCardViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HomeHeadTabView.h"
#import "PadPosViewController.h"
#import "PadPosLeftViewController.h"
#import "UIView+Frame.h"
#import "HomeCurrentPosTableViewCell.h"
#import "BSFetchPosOperateRequest.h"
#import "HomeHistoryMonthTableViewCell.h"
#import "HomeHistoryPosTableViewCell.h"
#import "PadPosViewController.h"
#import "BSFetchPosMonthIncomeRequest.h"
#import "BSProjectRequest.h"
#import "CBLoadingView.h"
#import "BSOrderRequest.h"
#import "BSPadDataRequest.h"
#import "PadBookMainViewController.h"
#import "PadLoginViewController.h"
#import "UINavigationBar+Background.h"
#import "HomeAddOperateMaskView.h"
#import "CBMessageView.h"
#import "PadGiveViewController.h"
#import "PadRestaurantViewController.h"
#import "PersonalProfile.h"
#import "HistoryPosViewController.h"
#import "PadWebViewController.h"
#import "NSData+Additions.h"
#import "HomeReserveTableViewCell.h"
#import "BSFetchBookRequest.h"
#import "HomeMemberSearchTableViewCell.h"
#import "HomeMemberListTableViewCell.h"
#import "BSFetchMemberCardRequest.h"
#import "BSFetchMemberRequest.h"
#import "PopupBuyExtensionService.h"
#import "PadPaymentViewController.h"
#import "PadCardOperateViewController.h"
#import "PadMemberAndCardViewController.h"
#import "PadTextInputViewController.h"
#import "BSHandleBookRequest.h"
#import "GivePopupSelectWXGiveType.h"
#import "BSFetchPosOperateRequest.h"
#import "HomeYimeiWashTableViewCell.h"
#import "YimeiPosOperateDetailViewController.h"
#import "PadHospitalMainViewController.h"
#import "MainViewController.h"
//#import "meim-Swift.h"
#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif
#import "BSFetchMemberDetailRequest.h"
#import "FetchAllWorkFlowActivity.h"
#import "FetchWashHandRequest.h"
#import "FetchCheckoutListRequest.h"
#import "BSFetchOperateRequest.h"
#import "DeleteGuadanRequest.h"
#import "FetchWashHandRequest.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <ACSBluetooth/ACSBluetooth.h>
#import "ABDHex.h"
#import "BSUserDefaultsManager.h"
#import "TempManager.h"

typedef enum HomeTableviewSection
{
    HomeTableviewSection_Head,
    HomeTableviewSection_Content,
    HomeTableviewSection_Count
}HomeTableviewSection;

@interface PadHomeViewController ()<HomeHeadTabViewDelegate, HomeCurrentPosTableViewCellDelegate, HomeReserveTableViewCellDelegate,PadProjectViewControllerDelegate,HomeAddOperateMaskViewDelegate, HomeMemberSearchTableViewCellDelegate,HomeMemberListTableViewCellDelegate,PadTextInputViewControllerDelegate,HomeYimeiWashTableViewCellDelegate,ABTBluetoothReaderManagerDelegate, ABTBluetoothReaderDelegate,CBCentralManagerDelegate>
{
    int moveDirection;
    CGFloat lastPosY;
    NSInteger currentSelectedReserveIndex;
    NSInteger currentSelectedMemberCardIndex;
    BOOL showHistoryToLocalAnimation;
    BOOL bFetchWashHandRequestFinished;
    
    CBCentralManager *_centralManager;
    CBPeripheral *_peripheral;
    ABTBluetoothReader *_bluetoothReader;
    ABTBluetoothReaderManager *_bluetoothReaderManager;
    NSData *_commandApdu;
    NSData *_masterKey;
    NSData *_escapeCommand;
}

@property(nonatomic, weak)IBOutlet UITableView* homeTableView;
@property(nonatomic, strong)HomeHeadTabView* headTabView;
@property(nonatomic, strong)IBOutlet UIButton* homeMenuButton;
@property(nonatomic, weak)IBOutlet UIView* rightContinueView;
@property(nonatomic, strong)NSArray* localPosOperateArray;
@property(nonatomic, strong)NSMutableArray* guadanArray;
@property(nonatomic, strong)NSArray* reserveArray;
@property(nonatomic, strong)NSArray* memberCardArray;
@property(nonatomic, strong)NSArray* yimeiPosOperateArray;
@property(nonatomic, strong)NSMutableDictionary* imageCacheDictionary;
@property(nonatomic, strong)NSMutableDictionary* historyDateDictionary;
@property(nonatomic, strong)CDPosOperate* projectOperate;
@property(nonatomic, strong)UILabel* loadingProgressLabel;
@property(nonatomic, strong)UIView* loadingProgressView;
@property(nonatomic, strong)UIButton* loadingMaskButton;
@property(nonatomic, strong)HomeAddOperateMaskView* addOperateMaskView;
@property(nonatomic, strong)NSNumber *popOperateID;
@property(nonatomic, assign)BOOL isPopGiveCard;
@property(nonatomic)BOOL shouldJumpToHistory;
@property(nonatomic)int jumpToHistoryIndex;
@property(nonatomic)BOOL isSubDetail;
@property(nonatomic)int subDetailIndex;
@property(nonatomic, strong)CBRotateNavigationController *restaurantNavi;
@property(nonatomic, strong)NSMutableArray *memberCardIDs;
@property(nonatomic, strong)NSString* searchMemberCardKeyword;
@property(nonatomic, strong)PadMaskView *maskView;
@property(nonatomic, weak)IBOutlet UIImageView* blueBgImageView;

@end

@implementation PadHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self forbidSwipGesture];
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _bluetoothReaderManager = [[ABTBluetoothReaderManager alloc] init];
    _bluetoothReaderManager.delegate = self;
    _commandApdu = [ABDHex byteArrayFromHexString:@"FF CA 00 00 00"];
    _escapeCommand = [ABDHex byteArrayFromHexString:@"E0 00 00 48 04"];

    
    bFetchWashHandRequestFinished = TRUE;
    
    currentSelectedReserveIndex = -1;
    currentSelectedMemberCardIndex = -1;
    self.imageCacheDictionary = [NSMutableDictionary dictionary];
    self.shouldJumpToHistory = NO;
    self.headTabView = [[[NSBundle mainBundle] loadNibNamed:@"HomeHeadTabView" owner:self options:nil] objectAtIndex:0];
    self.headTabView.isShouyintai = self.isShouyintai;
    self.headTabView.delegate = self;
    
    [self.homeTableView registerNib:[UINib nibWithNibName: @"HomeCurrentPosTableViewCell" bundle: nil] forCellReuseIdentifier:@"HomeCurrentPosTableViewCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName: @"HomeReserveTableViewCell" bundle: nil] forCellReuseIdentifier:@"HomeReserveTableViewCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName: @"HomeHistoryMonthTableViewCell" bundle: nil] forCellReuseIdentifier:@"HomeHistoryMonthTableViewCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName: @"HomeHistoryPosTableViewCell" bundle: nil] forCellReuseIdentifier:@"HomeHistoryPosTableViewCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName: @"HomeMemberSearchTableViewCell" bundle: nil] forCellReuseIdentifier:@"HomeMemberSearchTableViewCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName: @"HomeMemberListTableViewCell" bundle: nil] forCellReuseIdentifier:@"HomeMemberListTableViewCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName: @"HomeYimeiWashTableViewCell" bundle: nil] forCellReuseIdentifier:@"HomeYimeiWashTableViewCell"];
    if ( self.maskView == nil )
    {
        self.maskView = [[PadMaskView alloc] init];
        [self.view addSubview:self.maskView];
    }
    self.addOperateMaskView = (HomeAddOperateMaskView*)[UIView loadNibNamed:@"HomeAddOperateMaskView"];
    self.addOperateMaskView.delegate = self;
    [self.view addSubview:self.addOperateMaskView];
    
    [self reloadPadPosCashierView];
    
    [self setTableViewHeadView];
    [self fetchLocalPosOperates];
    
    [self registerNofitificationForMainThread:kBSFetchStartInfoResponse];
    [self registerNofitificationForMainThread:kFetchPosCardOperateResponse];
    [self registerNofitificationForMainThread:kFetchPosMonthIncomeResponse];
    [self registerNofitificationForMainThread:kBSOrderRequestSuccess];
    //[self registerNofitificationForMainThread:kBSPadDataRequestSuccess];
    //[self registerNofitificationForMainThread:kBSPadDataRequestFailed];
    //[self registerNofitificationForMainThread:kBSPadDataRequestFinishCount];
    [self registerNofitificationForMainThread:kPadMenuOrderBoardcast];
    //[self registerNofitificationForMainThread:kPadAccountLogoutResponse];
    [self registerNofitificationForMainThread:kPadAccountChangeResponse];
    [self registerNofitificationForMainThread:kBSLoginResponse];
    [self registerNofitificationForMainThread:kBSPadCashierSuccess];
    [self registerNofitificationForMainThread:kBSPadAllotPerformance];
    [self registerNofitificationForMainThread:kBSPadGiveGiftCard];
    [self registerNofitificationForMainThread:kFetchBookResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardDetailResponse];
    //[self registerNofitificationForMainThread:kPadSelectMemberAndCardFinish];
    [self registerNofitificationForMainThread:kBSEditBookResponse];
    [self registerNofitificationForMainThread:kBSCreateBookResponse];
    [self registerNofitificationForMainThread:kRefreshPadHome];
    [self registerNofitificationForMainThread:kFetchWashHandResponse];
    [self reloadHeadTabView];
}

- (void)setTableViewHeadView
{
#if 0
    UIView* v = [self.view viewWithTag:9876];
    [v removeFromSuperview];
    
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 75)];
    v.tag = 9876;
    v.backgroundColor = [UIColor whiteColor];
    
    self.loadingProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, 72, 0, 3)];
    self.loadingProgressView.backgroundColor = COLOR(250, 197, 24, 1);
    [v addSubview:self.loadingProgressView];
    
    self.loadingProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, IC_SCREEN_WIDTH, 30)];
    self.loadingProgressLabel.textColor = [UIColor blackColor];
    self.loadingProgressLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingProgressLabel.text = [NSString stringWithFormat:@"正在加载数据  %d%%",0];
    [v addSubview:self.loadingProgressLabel];
    
    if ( self.loadingMaskButton )
    {
        [self.loadingMaskButton removeFromSuperview];
    }
    self.loadingMaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loadingMaskButton.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    [self.view addSubview:self.loadingMaskButton];
    
    self.homeMenuButton.alpha = 0;

    if ([PersonalProfile.currentProfile.isTable boolValue])
    {
        [self.view addSubview:v];
        self.homeTableView.alpha = 0;
        
        CGRect frame = self.restaurantNavi.view.frame;
        frame.origin.y = 75;
        self.restaurantNavi.view.frame = frame;
        
        v.backgroundColor = COLOR(90, 211, 213, 1);
        self.loadingProgressLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.homeTableView.alpha = 1;
        self.homeTableView.tableHeaderView = v;
        self.homeTableView.contentOffset = CGPointMake(0, 0);
    }
#endif
}

- (void)reloadHeadTabView
{
    //[self registerNofitificationForMainThread:kBSFetchWorkFlowActivityResponse];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    [self.headTabView reloadCreateButton];
    if ( [profile.isYiMei boolValue] )
    {
        //if ( profile.roleOption != 1 && profile.roleOption != 2 && profile.roleOption != 4 )
        {
            for ( NSNumber* workID in profile.yimeiWorkFlowArray )
            {
                if ( bFetchWashHandRequestFinished )
                {
                    FetchWashHandRequest* request = [[FetchWashHandRequest alloc] init];
                    request.workID = workID;
                    request.bFetchDone = self.headTabView.isDoneSelected;
                    [request execute];
                    bFetchWashHandRequestFinished = FALSE;
                    [[CBLoadingView shareLoadingView] show];
                }
                
                self.headTabView.currentWorkID = workID;
                
                [self.headTabView setYimeiTitleLabelText:profile.yimeiWorkFlowName];
#if 0
                CDWorkFlowActivity *a = [[BSCoreDataManager currentManager] findEntity:@"CDWorkFlowActivity" withValue:workID forKey:@"workID"];
                
                if ( a )
                {
                    title = [NSString stringWithFormat:@"%@",a.name];
                    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kBSFetchWorkFlowActivityResponse object:nil];
                }
                else
                {
                    title = @"";
                }
                
                
                
                break;
#endif
            }
        }
    }
    else
    {
        self.headTabView.yimeiBackgroundView.hidden = YES;
    }
}

- (void)setTableViewHeadViewProgress:(CGFloat)progress
{
#if 0
    CALayer* layer = self.loadingProgressView.layer.presentationLayer;
    
    if ( layer == nil )
        return;
    
    self.loadingProgressView.frame = layer.frame;
    [self.loadingProgressView.layer removeAllAnimations];
    
    self.loadingProgressLabel.text = [NSString stringWithFormat:@"正在加载数据  %d%%",(NSInteger)(progress * 100)];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.loadingProgressView.frame;
        frame.size.width = progress * self.view.frame.size.width;
        self.loadingProgressView.frame = frame;
    }];
#endif
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchStartInfoResponse])
    {
        bFetchWashHandRequestFinished = TRUE;
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if (result == 0)
        {
            [self reloadPadPosCashierView];
            [self setTableViewHeadView];
            [self reloadHeadTabView];
        }
    }
    else if ([notification.name isEqualToString:kFetchPosCardOperateResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            [self fetchLocalPosOperates];
            [self reloadTableView];
            
        }
        if(self.shouldJumpToHistory)
        {
            self.shouldJumpToHistory = NO;
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"YimeiHistoryStoryboard" bundle:nil];
            YimeiHistoryDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"history_detail"];
            NSArray *historyList = [[BSCoreDataManager currentManager] fetchYimeiHistoryByKeyword:nil];
            for(CDYimeiHistory *history in historyList)
            {
                if(self.isSubDetail)
                {
                    if(history.operate_id.intValue == [[[[self.guadanArray[self.jumpToHistoryIndex] objectForKey:@"details"] objectAtIndex:self.subDetailIndex] objectForKey:@"id"] intValue])
                    {
                        vc.history = history;
                        break;
                    }
                }
                else{
                    if(history.operate_id.intValue == [[self.guadanArray[self.jumpToHistoryIndex] objectForKey:@"id"] intValue])
                    {
                        vc.history = history;
                        break;
                    }
                }
            }
            if (vc.history)
            {
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {

                
                //[self.navigationController pushViewController:vc animated:YES];
            }

//            CDPosOperate *op = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:[self.guadanArray[self.jumpToHistoryIndex] objectForKey:@"id"] forKey:@"operate_id"];
//            PadPosViewController *posViewController = [[PadPosViewController alloc] init];
//            posViewController.operate = op;
//            [self.navigationController pushViewController:posViewController animated:YES];
        }
    }
    else if ([notification.name isEqualToString:kFetchPosMonthIncomeResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            [self fetchHistoryPosOperates];
            [self reloadTableView];
        }
    }
    else if ([notification.name isEqualToString:kBSPadDataRequestSuccess] || [notification.name isEqualToString:kBSPadDataRequestFailed])
    {
        if ( [PersonalProfile.currentProfile.isTable boolValue] )
        {
            [self.loadingMaskButton removeFromSuperview];
            self.loadingMaskButton = nil;
            
            CGRect frame = self.restaurantNavi.view.frame;
            frame.origin.y = 0;
            
            [UIView animateWithDuration:0.5 animations:^{
                UIView* v = [self.view viewWithTag:9876];
                CGRect f = v.frame;
                f.origin.y = 0 - f.size.height;
                v.frame = f;
                self.restaurantNavi.view.frame = frame;
            } completion:^(BOOL finished) {
                UIView* v = [self.view viewWithTag:9876];
                [v removeFromSuperview];
            }];
        }
        else
        {
            if ( self.homeTableView.tableHeaderView )
            {
                [self.loadingMaskButton removeFromSuperview];
                self.loadingMaskButton = nil;
                
                [self.homeTableView setContentOffset:CGPointMake(0, 75) animated:YES];
                [UIView animateWithDuration:0.3 animations:^{
                    self.homeMenuButton.alpha = 1;
                }];
            }
            
            [self fetchLocalPosOperates];
            if ( self.headTabView.currentHeadTab == HomeHeadTabView_Local && self.homeTableView.tableHeaderView == nil)
            {
                [self reloadTableView];
            }
            else if ( self.headTabView.currentHeadTab == HomeHeadTabView_History )
            {
                ;
            }
        }
    }
    else if ([notification.name isEqualToString:kBSPadDataRequestFinishCount])
    {
        NSDictionary *params = notification.userInfo;
        [self setTableViewHeadViewProgress:[[params objectForKey:@"finish_count"] floatValue] / [[params objectForKey:@"total_count"] integerValue]];
    }
    else if ([notification.name isEqualToString:kPadMenuOrderBoardcast])
    {
        [[BSOrderRequest sharedInstance] startOrderRequest];
    }
    else if ([notification.name isEqualToString:kBSOrderRequestSuccess])
    {
        [self fetchLocalPosOperates];
        if ( self.headTabView.currentHeadTab == HomeHeadTabView_Local )
        {
            [self reloadTableView];
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_History )
        {
            ;
        }
    }
    else if ([notification.name isEqualToString:kPadAccountLogoutResponse] || [notification.name isEqualToString:kPadAccountChangeResponse])
    {
        
    }
    else if ([notification.name isEqualToString:kBSLoginResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            [self reloadPadPosCashierView];
            [self setTableViewHeadView];
            
            [self reloadHeadTabView];
            
            PadSideBarViewController *sideBarViewController = (PadSideBarViewController *)self.mm_drawerController.leftDrawerViewController;
            [sideBarViewController reloadData];
        }
    }
    else if ( [notification.name isEqualToString:kBSPadCashierSuccess] )
    {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    else if ([notification.name isEqualToString:kBSPadAllotPerformance] ||[notification.name isEqualToString:kBSPadGiveGiftCard])
    {
        self.popOperateID = notification.object;
//        [self fetchHistoryPosOperatesFromServer];
        self.isPopGiveCard = false;
        if ([notification.name isEqualToString:kBSPadGiveGiftCard])
        {
            self.isPopGiveCard = true;
        }
        
        if (self.popOperateID) {
//            CDPosOperate* op = nil;
//            BSFetchPosOperateRequest* request = [[BSFetchPosOperateRequest alloc] init];
//            request.type = @"day";
//            [request execute];
            
            if (self.isPopGiveCard) {
                CDMember *member = [notification.userInfo objectForKey:@"member"];
                if ([member.isDefaultCustomer integerValue] == 1) {
//                    [[[CBMessageView alloc] initWithTitle:@"客户还不是会员，无法进行赠送"] show];
//                    return;
                }
//                PadGiveViewController *padGiveVC = [[PadGiveViewController alloc] initWithNibName:@"PadGiveViewController" bundle:nil];
//                padGiveVC.member = member;
//                padGiveVC.operateID = self.popOperateID;
//                [self.navigationController pushViewController:padGiveVC animated:YES];
            }
            else
            {
//                PadPosViewController *posViewController = [[PadPosViewController alloc] init];
//                posViewController.operateID = self.popOperateID;
//                [self.navigationController pushViewController:posViewController animated:YES];
            }
            self.popOperateID = nil;
        }
        
    }
    else if ([notification.name isEqualToString:kFetchBookResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.reserveArray = [[BSCoreDataManager currentManager] fetchHomeTodayBooks];
            [self reloadTableView];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberResponse])
    {
        if ( self.memberCardIDs == nil )
            return;
        
        NSArray* members = notification.object;
        
        for ( CDMember* member in members )
        {
            if ( [member.isDefaultCustomer boolValue] == NO )
            {
                for ( CDMemberCard* card in member.card )
                {
                    [self.memberCardIDs addObject:card.cardID];
                }
                
                BSFetchMemberDetailRequest *detailRequest = [[BSFetchMemberDetailRequest alloc] initWithMember:member];
                [detailRequest execute];
            }
        }
    
        BSFetchMemberCardRequest* request = [[BSFetchMemberCardRequest alloc] initWithMemberCardIds:self.memberCardIDs keyword:self.searchMemberCardKeyword];
        [request execute];
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardResponse])
    {
        if ( self.memberCardIDs )
        {
            [[CBLoadingView shareLoadingView] hide];
        }
        
        if ( self.memberCardIDs )
        {
            self.memberCardArray = [[BSCoreDataManager currentManager] fetchMemberCardWithIDs:self.memberCardIDs];
            if ( self.memberCardArray.count == 0 )
            {
                CBMessageView* v = [[CBMessageView alloc] initWithTitle:@"没有搜索结果"];
                [v show];
            }
            [self reloadTableView];
        }
        
        self.memberCardIDs = nil;
        self.searchMemberCardKeyword = nil;
    }
    else if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        if (self.headTabView.currentHeadTab == HomeHeadTabView_Guadan)
        {
            [self didHomeHeadTabViewGuadanPosButtonPressed];
        }
        else if (self.maskView)
        {
            [[CBLoadingView shareLoadingView] hide];
            if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
            {
                [self.maskView hidden];
                self.maskView = nil;
            }
        }
        
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardDetailResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self reloadTableView];
//            self.member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.member.memberID forKey:@"memberID"];
//            NSMutableArray *cards = [NSMutableArray array];
//            for (CDMemberCard *card in self.member.card.array)
//            {
//                if (card.isActive.boolValue)
//                {
//                    [cards addObject:card];
//                }
//            }
//            self.memberCards = [NSArray arrayWithArray:cards];
//            if (!self.memberCard.isActive.boolValue)
//            {
//                self.memberCard = nil;
//                [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberCardFinish object:self.memberCard userInfo:nil];
//            }
//            self.couponCards = self.member.coupons.array;
//            [self.cardTableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kPadSelectMemberAndCardFinish])
    {
#if 0
        NSNumber *toOrder = (NSNumber *)notification.object;
        if (toOrder.boolValue)
        {
            PadSideBarViewController *sideBarViewController = (PadSideBarViewController *)self.mm_drawerController.leftDrawerViewController;
            [sideBarViewController setPadSideBarType:kPadSideBarTypePos];
            
            CDMemberCard *memberCard = (CDMemberCard *)[notification.userInfo objectForKey:@"card"];
            CDCouponCard *couponCard = (CDCouponCard *)[notification.userInfo objectForKey:@"coupon"];
            
            [self.navigationController popToRootViewControllerAnimated:FALSE];
            [self addPosOperate:memberCard couponCard:couponCard];
        }
#endif
    }
    else if ([notification.name isEqualToString:kBSEditBookResponse] || [notification.name isEqualToString:kBSCreateBookResponse])
    {
        self.reserveArray = [[BSCoreDataManager currentManager] fetchHomeTodayBooks];
        [self reloadTableView];
    }
    else if ( [notification.name isEqualToString:kRefreshPadHome] )
    {
        [self reloadHeadTabView];
    }
    else if ( [notification.name isEqualToString:kBSFetchWorkFlowActivityResponse] )
    {
        //[self reloadHeadTabView];
    }
    else if ( [notification.name isEqualToString:kBSFetchPrinterScannerResponse] )
    {
        NSString* result = notification.userInfo[@"result"];
        CDMemberCard* card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:result forKey:@"cardNo"];
        if ( card )
        {
            PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:card couponCard:nil handno:@""];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            CDCouponCard* couponCard = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCard" withValue:result forKey:@"cardNumber"];
            if ( couponCard )
            {
                PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:nil couponCard:couponCard handno:@""];
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
    else if ( [notification.name isEqualToString:kFetchWashHandResponse] )
    {
        [[CBLoadingView shareLoadingView] hide];
        bFetchWashHandRequestFinished = TRUE;
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            [self fetchLocalPosOperates];
            [self reloadTableView];
        }
    }
    else if ( [notification.name isEqualToString:@"GuadanFetchResponse"] )
    {
        [[CBLoadingView shareLoadingView] hide];
        self.guadanArray = [[NSMutableArray alloc] init];
        NSArray *originArray = [notification.userInfo valueForKey:@"data"];
        for (NSDictionary *dict in originArray)
        {
            NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [newDict setObject:@(FALSE) forKey:@"isExpand"];
            [self.guadanArray addObject:newDict];
        }
        NSMutableArray *operateIds = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.guadanArray)
        {
            [operateIds addObject:[dict objectForKey:@"id"]];
        }
        BSFetchOperateRequest *request3 = [[BSFetchOperateRequest alloc] initWithOperateIds:operateIds];
        [request3 execute];
        NSLog(@"%@",self.guadanArray);
        [self reloadTableView];
    }
    else if ( [notification.name isEqualToString:@"GuadanDeleteResponse"] )
    {
        [self didHomeHeadTabViewGuadanPosButtonPressed];
    }
    else if ( [notification.name isEqualToString:kEditWashHandResponse] )
    {
        PersonalProfile *profile = [PersonalProfile currentProfile];
        for ( NSNumber* workID in profile.yimeiWorkFlowArray )
        {
            if ( bFetchWashHandRequestFinished )
            {
                FetchWashHandRequest* request = [[FetchWashHandRequest alloc] init];
                request.workID = workID;
                request.bFetchDone = self.headTabView.isDoneSelected;
                [request execute];
                bFetchWashHandRequestFinished = FALSE;
                [[CBLoadingView shareLoadingView] show];
            }
        }
        [self fetchLocalPosOperates];
        [self reloadTableView];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberResponse];
    [self registerNofitificationForMainThread:kBSFetchPrinterScannerResponse];
    [self registerNofitificationForMainThread:@"GuadanFetchResponse"];
    [self registerNofitificationForMainThread:@"GuadanDeleteResponse"];
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    [self registerNofitificationForMainThread:kEditWashHandResponse];

    [self fetchLocalPosOperates];
    [self fetchHistoryPosOperates];
    [self reloadTableView];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [super viewWillAppear:animated];
    
    if ( showHistoryToLocalAnimation )
    {
        showHistoryToLocalAnimation = FALSE;
        [self.headTabView doAnimationFromHistoryToLocal];
    }
    if (self.headTabView.currentHeadTab == HomeHeadTabView_Guadan)
    {
        [self didHomeHeadTabViewGuadanPosButtonPressed];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBSFetchMemberCardResponse object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBSFetchMemberResponse object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBSFetchPrinterScannerResponse object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GuadanFetchResponse" object:nil];
    [self removeNotificationOnMainThread:kBSMemberCardOperateResponse];
    [self removeNotificationOnMainThread:kBSCreateBookResponse];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self stopScanPos];

    if ( _peripheral != nil )
    {
        [_centralManager cancelPeripheralConnection:_peripheral];
        _peripheral = nil;
    }
    
    [super viewWillDisappear:animated];

}

- (void)didPadProjectViewControllerMenuButtonPressed:(CDPosOperate*)operate
{
    self.projectOperate = operate;
    if ( operate )
    {
        self.rightContinueView.hidden = YES;
    }
    else
    {
        self.rightContinueView.hidden = YES;
    }
}

- (void)reloadPadPosCashierView
{
    if ([PersonalProfile.currentProfile.isTable boolValue])
    {
        if (self.restaurantNavi == nil)
        {
            PadRestaurantViewController *restaurant = [[PadRestaurantViewController alloc] initWithDelegate:self];
            self.restaurantNavi = [[CBRotateNavigationController alloc] initWithRootViewController:restaurant];
            [self.restaurantNavi setNavigationBarHidden:YES animated:NO];
            [self.view addSubview:self.restaurantNavi.view];
        }
        self.restaurantNavi.view.alpha = 1.0;
    }
    else
    {
        if (self.restaurantNavi != nil && self.restaurantNavi.view.alpha != 0.0)
        {
            self.restaurantNavi.view.alpha = 0.0;
        }
    }
}

- (IBAction)didContinuePosButtonPressed:(id)sender
{
    PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithPosOperate:self.projectOperate];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark PadSideBarViewControllerDelegate Methods

- (void)didPadSideBarItemSelected:(NSInteger)type
{
    if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 11 && [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        if (type != kPadSideBarTypeSetting && type != kPadSideBarTypePos )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"您没有权限" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            
            return;
        }
    }
    
    if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 && [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        if (type == kPadSidebarTypeHistory || type == kPadSideBarTypeStatistic )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"您没有权限" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    
    if (type == kPadSideBarTypePos)
    {
        [self reloadPadPosCashierView];
    }
    else if (type == kPadSideBarTypeMember)
    {
        PadMemberAndCardViewController *viewController = [[PadMemberAndCardViewController alloc] initWithViewType:kPadMemberAndCardDefault];
        viewController.rootNaviationVC = self.navigationController;
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else if (type == kPadSidebarTypeHistory)
    {
        HistoryPosViewController *viewController = [[HistoryPosViewController alloc] initWithNibName:@"HistoryPosViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else if (type == kPadSideBarTypeReserve)
    {
        PersonalProfile* profile = [PersonalProfile currentProfile];
        if ( [profile.isBook boolValue] )
        {
            PadBookMainViewController *viewController = [[PadBookMainViewController alloc] initWithNibName:@"PadBookMainViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:NO];
        }
        else
        {
            [PopupBuyExtensionService showWithNavigationController:self.navigationController url:@"http://www.wevip.com"];
        }
        
    }
    else if (type == kPadSideBarTypeStatistic)
    {
        PersonalProfile* profile = [PersonalProfile currentProfile];
//        NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@",profile.userName,profile.password];
//        NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",profile.userName,profile.password];
//        
//        NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[profile token]];
//        
//        NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
//        NSString* sign = [userData md5Hash];
//        
//        PadWebViewController* webViewController = [[PadWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/dashboard#/cashier?db=%@&%@&sign=%@&client_id=%@",profile.baseUrl,profile.sql,sendParams,sign,[profile deviceString]]];
//        webViewController.disableBounces = YES;
//        webViewController.hideNavigation = YES;
//        
//        [self.navigationController pushViewController:webViewController animated:NO];
        NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=dashboard",profile.userName,profile.password];
        NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",profile.userName,profile.password];
        
        NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[profile token]];
        
        NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
        NSString* sign = [userData md5Hash];
        
        PadWebViewController* webViewController = [[PadWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",profile.baseUrl,profile.sql,sendParams,sign,[profile deviceString]]];
        webViewController.disableBounces = YES;
        webViewController.hideNavigation = YES;
        [self.navigationController pushViewController:webViewController animated:NO];
    }
    else if (type == kPadSideBarTypeSetting)
    {
        PadSettingViewController *viewController = [[PadSettingViewController alloc] initWithViewType:kPadSettingViewDefault];
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else if (type == kPadSideBarTypeHospital)
    {
#if 0
        PadHospitalMainViewController* vc = [[PadHospitalMainViewController alloc] initWithNibName:@"PadHospitalMainViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
#else
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"QianTaiFenzhen" bundle:nil];
        QianTaiFenzhenMainViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        
        CBRotateNavigationController *naviController = nil;
        
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
        [naviController setNavigationBarHidden:YES animated:NO];

        
        self.mm_drawerController.centerViewController = naviController;
#endif
    }
}

- (BOOL)isRootViewController
{
    return self.navigationController.topViewController == self;
}

#pragma mark -
#pragma mark PadRestaurantViewControllerDelegate Methods

- (void)didBackPadSideBar
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HomeTableviewSection_Count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == HomeTableviewSection_Head )
    {
        return 1;
    }
    else if ( section == HomeTableviewSection_Content )
    {
        if ( !self.headTabView.yimeiBackgroundView.hidden )
        {
            NSLog(@"%@",self.yimeiPosOperateArray);
            return self.yimeiPosOperateArray.count;
        }
        else
        {
            if ( self.headTabView.currentHeadTab == HomeHeadTabView_Local )
            {
                return self.localPosOperateArray.count;
            }
            else if ( self.headTabView.currentHeadTab == HomeHeadTabView_History )
            {
                return self.reserveArray.count;
            }
            else if ( self.headTabView.currentHeadTab == HomeHeadTabView_MemberCard )
            {
                return self.memberCardArray.count + 1;
            }
            else if (self.headTabView.currentHeadTab == HomeHeadTabView_Guadan)
            {
                return self.guadanArray.count;
            }
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    if ( indexPath.section == HomeTableviewSection_Head )
    {
        return [self tableView:tableView cellForHomeTableviewSectionHead:indexPath];
    }
    else if ( indexPath.section == HomeTableviewSection_Content )
    {
        return [self tableView:tableView cellForHomeTableviewSectionContent:indexPath];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForHomeTableviewSectionHead:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableviewSection_Head"];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTableviewSection_Head"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = COLOR(82, 203, 201, 1);
        UIImageView* v = [[UIImageView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - 115)/2, 35, 115, 105)];
        v.image = [UIImage imageNamed:@"pad_login_pos_normal"];
        v.layer.anchorPoint = CGPointMake(0.5, 0.5);
        v.tag = 101;
        [cell.contentView addSubview:v];
    }
    
    if ( tableView.contentOffset.y == 0 )
    {
        UIImageView* v = (UIImageView*)[cell viewWithTag:101];
        v.transform = CGAffineTransformMakeScale(1, 1);
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForHomeTableviewSectionContent:(NSIndexPath *)indexPath
{
    if ( !self.headTabView.yimeiBackgroundView.hidden )
    {
        HomeYimeiWashTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeYimeiWashTableViewCell"];
        cell.delegate = self;
        CDPosWashHand* op = self.yimeiPosOperateArray[indexPath.row];
        [cell setPosOperate:op indexPath:indexPath];
        
        cell.isCurrentPos = FALSE;
        
        return cell;
    }
    else
    {
        if ( self.headTabView.currentHeadTab == HomeHeadTabView_Local )
        {
            HomeCurrentPosTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCurrentPosTableViewCell"];
            cell.delegate = self;
            
            CDPosOperate* op = self.localPosOperateArray[indexPath.row];
            [cell setPosOperate:op indexPath:indexPath];
            cell.isCurrentPos = ( op == self.projectOperate ? YES : NO );
            
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:op.member.image_url] placeholderImage:[UIImage imageNamed:@"pad_avatar_default"]];
            
            //        cell.currentPosLabel.hidden = YES;
            //
            //        if ( indexPath.row + 1 < self.localPosOperateArray.count )
            //        {
            //            CDPosOperate* op = self.localPosOperateArray[indexPath.row + 1];
            //            if ( op == self.projectOperate )
            //            {
            //                cell.currentPosLabel.hidden = NO;
            //            }
            //        }
            
            return cell;
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_Guadan )
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(150.0, 0.0, 725.0, 76.0)];
            topView.tag = 3000 + indexPath.row;
            topView.backgroundColor = [UIColor whiteColor];
            UISwipeGestureRecognizer* recognizer;
            recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
            recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
            //[topView addGestureRecognizer:recognizer];
            UISwipeGestureRecognizer* recognizerRight;
            recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
            recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
            //[topView addGestureRecognizer:recognizerRight];
            
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(650.0, 0.0, 75.0, 76.0)];
            [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            deleteButton.backgroundColor = COLOR(249, 86, 86, 1);
            deleteButton.tag = 2000 + indexPath.row;
            [deleteButton addTarget:self action:@selector(deleteGuadan:) forControlEvents:UIControlEventTouchUpInside];
            [topView addSubview:deleteButton];

            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(25.0, 13.0, 50.0, 50.0)];
            [photoView sd_setImageWithURL:[NSURL URLWithString:[self.guadanArray[indexPath.row] objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"pad_avatar_default"]];
            [topView addSubview:photoView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 16.0, 200.0, 18.0)];
            nameLabel.text = [self.guadanArray[indexPath.row] objectForKey:@"member_name"];
            nameLabel.font = [UIFont systemFontOfSize:16.0];
            nameLabel.textColor = COLOR(37, 37, 37, 1);
            [topView addSubview:nameLabel];
            
            UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 45.0, 200.0, 18.0)];
            orderLabel.text = [self.guadanArray[indexPath.row] objectForKey:@"name"];
            orderLabel.font = [UIFont systemFontOfSize:16.0];
            orderLabel.textColor = COLOR(37, 37, 37, 1);
            [topView addSubview:orderLabel];
            
            UIImageView *clockView = [[UIImageView alloc] initWithFrame:CGRectMake(420.0, 17.0, 16.0, 16.0)];
            clockView.image = [UIImage imageNamed:@"pad_time_icon"];
            [topView addSubview:clockView];
            
            NSLog(@"%@",[self.guadanArray[indexPath.row] objectForKey:@"create_date"]);
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(440.0, 16.0, 100.0, 18.0)];
            NSRange timeRange = NSMakeRange(5, 11);
            timeLabel.text = [[self.guadanArray[indexPath.row] objectForKey:@"create_date"] substringWithRange:timeRange];
            timeLabel.font = [UIFont systemFontOfSize:14.0];
            timeLabel.textColor = COLOR(153, 153, 153, 1);
            [topView addSubview:timeLabel];
            
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(420.0, 45.0, 200.0, 18.0)];
            statusLabel.font = [UIFont systemFontOfSize:14.0];
            NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] init];
            NSAttributedString *keshi = [[NSAttributedString alloc] initWithString:[self.guadanArray[indexPath.row] objectForKey:@"departments_name"] attributes:@{NSForegroundColorAttributeName:COLOR(153.0, 153.0, 153.0, 1.0)}];
            [statusString appendAttributedString:keshi];
            NSAttributedString *progress = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)",[self.guadanArray[indexPath.row] objectForKey:@"activity"]]  attributes:@{NSForegroundColorAttributeName:COLOR(96.0, 211.0, 212.0, 1.0)}];
            [statusString appendAttributedString:progress];
            statusLabel.attributedText = statusString;
            [topView addSubview:statusLabel];
            
            UIButton *rightColorView = [[UIButton alloc] initWithFrame:CGRectMake(597.0, 0.0, 128.0, 76.0)];
            //rightColorView.backgroundColor = COLOR(175, 233, 232, 1);
            rightColorView.backgroundColor = COLOR(96, 211, 212, 1);
            [rightColorView addTarget:self action:@selector(payNow:) forControlEvents:UIControlEventTouchUpInside];
            rightColorView.tag = 1000 + indexPath.row;
            [topView addSubview:rightColorView];
            
            UILabel *priceTitle = [[UILabel alloc] initWithFrame:CGRectMake(597.0, 0.0, 128.0, 76.0)];
            priceTitle.text = @"待结算";
            priceTitle.font = [UIFont systemFontOfSize:16.0];
            priceTitle.textColor = [UIColor whiteColor];
            priceTitle.backgroundColor = [UIColor clearColor];
            priceTitle.textAlignment = NSTextAlignmentCenter;
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(600.0, 0.0, 115.0, 76.0)];
            priceLabel.text = [NSString stringWithFormat:@"结算 ¥%.2f",[[self.guadanArray[indexPath.row] objectForKey:@"total_amount"] floatValue]];
            priceLabel.font = [UIFont systemFontOfSize:14.0];
            priceLabel.textColor = [UIColor whiteColor];
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.textAlignment = NSTextAlignmentCenter;
            if (self.isShouyintai)
            {
                [topView addSubview:priceLabel];
            }
            else
            {
                [topView addSubview:priceTitle];
            }            
            [cell addSubview:topView];
            
            if (((NSArray *)[self.guadanArray[indexPath.row] objectForKey:@"details"]).count > 0)
            {
                topView.frame = CGRectMake(150.0, 0.0, 761.0, 76.0);
                deleteButton.frame = CGRectMake(686.0, 0.0, 75.0, 76.0);
                UIButton *expand = [[UIButton alloc] initWithFrame:CGRectMake(725.0, 0.0, 36.0, 76.0)];
                expand.tag = indexPath.row;
                expand.backgroundColor = [UIColor whiteColor];
                [expand addTarget:self action:@selector(expandFoldedCell:) forControlEvents:UIControlEventTouchUpInside];
                [topView addSubview:expand];
                
                UILabel *expandLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.0, 26.0, 28.0, 14.0)];
                expandLabel.font = [UIFont systemFontOfSize:12.0];
                expandLabel.textColor = COLOR(197.0, 210.0, 210.0, 1.0);
                expandLabel.backgroundColor = [UIColor clearColor];
                expandLabel.textAlignment = NSTextAlignmentCenter;
                UIImageView *expandImage = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 44.0, 12.0, 6.0)];
                if (![[self.guadanArray[indexPath.row] objectForKey:@"isExpand"] boolValue])
                {
                    expandLabel.text = @"展开";
                    expandImage.image = [UIImage imageNamed:@"pad_triangle_down"];
                }
                else
                {
                    expandLabel.frame = CGRectMake(4.0, 39.0, 28.0, 14.0);
                    expandLabel.text = @"收起";
                    expandImage.frame = CGRectMake(12.0, 27.0, 12.0, 6.0);
                    expandImage.image = [UIImage imageNamed:@"pad_triangle_up"];
                    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(150.0, 76.0, 725.0, (((NSArray *)[self.guadanArray[indexPath.row] objectForKey:@"details"]).count)*54.0)];
                    bottomView.backgroundColor = [UIColor whiteColor];
                    for (int i = 0; i < ((NSArray *)[self.guadanArray[indexPath.row] objectForKey:@"details"]).count; i++)
                    {
                        UIView *subCellView = [[UIView alloc] initWithFrame:CGRectMake(0.0, i * 55.0, 725.0, 54.0)];
                        subCellView.backgroundColor = COLOR(242.0, 242.0, 242.0, 1);
                        NSDictionary *subDict = (NSDictionary *)[(NSArray *)[self.guadanArray[indexPath.row] objectForKey:@"details"] objectAtIndex:i];
                        
                        UILabel *subOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 19, 200.0, 16.0)];
                        subOrderLabel.text = [subDict objectForKey:@"name"];
                        subOrderLabel.font = [UIFont systemFontOfSize:16.0];
                        subOrderLabel.textColor = COLOR(37, 37, 37, 1);
                        [subCellView addSubview:subOrderLabel];
                        
                        UILabel *subKeshiLabel = [[UILabel alloc] initWithFrame:CGRectMake(400.0, 19.0, 200.0, 16.0)];
                        subKeshiLabel.font = [UIFont systemFontOfSize:14.0];
                        subKeshiLabel.text = [subDict objectForKey:@"departments_name"];
                        subKeshiLabel.textColor = COLOR(153.0, 153.0, 153.0, 1.0);
                        [subCellView addSubview:subKeshiLabel];
                        
                        UILabel *subStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(600.0, 19.0, 110.0, 16.0)];
                        subStatusLabel.font = [UIFont systemFontOfSize:14.0];
                        subStatusLabel.textAlignment = NSTextAlignmentRight;
                        subStatusLabel.text = [subDict objectForKey:@"activity"];
                        subStatusLabel.textColor = COLOR(90.0, 211.0, 213.0, 1.0);
                        [subCellView addSubview:subStatusLabel];

                        UIButton *subDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 725.0, 54.0)];
                        subDetailButton.backgroundColor = [UIColor clearColor];
                        subDetailButton.tag = 10000*indexPath.row + i;
                        [subDetailButton addTarget:self action:@selector(pushViewToHistory:) forControlEvents:UIControlEventTouchUpInside];
                        [subCellView addSubview:subDetailButton];
                        [bottomView addSubview:subCellView];
                    }
                    
                    [cell addSubview:bottomView];
                }
                [expand addSubview:expandImage];
                [expand addSubview:expandLabel];
            }
            cell.layer.shadowOpacity = 0.5;// 阴影透明度
            cell.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
            cell.layer.shadowRadius = 2;// 阴影扩散的范围控制
            cell.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
            return cell;
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_History )
        {
            HomeReserveTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeReserveTableViewCell"];
            cell.delegate = self;
            
            CDBook* book = self.reserveArray[indexPath.row];
            [cell setBook:book indexPath:indexPath];
            cell.isSelected = ( currentSelectedReserveIndex == indexPath.row );
            
            [cell.avatarImageView setImageWithName:[NSString stringWithFormat:@"%@_%@",book.telephone, book.booker_name] tableName:@"born.member" filter:book.member_id fieldName:@"image" writeDate:book.lastUpdate placeholderString:cell.isSelected?@"pad_avatar_currentPos":@"pad_avatar_default" cacheDictionary:self.imageCacheDictionary];
            
            return cell;
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_MemberCard )
        {
            if ( indexPath.row == 0 )
            {
                HomeMemberSearchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMemberSearchTableViewCell"];
                cell.delegate = self;
                [cell clear];
                
                return cell;
            }
            else
            {
                HomeMemberListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMemberListTableViewCell"];
                cell.delegate = self;
                cell.isSelected = ( currentSelectedMemberCardIndex == indexPath.row );
                
                CDMemberCard* card = self.memberCardArray[indexPath.row - 1];
                [cell setCard:card indexPath:indexPath];
                [cell.avatarImageView setImageWithName:[NSString stringWithFormat:@"%@_%@",card.member.memberID, card.member.memberName] tableName:@"born.member" filter:card.member.memberID fieldName:@"image" writeDate:card.member.lastUpdate placeholderString:cell.isSelected?@"pad_avatar_currentPos":@"pad_avatar_default" cacheDictionary:self.imageCacheDictionary];
                //[cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:card.member.image_url] placeholderImage:[UIImage imageNamed:@"pad_avatar_default"]];
                
                return cell;
            }
            
            return nil;
        }
    }
    
    return nil;
}

- (void)willSearchContent:(NSString*)content
{
//    if ( content.length < 2 )
//    {
//        UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"" message:@"输入的内容必须大于2个字符" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//        [v show];
//        return;
//    }
    
    NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    NSArray *array = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:storeID keyword:content];
    
    NSMutableArray* cardIDs = [NSMutableArray array];
    
    for ( CDMember* member in array )
    {
        if ( [member.isDefaultCustomer boolValue] == NO )
        {
            for ( CDMemberCard* card in member.card )
            {
                [cardIDs addObject:card.cardID];
            }
        }
    }
    
    self.memberCardIDs = cardIDs;
    
    BSFetchMemberRequest* request = [[BSFetchMemberRequest alloc] initWithKeyword:content];
    if ( [request execute] )
    {
        [[CBLoadingView shareLoadingView] show];
    }
    
    self.searchMemberCardKeyword = content;
    
    currentSelectedMemberCardIndex = -1;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForHomeTableviewYear:(NSIndexPath *)indexPath
//{
//    HomeHistoryMonthTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeHistoryMonthTableViewCell"];
//    cell.delegate = self;
//    
//    CDPosMonthIncome* p = self.historyPosOperateArray[indexPath.row];
//    cell.inCome = p;
//    
//    NSIndexPath* orignalIndexPath = self.historyDateDictionary[p.year];
//    if ( orignalIndexPath )
//    {
//        if ( orignalIndexPath.row == indexPath.row )
//        {
//            [cell showDate:[NSString stringWithFormat:@"%@年",p.year]];
//        }
//        else
//        {
//            [cell hideDate];
//        }
//    }
//    else
//    {
//        self.historyDateDictionary[p.year] = indexPath;
//        [cell showDate:[NSString stringWithFormat:@"%@年",p.year]];
//    }
//    
//    return cell;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForHomeTableviewMonth:(NSIndexPath *)indexPath
//{
//    HomeHistoryPosTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeHistoryPosTableViewCell"];
//    
//    CDPosOperate* op = self.historyPosOperateArray[indexPath.row];
//    cell.operate = op;
//    cell.delegate = self;
//    cell.indexPath = indexPath;
//    
//    if ( self.headTabView.historyType == HomeHeadTabViewHistoryType_Week || self.headTabView.historyType == HomeHeadTabViewHistoryType_Month )
//    {
//        NSIndexPath* orignalIndexPath = self.historyDateDictionary[op.day];
//        if ( orignalIndexPath )
//        {
//            if ( orignalIndexPath.row == indexPath.row )
//            {
//                [cell showDate:[NSString stringWithFormat:@"%@日",op.day]];
//            }
//            else
//            {
//                [cell hideDate];
//            }
//        }
//        else
//        {
//            self.historyDateDictionary[op.day] = indexPath;
//            [cell showDate:[NSString stringWithFormat:@"%@日",op.day]];
//        }
//    }
//    else
//    {
//        [cell hideDate];
//    }
//    
//    return cell;
//}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == HomeTableviewSection_Head )
    {
        return 10;
    }
    else if ( indexPath.section == HomeTableviewSection_Content )
    {
        if ( self.headTabView.currentHeadTab == HomeHeadTabView_Local )
        {
//            CDPosOperate* op = self.localPosOperateArray[indexPath.row];
//            if ( op == self.projectOperate )
//            {
//                return 110;
//            }
//            
//            if ( indexPath.row + 1 < self.localPosOperateArray.count )
//            {
//                CDPosOperate* op = self.localPosOperateArray[indexPath.row + 1];
//                if ( op == self.projectOperate )
//                {
//                    return 80;
//                }
//            }
            
            if ( self.localPosOperateArray.count == 6 && indexPath.row == 5 )
            {
                return 140;
            }
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_History )
        {
            if ( self.reserveArray.count == 6 && indexPath.row == 5 )
            {
                return 140;
            }
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_MemberCard )
        {
            if ( indexPath.row == 0 )
            {
                return 112;
            }
            else if ( self.memberCardArray.count == 5 && indexPath.row == 5 )
            {
                return 143;
            }
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_Guadan )
        {
            if (((NSArray *)[self.guadanArray[indexPath.row] objectForKey:@"details"]).count == 0)
            {
                return 96;
            }
            else if (![[self.guadanArray[indexPath.row] objectForKey:@"isExpand"]  boolValue])
            {
                return 96;
            }
            else
            {
                return 96 + ((NSArray *)[self.guadanArray[indexPath.row] objectForKey:@"details"]).count * 54;
            }
        }
        return 91;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == HomeTableviewSection_Content )
    {
        if ( !self.headTabView.yimeiBackgroundView.hidden )
        {
            return 215 - 66 + 27;
        }
        else
        {
            if ( self.headTabView.currentHeadTab == HomeHeadTabView_Local )
            {
                //            if ( self.localPosOperateArray.count > 0 )
                //            {
                //                CDPosOperate* op = self.localPosOperateArray[0];
                //                if ( op == self.projectOperate )
                //                {
                //                    return 238;
                //                }
                //            }
                
                return 215 - 66 + 27;
            }
            else if ( self.headTabView.currentHeadTab == HomeHeadTabView_MemberCard )
            {
                return 215 - 66;
            }
            else
            {
                return 215 - 66 + 27;
            }
        }
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == HomeTableviewSection_Content )
    {
        if ( !self.headTabView.yimeiBackgroundView.hidden )
        {
            self.headTabView.createPosButton.enabled = YES;
            self.headTabView.currentPosLabel.hidden = YES;
        }
        else
        {
            if ( self.headTabView.currentHeadTab == HomeHeadTabView_Local )
            {
                self.headTabView.currentPosLabel.hidden = YES;
                if ( self.localPosOperateArray.count > 0 )
                {
                    CDPosOperate* op = self.localPosOperateArray[0];
                    if ( op == self.projectOperate )
                    {
                        self.headTabView.currentPosLabel.hidden = NO;
                    }
                }
                self.headTabView.createPosButton.enabled = YES;
            }
            else if ( self.headTabView.currentHeadTab == HomeHeadTabView_History )
            {
                if ( currentSelectedReserveIndex >= 0 )
                {
                    self.headTabView.createPosButton.enabled = YES;
                }
                else
                {
                    self.headTabView.createPosButton.enabled = NO;
                }
                self.headTabView.currentPosLabel.hidden = YES;
            }
            else if ( self.headTabView.currentHeadTab == HomeHeadTabView_MemberCard )
            {
                if ( currentSelectedMemberCardIndex >= 1 )
                {
                    self.headTabView.createPosButton.enabled = YES;
                }
                else
                {
                    self.headTabView.createPosButton.enabled = NO;
                }
                self.headTabView.currentPosLabel.hidden = YES;
            }
            else if  ( self.headTabView.currentHeadTab == HomeHeadTabView_Guadan )
            {
                self.headTabView.createPosButton.enabled = YES;
            }
        }
        
        return self.headTabView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Cell Selected");
    if (indexPath.section == HomeTableviewSection_Content)
    {
        self.isSubDetail = NO;
        self.shouldJumpToHistory = YES;
        self.jumpToHistoryIndex= indexPath.row;
        FetchYimeiHistoryDetailRequest *request2 = [[FetchYimeiHistoryDetailRequest alloc] init];
        request2.operate_id = [self.guadanArray[self.jumpToHistoryIndex] objectForKey:@"id"];
        [request2 execute];
        BSFetchPosOperateRequest* request = [[BSFetchPosOperateRequest alloc] init];
        request.type = @"day";
        [request execute];
    }
}

- (IBAction)didMenuButtonPressed:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ( self.homeTableView.tableHeaderView )
    {
        self.homeTableView.tableHeaderView = nil;
        self.homeTableView.contentOffset = CGPointMake(0, 0);
        [self reloadTableView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( self.homeTableView.tableHeaderView )
        return;
    
    CGFloat offset = scrollView.contentOffset.y;
    if ( offset < 0 )
    {
        offset = 0;
    }
    else if ( offset > 140 )
    {
        offset = 140;
    }
    
    CGFloat scale = 1 - offset / 140;
    UITableViewCell* headCell = [self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:HomeTableviewSection_Head]];
    UIImageView* v = [headCell viewWithTag:101];
    v.transform = CGAffineTransformMakeScale(scale, scale);
    
    NSInteger offsetY = scrollView.contentOffset.y;
    
    if ( scrollView.contentOffset.y > lastPosY )
    {
        moveDirection = -1;
    }
    else
    {
        moveDirection = 1;
    }
    
    lastPosY = offsetY;
    
    if ( scrollView.contentOffset.y < 0 )
    {
        self.blueBgImageView.frame = CGRectMake(0, 0, 1024, 0 - scrollView.contentOffset.y);
    }
    else
    {
        self.blueBgImageView.frame = CGRectMake(0,0,0,0);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ( self.homeTableView.tableHeaderView )
        return;
    
    if ( moveDirection > 0 && (*targetContentOffset).y < 140 )
    {
        *targetContentOffset = CGPointMake(0, 0);
    }
    else if ( moveDirection < 0 && (*targetContentOffset).y < 140 )
    {
        *targetContentOffset = CGPointMake(0, 140);
    }
}

#pragma mark - HomeHistoryMonthTableViewCellDelegate
- (void)didHomeHistoryPosTableViewYearCellPresssed:(HomeHistoryPosTableViewCell*)cell inCome:(CDPosMonthIncome *)inCome
{
    self.headTabView.historyMonthType = HomeHeadTabViewHistoryMonthType_Month;
    self.headTabView.selectedMonthYearString = [NSString stringWithFormat:@"%@-%02d",inCome.year,[inCome.month integerValue]];
    self.headTabView.selectedMonthStoreID = inCome.storeID;
    [self fetchHistoryPosOperates];
    [self fetchHistoryPosOperatesFromServer];
    [self.headTabView showHistoryMonthBackView:[NSString stringWithFormat:@"%@年%02d月",inCome.year,[inCome.month integerValue]]];
    [self reloadTableView];
}

//#pragma mark - HomeHistoryPosTableViewCellDelegate
//- (void)didHomeHistoryPosTableViewCellPresssed:(HomeHistoryPosTableViewCell*)cell
//{
//    CDPosOperate* op = self.historyPosOperateArray[cell.indexPath.row];
//    
//    PadPosViewController *posViewController = [[PadPosViewController alloc] init];
//    posViewController.operate = op;
//    [self.navigationController pushViewController:posViewController animated:YES];
//}

#pragma mark - HomeCurrentPosTableViewCellDelegate
- (void)didHomeCurrentPosTableViewCellDeleteButtonPresssed:(HomeCurrentPosTableViewCell*)cell
{
    BOOL isReloadAll = NO;
    
    if ( self.projectOperate == cell.posOperate )
    {
        self.projectOperate = nil;
        self.rightContinueView.hidden = YES;
        isReloadAll = YES;
    }
    
    NSArray* products = cell.posOperate.products.array;
    
    for ( CDPosProduct* product in products )
    {
        product.operate.couponCard.remainAmount = [NSNumber numberWithFloat:product.coupon_deduction.floatValue + product.operate.couponCard.remainAmount.floatValue];
        product.operate.memberCard.points = [NSString stringWithFormat:@"%.0f",product.point_deduction.floatValue + product.operate.memberCard.points.floatValue];
        CDBook* book = product.book;
        if ( book )
        {
            book.isUsed = @(FALSE);
            BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
            if ( [book.is_reservation_bill boolValue] )
            {
                request.type = HandleBookType_delete;
            }
            else
            {
                request.type = HandleBookType_approved;
            }
            [request execute];
        }
    }

    if ( cell.posOperate.book )
    {
        cell.posOperate.book.isUsed = @(FALSE);
        
        BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:cell.posOperate.book];
        if ( [cell.posOperate.book.is_reservation_bill boolValue] )
        {
            request.type = HandleBookType_delete;
        }
        else
        {
            request.type = HandleBookType_approved;
        }
        [request execute];
    }
    
    [[BSCoreDataManager currentManager] deleteObject:cell.posOperate];
    [[BSCoreDataManager currentManager] save:nil];
    
    [self fetchLocalPosOperates];
    
    NSIndexPath* path = [self.homeTableView indexPathForCell:cell];
    [self.homeTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    
    for ( HomeCurrentPosTableViewCell* cell in [self.homeTableView visibleCells] )
    {
        if ( [cell isKindOfClass:[HomeCurrentPosTableViewCell class]] )
        {
            NSIndexPath* path = [self.homeTableView indexPathForCell:cell];
            cell.numberLabel.text = [NSString stringWithFormat:@"%d",path.row + 1];
        }
    }
    
    [self performSelector:@selector(reloadEmptyPosImageView) withObject:nil afterDelay:0.2];
}

- (void)didHomeCurrentPosTableViewCellPresssed:(HomeCurrentPosTableViewCell*)cell
{
    self.projectOperate = cell.posOperate;
    [self.homeTableView reloadData];
    
    PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithPosOperate:cell.posOperate];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - HomeMemberListTableViewCellDelegate
- (void)didHomeMemberListTableViewCellChongzhiPresssed:(HomeMemberListTableViewCell*)cell
{
    CDMemberCard* card = self.memberCardArray[cell.indexPath.row - 1];
    
    if ( self.maskView == nil )
    {
        self.maskView = [[PadMaskView alloc] init];
        [self.view addSubview:self.maskView];
    }
    
    PadCardOperateViewController* viewController = [[PadCardOperateViewController alloc] initWithMember:card.member memberCard:card operateType:kPadMemberCardOperateRecharge];
    viewController.maskView = self.maskView;
    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    [self.maskView addSubview:self.maskView.navi.view];
    [self.maskView show];
}

- (void)didHomeHomeMemberListTableViewCellPresssed:(HomeMemberListTableViewCell*)cell
{
    if ( cell.indexPath.row == currentSelectedMemberCardIndex )
    {
        currentSelectedMemberCardIndex = -1;
    }
    else
    {
        currentSelectedMemberCardIndex = cell.indexPath.row;
    }
    
    [self reloadTableView];
}

#pragma mark - HomeReserveTableViewCellDelegate
- (void)didHomeReserveTableViewCellDeleteButtonPresssed:(HomeReserveTableViewCell*)cell
{
    CDBook* book = self.reserveArray[cell.indexPath.row];
    
    BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
    request.type = HandleBookType_delete;
    [request execute];
    
    [[BSCoreDataManager currentManager] deleteObject:book];
    [[BSCoreDataManager currentManager] save:nil];
    
    [self fetchHistoryPosOperates];
    
    if ( cell.indexPath.row < currentSelectedReserveIndex )
    {
        currentSelectedReserveIndex--;
    }
    
    NSIndexPath* path = [self.homeTableView indexPathForCell:cell];
    [self.homeTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    
    for ( HomeReserveTableViewCell* cell in [self.homeTableView visibleCells] )
    {
        if ( [cell isKindOfClass:[HomeReserveTableViewCell class]] )
        {
            NSIndexPath* path = [self.homeTableView indexPathForCell:cell];
            cell.indexPath = path;
            cell.numberLabel.text = [NSString stringWithFormat:@"%d",path.row + 1];
        }
    }
}

- (void)didHomeReserveTableViewCellModifyButtonPresssed:(HomeReserveTableViewCell*)cell
{
    CDBook* book = self.reserveArray[cell.indexPath.row];
    
    PadBookMainViewController *viewController = [[PadBookMainViewController alloc] initWithNibName:@"PadBookMainViewController" bundle:nil];
    viewController.isCloseButton = YES;
    viewController.focusBook = book;
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)didHomeReserveTableViewCellPresssed:(HomeReserveTableViewCell*)cell
{
    if ( cell.indexPath.row == currentSelectedReserveIndex )
    {
        currentSelectedReserveIndex = -1;
    }
    else
    {
        CDBook* book = self.reserveArray[cell.indexPath.row];
        if ( [book.state isEqualToString:@"approved"] && ![book.isUsed boolValue] )
        {
            currentSelectedReserveIndex = cell.indexPath.row;
        }
    }
    
    [self reloadTableView];
}

- (void)didHomeYimeiWashTableViewCellPresssed:(HomeYimeiWashTableViewCell*)cell
{
    YimeiPosOperateDetailViewController* vc = [[YimeiPosOperateDetailViewController alloc] initWithNibName:@"YimeiPosOperateDetailViewController" bundle:nil];
    CDPosWashHand* op = self.yimeiPosOperateArray[cell.indexPath.row];
    vc.washHand = op;
    
//    FetchAllWorkFlowActivity* r = [[FetchAllWorkFlowActivity alloc] init];
//    r.yimeiWorkFlowID = op.workflow_id;
//    [r execute];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didBookedPosOperatePressed
{
//    PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithBooked];
//    viewController.delegate = self;
//    [self.navigationController pushViewController:viewController animated:YES];
//    [self performSelector:@selector(hideOperateMaskView) withObject:nil afterDelay:0.5];
}

- (void)didUnBookedPosOperatePressed
{
#if 1
    PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithHandNo:@"" memberCard:nil];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
    [self performSelector:@selector(hideOperateMaskView) withObject:nil afterDelay:0.5];
#else
    NSString *urlString = [NSString stringWithFormat:@"com.vepos.wyzft://%@,%@,%@,%d,%@",@"15201995316",@"qqqqqq",@"0.01",1,@"PosBoss"];
    BOOL t =  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
#endif
}

- (void)hideOperateMaskView
{
    self.addOperateMaskView.alpha = 0;
}

#pragma mark - HomeHeadTabViewDelegate
- (void)didHomeHeadTabViewAddPosOperateButtonPressed:(CGFloat)posY
{
    if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"您没有权限开单" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        
        return;
    }
    
    [self addPosOperate:nil couponCard:nil];
}

- (void)didCreateYimeiNewMemberButtonPressed
{
    if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"您没有权限开单" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        
        return;
    }

    PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithHandNo:@"" memberCard:nil];
    viewController.createYimeiNewMember = YES;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)addPosOperate:(CDMemberCard*)card couponCard:(CDCouponCard*)couponCard
{
    if ( [[PersonalProfile currentProfile].isUseHandNumber boolValue] )
    {
        if ( self.maskView == nil )
        {
            self.maskView = [[PadMaskView alloc] init];
            [self.view addSubview:self.maskView];
        }
        
        PadTextInputViewController *viewController = [[PadTextInputViewController alloc] initWithType:kPadTextInputHandNum];
        viewController.delegate = self;
        viewController.maskView = self.maskView;
        viewController.memberCard = card;
        viewController.couponCard = couponCard;
        CBRotateNavigationController *navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        navi.navigationBarHidden = YES;
        navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
    else
    {
        [self didTextInputFinishedWithType:kPadTextInputHandNum inputText:@"" memberCard:card couponCard:couponCard];
    }
}

#pragma mark -
#pragma mark PadTextInputViewControllerDelegate Methods
- (void)didTextInputFinishedWithType:(kPadTextInputType)type inputText:(NSString *)inputText memberCard:(CDMemberCard*)memberCard couponCard:(CDCouponCard*)couponCard
{
    if (type == kPadTextInputHandNum)
    {
        if ( memberCard || couponCard )
        {
            PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:memberCard couponCard:couponCard handno:inputText];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_Local || self.headTabView.currentHeadTab == HomeHeadTabView_Guadan)
        {
            PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithHandNo:inputText memberCard:nil];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_History )
        {
            if ( currentSelectedReserveIndex >= 0 )
            {
                CDBook* book = self.reserveArray[currentSelectedReserveIndex];
                PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithBook:book handno:inputText];
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:YES];
                
                currentSelectedReserveIndex = -1;
                
                self.reserveArray = [[BSCoreDataManager currentManager] fetchHomeTodayBooks];
                
                [self performSelector:@selector(setCurrentHeadTabToLocal) withObject:nil afterDelay:1];
            }
        }
        else if ( self.headTabView.currentHeadTab == HomeHeadTabView_MemberCard )
        {
            if ( currentSelectedMemberCardIndex >= 1 )
            {
                CDMemberCard* card = self.memberCardArray[currentSelectedMemberCardIndex-1];
                PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:card handno:inputText];
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:YES];
                
                [self performSelector:@selector(setCurrentHeadTabFromSearchToLocal) withObject:nil afterDelay:1];
            }
        }
    }
}

- (void)setCurrentHeadTabToLocal
{
    self.headTabView.currentHeadTab = HomeHeadTabView_Local;
    [self reloadTableView];
    showHistoryToLocalAnimation = TRUE;
}

- (void)setCurrentHeadTabFromSearchToLocal
{
    currentSelectedMemberCardIndex = -1;
    self.memberCardArray = nil;
    self.headTabView.currentHeadTab = HomeHeadTabView_Local;
    [self reloadTableView];
}

- (void)didTextInputFinishedWithType:(kPadTextInputType)type inputText:(NSString *)inputText
{
    [self didTextInputFinishedWithType:type inputText:inputText memberCard:nil couponCard:nil];
}

- (void)didHomeHeadTabViewTimeFilterButtonPressed
{
    [self fetchLocalPosOperates];
    [self reloadTableView];
}

- (void)didHomeHeadTabViewPriceFilterButtonPressed
{
    [self fetchLocalPosOperates];
    [self reloadTableView];
}

- (void)fetchLocalPosOperates
{
    if ( !self.headTabView.yimeiBackgroundView.hidden )
    {
        self.yimeiPosOperateArray = [[BSCoreDataManager currentManager] fetchAllWashHandWithID:self.headTabView.currentWorkID keyword:nil isDone:self.headTabView.isDoneSelected];
        NSLog(@"%@",self.yimeiPosOperateArray);
    }
    else
    {
        if ( self.headTabView.localSortType == HomeHeadTabViewLocalSortType_Time )
        {
            self.localPosOperateArray = [[BSCoreDataManager currentManager] fetchLocalPosOperates:@"operate_date"];
        }
        else if ( self.headTabView.localSortType == HomeHeadTabViewLocalSortType_Price )
        {
            self.localPosOperateArray = [[BSCoreDataManager currentManager] fetchLocalPosOperates:@"amount"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLocalPosOperateNotification object:nil userInfo:@{@"count":@(self.localPosOperateArray.count)}];
    }
}

- (void)fetchHistoryPosOperates
{
    self.reserveArray = [[BSCoreDataManager currentManager] fetchHomeTodayBooks];
}

- (void)fetchHistoryPosOperatesFromServer
{
    BSFetchBookRequest *request = [[BSFetchBookRequest alloc] init];
    [request execute];
}

- (void)didHomeHeadTabViewCurrentPosButtonPressed
{
    [self stopScanPos];
    [self reloadTableView];
    //[GivePopupSelectWXGiveType showWithNavigationController:self.navigationController member:nil wxCardTemplate:nil];
}

- (void)didHomeHeadTabViewGuadanPosButtonPressed
{
    [self stopScanPos];
    [[CBLoadingView shareLoadingView] show];
    FetchCheckoutListRequest* request = [[FetchCheckoutListRequest alloc] init];
    [request execute];
    FetchYimeiHistoryRequest *request2 = [[FetchYimeiHistoryRequest alloc] init];
    //[request2 setKeyword:[NSString stringWithFormat:@"%@", [PersonalProfile currentProfile].bshopId]];
    [request2 execute];
}

- (void)didHomeHeadTabViewHistoryPosButtonPressed
{
    [self stopScanPos];
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( [profile.isBook boolValue] )
    {
        [self fetchHistoryPosOperates];
        [self fetchHistoryPosOperatesFromServer];
        [self reloadTableView];
    }
    else
    {
        [PopupBuyExtensionService showWithNavigationController:self.navigationController url:@"http://www.baidu.com"];
    }
}

- (void)didHomeHeadTabViewMemberCardButtonPressed
{
    [self stopScanPos];
    [self performSelector:@selector(startScanPos) withObject:nil afterDelay:0.5];
    //[self startScanPos];
    [self reloadTableView];
}

- (void)didHomeHeadTableViewRefreshBtnPressed
{
    [self reloadHeadTabView];
}

- (void)didHomeHeadTableViewShowDoneBtnPressed
{
    [self reloadHeadTabView];
}

- (void)didHomeHeadTabViewWillSearchYimeiContent:(NSString*)content
{
    if ( content.length > 0 )
    {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"member_name contains[cd] %@", content];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"doctor_name contains[cd] %@", content];
        NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"yimei_queueID contains[cd] %@", content];
        NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1,predicate2,predicate3]];
        
        self.yimeiPosOperateArray = [self.yimeiPosOperateArray filteredArrayUsingPredicate:predicate];
    }
    else
    {
        [self fetchLocalPosOperates];
    }
    
    [self reloadTableView];
}

- (void)didHomeHeadTabViewTodayFilterButtonPressed
{
    [self fetchHistoryPosOperates];
    [self fetchHistoryPosOperatesFromServer];
    [self reloadTableView];
}

- (void)didHomeHeadTabViewWeekFilterButtonPressed
{
    [self fetchHistoryPosOperates];
    [self fetchHistoryPosOperatesFromServer];
    [self reloadTableView];
}

- (void)didHomeHeadTabViewMonthFilterButtonPressed
{
    [self fetchHistoryPosOperates];
    [self fetchHistoryPosOperatesFromServer];
    [self reloadTableView];
}

- (void)didHomeHeadTabViewMonthBackButtonPressed
{
    [self fetchHistoryPosOperates];
    [self reloadTableView];
}

- (void)reloadTableView
{
    [self.homeTableView reloadData];
    [self reloadEmptyPosImageView];
}

- (void)reloadEmptyPosImageView
{
    [self scrollViewDidScroll:self.homeTableView];
    
    if ( !self.headTabView.yimeiBackgroundView.hidden )
    {
        UIImageView* emptyReserveImageView = [self.homeTableView viewWithTag:2986];
        [emptyReserveImageView removeFromSuperview];
        
         return;
    }
    
    UIImageView* emptyPosImageView = [self.homeTableView viewWithTag:2986];
    
    if ( self.headTabView.currentHeadTab == HomeHeadTabView_Local && self.localPosOperateArray.count == 0 )
    {
        UIImage* image = [UIImage imageNamed:@"Pad_Home_EmptyPos"];
        if ( emptyPosImageView == nil )
        {
            emptyPosImageView = [[UIImageView alloc] initWithFrame:CGRectMake(396, 365, image.size.width, image.size.height)];
            emptyPosImageView.image = image;
            emptyPosImageView.tag = 2986;
            [self.homeTableView addSubview:emptyPosImageView];
            
            UIImageView* emptyReserveImageView = [self.homeTableView viewWithTag:2987];
            [emptyReserveImageView removeFromSuperview];
            
            UIImageView* emptyResearchImageView = [self.homeTableView viewWithTag:2988];
            [emptyResearchImageView removeFromSuperview];
        }
        
        CGFloat posY = 365;
        if ( self.homeTableView.tableHeaderView )
        {
            posY = 365 + 75;
        }
        
        emptyPosImageView.frame = CGRectMake(396, posY, image.size.width, image.size.height);
        
        return;
    }
    
    [emptyPosImageView removeFromSuperview];
    
    UIImageView* emptyReserveImageView = [self.homeTableView viewWithTag:2987];
    
    if ( self.headTabView.currentHeadTab == HomeHeadTabView_History && self.reserveArray.count == 0 )
    {
        UIImage* image = [UIImage imageNamed:@"Pad_Home_EmptyReserve"];
        if ( emptyReserveImageView == nil )
        {
            emptyReserveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(372, 345, image.size.width, image.size.height)];
            emptyReserveImageView.image = image;
            emptyReserveImageView.tag = 2987;
            [self.homeTableView addSubview:emptyReserveImageView];
            
            UIImageView* emptyResearchImageView = [self.homeTableView viewWithTag:2988];
            [emptyResearchImageView removeFromSuperview];
        }
        
        CGFloat posY = 345;
        if ( self.homeTableView.tableHeaderView )
        {
            posY = 345 + 75;
        }
        
        emptyReserveImageView.frame = CGRectMake(372, posY, image.size.width, image.size.height);
        
        return;
    }
    
    [emptyReserveImageView removeFromSuperview];

    UIImageView* emptyResearchImageView = [self.homeTableView viewWithTag:2988];
    
    if ( self.headTabView.currentHeadTab == HomeHeadTabView_MemberCard && self.memberCardArray.count == 0 )
    {
        UIImage* image = [UIImage imageNamed:@"Pad_Home_EmptyResearch"];
        if ( emptyResearchImageView == nil )
        {
            emptyResearchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, 420, image.size.width, image.size.height)];
            emptyResearchImageView.image = image;
            emptyResearchImageView.tag = 2988;
            [self.homeTableView addSubview:emptyResearchImageView];
        }
        
        CGFloat posY = 420;
        if ( self.homeTableView.tableHeaderView )
        {
            posY = 420 + 75;
        }
        
        emptyResearchImageView.frame = CGRectMake(275, posY, image.size.width, image.size.height);
        
        return;
    }
    
    [emptyResearchImageView removeFromSuperview];
}

- (void)expandFoldedCell:(UIButton*)button
{
    bool status = [[self.guadanArray[button.tag] objectForKey:@"isExpand"] boolValue];
    [(NSMutableDictionary *)self.guadanArray[button.tag] setObject:@(!status) forKey:@"isExpand"];
    [self reloadTableView];
}

- (void)payNow:(UIButton*)button
{
    BSFetchMemberCardRequest *memberRequest = [[BSFetchMemberCardRequest alloc] initWithMemberCardIds:[NSMutableArray arrayWithObject:[self.guadanArray[button.tag-1000] objectForKey:@"card_id"]] keyword:[self.guadanArray[button.tag-1000] objectForKey:@"member_name"]];
    [memberRequest execute];
    [self performSelector:@selector(openPayment:) withObject:button afterDelay:1.0];
}

- (void)openPayment:(UIButton*)button
{
    if ( self.maskView == nil )
    {
        self.maskView = [[PadMaskView alloc] init];
        [self.view addSubview:self.maskView];
    }
    CDPosOperate *op = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:[self.guadanArray[button.tag-1000] objectForKey:@"id"] forKey:@"operate_id"];
    
    
    op.memberCard = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberCard" withValue:[self.guadanArray[button.tag-1000] objectForKey:@"card_id"] forKey:@"cardID"];
    PadPaymentViewController *viewController = [[PadPaymentViewController alloc] initWithPosOperate:op];
    op.amount = [self.guadanArray[button.tag-1000] objectForKey:@"total_amount"];
    viewController.maskView = self.maskView;
    viewController.isGuadan = FALSE;
    viewController.isGuadanPay = TRUE;
    viewController.orignalOperateID = op.old_operate_id;
    viewController.outNavigationController = self.navigationController;
    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    [self.maskView addSubview:self.maskView.navi.view];
    [self.maskView show];
}

- (void)pushViewToHistory:(UIButton*)button
{
    

    self.isSubDetail = YES;
    self.jumpToHistoryIndex = button.tag/10000;
    self.subDetailIndex = button.tag%10;
    self.shouldJumpToHistory = YES;

    FetchYimeiHistoryDetailRequest *request2 = [[FetchYimeiHistoryDetailRequest alloc] init];
    request2.operate_id = [[[self.guadanArray[self.jumpToHistoryIndex] objectForKey:@"details"] objectAtIndex:self.subDetailIndex] objectForKey:@"id"];
    [request2 execute];
    
    BSFetchPosOperateRequest* request = [[BSFetchPosOperateRequest alloc] init];
    request.type = @"day";
    [request execute];
}

- (void)deleteGuadan:(UIButton*)button
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除所有项目吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CDPosOperate *op = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:[self.guadanArray[button.tag-2000] objectForKey:@"id"] forKey:@"operate_id"];
        BSPosOperateCancelRequest *request = [[BSPosOperateCancelRequest alloc] initWithParams:@{@"operate_id":[self.guadanArray[button.tag-2000] objectForKey:@"id"]} operate:op];
        [request execute];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
    
- (void)handleSwipeLeft:(UISwipeGestureRecognizer * )sender
{
    NSLog(@"%@", [sender.view viewWithTag:sender.view.tag-1000]);
    if(sender.view.origin.x >= 150)
    {
        [UIView animateWithDuration:0.5 animations:^{
            NSArray *array = [self.guadanArray[sender.view.tag%10] objectForKey:@"details"];
            if (array.count == 0)
            {
                sender.view.frame = CGRectMake(75, 0, 725, 76);
                [sender.view viewWithTag:sender.view.tag-1000].frame = CGRectMake(725.0, 0.0, 75.0, 76.0);
            }
            else
            {
                sender.view.frame = CGRectMake(75, 0, 836, 76);
                [sender.view viewWithTag:sender.view.tag-1000].frame = CGRectMake(761.0, 0.0, 75.0, 76.0);
            }
        }];
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer * )sender
{
    NSLog(@"%@", [sender.view viewWithTag:sender.view.tag-1000]);
    if(sender.view.origin.x <= 75)
    {
        [UIView animateWithDuration:0.5 animations:^{
            NSArray *array = [self.guadanArray[sender.view.tag%10] objectForKey:@"details"];
            if (array.count == 0)
            {
                sender.view.frame = CGRectMake(150, 0, 725, 76);
                [sender.view viewWithTag:sender.view.tag-1000].frame = CGRectMake(650.0, 0.0, 75.0, 76.0);
            }
            else
            {
                sender.view.frame = CGRectMake(150, 0, 761, 76);
                [sender.view viewWithTag:sender.view.tag-1000].frame = CGRectMake(686.0, 0.0, 75.0, 76.0);
            }
        }];
    }
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView.tag < 2000)
//    {
//        return;
//    }
//    if ( scrollView.contentOffset.x >= 75 )
//    {
//        [self.contentView bringSubviewToFront:self.deleteButton];
//        if ( scrollView.contentOffset.x >= 147 )
//        {
//            [self.contentView bringSubviewToFront:self.modifyButton];
//        }
//    }
//    else
//    {
//        [self.contentView sendSubviewToBack:self.deleteButton];
//        [self.contentView sendSubviewToBack:self.modifyButton];
//    }
//}

#pragma mark -
#pragma mark PadNumberKeyboardDelegate Methods

- (void)didPadNumberKeyboardDonePressed:(UITextField*)textField
{
    UIViewController *viewController = [self.restaurantNavi.viewControllers lastObject];
    if ([viewController isKindOfClass:[PadProjectViewController class]])
    {
        PadProjectViewController *projectViewController = (PadProjectViewController *)viewController;
        [projectViewController didTextFieldEditDone:textField];
    }
    else if ([viewController isKindOfClass:[PadMemberAndCardViewController class]])
    {
        PadMemberAndCardViewController *memberAndCardViewController = (PadMemberAndCardViewController *)viewController;
        [memberAndCardViewController didTextFieldEditDone:textField];
    }
    else if ([viewController isKindOfClass:[PadRestaurantViewController class]])
    {
        PadRestaurantViewController *resutaurantViewController = (PadRestaurantViewController *)viewController;
        [resutaurantViewController didTextFieldEditDone:textField];
    }

    viewController = [self.maskView.navi.viewControllers lastObject];
    if ([viewController isKindOfClass:[PadCardOperateViewController class]])
    {
        PadCardOperateViewController *cardOperateViewController = (PadCardOperateViewController *)viewController;
        [cardOperateViewController didTextFieldEditDone:textField];
    }
}

#pragma mark -
#pragma mark Connect to Pos Machine


- (void)startScanPos
{
    //_peripheral =
    [_centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)stopScanPos
{
    [_centralManager stopScan];
}

#pragma mark - Bluetooth Reader Manager


- (void)bluetoothReaderManager:(ABTBluetoothReaderManager *)bluetoothReaderManager didDetectReader:(ABTBluetoothReader *)reader peripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        // Store the Bluetooth reader.
        _bluetoothReader = reader;
        _bluetoothReader.delegate = self;
        
        // Attach the peripheral to the Bluetooth reader.
        [_bluetoothReader attachPeripheral:peripheral];
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didAttachPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"The reader is attached to the peripheral successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [_bluetoothReader authenticateWithMasterKey:_masterKey];

        
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didAuthenticateWithError:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"The reader is authenticated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        if ([_bluetoothReader isKindOfClass:[ABTAcr1255uj1Reader class]]) {
            
            uint8_t command[] = { 0xE0, 0x00, 0x00, 0x40, 0x01 };
            
            [_bluetoothReader transmitEscapeCommand:command length:sizeof(command)];
            [_bluetoothReader transmitEscapeCommand:_escapeCommand];

        }
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didReturnResponseApdu:(NSData *)apdu error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        // Show the response APDU.
        //self.responseApduLabel.text = [ABDHex hexStringFromByteArray:apdu];
        HomeMemberSearchTableViewCell* cell = [self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        NSString *newString = [[ABDHex hexStringFromByteArray:apdu] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ( newString.length > 4 )
        {
            NSString* testString = [newString substringFromIndex:newString.length - 4];
            if ( [testString isEqualToString:@"9000"] )
            {
                newString = [newString substringToIndex:newString.length - 4];
            }
        }
        if ([cell isKindOfClass:[HomeMemberSearchTableViewCell class]]) {
            cell.searchContentTextFiled.text = newString;
            [TempManager sharedInstance].notSearchAll = TRUE;
            [self willSearchContent:newString];
        }
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didReturnCardStatus:(ABTBluetoothReaderCardStatus)cardStatus error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        // Show the card status.
        [self ABD_stringFromCardStatus:cardStatus];
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didChangeCardStatus:(ABTBluetoothReaderCardStatus)cardStatus error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        // Show the card status.
        [self ABD_stringFromCardStatus:cardStatus];
//        [self.tableView reloadData];
    }
}

- (NSString *)ABD_stringFromCardStatus:(ABTBluetoothReaderCardStatus)cardStatus {
    
    NSString *string = nil;
    
    switch (cardStatus) {
            
        case ABTBluetoothReaderCardStatusUnknown:
            string = @"Unknown";
            break;
            
        case ABTBluetoothReaderCardStatusAbsent:
            string = @"Absent";
            break;
            
        case ABTBluetoothReaderCardStatusPresent:
            string = @"Present";
            
            [_bluetoothReader transmitApdu:_commandApdu];

            break;
            
        case ABTBluetoothReaderCardStatusPowered:
            string = @"Powered";
            break;
            
        case ABTBluetoothReaderCardStatusPowerSavingMode:
            string = @"Power Saving Mode";
            break;
            
        default:
            string = @"Unknown";
            break;
    }
    
    return string;
}

#pragma mark - Central Manager

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    static BOOL firstRun = YES;
    NSString *message = nil;
    
    switch (central.state) {
            
        case CBCentralManagerStateUnknown:
        case CBCentralManagerStateResetting:
            message = @"The update is being started. Please wait until Bluetooth is ready.";
            break;
            
        case CBCentralManagerStateUnsupported:
            message = @"This device does not support Bluetooth low energy.";
            break;
            
        case CBCentralManagerStateUnauthorized:
            message = @"This app is not authorized to use Bluetooth low energy.";
            break;
            
        case CBCentralManagerStatePoweredOff:
            if (!firstRun) {
                message = @"You must turn on Bluetooth in Settings in order to use the reader.";
            }
            break;
            
        default:
            break;
    }
    
    if (message != nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    firstRun = NO;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    // If the peripheral is not found, then add it to the array.
    if ([[[BSUserDefaultsManager sharedManager].mPadPosMachineRecord objectForKey:@"name"] isEqualToString:peripheral.name]) {
        
        _masterKey = [ABDHex byteArrayFromHexString:@"41 43 52 31 32 35 35 55 2D 4A 31 20 41 75 74 68"];
        _peripheral = peripheral;
        [_centralManager connectPeripheral:_peripheral options:nil];
    }
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    // Detect the Bluetooth reader.
    [_bluetoothReaderManager detectReaderWithPeripheral:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    // Show the error
    if (error != nil) {
        //[self ABD_showError:error];
        [self stopScanPos];
        [self performSelector:@selector(startScanPos) withObject:nil afterDelay:0.5];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"连接失败，请重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        [self stopScanPos];
        [self performSelector:@selector(startScanPos) withObject:nil afterDelay:0.5];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备断开" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    } else {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"The reader is disconnected successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
    }
}

@end
