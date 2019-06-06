//
//  HomeViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/3/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "BSFetchMemberRequest.h"
#import "MemberViewController.h"
#import "HomeViewController.h"
#import "HomeItemsTableViewCell.h"
#import "ProjectViewController.h"
#import "StaffManagerViewController.h"
#import "StaffViewController.h"
#import "MemberManageViewController.h"
#import "BSFetchStaffRequest.h"
#import "CBWebViewController.h"
#import "PurchaseViewController.h"
#import "HomeBannerTableViewCell.h"
#import "BSFetchStoreListRequest.h"
#import "BSCommonSelectedItemViewController.h"
#import "NSData+Additions.h"
#import "FetchHomeAdvertisementReqeust.h"
#import "HomeCountDataManager.h"
#import "HomeTodayIncomeViewController.h"
#import "PanDianViewController.h"
#import "HomePassengerFlowViewController.h"
#import "HomeMyTodayIncomeViewController.h"
#import "PurchaseOrderViewController.h"
#import "MessageViewController.h"
#import "productProjectMainController.h"
#import "GuadanViewController.h"
#import "HomePopSelectedStoreView.h"
#import "HistoryOperateViewController.h"
#import "BSSuccessViewController.h"
#import "PosOperateDetailViewController.h"
#import "PhoneGiveViewController.h"

typedef enum HomeTableviewItems
{
    HomeTableviewItems_Member = 1,  //会员管理
    HomeTableviewItems_Staff,       //员工管理
    HomeTableviewItems_Project,     //产品项目
    HomeTableviewItems_Pie,         //报表
    HomeTableviewItems_Cash,        //收银
    HomeTableviewItems_Guadan,      //挂单
    HomeTableviewItems_Stock,       //仓库管理
    HomeTableviewItems_Purchase,    //采购管理
    HomeTableviewItems_Appointment, //预约
    HomeTableviewItems_Attendance,  //考勤打卡
    HomeTableviewItems_Leave,       //请假
    HomeTableviewItems_MyMoney,     //我的提成
    HomeTableviewItems_Monitor,     //门店监控
    HomeTableviewItems_Tuoke,       //拓客
    HomeTableviewItems_HuliFanKui,  //护理反馈
    HomeTableviewItems_HistoryPos   //历史单据
}HomeTableviewItems;

typedef enum HomeTableviewSection
{
    HomeTableviewSection_WebView,
    HomeTableviewSection_Items,
    HomeTableviewSection_Count
}HomeTableviewSection;

@interface HomeItemsObject :NSObject
@property(nonatomic)SEL function;
@property(nonatomic)HomeTableviewItems itemIndex;
@property(nonatomic, strong)NSString* imageName;
@end

@implementation HomeItemsObject
@end

@interface HomeViewController ()<HomeItemsTableViewCellDelegate,HomeBannerTableViewCellDelegate,BSCommonSelectedItemViewControllerDelegate,HomeSelectedStoreDelegate>
{
    CGFloat sectionItemsHeight;
}
@property(nonatomic, weak)IBOutlet UITableView* homeTableview;
@property(nonatomic, strong)NSMutableArray* itemsArray;
@property(nonatomic, strong)PersonalProfile* profile;
@property(nonatomic, strong)UILabel *storeLabel;
@property(nonatomic, strong)UIImageView *arrowImgView;
@property(nonatomic, strong)UIView *titleView;
@property(nonatomic, strong)UIButton *button;
@property(nonatomic, strong)CDStore *store;
@property(nonatomic, strong)HomePopSelectedStoreView *selectedStoreView;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNofitificationForMainThread:kBSLoginResponse];
    [self registerNofitificationForMainThread:kBSUpdatePersonalInfoResponse];
    [self registerNofitificationForMainThread:kFetchUnReadMessageResponse];
    [self registerNofitificationForMainThread:kBSMemberCashierSuccess];
    
    [self registerNofitificationForMainThread:kPushToCashier];
    [self registerNofitificationForMainThread:kPushToAssign];
    [self registerNofitificationForMainThread:kPushToGive];
    
    sectionItemsHeight = IC_SCREEN_WIDTH / 320 * 84;

    
    self.selectedStoreView = [HomePopSelectedStoreView createView];
    self.selectedStoreView.delegate = self;

    [self reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationController.navigationBarHidden = false;
    [self setNaviBackButtonItem];
    [self setNaviTitle];
}

- (void)setNaviTitle
{
    self.titleView = [[UIView alloc] init];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    
    self.store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:storeID forKey:@"storeID"];
    
    self.storeLabel = [[UILabel alloc] init];
    self.storeLabel.backgroundColor = [UIColor clearColor];
    self.storeLabel.textColor = [UIColor whiteColor];
    self.storeLabel.font = [UIFont boldSystemFontOfSize:17];
    self.storeLabel.text = (self.store.storeName.length > 0 ) ? [NSString stringWithFormat:@"%@",self.store.storeName] : @"";
    [self.titleView addSubview:self.storeLabel];
    
    UIImage *image = [UIImage imageNamed:@"sale_selected_member_arrow.png"];
    self.arrowImgView = [[UIImageView alloc] initWithImage:image];
    [self.titleView addSubview:self.arrowImgView];
    self.arrowImgView.hidden = ( self.storeLabel.text.length == 0 || profile.shopIds.count < 2) ? YES : NO;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.button addTarget:self action:@selector(didSelectedStoreBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.button.hidden = self.arrowImgView.hidden;
    
    [self.titleView addSubview:self.button];
    
    [self reloadNaviTitleView];
}

- (void)reloadNaviTitleView
{
    self.storeLabel.text = (self.store.storeName.length > 0 ) ? [NSString stringWithFormat:@"%@",self.store.storeName] : @"";
    
    CGSize size = [self.storeLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(280, 25) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat totalLength = size.width + (self.arrowImgView.hidden ? 0 : self.self.arrowImgView.frame.size.width) + 2;
    
    self.titleView.frame = CGRectMake(0, 0, totalLength, 44);
    
    self.storeLabel.frame = CGRectMake(0, (44 - size.height)/2.0, size.width, size.height);
    
    CGRect frame = self.arrowImgView.frame;
    frame.origin.x = self.storeLabel.frame.origin.x + self.storeLabel.frame.size.width + 6;
    frame.origin.y = (44 - frame.size.height)/2.0;
    self.arrowImgView.frame = frame;
    
    self.button.frame = self.titleView.bounds;
    
    self.tabBarController.navigationItem.titleView = self.titleView;
}

- (void)setNaviBackButtonItem
{
    BNBackButtonItem *leftButtonItem = nil;
    if ( [[BSCoreDataManager currentManager] fetchMessageLastCreateTime].length > 0 )
    {
        if ([[BSCoreDataManager currentManager] fetchUnReadMessage].count > 0)
        {
            leftButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_news_exist_n"] highlightedImage:[UIImage imageNamed:@"navi_news_exist_h"]];
        }
        else
        {
            leftButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_news_n"] highlightedImage:[UIImage imageNamed:@"navi_news_h"]];
        }
    }
    leftButtonItem.delegate = self;
    self.tabBarController.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)didBackBarButtonItemClick:(id)sender
{
    MessageViewController *viewController = [[MessageViewController alloc] initWithNibName:NIBCT(@"MessageViewController") bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSLoginResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            [self reloadData];
        }
    }
    else if ([notification.name isEqualToString:kBSUpdatePersonalInfoResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            self.profile = [PersonalProfile currentProfile];
        }
    }
    else if ([notification.name isEqualToString:kFetchUnReadMessageResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self setNaviBackButtonItem];
        }
    }
    else if ([notification.name isEqualToString:kBSMemberCashierSuccess])
    {
//        [self reloadData];
        [[HomeCountDataManager sharedManager] fetchData];
    }
    else if ([notification.name isEqualToString:kPushToCashier])
    {
        [self didItemsCashPressed:nil];
    }
    else if ([notification.name isEqualToString:kPushToAssign])
    {
        PosOperateDetailViewController *operateDetailVC = [[PosOperateDetailViewController alloc] init];
        if ([notification.object isKindOfClass:[CDPosOperate class]]) {
            operateDetailVC.operate = notification.object;
        }
        else
        {
            operateDetailVC.operateID = notification.object;
        }
        
        [self.navigationController pushViewController:operateDetailVC animated:YES];
    }
    else if ([notification.name isEqualToString:kPushToGive])
    {
        PhoneGiveViewController *giveVC = [[PhoneGiveViewController alloc] init];
        if ([notification.object isKindOfClass:[CDPosOperate class]]) {
            giveVC.operate = notification.object;
        }
        else
        {
            giveVC.operateID = notification.object;
        }
        giveVC.member = [notification.userInfo objectForKey:@"member"];
        [self.navigationController pushViewController:giveVC animated:NO];
    }
}

- (void)didSelectedStoreBtnPressed:(UIButton *)btn
{
    NSArray* storeList = [[BSCoreDataManager currentManager] fetchItems:@"CDStore" sortedByKey:@"storeID" ascending:YES];
    NSInteger currentIndex = -1;
    if ( self.store )
    {
        currentIndex = [storeList indexOfObject:self.store];
    }
    
    self.selectedStoreView.selectedIdx = currentIndex;
    [self.selectedStoreView show];
    
    self.arrowImgView.transform = CGAffineTransformRotate(self.arrowImgView.transform, M_PI);
}

- (void)didSelectedStore:(CDStore *)store
{
    if (store) {
        self.store = store;
        self.profile.homeSelectedShopID = store.storeID;
        [self.profile save];
        [self.homeTableview reloadData];
        
        [[HomeCountDataManager sharedManager] fetchData];
        
        [self setNaviTitle];
    }
    self.arrowImgView.transform = CGAffineTransformIdentity;
}


- (void)reloadData
{
    self.itemsArray = [NSMutableArray array];
    self.profile = [PersonalProfile currentProfile];
    if ( self.profile.roleOption == RoleOption_boss || self.profile.roleOption == RoleOption_shopManager )
    {
        //会员管理
        HomeItemsObject* item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Member";
        item.itemIndex = HomeTableviewItems_Member;
        item.function = @selector(didItemsMemberPressed:);
        [self.itemsArray addObject:item];
        //员工管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Staff";
        item.itemIndex = HomeTableviewItems_Staff;
        item.function = @selector(didItemsStaffPressed:);
        [self.itemsArray addObject:item];
        //产品项目
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Project";
        item.itemIndex = HomeTableviewItems_Project;
        item.function = @selector(didItemsProjectPressed:);
        [self.itemsArray addObject:item];
        //预约
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Appointment";
        item.itemIndex = HomeTableviewItems_Appointment;
        item.function = @selector(didItemsAppointmentPressed:);
        [self.itemsArray addObject:item];
        //报表
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Pie";
        item.itemIndex = HomeTableviewItems_Pie;
        item.function = @selector(didItemsPiePressed:);
        [self.itemsArray addObject:item];
//        //收银
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Cash";
//        item.itemIndex = HomeTableviewItems_Cash;
//        item.function = @selector(didItemsCashPressed:);
//        [self.itemsArray addObject:item];
        if (self.profile.posID.integerValue > 0) {
            //收银
            item = [[HomeItemsObject alloc] init];
            item.imageName = @"HomeTableviewItems_Cash";
            item.itemIndex = HomeTableviewItems_Cash;
            item.function = @selector(didItemsCashPressed:);
            [self.itemsArray addObject:item];
            
            //挂单
            item = [[HomeItemsObject alloc] init];
            item.imageName = @"HomeTableviewItems_Guadan";
            item.itemIndex = HomeTableviewItems_Guadan;
            item.function = @selector(didItemsGuadanPressed:);
            [self.itemsArray addObject:item];
            
            //历史单据
            item = [[HomeItemsObject alloc] init];
            item.imageName = @"HomeTableviewItems_HistoryPos";
            item.itemIndex = HomeTableviewItems_HistoryPos;
            item.function = @selector(didItemHistoryPosPressed:);
            [self.itemsArray addObject:item];
        }
        
        //仓库管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Stock";
        item.itemIndex = HomeTableviewItems_Stock;
        item.function = @selector(didItemsStockPressed:);
        [self.itemsArray addObject:item];
        //采购管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Purchase";
        item.itemIndex = HomeTableviewItems_Purchase;
        item.function = @selector(didItemsPurchasePressed:);
        [self.itemsArray addObject:item];
        
        //员工业绩
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_StaffMoney";
        item.itemIndex = HomeTableviewItems_MyMoney;
        item.function = @selector(didItemsMyMoneyPressed:);
        [self.itemsArray addObject:item];
        //门店监控
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Monitor";
//        item.itemIndex = HomeTableviewItems_Monitor;
//        item.function = @selector(didItemsMonitorPressed:);
//        [self.itemsArray addObject:item];
        //拓客
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Tuoke";
//        item.itemIndex = HomeTableviewItems_Tuoke;
//        item.function = @selector(didItemsTuokePressed:);
//        [self.itemsArray addObject:item];
    }
    else if ( self.profile.roleOption == RoleOption_shopIncome)
    {
        
        HomeItemsObject* item = [[HomeItemsObject alloc] init];
        
//        我的业绩
//        item.imageName = @"HomeTableviewItems_MyMoney";
//        item.itemIndex = HomeTableviewItems_MyMoney;
//        item.function = @selector(didItemsMyMoneyPressed:);
//        [self.itemsArray addObject:item];
        
        //收银
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Cash";
        item.itemIndex = HomeTableviewItems_Cash;
        item.function = @selector(didItemsCashPressed:);
        [self.itemsArray addObject:item];
        
        //挂单
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Guadan";
        item.itemIndex = HomeTableviewItems_Guadan;
        item.function = @selector(didItemsGuadanPressed:);
        [self.itemsArray addObject:item];
        
        
        //历史单据
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_HistoryPos";
        item.itemIndex = HomeTableviewItems_HistoryPos;
        item.function = @selector(didItemHistoryPosPressed:);
        [self.itemsArray addObject:item];
        
        //会员管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Member";
        item.itemIndex = HomeTableviewItems_Member;
        item.function = @selector(didItemsMemberPressed:);
        [self.itemsArray addObject:item];
        
        //员工管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Staff";
        item.itemIndex = HomeTableviewItems_Staff;
        item.function = @selector(didItemsStaffPressed:);
        [self.itemsArray addObject:item];
        
        //产品项目
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Project";
        item.itemIndex = HomeTableviewItems_Project;
        item.function = @selector(didItemsProjectPressed:);
        [self.itemsArray addObject:item];
        
        //报表
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Pie";
        item.itemIndex = HomeTableviewItems_Pie;
        item.function = @selector(didItemsPiePressed:);
        [self.itemsArray addObject:item];
        
        //预约
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Appointment_2";
        item.itemIndex = HomeTableviewItems_Appointment;
        item.function = @selector(didItemsAppointmentPressed:);
        [self.itemsArray addObject:item];
        
        //护理反馈
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_HuliFanKui";
        item.itemIndex = HomeTableviewItems_HuliFanKui;
        item.function = @selector(didItemsHuliFanKuiPressed:);
        [self.itemsArray addObject:item];
        
        
        //仓库管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Stock";
        item.itemIndex = HomeTableviewItems_Stock;
        item.function = @selector(didItemsStockPressed:);
        [self.itemsArray addObject:item];
        
        //采购管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Purchase";
        item.itemIndex = HomeTableviewItems_Purchase;
        item.function = @selector(didItemsPurchasePressed:);
        [self.itemsArray addObject:item];
        
        
        //员工业绩
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_StaffMoney";
        item.itemIndex = HomeTableviewItems_MyMoney;
        item.function = @selector(didItemsMyMoneyPressed:);
        [self.itemsArray addObject:item];
        
//        //考勤打卡
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Attendance";
//        item.itemIndex = HomeTableviewItems_Attendance;
//        item.function = @selector(didItemsAttendancePressed:);
//        [self.itemsArray addObject:item];
        
//        //请假
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Leave";
//        item.itemIndex = HomeTableviewItems_Leave;
//        item.function = @selector(didItemsLeavePressed:);
//        [self.itemsArray addObject:item];
    }
    else if ( self.profile.roleOption == RoleOption_waiter)
    {
        //我的提成
        HomeItemsObject* item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_MyMoney";
        item.itemIndex = HomeTableviewItems_MyMoney;
        item.function = @selector(didItemsMyMoneyPressed:);
        [self.itemsArray addObject:item];
        
        //会员管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Member";
        item.itemIndex = HomeTableviewItems_Member;
        item.function = @selector(didItemsMemberPressed:);
        [self.itemsArray addObject:item];
        
        //员工管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Staff";
        item.itemIndex = HomeTableviewItems_Staff;
        item.function = @selector(didItemsStaffPressed:);
        [self.itemsArray addObject:item];
        
        if (self.profile.posID.integerValue > 0) {
            //收银
            item = [[HomeItemsObject alloc] init];
            item.imageName = @"HomeTableviewItems_Cash";
            item.itemIndex = HomeTableviewItems_Cash;
            item.function = @selector(didItemsCashPressed:);
            [self.itemsArray addObject:item];
            
            //挂单
            item = [[HomeItemsObject alloc] init];
            item.imageName = @"HomeTableviewItems_Guadan";
            item.itemIndex = HomeTableviewItems_Guadan;
            item.function = @selector(didItemsGuadanPressed:);
            [self.itemsArray addObject:item];
            
            //历史单据
            item = [[HomeItemsObject alloc] init];
            item.imageName = @"HomeTableviewItems_HistoryPos";
            item.itemIndex = HomeTableviewItems_HistoryPos;
            item.function = @selector(didItemHistoryPosPressed:);
            [self.itemsArray addObject:item];
        }

        //产品项目
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Project";
        item.itemIndex = HomeTableviewItems_Project;
        item.function = @selector(didItemsProjectPressed:);
        [self.itemsArray addObject:item];
        
        //预约
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Appointment";
        item.itemIndex = HomeTableviewItems_Appointment;
        item.function = @selector(didItemsAppointmentPressed:);
        [self.itemsArray addObject:item];
        
        //护理反馈
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_HuliFanKui";
        item.itemIndex = HomeTableviewItems_HuliFanKui;
        item.function = @selector(didItemsHuliFanKuiPressed:);
        [self.itemsArray addObject:item];
        
        //仓库管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Stock_2";
        item.itemIndex = HomeTableviewItems_Stock;
        item.function = @selector(didItemsStockPressed:);
        [self.itemsArray addObject:item];
        
//        //        //采购管理
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Purchase_2";
//        item.itemIndex = HomeTableviewItems_Purchase;
//        item.function = @selector(didItemsPurchasePressed:);
//        [self.itemsArray addObject:item];
        
        
//        //考勤打卡
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Attendance";
//        item.itemIndex = HomeTableviewItems_Attendance;
//        item.function = @selector(didItemsAttendancePressed:);
//        [self.itemsArray addObject:item];
//        //请假
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Leave";
//        item.itemIndex = HomeTableviewItems_Leave;
//        item.function = @selector(didItemsLeavePressed:);
//        [self.itemsArray addObject:item];
    }
    else //if ( self.profile.roleOption == RoleOption_waiter)
    {
        //我的提成
        HomeItemsObject* item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_MyMoney";
        item.itemIndex = HomeTableviewItems_MyMoney;
        item.function = @selector(didItemsMyMoneyPressed:);
        [self.itemsArray addObject:item];
        
        
        //会员管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Member";
        item.itemIndex = HomeTableviewItems_Member;
        item.function = @selector(didItemsMemberPressed:);
        [self.itemsArray addObject:item];
        
        //员工管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Staff";
        item.itemIndex = HomeTableviewItems_Staff;
        item.function = @selector(didItemsStaffPressed:);
        [self.itemsArray addObject:item];
        
        if (self.profile.posID.integerValue > 0) {
            //收银
            item = [[HomeItemsObject alloc] init];
            item.imageName = @"HomeTableviewItems_Cash";
            item.itemIndex = HomeTableviewItems_Cash;
            item.function = @selector(didItemsCashPressed:);
            [self.itemsArray addObject:item];
            
            //挂单
            item = [[HomeItemsObject alloc] init];
            item.imageName = @"HomeTableviewItems_Guadan";
            item.itemIndex = HomeTableviewItems_Guadan;
            item.function = @selector(didItemsGuadanPressed:);
            [self.itemsArray addObject:item];
        }
        
        
        //产品项目
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Project";
        item.itemIndex = HomeTableviewItems_Project;
        item.function = @selector(didItemsProjectPressed:);
        [self.itemsArray addObject:item];
        
        //预约
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Appointment";
        item.itemIndex = HomeTableviewItems_Appointment;
        item.function = @selector(didItemsAppointmentPressed:);
        [self.itemsArray addObject:item];
        
        //护理反馈
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_HuliFanKui";
        item.itemIndex = HomeTableviewItems_HuliFanKui;
        item.function = @selector(didItemsHuliFanKuiPressed:);
        [self.itemsArray addObject:item];
        
        //仓库管理
        item = [[HomeItemsObject alloc] init];
        item.imageName = @"HomeTableviewItems_Stock_2";
        item.itemIndex = HomeTableviewItems_Stock;
        item.function = @selector(didItemsStockPressed:);
        [self.itemsArray addObject:item];
        
//        //        //采购管理
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Purchase_2";
//        item.itemIndex = HomeTableviewItems_Purchase;
//        item.function = @selector(didItemsPurchasePressed:);
//        [self.itemsArray addObject:item];
        
        //考勤打卡
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Attendance";
//        item.itemIndex = HomeTableviewItems_Attendance;
//        item.function = @selector(didItemsAttendancePressed:);
//        [self.itemsArray addObject:item];
//        //请假
//        item = [[HomeItemsObject alloc] init];
//        item.imageName = @"HomeTableviewItems_Leave";
//        item.itemIndex = HomeTableviewItems_Leave;
//        item.function = @selector(didItemsLeavePressed:);
//        [self.itemsArray addObject:item];
    }
    
    [self.homeTableview reloadData];
}

- (void)didItemsMemberPressed:(id)sender
{
#if 0
    if([PersonalProfile currentProfile].shopIds.count > 1)
    {
        MemberManageViewController *viewController = [[MemberManageViewController alloc] initWithNibName:NIBCT(@"MemberManageViewController") bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
        CDStore *store = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDStore" withValue:storeID forKey:@"storeID"];
        MemberViewController *viewController = [[MemberViewController alloc] initWithStore:store];
        [self.navigationController pushViewController:viewController animated:YES];
    }
#endif
    
//    CDStore *store = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDStore" withValue:storeID forKey:@"storeID"];
    MemberViewController *viewController = [[MemberViewController alloc] initWithStore:self.store];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)didItemsStaffPressed:(id)sender
{
    if ([PersonalProfile currentProfile].shopIds.count > 1) {
        StaffManagerViewController *staffManagerVC = [[StaffManagerViewController alloc] initWithNibName:NIBCT(@"StaffManagerViewController") bundle:nil];
        [self.navigationController pushViewController:staffManagerVC animated:YES];
    }
    else
    {
        StaffViewController *staffVC = [[StaffViewController alloc] initWithNibName:NIBCT(@"StaffViewController") bundle:nil];
        staffVC.isOnlyShop = true;
        NSNumber *storeId = [PersonalProfile currentProfile].shopIds[0];
        staffVC.shop = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:storeId forKey:@"storeID"];
        [self.navigationController pushViewController:staffVC animated:YES];
    }
}
#pragma mark 跳到产品项目控制器中
- (void)didItemsProjectPressed:(id)sender
{
//    NSLog(@"跳到产品项目控制器中");
//    ProjectViewController *projectViewController = [[ProjectViewController alloc] initWithViewType:kProjectViewEdit existItemIds:nil];
//     [self.navigationController pushViewController:projectViewController animated:YES];
    
    ProductProjectMainController *xpxm = [[ProductProjectMainController alloc]init];
    xpxm.controllerType = ProductControllerType_Template;
    [self.navigationController pushViewController:xpxm animated:YES];
}
-(void)productProjectMainControllerPayBtnClickWith:(NSMutableArray *)goods
{
    NSLog(@"goods.count-----%d",goods.count);
}
- (void)didItemsPiePressed:(id)sender
{
    NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=dashboard",self.profile.userName,self.profile.password];
    NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",self.profile.userName,self.profile.password];
    
    NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[self.profile token]];
    
    NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
    NSString* sign = [userData md5Hash];
    
    CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",self.profile.baseUrl,self.profile.sql,sendParams,sign,[self.profile deviceString]]];
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"筛选"];
    rightButtonItem.delegate = webViewController;
    webViewController.rightItem = rightButtonItem;
    webViewController.disableBounces = YES;
    [webViewController setRightItemJs:^(UIWebView *webview) {
        [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"selectRole()"]];
    }];
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didItemsCashPressed:(id)sender
{
//    CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:@"https://testtop.we-erp.com/bornservice/index?born_uuid=bd57b808-2981-44c3-9519-243baa1b2c47"];
//    [self.navigationController pushViewController:webViewController animated:YES];
//    webViewController.disableBounces = TRUE;
    ProductProjectMainController *projectMainVC = [[ProductProjectMainController alloc] init];
    projectMainVC.controllerType = ProductControllerType_Sale;
    [self.navigationController pushViewController:projectMainVC animated:YES];
}

- (void)didItemHistoryPosPressed:(id)sender
{
    HistoryOperateViewController *historyPosVC = [[HistoryOperateViewController alloc] init];
    [self.navigationController pushViewController:historyPosVC animated:YES];
}

- (void)didItemsGuadanPressed:(id)sender
{
    GuadanViewController *guaDanVC = [[GuadanViewController alloc] init];
    [self.navigationController pushViewController:guaDanVC animated:YES];
}

- (void)didItemsStockPressed:(id)sender
{
    PanDianViewController *panDianVC = [[PanDianViewController alloc] initWithNibName:NIBCT(@"PanDianViewController") bundle:nil];
    [self.navigationController pushViewController:panDianVC animated:YES];
}

- (void)didItemsPurchasePressed:(id)sender
{
//    PurchaseViewController *purchaseVC = [[PurchaseViewController alloc] init];
//    [self.navigationController pushViewController:purchaseVC animated:YES];
    
    PurchaseOrderViewController *purchaseVC = [[PurchaseOrderViewController alloc] init];
    [self.navigationController pushViewController:purchaseVC animated:YES];
}

- (void)didItemsAppointmentPressed:(id)sender
{
    NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=reservation",self.profile.userName,self.profile.password];
    NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",self.profile.userName,self.profile.password];
    
    NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[self.profile token]];
    
    NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
    NSString* sign = [userData md5Hash];
    
    CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",self.profile.baseUrl,self.profile.sql,sendParams,sign,[self.profile deviceString]]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didItemsAttendancePressed:(id)sender
{
    
}

- (void)didItemsLeavePressed:(id)sender
{
    
}

- (void)didItemsMyMoneyPressed:(id)sender
{
    NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=mobile_report_commission",self.profile.userName,self.profile.password];
    NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",self.profile.userName,self.profile.password];
    
    NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[self.profile token]];
    
    NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
    NSString* sign = [userData md5Hash];
    
    CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",self.profile.baseUrl,self.profile.sql,sendParams,sign,[self.profile deviceString]]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

//门店监控
- (void)didItemsMonitorPressed:(id)sender
{
    
}

//拓客
- (void)didItemsTuokePressed:(id)sender
{
    NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=spread",self.profile.userName,self.profile.password];
    NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",self.profile.userName,self.profile.password];
    
    NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[self.profile token]];
    
    NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
    NSString* sign = [userData md5Hash];
    
    CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",self.profile.baseUrl,self.profile.sql,sendParams,sign,[self.profile deviceString]]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didItemsHuliFanKuiPressed:(id)sender
{
    NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=mobile_feedback",self.profile.userName,self.profile.password];
    NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",self.profile.userName,self.profile.password];
    
    NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[self.profile token]];
    
    NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
    NSString* sign = [userData md5Hash];
    
    CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",self.profile.baseUrl,self.profile.sql,sendParams,sign,[self.profile deviceString]]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didItemButtonPressed:(NSInteger)index cell:(HomeItemsTableViewCell*)cell
{
    HomeItemsObject* item = self.itemsArray[index];
    SEL select = item.function;
    if ( [self respondsToSelector:select] )
    {
        SuppressPerformSelectorLeakWarning([self performSelector:select withObject:nil]);
    }
}

#pragma mark -
#pragma mark HomeBannerTableViewCellDelegate
- (void)didSettingStoreButtonPressed:(HomeBannerTableViewCell*)cell store:(CDStore*)store
{
    NSArray* storeList = [[BSCoreDataManager currentManager] fetchItems:@"CDStore" sortedByKey:@"storeID" ascending:YES];
    NSInteger currentIndex = -1;
    if ( store )
    {
        currentIndex = [storeList indexOfObject:store];
    }
    
    NSMutableArray* storeNameList = [NSMutableArray array];
    for (CDStore* s in storeList )
    {
        [storeNameList addObject:s.storeName];
    }
    
    BSCommonSelectedItemViewController* v = [[BSCommonSelectedItemViewController alloc] initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
    v.currentSelectIndex = currentIndex;
    v.dataArray = storeNameList;
    v.delegate = self;
    v.userData = storeList;
    [self.navigationController pushViewController:v animated:YES];
}

- (void)didAdvertisementButtonPressed:(HomeBannerTableViewCell*)cell linkUrl:(NSString*)linkUrl
{
    CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:linkUrl];
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    NSArray* storeList = (NSArray*)userData;
    self.profile.homeSelectedShopID = ((CDStore*)storeList[index]).storeID;
    [self.profile save];
    [self.homeTableview reloadData];
    
    [[HomeCountDataManager sharedManager] fetchData];
}

- (void)didTodayIncomeButtonPressed:(HomeBannerTableViewCell*)cell
{
    HomeTodayIncomeViewController* vc = [[HomeTodayIncomeViewController alloc] initWithNibName:NIBCT(@"HomeTodayIncomeViewController") bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didPassengerFlowButtonPressed:(HomeBannerTableViewCell*)cell
{
    HomePassengerFlowViewController* vc = [[HomePassengerFlowViewController alloc] initWithNibName:NIBCT(@"HomePassengerFlowViewController") bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didMyTodayInComeButtonPressed:(HomeBannerTableViewCell*)cell
{
    HomeMyTodayIncomeViewController* vc = [[HomeMyTodayIncomeViewController alloc] initWithNibName:NIBCT(@"HomeMyTodayIncomeViewController") bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didMyTodayAppointmentButtonPressed:(HomeBannerTableViewCell*)cell
{
    [self didItemsAppointmentPressed:nil];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HomeTableviewSection_Count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == HomeTableviewSection_WebView )
    {
        return 1;
    }
    else if ( section == HomeTableviewSection_Items )
    {
        return (self.itemsArray.count + 2) / 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    if ( indexPath.section == HomeTableviewSection_WebView )
    {
        return [self tableView:tableView cellForHomeTableviewSectionWebView:indexPath];
    }
    else if ( indexPath.section == HomeTableviewSection_Items )
    {
        return [self tableView:tableView cellForHomeTableviewSectionItems:indexPath];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForHomeTableviewSectionWebView:(NSIndexPath *)indexPath
{
    HomeBannerTableViewCell* cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"HomeBannerTableViewCell"];
    if ( cell == nil )
    {
        cell = [[HomeBannerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellForHomeTableviewSectionWebView"];
        cell.delegate = self;
        cell.backgroundColor = [UIColor greenColor];
    }
    
    [cell reloadData];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForHomeTableviewSectionItems:(NSIndexPath *)indexPath
{
    HomeItemsTableViewCell* cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cellForHomeTableviewSectionItems"];
    
    if ( cell == nil )
    {
        cell = [[HomeItemsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellForHomeTableviewSectionItems"];
        cell.delegate = self;
    }
    
    NSInteger startIndex = indexPath.row * 3;
    for ( int i = 0; i < 3; i++ )
    {
        if ( i + startIndex < self.itemsArray.count )
        {
            HomeItemsObject* item = self.itemsArray[i + startIndex];
            [cell setItemImage:[UIImage imageNamed:item.imageName] atIndex:i];
        }
        else
        {
            [cell setItemImage:nil atIndex:i];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == HomeTableviewSection_WebView )
    {
        return IC_SCREEN_WIDTH / 320 * 122;
    }
    else if ( indexPath.section == HomeTableviewSection_Items )
    {
        return sectionItemsHeight;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
