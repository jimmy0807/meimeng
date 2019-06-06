//
//  PadProjectViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/8.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectViewController.h"
#import "PadProjectConstant.h"
#import "PadProjectData.h"
#import "BSScanCardManager.h"
#import "BSUserDefaultsManager.h"
#import "CBLoadingView.h"
#import "PadProjectRemindView.h"
#import "BSProjectRequest.h"
#import "BSProjectItemPriceRequest.h"
#import "BSPopoverBackgroundView.h"
#import "PadProjectKeyboardView.h"
#import "PadMemberAndCardViewController.h"
#import "PadFreeCombinationCreateViewController.h"
#import "CBBluetoothManager.h"
#import "BSHandleBookRequest.h"
#import "BSFetchMemberCardRequest.h"
#import "PadPaymentViewController.h"
#import "PadSettingViewController.h"
#import "BNScanCodeViewController.h"
#import "PadCardOperateViewController.h"
#import "BSFetchMemberDetailRequest.h"
#import "PadMemberCreateViewController.h"
#import "YimeiCreateKeshiViewController.h"
#import "YimeiCreateProjectItemViewController.h"
#import "BSMemberCardOperateRequest.h"
#import "YimeiCreateMultiKeshiViewController.h"

@interface PadProjectViewController ()

@property (nonatomic, strong) PadProjectNaviView *naviBar;
@property (nonatomic, strong) PadProjectView *projectView;
@property (nonatomic, strong) PadProjectKeyboardView *keyboardView;
@property (nonatomic, strong) PadProjectSideView *sideView;
@property (nonatomic, strong) PadProjectUserSelectView *userSelectView;
@property (nonatomic, strong) UIPopoverController *typePopover;
@property (nonatomic, strong) PadCategoryViewController *typeViewController;
@property (nonatomic, strong) PadMaskView *maskView;

@property (nonatomic, strong) PadProjectData *data;

@property (nonatomic, strong) NSMutableDictionary *cachePicParams;
@property (nonatomic, strong) UIView *fastInputView;
@property (nonatomic, strong) NSString *fastInputString;

@end


@implementation PadProjectViewController

- (id)initWithHandNo:(NSString *)handno memberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadProjectViewController" bundle:nil];
    if (self)
    {
        self.data = [[PadProjectData alloc] init];
        self.data.operateType = kPadProjectPosOperateCreate;
        self.data.posOperate = [[BSCoreDataManager currentManager] insertEntity:@"CDPosOperate"];
        
        self.data.posOperate.handno = handno;
        self.data.posOperate.isLocal = [NSNumber numberWithBool:YES];
        self.data.posOperate.isTakeout = [NSNumber numberWithInteger:NO];
        
        if ( !memberCard )
        {
            NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
            self.data.posOperate.member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"storeID = %@ && isDefaultCustomer", storeID]];
//            NSMutableArray *cardIds = [NSMutableArray array];
//            NSArray *cards = self.data.posOperate.member.card.array;
//            for (NSInteger i = 0; i < cards.count; i++)
//            {
//                CDMemberCard *card = [cards objectAtIndex:i];
//                [cardIds addObject:card.cardID];
//            }
//            if (cardIds.count > 0)
//            {
//                BSFetchMemberCardRequest *request = [[BSFetchMemberCardRequest alloc] initWithMemberCardIds:cardIds];
//                [request execute];
//            }
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.data.posOperate.operate_date = [dateFormatter stringFromDate:[NSDate date]];
        [[BSCoreDataManager currentManager] save:nil];
    }
    
    return self;
}

- (id)initWithTakeoutWithHandNo:(NSString *)handno
{
    self = [self initWithHandNo:handno memberCard:nil];
    if (self)
    {
        self.data.posOperate.handno = handno;
        self.data.posOperate.isTakeout = [NSNumber numberWithInteger:YES];
    }
    
    return self;
}

- (id)initWithRestaurant:(CDRestaurantTable *)table personCount:(NSInteger)PersonCount occupyID:(NSNumber*)occupyID book:(CDBook *)book
{
    self = [self initWithHandNo:@"" memberCard:nil];
    if (self)
    {
        self.data.posOperate.restaurant_person_count = @(PersonCount);
        self.data.posOperate.restaurant_table = table;
        self.data.posOperate.occupy_restaurant_id = occupyID;
        
        if ( book )
        {
            [self didPadReserveConfirm:book];
        }
    }
    
    return self;
}

- (id)initWithBook:(CDBook *)book handno:(NSString *)handno
{
    
    self = [self initWithHandNo:handno memberCard:nil];
    if (self)
    {
        self.data.posOperate.member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:book.member_id forKey:@"memberID"];

        NSMutableArray *cardIds = [NSMutableArray array];
        NSArray *cards = self.data.posOperate.member.card.array;
        for (NSInteger i = 0; i < cards.count; i++)
        {
            CDMemberCard *card = [cards objectAtIndex:i];
            [cardIds addObject:card.cardID];
        }
        if (cardIds.count > 0)
        {
            BSFetchMemberCardRequest *request = [[BSFetchMemberCardRequest alloc] initWithMemberCardIds:cardIds];
            [request execute];
        }
        self.data.posOperate.handno = handno;
        self.data.posOperate.memberCard = cards[0];
        [self didPadReserveConfirm:book];
    }
    
    return self;
}

- (id)initWithMemberCard:(CDMemberCard *)memberCard handno:(NSString *)handno
{
    self = [self initWithHandNo:handno memberCard:memberCard];
    if (self)
    {
        if (memberCard != nil)
        {
            [self addObserver:self forKeyPath:@"data.cardItemCount" options:NSKeyValueObservingOptionNew context:nil];
            if (self.naviBar == nil)
            {
                self.naviBar = [[PadProjectNaviView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kPadNaviHeight + 3.0)];
                self.naviBar.delegate = self;
            }
            self.data.posOperate.handno = handno;
            self.data.posOperate.memberCard = memberCard;
            self.data.posOperate.member = memberCard.member;
        }
    }
    
    return self;
}

- (id)initWithMemberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard*)couponCard handno:(NSString *)handno
{
    self = [self initWithHandNo:handno memberCard:memberCard];
    if (self)
    {
        self.data.posOperate.handno = handno;
        self.data.posOperate.memberCard = memberCard;
        self.data.posOperate.couponCard = couponCard;
        if ( memberCard )
        {
            self.data.posOperate.member = memberCard.member;
        }
        else if ( couponCard )
        {
            self.data.posOperate.member = couponCard.member;
        }
    }
    
    return self;
}

- (id)initWithPosOperate:(CDPosOperate *)posOperate
{
    self = [super initWithNibName:@"PadProjectViewController" bundle:nil];
    if (self)
    {
        self.data = [[PadProjectData alloc] init];
        self.data.posOperate = posOperate;
        self.data.operateType = kPadProjectPosOperateEdit;
        if (self.data.posOperate.member == nil || self.data.posOperate.member.memberID.integerValue == 0)
        {
            NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
            self.data.posOperate.member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"storeID = %@ && isDefaultCustomer", storeID]];
//            NSMutableArray *cardIds = [NSMutableArray array];
//            NSArray *cards = self.data.posOperate.member.card.array;
//            for (NSInteger i = 0; i < cards.count; i++)
//            {
//                CDMemberCard *card = [cards objectAtIndex:i];
//                [cardIds addObject:card.cardID];
//            }
//            if (cardIds.count > 0)
//            {
//                BSFetchMemberCardRequest *request = [[BSFetchMemberCardRequest alloc] initWithMemberCardIds:cardIds];
//                [request execute];
//            }
        }
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.orignalOperateID )
    {
        self.data.posOperate.old_operate_id = self.orignalOperateID;
        [[BSCoreDataManager currentManager] save:nil];
    }
    
    [self forbidSwipGesture];
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    self.cachePicParams = [[NSMutableDictionary alloc] init];
    [self registerNofitificationForMainThread:kBSProjectRequestSuccess];
    [self registerNofitificationForMainThread:kBSProjectRequestFailed];
    [self registerNofitificationForMainThread:kBSProjectItemCreateResponse];
    [self registerNofitificationForMainThread:kBSScanWeVIPCardCodeResult];
    [self registerNofitificationForMainThread:kBSScanCardManagerResponse];
    [self registerNofitificationForMainThread:kBSProjectItemPriceResponse];
    [self registerNofitificationForMainThread:kBSPadCashierSuccess];
    [self registerNofitificationForMainThread:kBSPadAllotPerformance];
    [self registerNofitificationForMainThread:kBSPadGiveGiftCard];
    [self registerNofitificationForMainThread:kBSPadPrinterUpdatedNotification];
    [self registerNofitificationForMainThread:kBSPadCodeScannerUpdatedNotification];
    [self registerNofitificationForMainThread:kBSPadPosMachineUpdatedNotification];
    //[self registerNofitificationForMainThread:kBSCreateBookResponse];
    [self registerNofitificationForMainThread:kBSEditBookResponse];
    [self registerNofitificationForMainThread:kBSDeleteBookResponse];
    [self registerNofitificationForMainThread:kBSPadSetPosMachineAndPayAccount];
    [self registerNofitificationForMainThread:kBSCashMemberAgain];
    [self registerNofitificationForMainThread:@"showMemberSelect"];

    [self addObserver:self forKeyPath:@"data.cardItemCount" options:NSKeyValueObservingOptionNew context:nil];
    
    [CBBluetoothManager shareManager].isAutomatic = YES;
    [[CBBluetoothManager shareManager] startConnection];
    
    [self initView];
    [self initData];
    
    if ( self.createYimeiNewMember )
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PadMemberCreateViewController *viewController = [[PadMemberCreateViewController alloc] init];
            viewController.maskView = self.maskView;
            self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
            self.maskView.navi.navigationBarHidden = YES;
            self.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
            [self.maskView addSubview:self.maskView.navi.view];
            [self.maskView show];
        });
        
//        [self registerNofitificationForMainThread:kBSMemberCreateResponse];
//        [self registerNofitificationForMainThread:kBSFetchMemberDetailResponse];
    }
    
    [self initGuadan];
    
    [self createFastInput];
}

- (void)createFastInput
{
    self.fastInputView = [[UIView alloc] initWithFrame:CGRectMake(-504, 574, 641, 194)];
    self.fastInputView.backgroundColor = [UIColor clearColor];
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 26, 504, 168)];
    inputView.backgroundColor = COLOR(205, 209, 215, 1);
    for (int i = 0; i < 10 ; i++) {
        int line = i > 5 ? 1 : 0;
        UIButton *numButton = [[UIButton alloc] initWithFrame:CGRectMake(12+i%6*82, 12+line*78, 70, 66)];
        numButton.layer.cornerRadius = 7;
        numButton.backgroundColor = [UIColor whiteColor];
        numButton.tag = i;
        [numButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [numButton setTitleColor:COLOR(37, 37, 37, 1) forState:UIControlStateNormal];
        //        [numButton setBackgroundColor:COLOR(163, 171, 182, 1) forState:UIControlStateHighlighted];
        //        [numButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [numButton addTarget:self action:@selector(fastInput:) forControlEvents:UIControlEventTouchUpInside];
        [numButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [numButton addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchUpOutside];
        numButton.titleLabel.font = [UIFont systemFontOfSize:22];
        [inputView addSubview:numButton];
    }
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(340, 90, 152, 66)];
    cancelButton.backgroundColor = COLOR(163, 171, 182, 1);
    cancelButton.layer.cornerRadius = 7;
    [cancelButton setTitle:@"撤销" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR(111, 116, 123, 1) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelFastInput) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [inputView addSubview:cancelButton];
    
    [self.fastInputView addSubview:inputView];
    UIButton *controlButton = [[UIButton alloc] initWithFrame:CGRectMake(504, 100, 127, 56)];
    [controlButton setImage:[UIImage imageNamed:@"fast_input_show"] forState:UIControlStateNormal];
    [controlButton addTarget:self action:@selector(controlButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    controlButton.tag = 100;
    [self.fastInputView addSubview:controlButton];
    self.fastInputString = @"";
    [self.view addSubview:self.fastInputView];
    self.fastInputView.hidden = YES;
    
    NSTimer *autoHideFastTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleFastInput) userInfo:nil repeats:YES];
    [autoHideFastTimer fire];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.fastInputView == nil)
    {
        [self createFastInput];
    }
    else
    {
        self.fastInputView.hidden = NO;
    }
}

- (void)handleFastInput
{
    if (self.maskView.subviews.count > 1)
    {
        self.fastInputView.hidden = YES;
    }
    else
    {
        self.fastInputView.hidden = NO;
    }
}

- (void)hideFastInput
{
    if (self.fastInputView.frame.origin.x >= 0)
    {
        [self controlButtonClicked];
    }
}

- (void)controlButtonClicked
{
    NSLog(@"%@",self.maskView.subviews);
    if (self.maskView.subviews.count > 1)
    {
        return;
    }
    UIButton *button = [self.fastInputView viewWithTag:100];
    if (self.fastInputView.frame.origin.x < 0)
    {
        self.fastInputView.frame = CGRectMake(0, 574, 641, 194);
        button.frame = CGRectMake(484, 0, 127, 56);
        [button setImage:[UIImage imageNamed:@"fast_input_hide"] forState:UIControlStateNormal];
    }
    else
    {
        self.fastInputView.frame = CGRectMake(-504, 574, 641, 194);
        button.frame = CGRectMake(504, 100, 127, 56);
        [button setImage:[UIImage imageNamed:@"fast_input_show"] forState:UIControlStateNormal];
    }
}

- (void)touchDown:(UIButton *)button
{
    button.backgroundColor = COLOR(163, 171, 182, 1);
}

- (void)touchCancel:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
}

- (void)fastInput:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
    self.fastInputString = [self.fastInputString stringByAppendingString:[NSString stringWithFormat:@"%d",button.tag]];
    NSLog(@"%@",self.fastInputString);
    if ([self.fastInputString length] == 2)
    {
        CDProjectItem* item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:self.fastInputString forKey:@"defaultCode"];
        if (item != nil)
        {
            [self didPadProjectViewItemClick:item];
        }
        self.fastInputString = @"";
    }
}

- (void)cancelFastInput
{
    NSString *newText;
    if([self.fastInputString length] > 0){
        newText = [self.fastInputString substringToIndex:([self.fastInputString length]-1)];// 去掉最后一个","
    }else{
        newText = self.fastInputString;
    }
    self.fastInputString = newText;
    NSLog(@"%@",self.fastInputString);
}

- (void)initGuadan
{
    if ( self.guadan == nil )
        return;
    
    for ( CDHGuadanProduct* p in self.guadan.items )
    {
        CDProjectItem* item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:p.product_id forKey:@"itemID"];
        [self didPadProjectViewItemClickGuadan:item];
    }
    
    for ( CDHGuadanProduct* p in self.guadan.card_items )
    {
        CDMemberCardProject* item = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCardProject" withValue:p.line_id forKey:@"productLineID"];
        [self didPadProjectViewItemClickGuadan:item];
    }
    
    if ( [self.guadan.departments_id integerValue] > 0 )
    {
        CDKeShi* k = [[BSCoreDataManager currentManager] findEntity:@"CDKeShi" withValue:self.guadan.departments_id forKey:@"keshi_id"];
        self.data.posOperate.firstKeshi = k;
    }
    
    self.data.posOperate.doctor_id = self.guadan.doctor_id;
    self.data.posOperate.doctor_name = self.guadan.doctor_name;
    self.data.posOperate.note = self.guadan.note;
    self.data.posOperate.remark = self.guadan.remark;
    self.data.posOperate.yimei_shejishiID = self.guadan.designers_id;
    self.data.posOperate.yimei_shejishiName = self.guadan.designers_name;
    self.data.posOperate.yimei_shejizongjianID = self.guadan.director_employee_id;
    self.data.posOperate.yimei_shejizongjianName = self.guadan.director_employee_name;
    self.data.posOperate.yimei_guwenID = self.guadan.employee_id;
    self.data.posOperate.yimei_guwenName = self.guadan.employee_name;
    
    self.data.posOperate.orderID = self.guadan.guadan_id;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"data.cardItemCount"];
}


#pragma mark -
#pragma mark init Methods

- (void)initView
{
    self.projectView = [[PadProjectView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadProjectSideViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight)];
    self.projectView.backgroundColor = [UIColor clearColor];
    self.projectView.delegate = self;
    [self.view addSubview:self.projectView];
    
    self.keyboardView = [[PadProjectKeyboardView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadProjectSideViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight) delegate:self];
    self.keyboardView.hidden = YES;
    [self.view addSubview:self.keyboardView];
    
    self.sideView = [[PadProjectSideView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH -kPadProjectSideViewWidth, kPadNaviHeight, kPadProjectSideViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight)];
    self.sideView.delegate = self;
    self.sideView.isGuadanAddItem = self.isGuadan && self.isGuadanAddItem;
    self.sideView.isAddItem = self.isGuadanAddItem;//应该为isAddItem
    [self.sideView updateFrame];
    [self.view addSubview:self.sideView];
    
    self.userSelectView = [[PadProjectUserSelectView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kPadProjectSideViewWidth, kPadNaviHeight - kUserSelectContentHeight, kPadProjectSideViewWidth, kUserSelectContentHeight)];
    self.userSelectView.delegate = self;
    [self.userSelectView reloadWithMember:self.data.posOperate.member];
    [self.view addSubview:self.userSelectView];
    
    if (self.naviBar == nil)
    {
        self.naviBar = [[PadProjectNaviView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kPadNaviHeight + 3.0)];
        self.naviBar.delegate = self;
    }
    [self.view addSubview:self.naviBar];
    
    self.typeViewController = [[PadCategoryViewController alloc] initWithBornCategory:nil];
    self.typeViewController.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.typeViewController];
    navi.navigationBarHidden = YES;
    self.typePopover = [[UIPopoverController alloc] initWithContentViewController:navi];
    self.typePopover.backgroundColor = [UIColor whiteColor];
    self.typePopover.popoverBackgroundViewClass = [BSPopoverBackgroundView class];
    
    self.maskView = [[PadMaskView alloc] init];
    [self.view addSubview:self.maskView];
    
    if (![BSUserDefaultsManager sharedManager].isPadProjectViewRemind)
    {
        PadProjectRemindView *remindView = [[PadProjectRemindView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
        [self.view addSubview:remindView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNofitificationForMainThread:kBSFetchPrinterScannerResponse];
    [self registerNofitificationForMainThread:kPadSelectMemberAndCardFinish];
    [self registerNofitificationForMainThread:kBSCreateBookResponse];
    if ( self.createYimeiNewMember )
    {
        [self registerNofitificationForMainThread:kBSMemberCreateResponse];
        [self registerNofitificationForMainThread:kBSFetchMemberDetailResponse];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver: self name: kBSCreateBookResponse object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kBSFetchPrinterScannerResponse object:nil];
    [self removeNotificationOnMainThread:kBSCreateBookResponse];
    //[self removeNotificationOnMainThread:kBSProjectRequestSuccess];
    if ( self.createYimeiNewMember )
    {
        [self removeNotificationOnMainThread:kBSMemberCreateResponse];
        [self removeNotificationOnMainThread:kBSFetchMemberDetailResponse];
    }
}

- (void)initData
{
    [self.data reloadProjectItem];
    [self.projectView reloadProjectViewWithData:self.data];
    
    NSArray *localPosOperate = [[BSCoreDataManager currentManager] fetchLocalPosOperates:@"operate_date"];
    if (self.data.operateType == kPadProjectPosOperateCreate)
    {
        if (localPosOperate.count >= 1)
        {
            [self.naviBar reloadRemindInfoWithCount:localPosOperate.count - 1];
        }
        else
        {
            [self.naviBar reloadRemindInfoWithCount:0];
        }
    }
    if (self.data.operateType == kPadProjectPosOperateEdit)
    {
        [self.naviBar reloadRemindInfoWithCount:localPosOperate.count];
    }
    
    [self.naviBar reloadTitleWithData:self.data];
    [self.naviBar reloadUserInfoWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
    
//    NSArray *templates = [[BSCoreDataManager currentManager] fetchAllProjectTemplate];
//    NSArray *items = [[BSCoreDataManager currentManager] fetchAllProjectItem];
//    if (templates.count == 0 || items.count == 0)
//    {
//        
//    }
//    
//    [[CBLoadingView shareLoadingView] show];
    //[[BSProjectRequest sharedInstance] startProjectRequest];
}

- (void)resetBookInfo
{
    CDBook *book;
    HandleBookType type;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (CDPosProduct *product in self.data.posOperate.products)
    {
        CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.product_id forKey:@"itemID"];
        if (projectItem.bornCategory.integerValue == kPadBornCategoryProject && product.book.technician_id.integerValue != 0)
        {
            if (product.book == nil || product.book.book_id.integerValue == 0)
            {
                type = HandleBookType_create;
                book = [[BSCoreDataManager currentManager] insertEntity:@"CDBook"];
                params[@"start_date"] = product.book.start_date;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                if (product.book.end_date.length != 0 && [product.book.start_date compare:product.book.end_date] == NSOrderedAscending)
                {
                    params[@"end_date"] = product.book.end_date;
                }
                else
                {
                    NSDate *startDate = [dateFormatter dateFromString:product.book.start_date];
                    NSTimeInterval startInterval = [startDate timeIntervalSince1970];
                    NSTimeInterval endInterval = startInterval + ((projectItem.time.integerValue != 0) ? (projectItem.time.integerValue * 60) : (60 * 60));
                    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInterval];
                    params[@"end_date"] = [dateFormatter stringFromDate:endDate];
                }
                params[@"telephone"] = self.data.posOperate.member.mobile;
                params[@"member_name"] = self.data.posOperate.member.memberName;
                params[@"technician_id"] = product.book.technician_id;
                params[@"product_ids"] = @[@[@(kBSDataExist), @(NO), @[product.product_id]]];
                params[@"active"] = [NSNumber numberWithBool:YES];
                params[@"state"] = @"approved";
            }
            else
            {
                type = HandleBookType_edit;
                book = product.book;
                params[@"telephone"] = self.data.posOperate.member.mobile;
                params[@"member_name"] = self.data.posOperate.member.memberName;
            }
            
            [params setObject:@(YES) forKey:@"is_reservation_bill"];
            BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:product.book];
            request.type = type;
            request.params = params;
            [request execute];
        }
    }
    
    for (CDCurrentUseItem *useItem in self.data.posOperate.useItems)
    {
        if (useItem.projectItem.bornCategory.integerValue == kPadBornCategoryProject && useItem.book.technician_id.integerValue != 0)
        {
            if (useItem.book == nil || useItem.book.book_id.integerValue == 0)
            {
                type = HandleBookType_create;
                book = [[BSCoreDataManager currentManager] insertEntity:@"CDBook"];
                params[@"start_date"] = useItem.book.start_date;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                if (useItem.book.end_date.length != 0 && [useItem.book.start_date compare:useItem.book.end_date] == NSOrderedAscending)
                {
                    params[@"end_date"] = useItem.book.end_date;
                }
                else
                {
                    NSDate *startDate = [dateFormatter dateFromString:useItem.book.start_date];
                    NSTimeInterval startInterval = [startDate timeIntervalSince1970];
                    NSTimeInterval endInterval = startInterval + ((useItem.projectItem.time.integerValue != 0) ? (useItem.projectItem.time.integerValue * 60) : (60 * 60));
                    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInterval];
                    params[@"end_date"] = [dateFormatter stringFromDate:endDate];
                }
                params[@"telephone"] = self.data.posOperate.member.mobile;
                params[@"member_name"] = self.data.posOperate.member.memberName;
                params[@"technician_id"] = useItem.book.technician_id;
                params[@"product_ids"] = @[@[@(kBSDataExist), @(NO), @[useItem.projectItem.itemID]]];
                params[@"active"] = [NSNumber numberWithBool:YES];
                params[@"state"] = @"approved";
            }
            else
            {
                type = HandleBookType_edit;
                book = useItem.book;
                params[@"telephone"] = self.data.posOperate.member.mobile;
                params[@"member_name"] = self.data.posOperate.member.memberName;
            }
            
            [params setObject:@(YES) forKey:@"is_reservation_bill"];
            BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:useItem.book];
            request.type = type;
            request.params = params;
            [request execute];
        }
    }
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id value = change[NSKeyValueChangeNewKey];
    
    [self.naviBar reloadTitleWithData:self.data];
    if ([value integerValue] != 0)
    {
        [self.naviBar didShowCardItemButton];
    }
    else
    {
        self.data.isCardItem = NO;
        [self.naviBar didHideCardItemButton];
    }
    
    [self.projectView reloadProjectViewWithData:self.data];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSProjectRequestSuccess])
    {
        [[CBLoadingView shareLoadingView] hide];

        [self.data relaodBornCategories];
        [self.data reloadProjectItem];
        [self.naviBar reloadTitleWithData:self.data];
        [self.projectView reloadProjectViewWithData:self.data];
    }
    else if ([notification.name isEqualToString:kBSProjectRequestFailed])
    {
        [[CBLoadingView shareLoadingView] hide];
    }
    else if ([notification.name isEqualToString:kBSProjectItemCreateResponse])
    {
        //[[BSProjectRequest sharedInstance] startProjectRequest];
    }
    else if ([notification.name isEqualToString:kPadSelectMemberAndCardFinish])
    {
        CDMember *member = (CDMember *)[notification.userInfo objectForKey:@"member"];
        CDMemberCard *memberCard = (CDMemberCard *)[notification.userInfo objectForKey:@"card"];
        CDCouponCard *couponCard = (CDCouponCard *)[notification.userInfo objectForKey:@"coupon"];
        
        BOOL bFetchPriceFromServer = FALSE;
        
        if ( member == nil || member.isDefaultCustomer.boolValue)
        {
            for (CDPosProduct *product in self.data.posOperate.products)
            {
                product.product_price = [NSNumber numberWithFloat:product.product.totalPrice.floatValue];
                product.product_discount = [NSNumber numberWithFloat:10.0];
            }
            
            CGFloat totalAmount = 0.0;
            for (CDPosProduct *product in self.data.posOperate.products)
            {
                totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
            }
            self.data.posOperate.amount = [NSNumber numberWithDouble:totalAmount];
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            if (memberCard.cardID.integerValue != 0 && memberCard.cardID.integerValue != self.data.posOperate.memberCard.cardID.integerValue && memberCard.priceList.priceID.integerValue != 0)
            {
                bFetchPriceFromServer = TRUE;
            }
        }
        
        if (member.memberID.integerValue != self.data.posOperate.member.memberID.integerValue ||
            memberCard.cardID.integerValue != self.data.posOperate.memberCard.cardID.integerValue ||
            couponCard.cardID.integerValue != self.data.posOperate.couponCard.cardID.integerValue)
        {
            self.data.posOperate.member = member;
            self.data.posOperate.memberCard = memberCard;
            self.data.posOperate.couponCard = couponCard;
            [self.userSelectView reloadWithMember:self.data.posOperate.member];
            [self resetBookInfo];
            [self.data reloadPosOperate];
            [[BSCoreDataManager currentManager] save:nil];
        }
        
        if (self.data.cardItems.count != 0)
        {
            self.data.isCardItem = YES;
            if (!self.keyboardView.hidden)
            {
                self.projectView.hidden = NO;
                self.keyboardView.hidden = YES;
            }
        }
        [self.naviBar reloadTitleWithData:self.data];
        [self.naviBar reloadUserInfoWithData:self.data];
        [self.sideView reloadProjectSideViewWithData:self.data];
        [self.projectView reloadProjectViewWithData:self.data];
        
        if ( bFetchPriceFromServer )
        {
            NSMutableArray *productIds = [NSMutableArray array];
            for (CDPosProduct *product in self.data.posOperate.products)
            {
                [productIds addObject:product.product_id];
            }
            BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:productIds priceListId:memberCard.priceList.priceID];
            [request execute];
        }
    }
    else if ([notification.name isEqualToString:kUpdateLocalPosOperateNotification])
    {
        NSInteger count = [notification.userInfo[@"count"] integerValue];
        [self.naviBar reloadRemindInfoWithCount:count];
    }
    else if ([notification.name isEqualToString:kBSScanWeVIPCardCodeResult])
    {
        //[[BSScanCardManager sharedManager] fetchCardFromQRCode:@"E10092841"];
    }
    else if ([notification.name isEqualToString:kBSScanCardManagerResponse])
    {
        NSObject *card = [notification.userInfo objectForKey:@"card"];
        if (card != nil)
        {
            if ([card isKindOfClass:[CDMemberCard class]])
            {
                self.data.posOperate.memberCard = (CDMemberCard *)card;
                self.data.posOperate.member = self.data.posOperate.memberCard.member;
            }
            else if ([card isKindOfClass:[CDCouponCard class]])
            {
                self.data.posOperate.couponCard = (CDCouponCard *)card;
                self.data.posOperate.member = self.data.posOperate.couponCard.member;
            }
            [self.naviBar reloadUserInfoWithData:self.data];
            
            PadMemberAndCardViewController *viewController = [[PadMemberAndCardViewController alloc] initWithMember:self.data.posOperate.member memberCard:self.data.posOperate.memberCard couponCard:self.data.posOperate.couponCard];
            viewController.rootNaviationVC = self.navigationController;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:LS(@"扫描获取卡号失败")
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else if ([notification.name isEqualToString:kBSProjectItemPriceResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            NSDictionary *params = notification.userInfo;
            for (CDPosProduct *product in self.data.posOperate.products)
            {
                NSNumber *price = [params objectForKey:product.product_id];
                if (price != nil)
                {
                    product.product_price = price;
                    CGFloat discount = product.product_price.floatValue/product.product.totalPrice.floatValue * 10.0;
                    if (isnan(discount) || isinf(discount))
                    {
                        discount = 10.0;
                    }
                    product.product_discount = [NSNumber numberWithFloat:discount];
                }
            }
            
            CGFloat totalAmount = 0.0;
            for (CDPosProduct *product in self.data.posOperate.products)
            {
                totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
            }
            self.data.posOperate.amount = [NSNumber numberWithDouble:totalAmount];
            [[BSCoreDataManager currentManager] save:nil];
            [self.projectView reloadProjectViewWithData:self.data];
            [self.sideView reloadProjectSideViewWithData:self.data];
            
            UIViewController *viewController = [self.maskView.navi.viewControllers lastObject];
            if ([viewController isKindOfClass:[PadProjectDetailViewController class]])
            {
                PadProjectDetailViewController *detailViewController = (PadProjectDetailViewController *)viewController;
                detailViewController.needRefreshCoupon = NO;
                [detailViewController refreshProductPrice];
                detailViewController.isFromProject = YES;
            }
        }
    }
    else if ([notification.name isEqualToString:kBSPadCashierSuccess] ||
             [notification.name isEqualToString:kBSPadAllotPerformance] ||
             [notification.name isEqualToString:kBSPadGiveGiftCard] ||
             [notification.name isEqualToString:kBSCashMemberAgain])
    {
        for (CDCurrentUseItem *useItem in self.data.posOperate.useItems)
        {
            if (useItem.book != nil && useItem.book.book_id.integerValue != 0)
            {
                useItem.book.state = @"done";
            }
        }
        for (CDPosProduct *product in self.data.posOperate.products)
        {
            if (product.book != nil && product.book.book_id.integerValue != 0)
            {
                product.book.state = @"done";
            }
        }
        [[BSCoreDataManager currentManager] deleteObject:self.data.posOperate];
        [[BSCoreDataManager currentManager] save:nil];
        
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([notification.name isEqualToString:kBSPadPrinterUpdatedNotification])
    {
        NSString *string = notification.object;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:string
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if ([notification.name isEqualToString:kBSPadCodeScannerUpdatedNotification])
    {
        NSString *string = notification.object;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:string
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if ([notification.name isEqualToString:kBSPadPosMachineUpdatedNotification])
    {
        NSString *string = notification.object;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:string
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if ([notification.name isEqualToString:kBSCreateBookResponse])
    {
//        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
//        {
//            CDBook *book = [[BSCoreDataManager currentManager] findEntity:@"CDBook" withValue:notification.object forKey:@"book_id"];
//            book.isUsed = [NSNumber numberWithBool:YES];
//
//            BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
//            request.type = HandleBookType_billed;
//            [request execute];
//        }
    }
    else if ([notification.name isEqualToString:kBSEditBookResponse])
    {
//        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
//        {
//            CDBook *book = [[BSCoreDataManager currentManager] findEntity:@"CDBook" withValue:notification.object forKey:@"book_id"];
//            book.isUsed = [NSNumber numberWithBool:YES];
//        }
    }
    else if ([notification.name isEqualToString:kBSDeleteBookResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
    }
    else if ([notification.name isEqualToString:kBSPadSetPosMachineAndPayAccount])
    {
        kPadSettingViewType type = ((NSNumber *)notification.object).integerValue;
        PadSettingViewController *viewController = [[PadSettingViewController alloc] initWithViewType:type];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([notification.name isEqualToString:kBSMemberCreateResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self.maskView hidden];
            CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:notification.object forKey:@"memberID"];
            self.data.posOperate.member = member;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kBSMemberCreateResponse object:nil];
            [self.userSelectView reloadWithMember:self.data.posOperate.member];
            [self.naviBar reloadUserInfoWithData:self.data];
            
            NSString* memberCardNum = @"";
            NSString *phoneNumber = member.mobile;
            if (member.mobile.length == 0 || [member.mobile isEqualToString:@"0"])
            {
                phoneNumber = [NSString stringWithFormat:@"%d", (arc4random()%9001)+1000];
            }
            NSString *substring = [phoneNumber substringWithRange:NSMakeRange(7, 4)];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.dateFormat = @"yyyyMMdd";
            NSString* today = [dateFormat stringFromDate:[NSDate date]];
            
            memberCardNum = [NSString stringWithFormat:@"%@%@%02d", substring, [today substringFromIndex:2], arc4random()%100];
            
            if ( member.card.count > 0 )
                return;
            
            NSArray* priceLists = [[BSCoreDataManager currentManager] fetchCanUsePriceList];
            if ( priceLists.count == 0 )
                return;
            
            CDMemberPriceList *priceList = priceLists[0];
            NSDictionary *params = @{@"no":memberCardNum, @"member_id":member.memberID, @"pricelist_id":priceList.priceID, @"now_arrears_amount":@(0), @"statement_ids":@[], @"commission_ids": @[], @"invalid_date":@(NO), @"default_code":@(NO), @"remark":@(NO)};
            
            BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateCreate];
            [request execute];
            
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberDetailResponse])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kBSFetchMemberDetailResponse object:nil];
        if ( self.data.posOperate.member.card.count == 1 )
        {
            self.data.posOperate.memberCard= self.data.posOperate.member.card[0];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchPrinterScannerResponse])
    {
        NSString* result = notification.userInfo[@"result"];
        CDProjectItem* item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:result forKey:@"barcode"];
        [self didPadProjectViewItemClick:item];
    }
    else if ([notification.name isEqualToString:@"showMemberSelect"])
    {
        [self didNaviUserInfoButtonClick:nil];
    }
}

#pragma mark -
#pragma mark PadProjectViewDelegate Methods

- (void)didPadFreeCombinationCreate
{
    PadFreeCombinationCreateViewController *viewController = [[PadFreeCombinationCreateViewController alloc] init];
    viewController.maskView = self.maskView;
    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    [self.maskView addSubview:self.maskView.navi.view];
    [self.maskView show];
}

- (void)didPadProjectViewItemClick:(NSObject *)object
{
    NSObject *resultObject = nil;
    if ([object isKindOfClass:[CDProjectItem class]])
    {
        CDProjectItem *item = (CDProjectItem *)object;
        resultObject = [self.data didAddPosOperateWithProjectItem:item];//[self didPadProjectViewClickWithProjectItem:item];
        if (!self.data.posOperate.member.isDefaultCustomer.boolValue && self.data.posOperate.memberCard.priceList.priceID.integerValue != 0)
        {
            BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:@[item.itemID] priceListId:self.data.posOperate.memberCard.priceList.priceID];
            [request execute];
        }
        if ( item.bornCategory.integerValue == kPadBornCategoryProject )
        {
            if ([item.consumables_ids componentsSeparatedByString:@","].count > 0)
            {
                for (NSString *consumeId in [item.consumables_ids componentsSeparatedByString:@","]) {
                    if ([consumeId length] == 0)
                    {
                        break;
                    }
                    CDProjectConsumable *consume = [[BSCoreDataManager currentManager] findEntity:@"CDProjectConsumable" withValue:[NSNumber numberWithInt:[consumeId intValue]] forKey:@"productID"];
                    CDProjectItem *consumeItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:[consumeId intValue]] forKey:@"itemID"];
                    CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
                    useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
                    useItem.projectItem = consumeItem;
                    useItem.itemID = consumeItem.itemID;
                    useItem.itemName = consumeItem.itemName;
                    useItem.uomName = consumeItem.uomName;
                    useItem.defaultCode = consumeItem.defaultCode;
                    useItem.useCount = consume.qty;
                    //useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
                    NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.useItems];
                    [mutableSet addObject:useItem];
                    self.data.posOperate.useItems = mutableSet;
                }
            }
            if ([item.check_ids componentsSeparatedByString:@","].count > 0)
            {
                for (NSString *checkId in [item.check_ids componentsSeparatedByString:@","]) {
                    if ([checkId length] == 0)
                    {
                        break;
                    }
                    CDProjectCheck *check = [[BSCoreDataManager currentManager] findEntity:@"CDProjectCheck" withValue:[NSNumber numberWithInt:[checkId intValue]] forKey:@"productID"];
                    CDProjectItem *checkItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:[checkId intValue]] forKey:@"itemID"];
                    CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
                    useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
                    useItem.projectItem = checkItem;
                    useItem.itemID = checkItem.itemID;
                    useItem.itemName = checkItem.itemName;
                    useItem.uomName = checkItem.uomName;
                    useItem.defaultCode = checkItem.defaultCode;
                    useItem.useCount = check.qty;
                    //useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
                    //useItem.useCount = [NSNumber numberWithInteger:1];
                    NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.useItems];
                    [mutableSet addObject:useItem];
                    self.data.posOperate.useItems = mutableSet;
                }
            }
        }
        
    }
    else if ([object isKindOfClass:[PadProjectCart class]])
    {
        PadProjectCart *projectCart = (PadProjectCart *)object;
        resultObject = [self.data didAddPosOperateWithCart:projectCart];
        if (resultObject == nil && !self.data.posOperate.member.isDefaultCustomer.boolValue && self.data.posOperate.memberCard.priceList.priceID.integerValue != 0)
        {
            BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:@[projectCart.item.itemID] priceListId:self.data.posOperate.memberCard.priceList.priceID];
            [request execute];
        }
        CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:projectCart.item.itemID forKey:@"itemID"];
        if ([projectItem.consumables_ids componentsSeparatedByString:@","].count > 0)
        {
            for (NSString *consumeId in [projectItem.consumables_ids componentsSeparatedByString:@","]) {
                if ([consumeId length] == 0)
                {
                    break;
                }
                CDProjectItem *consumeItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:[consumeId intValue]] forKey:@"itemID"];
                CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
                useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
                useItem.projectItem = consumeItem;
                useItem.itemID = consumeItem.itemID;
                useItem.itemName = consumeItem.itemName;
                useItem.uomName = consumeItem.uomName;
                useItem.defaultCode = consumeItem.defaultCode;
                //useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
                useItem.useCount = [NSNumber numberWithInteger:1];
                NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.useItems];
                [mutableSet addObject:useItem];
                self.data.posOperate.useItems = mutableSet;
            }
        }
        if ([projectItem.check_ids componentsSeparatedByString:@","].count > 0)
        {
            for (NSString *checkId in [projectItem.check_ids componentsSeparatedByString:@","]) {
                if ([checkId length] == 0)
                {
                    break;
                }
                CDProjectItem *checkItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:[checkId intValue]] forKey:@"itemID"];
                CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
                useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
                useItem.projectItem = checkItem;
                useItem.itemID = checkItem.itemID;
                useItem.itemName = checkItem.itemName;
                useItem.uomName = checkItem.uomName;
                useItem.defaultCode = checkItem.defaultCode;
                //useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
                //useItem.useCount = [NSNumber numberWithInteger:1];
                NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.useItems];
                [mutableSet addObject:useItem];
                self.data.posOperate.useItems = mutableSet;
            }
        }
    }
    else if ([object isKindOfClass:[CDMemberCardProject class]])
    {
        CDMemberCardProject *cardProject = (CDMemberCardProject *)object;
        
        resultObject = [self.data didAddPosOperateWithMemberCardProject:cardProject];
        if (resultObject == nil && !self.data.posOperate.member.isDefaultCustomer.boolValue && self.data.posOperate.memberCard.priceList.priceID.integerValue != 0)
        {
            BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:@[cardProject.item.itemID] priceListId:self.data.posOperate.memberCard.priceList.priceID];
            [request execute];
        }
        CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:cardProject.projectID forKey:@"itemID"];
        if ([projectItem.consumables_ids componentsSeparatedByString:@","].count > 0)
        {
            for (NSString *consumeId in [projectItem.consumables_ids componentsSeparatedByString:@","]) {
                if ([consumeId length] == 0)
                {
                    break;
                }
                CDProjectItem *consumeItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:[consumeId intValue]] forKey:@"itemID"];
                CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
                useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
                useItem.projectItem = consumeItem;
                useItem.itemID = consumeItem.itemID;
                useItem.itemName = consumeItem.itemName;
                useItem.uomName = consumeItem.uomName;
                useItem.defaultCode = consumeItem.defaultCode;
                //useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
                useItem.useCount = [NSNumber numberWithInteger:1];
                NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.useItems];
                [mutableSet addObject:useItem];
                self.data.posOperate.useItems = mutableSet;
            }
        }
        if ([projectItem.check_ids componentsSeparatedByString:@","].count > 0)
        {
            for (NSString *checkId in [projectItem.check_ids componentsSeparatedByString:@","]) {
                if ([checkId length] == 0)
                {
                    break;
                }
                CDProjectItem *checkItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:[checkId intValue]] forKey:@"itemID"];
                CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
                useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
                useItem.projectItem = checkItem;
                useItem.itemID = checkItem.itemID;
                useItem.itemName = checkItem.itemName;
                useItem.uomName = checkItem.uomName;
                useItem.defaultCode = checkItem.defaultCode;
                //useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
                //useItem.useCount = [NSNumber numberWithInteger:1];
                NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.useItems];
                [mutableSet addObject:useItem];
                self.data.posOperate.useItems = mutableSet;
            }
        }
    }
    else if ([object isKindOfClass:[CDCouponCardProduct class]])
    {
        CDCouponCardProduct *couponProduct = (CDCouponCardProduct *)object;
        resultObject = [self.data didAddPosOperateWithCouponCardProduct:couponProduct];
        if (resultObject == nil && !self.data.posOperate.member.isDefaultCustomer.boolValue && self.data.posOperate.memberCard.priceList.priceID.integerValue != 0)
        {
            BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:@[couponProduct.item.itemID] priceListId:self.data.posOperate.memberCard.priceList.priceID];
            [request execute];
        }
    }
    
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
    if ([resultObject isKindOfClass:[CDPosProduct class]])
    {
        CDPosProduct *product = (CDPosProduct *)resultObject;
        if (product.product_qty.integerValue == 1 && ( product.product.bornCategory.integerValue == kPadBornCategoryProject || [PersonalProfile currentProfile].isYiMei.boolValue ) )
        {
            [self didProjectSideCellClick:product];
        }
    }
    else if ([resultObject isKindOfClass:[CDCurrentUseItem class]])
    {
        CDCurrentUseItem *useItem = (CDCurrentUseItem *)resultObject;
        if (useItem.useCount.integerValue == 1 && useItem.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            [self didProjectSideUseItemClick:useItem];
        }
    }
}

- (void)refreshItems
{
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
}

- (void)didPadProjectViewItemClickGuadan:(NSObject *)object
{
    NSObject *resultObject = nil;
    if ([object isKindOfClass:[CDProjectItem class]])
    {
        CDProjectItem *item = (CDProjectItem *)object;
        resultObject = [self didPadProjectViewClickWithProjectItem:item];
        if (!self.data.posOperate.member.isDefaultCustomer.boolValue && self.data.posOperate.memberCard.priceList.priceID.integerValue != 0)
        {
            BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:@[item.itemID] priceListId:self.data.posOperate.memberCard.priceList.priceID];
            [request execute];
        }
    }
    else if ([object isKindOfClass:[PadProjectCart class]])
    {
        PadProjectCart *projectCart = (PadProjectCart *)object;
        resultObject = [self.data didAddPosOperateWithCart:projectCart];
        if (resultObject == nil && !self.data.posOperate.member.isDefaultCustomer.boolValue && self.data.posOperate.memberCard.priceList.priceID.integerValue != 0)
        {
            BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:@[projectCart.item.itemID] priceListId:self.data.posOperate.memberCard.priceList.priceID];
            [request execute];
        }
    }
    else if ([object isKindOfClass:[CDMemberCardProject class]])
    {
        CDMemberCardProject *cardProject = (CDMemberCardProject *)object;
        
        resultObject = [self.data didAddPosOperateWithMemberCardProject:cardProject];
        if (resultObject == nil && !self.data.posOperate.member.isDefaultCustomer.boolValue && self.data.posOperate.memberCard.priceList.priceID.integerValue != 0)
        {
            BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:@[cardProject.item.itemID] priceListId:self.data.posOperate.memberCard.priceList.priceID];
            [request execute];
        }
    }
    else if ([object isKindOfClass:[CDCouponCardProduct class]])
    {
        CDCouponCardProduct *couponProduct = (CDCouponCardProduct *)object;
        resultObject = [self.data didAddPosOperateWithCouponCardProduct:couponProduct];
        if (resultObject == nil && !self.data.posOperate.member.isDefaultCustomer.boolValue && self.data.posOperate.memberCard.priceList.priceID.integerValue != 0)
        {
            BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:@[couponProduct.item.itemID] priceListId:self.data.posOperate.memberCard.priceList.priceID];
            [request execute];
        }
    }
    
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
}

- (NSObject *)didPadProjectViewClickWithProjectItem:(CDProjectItem *)item
{
    for (NSObject *object in self.data.cardItems)
    {
        if ([object isKindOfClass:[PadProjectCart class]])
        {
            PadProjectCart *cart = (PadProjectCart *)object;
            if (cart.item.itemID.integerValue == item.itemID.integerValue)
            {
                return [self.data didAddPosOperateWithCart:cart];
            }
        }
        else if ([object isKindOfClass:[CDMemberCardProject class]])
        {
            CDMemberCardProject *project = (CDMemberCardProject *)object;
            if (project.item.itemID.integerValue == item.itemID.integerValue)
            {
                return [self.data didAddPosOperateWithMemberCardProject:project];
            }
        }
        else if ([object isKindOfClass:[CDCouponCardProduct class]])
        {
            CDCouponCardProduct *product = (CDCouponCardProduct *)object;
            if (product.item.itemID.integerValue == item.itemID.integerValue)
            {
                return [self.data didAddPosOperateWithCouponCardProduct:product];
            }
        }
    }
    
    return [self.data didAddPosOperateWithProjectItem:item];
}


#pragma mark -
#pragma mark PadProjectHeaderViewDelegate Methods

- (void)didProjectItemSearchBarBeginEditing
{
    self.data.isDefaultCode = YES;
}

- (void)didProjectItemSearchBarCancelButtonClick
{
    self.data.isDefaultCode = NO;
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
}

- (void)didProjectItemSearchBarSearch:(NSString *)keyword
{
    if (keyword.length == 0)
    {
        [self.projectView reloadProjectViewWithData:self.data];
        return;
    }
    [self.data reloadProjectItemWithKeyword:keyword];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
}

- (void)didProjectItemSearchBarTextChanged:(NSString *)keyword
{
    if (keyword.length == 0)
    {
        return;
    }
    [self.data reloadProjectItemWithKeyword:keyword];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
}


#pragma mark -
#pragma mark PadProjectSideViewDelegate Methods

- (void)didProjectSideCellClick:(CDPosProduct *)product
{
    [self hideFastInput];
    PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithPosProduct:product detailType:kPadProjectDetailCurrentCashier];
    viewController.isFromProject = YES;
    viewController.delegate = self;
    viewController.maskView = self.maskView;
    viewController.member = self.data.posOperate.member;
    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    [self.maskView addSubview:self.maskView.navi.view];
    [self.maskView show];
}

- (void)didProjectSideCellDelete:(CDPosProduct *)product
{
    if (product.book)
    {
        product.book.isUsed = @(NO);
        BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:product.book];
        if (product.book.is_reservation_bill.boolValue)
        {
            request.type = HandleBookType_delete;
        }
        else
        {
            request.type = HandleBookType_approved;
        }
        [request execute];
    }
    product.operate.couponCard.remainAmount = [NSNumber numberWithFloat:product.coupon_deduction.floatValue + product.operate.couponCard.remainAmount.floatValue];
    NSLog(@"%f,%f",product.point_deduction.floatValue,product.operate.memberCard.points.floatValue);
    product.operate.memberCard.points = [NSString stringWithFormat:@"%.0f",product.point_deduction.floatValue + product.operate.memberCard.points.floatValue];
    NSLog(@"%@",product.operate.memberCard.points);
    [[BSCoreDataManager currentManager] save:nil];
    NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.products];
    [mutableSet removeObject:product];
    self.data.posOperate.products = mutableSet;
    
    [self.data reloadPosOperate];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
}

- (void)didProjectSideUseItemClick:(CDCurrentUseItem *)useItem
{
    PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithUseItem:useItem];
    viewController.isFromProject = YES;
    viewController.delegate = self;
    viewController.maskView = self.maskView;
    viewController.member = self.data.posOperate.member;
    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    [self.maskView addSubview:self.maskView.navi.view];
    [self.maskView show];
}

- (void)didProjectSideUseItemDelete:(CDCurrentUseItem *)useItem
{
    if (useItem.book.is_reservation_bill.boolValue)
    {
        BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:useItem.book];
        request.type = HandleBookType_delete;
        [request execute];
    }
    
    NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.useItems];
    [mutableSet removeObject:useItem];
    self.data.posOperate.useItems = mutableSet;
   
    [self.data reloadPosOperate];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
}

- (void)didProjectSideSettleButtonClick:(CDPosOperate *)operate
{
    if (self.data.posOperate.products.count == 0 && self.data.posOperate.useItems.count == 0)
    {
        return;
    }
    
    if (self.data.posOperate.member.isDefaultCustomer.boolValue)
    {
        BOOL isCourses = NO;
        for (int i = 0; i < self.data.posOperate.products.count; i++)
        {
            CDPosBaseProduct *product = [self.data.posOperate.products objectAtIndex:i];
            if ( product.product.bornCategory.integerValue == kPadBornCategoryCourses || product.product.bornCategory.integerValue == kPadBornCategoryPackage || product.product.bornCategory.integerValue == kPadBornCategoryPackageKit)
            {
                isCourses = YES;
                break;
            }
        }
        
        if (isCourses)
        {
            UIImage *image = [UIImage imageNamed:@"select_member_card_1"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - image.size.width)/2.0, (IC_SCREEN_HEIGHT - image.size.height)/2.0, image.size.width, image.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = image;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.frame = CGRectMake(18.0, 274.0, 298.0, 60.0);
            [button addTarget:self action:@selector(didSelectMemberCard:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            [self.maskView addSubview:imageView];
            [self.maskView show];
            
            return;
        }
    }
    
    if (!self.data.posOperate.member.isDefaultCustomer.boolValue && self.data.posOperate.memberCard == nil && self.data.posOperate.couponCard == nil )
    {
        if (self.data.posOperate.member.card.count == 1)
        {
            self.data.posOperate.memberCard = [self.data.posOperate.member.card objectAtIndex:0];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:@"select_member_card_2"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - image.size.width)/2.0, (IC_SCREEN_HEIGHT - image.size.height)/2.0, image.size.width, image.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = image;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.frame = CGRectMake(18.0, 274.0, 298.0, 60.0);
            [button addTarget:self action:@selector(didSelectMemberCard:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            [self.maskView addSubview:imageView];
            [self.maskView show];
        }
        
        return;
    }
    
    if (self.data.posOperate.member.isDefaultCustomer.boolValue)
    {
        if (self.data.posOperate.member.card.count != 0)
        {
            self.data.posOperate.memberCard = [self.data.posOperate.member.card objectAtIndex:0];
        }
    }
    
    if ( self.orignalOperateID.integerValue == 0 && [[PersonalProfile currentProfile].isYiMei boolValue] && !self.data.posOperate.firstKeshi )
    {
        BOOL bShowAlert = FALSE;
        for (int i = 0; i < self.data.posOperate.products.count; i++)
        {
            CDPosProduct *product = (CDPosProduct *)[self.data.posOperate.products objectAtIndex:i];
            
            if ( product.product.bornCategory.integerValue == kPadBornCategoryProject && product.product.category.departments_id.integerValue == 0 && [self isMultiKeshi])
            {
                if (product.product.departments_id != nil) {
                    if ([product.product.departments_id intValue] != 0)
                    {
                        continue;
                    }
                }
                NSLog(@"%@",product.product);
                NSLog(@"%@",product.product.category);
                bShowAlert = TRUE;
                break;
            }
            else if ( product.product.bornCategory.integerValue == kPadBornCategoryProject && ![self isMultiKeshi])
            {
                bShowAlert = TRUE;
                break;
            }
        }
        
        for (int i = 0; i < self.data.posOperate.useItems.count; i++)
        {
            CDCurrentUseItem *useItem = [self.data.posOperate.useItems objectAtIndex:i];
            if ( useItem.projectItem.bornCategory.integerValue == kPadBornCategoryProject && useItem.projectItem.category.departments_id.integerValue == 0 && [self isMultiKeshi])
            {
                bShowAlert = TRUE;
                break;
            }
            else if ( useItem.projectItem.bornCategory.integerValue == kPadBornCategoryProject && ![self isMultiKeshi])
            {
                bShowAlert = TRUE;
                break;
            }
        }
        
        if ( bShowAlert )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请先去选择科室" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            v.tag = 9999;
            v.delegate = self;
            [v show];
            return;
        }
    }
    else if ( self.data.posOperate.useItems.count > 0 )
    {
        BOOL bShowAlert = FALSE;
        NSArray *arr = [self.data.posOperate.departmentids componentsSeparatedByString:@","];
        for (int i = 0; i < arr.count; i++)
        {
            if ([arr[i] intValue] == 0 )
            {
                bShowAlert = TRUE;
            }
        }
        if ( bShowAlert )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请先去选择科室" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            v.delegate = self;
            v.tag = 9999;
            return;
        }
    }
    
    NSArray *departIDArray = [self.data.posOperate.departmentids componentsSeparatedByString:@","];
    for (NSString *departId in departIDArray)
    {
        if ([departId isEqualToString:@"0"]) {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请先去选择科室" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            v.delegate = self;
            v.tag = 9999;
            return;
        }
    }
    
    for (int i = 0; i < self.data.posOperate.products.count; i++)
    {
        CDPosProduct *product = (CDPosProduct *)[self.data.posOperate.products objectAtIndex:i];
        
        CGFloat minPrice = [product.product.minPrice doubleValue];
        CGFloat maxPrice = [product.product.maxPrice doubleValue];
        if ( minPrice > 0.01 )
        {
            if ( [product.product_price doubleValue] < minPrice )
            {
                UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@的最小价格是%.02f",product.product_name, minPrice] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [v show];
                return;
            }
        }
        
        if ( maxPrice > 0.01 )
        {
            if ( [product.product_price doubleValue] > maxPrice )
            {
                UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@的最大价格是%.02f",product.product_name, maxPrice] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [v show];
                return;
            }
        }
    }
    
    BOOL bShowAlert = TRUE;
    for (int i = 0; i < self.data.posOperate.products.count; i++)
    {
        CDPosProduct *product = (CDPosProduct *)[self.data.posOperate.products objectAtIndex:i];
        
        if ( product.product.bornCategory.integerValue == kPadBornCategoryProject )
        {
            bShowAlert = FALSE;
            break;
        }
    }
    
    for (int i = 0; i < self.data.posOperate.useItems.count; i++)
    {
        CDCurrentUseItem *useItem = [self.data.posOperate.useItems objectAtIndex:i];
        if ( useItem.projectItem.bornCategory.integerValue == kPadBornCategoryProject )
        {
            bShowAlert = FALSE;
            break;
        }
    }
    
    if ( bShowAlert )
    {
        WeakSelf;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"您还没有选择任何服务项目, 确定去付款吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"去选服务项目" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf didNaviCardItemButtonClick:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续付款" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf goPayment:operate];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [self goPayment:operate];
}

- (void)isGuadanActive:(BOOL)isGuadan
{
    self.isGuadan = isGuadan;
}

- (void)isAddItemActive:(BOOL)isAddItem;
{
    self.isGuadanAddItem = isAddItem;
}

- (void)goPayment:(CDPosOperate *)operate
{
    [[BSCoreDataManager currentManager] save:nil];
    PadPaymentViewController *viewController = [[PadPaymentViewController alloc] initWithPosOperate:operate];
    viewController.orignalOperateID = self.data.posOperate.old_operate_id;
    viewController.maskView = self.maskView;
    viewController.isGuadan = self.isGuadan;
    viewController.isAddItem = self.isGuadanAddItem;
    viewController.outNavigationController = self.navigationController;
    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    [self.maskView addSubview:self.maskView.navi.view];
    if(!(self.isGuadanAddItem && self.isGuadan))//isGuadanAdditem 应为 isAddItem
    {
        [self.maskView show];
    }
}

- (void)didSelectMemberCard:(id)sender
{
    [self.maskView hidden];
    [self.maskView removeSubviews];
    
    PadMemberAndCardViewController *viewController = [[PadMemberAndCardViewController alloc] initWithMember:self.data.posOperate.member memberCard:self.data.posOperate.memberCard couponCard:self.data.posOperate.couponCard];
    viewController.rootNaviationVC = self.navigationController;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didProjectSideYiMeiLeftButtonPressed
{
    YimeiCreateProjectItemViewController *viewController = [[YimeiCreateProjectItemViewController alloc] initWithNibName:@"YimeiCreateProjectItemViewController" bundle:nil];
    viewController.currentCategory = self.data.currentCategory;
    viewController.maskView = self.maskView;
    
    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake((1024 - 725) / 2, 0, 725, 768);
    [self.maskView addSubview:self.maskView.navi.view];
    [self.maskView show];
}

- (void)didProjectSideYiMeiRightButtonPressed
{
    [self hideFastInput];
    if ( [self.orignalOperateID integerValue] > 0 )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"增改单不能修改科室信息" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        return;
    }
    
    NSMutableArray *prodArray = [[NSMutableArray alloc] init];
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )//&& !self.data.posOperate.firstKeshi )
    {
        BOOL bShowAlert = TRUE;
        for (int i = 0; i < self.data.posOperate.products.count; i++)
        {
            CDPosProduct *product = (CDPosProduct *)[self.data.posOperate.products objectAtIndex:i];
            
            if ( product.product.bornCategory.integerValue == kPadBornCategoryProject )
            {
                [prodArray addObject:product];
                bShowAlert = FALSE;
                //break;
            }
        }
        
        for (int i = 0; i < self.data.posOperate.useItems.count; i++)
        {
            CDCurrentUseItem *useItem = [self.data.posOperate.useItems objectAtIndex:i];
            if ( useItem.projectItem.bornCategory.integerValue == kPadBornCategoryProject )
            {
                [itemArray addObject:useItem];
                bShowAlert = FALSE;
                //break;
            }
        }
        
        if ( bShowAlert )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请先去选择项目" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            return;
        }
    }
    else
    {
        for (int i = 0; i < self.data.posOperate.products.count; i++)
        {
            CDPosProduct *product = (CDPosProduct *)[self.data.posOperate.products objectAtIndex:i];
            
            if ( product.product.bornCategory.integerValue == kPadBornCategoryProject )
            {
                [prodArray addObject:product];
                if (![self isMultiKeshi])
                {
                    break;
                }
            }
        }
        
        for (int i = 0; i < self.data.posOperate.useItems.count; i++)
        {
            CDCurrentUseItem *useItem = [self.data.posOperate.useItems objectAtIndex:i];
            if ( useItem.projectItem.bornCategory.integerValue == kPadBornCategoryProject )
            {
                [itemArray addObject:useItem];
                if (![self isMultiKeshi])
                {
                    break;
                }
            }
        }
    }
    
    if ([self isMultiKeshi])
    {
        YimeiCreateMultiKeshiViewController *viewController = [[YimeiCreateMultiKeshiViewController alloc] initWithNibName:@"YimeiCreateMultiKeshiViewController" bundle:nil];
        viewController.maskView = self.maskView;
        viewController.operate = self.data.posOperate;
        viewController.productArray = prodArray;
        viewController.itemArray = itemArray;
        viewController.keshiSelectFinished = ^(CDKeShi* k, CDStaff* k2)
        {
            self.data.posOperate.firstKeshi = k;
            
            self.data.posOperate.doctor_id = k2.staffID;
            self.data.posOperate.doctor_name = k2.name;
            [[BSCoreDataManager currentManager] save:nil];
        };
        
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    }
    else
    {
        YimeiCreateKeshiViewController *viewController = [[YimeiCreateKeshiViewController alloc] initWithNibName:@"YimeiCreateKeshiViewController" bundle:nil];
        viewController.maskView = self.maskView;
        viewController.operate = self.data.posOperate;
        viewController.keshiSelectFinished = ^(CDKeShi* k, CDStaff* k2)
        {
            self.data.posOperate.firstKeshi = k;
            self.data.posOperate.doctor_id = k2.staffID;
            self.data.posOperate.doctor_name = k2.name;
            [[BSCoreDataManager currentManager] save:nil];
        };
        
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    }
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake(0, 0, 725, 768);
    [self.maskView addSubview:self.maskView.navi.view];
    [self.maskView show];
}

#pragma mark -
#pragma mark PadProjectDetailViewControllerDelegate Methods

- (void)didPadPosProductDelete:(CDPosProduct *)product
{
    product.operate.couponCard.remainAmount = [NSNumber numberWithFloat:product.coupon_deduction.floatValue + product.operate.couponCard.remainAmount.floatValue];
    product.operate.memberCard.points = [NSString stringWithFormat:@"%.0f",product.point_deduction.floatValue + product.operate.memberCard.points.floatValue];
    [[BSCoreDataManager currentManager] save:nil];
    NSMutableOrderedSet *mutableOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.products];
    [mutableOrderedSet removeObject:product];
    self.data.posOperate.products = mutableOrderedSet;
    
    [self.data reloadPosOperate];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
}

- (void)didPadPosProductConfirm:(CDPosProduct *)product
{
    [self.data reloadPosOperate];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
}

- (void)didUseItemDelete:(CDCurrentUseItem *)useItem
{
    if (useItem.book)
    {
        useItem.book.isUsed = @(NO);
        if (useItem.book.is_reservation_bill.boolValue)
        {
            BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:useItem.book];
            request.type = HandleBookType_delete;
            [request execute];
        }
    }
    
    NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.useItems];
    [mutableSet removeObject:useItem];
    self.data.posOperate.useItems = mutableSet;
    [self.data reloadPosOperate];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
}

- (void)didUseItemEditConfirm:(CDCurrentUseItem *)useItem
{
    [self.data reloadPosOperate];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
}


#pragma mark -
#pragma mark PadProjectNaviViewDelegate Methods

- (void)didNaviBackButtonClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kPadSelectMemberAndCardFinish object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kBSPadCashierSuccess object:nil];
    self.fastInputView.hidden = YES;
    [self.fastInputView removeFromSuperview];
    if (self.isGuadanAddItem)
    {
        [[BSCoreDataManager currentManager] deleteObject:self.data.posOperate];
        self.data.posOperate = nil;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.data.posOperate.localUpdateDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"storeID = %@ && isDefaultCustomer", storeID]];
    if (self.data.posOperate.member.memberID.integerValue == member.memberID.integerValue && self.data.posOperate.products.count == 0 && self.data.posOperate.restaurant_table == nil )
    {
        self.data.posOperate.book.isUsed = [NSNumber numberWithBool:NO];
        [[BSCoreDataManager currentManager] deleteObject:self.data.posOperate];
        self.data.posOperate = nil;
    }
    
    if ( [self.orignalOperateID integerValue] > 0 )
    {
        [[BSCoreDataManager currentManager] deleteObject:self.data.posOperate];
        self.data.posOperate = nil;
    }
    
    [[BSCoreDataManager currentManager] save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    if ( self.delegate )
    {
        [self.delegate didPadProjectViewControllerMenuButtonPressed:self.data.posOperate];
    }
}

- (void)didNaviTitleButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIButton *button = (UIButton *)sender;
    UIView *parentView = button.superview;
    [self.typePopover presentPopoverFromRect:CGRectMake(parentView.frame.origin.x + button.frame.origin.x + button.frame.size.width/2.0, button.frame.origin.y + button.frame.size.height, 0.0, 0.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
    
    if ( [PersonalProfile currentProfile].isYiMei.boolValue )
    {
        //[self performSelector:@selector(delayToShowNextNavi) withObject:nil afterDelay:0.5];
        //[self delayToShowNextNavi];
    }
}

- (void)delayToShowNextNavi
{
    [self.typeViewController tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0    ]];
}

- (void)didNaviCardItemButtonClick:(id)sender
{
    if (!self.keyboardView.hidden)
    {
        self.projectView.hidden = NO;
        self.keyboardView.hidden = YES;
    }
    
    self.data.isCardItem = YES;
    self.data.isCustomPrice = NO;
    [self.projectView reloadProjectViewWithData:self.data];
}

- (void)didNaviKeyboardButtonClick:(id)sender
{
    UIButton *keyboardButton = (UIButton *)sender;
    if (self.keyboardView.hidden)
    {
        self.projectView.hidden = YES;
        self.keyboardView.hidden = NO;
        self.data.isCustomPrice = YES;
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"pad_project_keyboard_h"] forState:UIControlStateNormal];
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"pad_project_keyboard_n"] forState:UIControlStateHighlighted];
    }
    else
    {
        self.projectView.hidden = NO;
        self.keyboardView.hidden = YES;
        self.data.isCustomPrice = NO;
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"pad_project_keyboard_n"] forState:UIControlStateNormal];
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"pad_project_keyboard_h"] forState:UIControlStateHighlighted];
    }
    [self.naviBar reloadTitleWithData:self.data];
}

- (void)didNaviUserInfoButtonClick:(id)sender
{
    [self didPadProjectUserSelectButtonClick:kProjectSelectMember];
}

- (void)didNaviDeleteMemberInfoButtonClick:(id)sender
{
    for (CDPosProduct *product in self.data.posOperate.products)
    {
        product.operate.couponCard.remainAmount = [NSNumber numberWithFloat:product.coupon_deduction.floatValue + product.operate.couponCard.remainAmount.floatValue];
        product.operate.memberCard.points = [NSString stringWithFormat:@"%.0f",product.point_deduction.floatValue + product.operate.memberCard.points.floatValue];
    }
    self.data.posOperate.member = nil;
    self.data.posOperate.memberCard = nil;
    self.data.posOperate.couponCard = nil;
    NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    self.data.posOperate.member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"storeID = %@ && isDefaultCustomer", storeID]];
    
    for (CDPosProduct *product in self.data.posOperate.products)
    {
        product.product_price = [NSNumber numberWithFloat:product.product.totalPrice.floatValue];
        product.product_discount = [NSNumber numberWithFloat:10.0];
        product.point_deduction = [NSNumber numberWithFloat:0.0];
        product.coupon_deduction = [NSNumber numberWithFloat:0.0];
        product.coupon_id = nil;
    }
    CGFloat totalAmount = 0.0;
    for (CDPosProduct *product in self.data.posOperate.products)
    {
        totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
    }
    self.data.posOperate.amount = [NSNumber numberWithDouble:totalAmount];
    [[BSCoreDataManager currentManager] save:nil];
    
    [self.data reloadPosOperate];
    [self.naviBar reloadTitleWithData:self.data];
    [self.naviBar reloadUserInfoWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
}


#pragma mark -
#pragma mark PadProjectKeyboardViewDelegate Methods

- (void)addServiceWithAmount:(CGFloat)amount
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:profile.defaultProductId forKey:@"itemID"];
    BOOL isExist = NO;
    for (CDPosProduct *product in self.data.posOperate.products)
    {
        if (product.product_id.integerValue == item.itemID.integerValue)
        {
            isExist = YES;
            amount += product.product_price.floatValue;
            product.product_name = item.itemName;
            product.product_price = [NSNumber numberWithFloat:amount];
            product.product_discount = [NSNumber numberWithFloat:10.0];
            product.money_total = [NSNumber numberWithFloat:amount];
            break;
        }
    }
    
    if (!isExist)
    {
        CDPosProduct *product = [[BSCoreDataManager currentManager] insertEntity:@"CDPosProduct"];
        product.product = item;
        product.product_id = item.itemID;
        product.product_name = item.itemName;
        product.defaultCode = item.defaultCode;
        product.product_price = [NSNumber numberWithFloat:amount];
        product.product_qty = [NSNumber numberWithInteger:1];
        product.product_discount = [NSNumber numberWithFloat:10.0];
        product.money_total = [NSNumber numberWithFloat:amount];
        product.imageUrl = item.imageUrl;
        product.imageSmallUrl = item.imageSmallUrl;
        NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.products];
        [orderedSet addObject:product];
        self.data.posOperate.products = orderedSet;
    }
    
    CGFloat totalAmount = 0.0;
    for (CDPosProduct *product in self.data.posOperate.products)
    {
        totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
    }
    self.data.posOperate.amount = [NSNumber numberWithDouble:totalAmount];
    [[BSCoreDataManager currentManager] save:nil];
    
    [self.data reloadPosOperate];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.sideView reloadProjectSideViewWithData:self.data];
}

- (void)didKeyboardViewClose:(PadProjectKeyboardView *)keyboardView
{
    self.projectView.hidden = NO;
    self.keyboardView.hidden = YES;
    self.data.isCustomPrice = NO;
    [self.naviBar reloadTitleWithData:self.data];
}


#pragma mark -
#pragma mark PadProjectUserSelectViewDelegate Methods

- (void)didPadProjectUserSelectButtonClick:(kProjectSelectUserType)type
{
    if (type == kProjectSelectMember || type == kProjectAddGiftCardVouchers)
    {
        PadMemberAndCardViewController *viewController = [[PadMemberAndCardViewController alloc] initWithMember:self.data.posOperate.member memberCard:self.data.posOperate.memberCard couponCard:self.data.posOperate.couponCard];
        viewController.rootNaviationVC = self.navigationController;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (type == kProjectAddHandGrade)
    {
//        kPadTextInputType inputType = kPadTextInputHandNum;
//        if (type == kProjectAddHandGrade)
//        {
//            inputType = kPadTextInputHandNum;
//        }
//        else if (type == kProjectAddGiftCardVouchers)
//        {
//            inputType = kPadTextInputCouponNum;
//        }
//        
//        PadTextInputViewController *viewController = [[PadTextInputViewController alloc] initWithType:inputType];
//        viewController.delegate = self;
//        viewController.maskView = self.maskView;
//        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
//        self.maskView.navi.navigationBarHidden = YES;
//        self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
//        [self.maskView addSubview:self.maskView.navi.view];
//        [self.maskView show];
    }
}


#pragma mark -
#pragma mark PadProjectTypeViewControllerDelegate Methods

- (void)didProjectViewSelectCustomPrice
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.typePopover dismissPopoverAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.keyboardView.hidden)
            {
                self.projectView.hidden = YES;
                self.keyboardView.hidden = NO;
                self.data.isCustomPrice = YES;
                [self.naviBar reloadTitleWithData:self.data];
            }
        });
    });
}
#pragma mark ???
- (void)didProjectViewSelectWithBornCategory:(CDBornCategory *)bornCategory hidden:(BOOL)hidden
{
    if (!self.keyboardView.hidden)
    {
        self.projectView.hidden = NO;
        self.keyboardView.hidden = YES;
    }
    
    self.data.isCardItem = NO;
    self.data.isCustomPrice = NO;
    self.data.bornCategory = bornCategory;
    [self.data setCurrentCategory:nil];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    
    if (hidden)
    {
        [self.typePopover dismissPopoverAnimated:YES];
        return;
    }
#if 0
    BOOL isExist = NO;
    NSArray *categories = [[BSCoreDataManager currentManager] fetchTopProjectCategory];
    for (NSInteger i = 0; i < categories.count; i++)
    {
        CDProjectCategory *category = [categories objectAtIndex:i];
        if (category.itemCount.integerValue != 0)
        {
            isExist = YES;
            break;
        }
    }
    
    if (!isExist)
    {
        [self.typePopover dismissPopoverAnimated:YES];
    }
#endif
}


#pragma mark -
#pragma mark PadCategoryViewControllerDelegate Methods

- (void)didPadCategoryBack
{
    [self.data setCurrentCategory:nil];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
}

- (void)didPadCategorySubTotalSelect
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:nil];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
}

- (void)didPadCategoryCellSelect:(CDProjectCategory *)category
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    if (self.data.currentCategory.subCategory.count == 0)
    {
        [self.typePopover dismissPopoverAnimated:YES];
    }
}

- (void)didPadCategorySubOtherSelect
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:nil];
    [self.data reloadOnlyParantProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark PadSubCategoryViewControllerDelegate Methods

- (void)didPadSubCategoryBack:(CDProjectCategory *)category
{
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
}

- (void)didPadSubCategorySubTotalSelect:(CDProjectCategory *)category
{
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
}

- (void)didPadSubCategoryCellSelect:(CDProjectCategory *)category
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    if (self.data.currentCategory.subCategory.count == 0)
    {
        [self.typePopover dismissPopoverAnimated:YES];
    }
}

- (void)didPadSubCategorySubOtherSelect:(CDProjectCategory *)category
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:category];
    [self.data reloadOnlyParantProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark PadReserveViewControllerDelegate Methods

- (void)didPadReserveConfirm:(CDBook *)book
{
    CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:book.member_id forKey:@"memberID"];
    if (member)
    {
        self.data.posOperate.member = member;
        [self.naviBar reloadUserInfoWithData:self.data];
    }
    else if (book.member_id.integerValue != 0)
    {
        member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
        member.memberID = book.member_id;
        member.memberName = book.member_name;
        [[BSCoreDataManager currentManager] save:nil];
        
        BSFetchMemberDetailRequest *request = [[BSFetchMemberDetailRequest alloc] initWithMember:member];
        [request execute];
    }
    else if (book.member_id.integerValue == 0)
    {
        member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:@(YES) forKey:@"isDefaultCustomer"];
    }
    
    self.data.posOperate.member = member;
    [self.naviBar reloadUserInfoWithData:self.data];
    
    if ( book.product_ids.length > 0 )
    {
        NSArray* bookProductIDs = [book.product_ids componentsSeparatedByString:@","];
        for ( NSArray* product_id in bookProductIDs )
        {
            CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product_id forKey:@"itemID"];
            if (item)
            {
                CDPosProduct *product = [[BSCoreDataManager currentManager] insertEntity:@"CDPosProduct"];
                product.product = item;
                product.product_id = item.itemID;
                product.product_name = item.itemName;
                product.lastUpdate = item.lastUpdate;
                product.defaultCode = item.defaultCode;
                product.category_id = item.categoryID;
                product.category_name = item.categoryName;
                product.product_price = item.totalPrice;
                product.product_qty = [NSNumber numberWithInteger:1];
                product.product_discount = [NSNumber numberWithFloat:10.0];
                product.imageUrl = item.imageUrl;
                product.imageSmallUrl = item.imageSmallUrl;
                product.book = book;
                product.money_total = @(product.product_price.floatValue * product.product_qty.floatValue);
                NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.data.posOperate.products];
                [orderedSet addObject:product];
                self.data.posOperate.products = orderedSet;
                self.data.posOperate.amount = @(self.data.posOperate.amount.doubleValue + product.product_price.doubleValue);
                [[BSCoreDataManager currentManager] save:nil];
                
                [self.data reloadProjectItem];
                [self.projectView reloadProjectViewWithData:self.data];
                [self.sideView reloadProjectSideViewWithData:self.data];
            }
        }
    }
    
    self.data.posOperate.book = book;
    self.data.posOperate.book.isUsed = [NSNumber numberWithBool:YES];
    
//    BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
//    request.type = HandleBookType_billed;
//    [request execute];
}


#pragma mark -
#pragma mark PadNumberKeyboardDelegate Methods

- (void)didPadNumberKeyboardDonePressed:(UITextField*)textField
{
    [self didTextFieldEditDone:textField];
}

- (void)didTextFieldEditDone:(UITextField *)textField
{
    UIViewController *viewController = [self.maskView.navi.viewControllers lastObject];
    if ([viewController isKindOfClass:[PadPaymentViewController class]])
    {
        PadPaymentViewController *paymentViewController = (PadPaymentViewController *)viewController;
        [paymentViewController didTextFieldEditDone:textField];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9999)
    {
        [self didProjectSideYiMeiRightButtonPressed];
    }
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
