//
//  PadSideBarViewController.m
//  BornPOS
//
//  Created by XiaXianBing on 15/10/8.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSideBarViewController.h"
#import "CBLoadingView.h"
#import "PadSideBarCell.h"
#import "UIImage+Resizable.h"
#import "PersonalProfile.h"
#import "BSFetchPosSessionRequest.h"
#import "BSPosSessionOperateRequest.h"
#import "PadLoginViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "PadHomeViewController.h"
#import "PadSettingViewController.h"
#import "PadBookMainViewController.h"
#import "PadWebViewController.h"
#import "NSData+Additions.h"
#import "PadProjectViewController.h"
#import "PadPicHomeViewController.h"
#import "PadMemberAndCardViewController.h"
#import "HistoryPosViewController.h"
#import "PadHospitalMainViewController.h"
//#import "meim-Swift.h"
#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif
#import "PadHospitalPatientMainViewController.h"
#import "HJiaoHaoListViewController.h"
#import "PadGiveViewController.h"
#import "PadPosViewController.h"

#define kPadSideBarBottomViewHeight     216.0

NSInteger kPadSideBarTypeHomePic = 0;
NSInteger kPadSideBarTypePos = 1;
NSInteger kPadSideBarTypeReserve = 2;
NSInteger kPadSideBarTypeMember = 3;
NSInteger kPadSidebarTypeHistory = 4;
NSInteger kPadSideBarTypeHospital = 5;
NSInteger kPadSideBarTypeSetting = 6;
NSInteger kPadSideBarTypeCount = 7;
NSInteger kPadSideBarTypeFuzhujiancha = 8;
NSInteger kPadSideBarTypeWenzhen = 9;
NSInteger kPadSideBarTypeCashier = 10;
NSInteger kPadSideBarTypeZhuyuan = 11;
NSInteger kPadSideBarTypeYaofang = 12;
NSInteger kPadSideBarTypeStatistic = 13;
NSInteger kPadSideBarTypeFenzhen = 14;
NSInteger kPadSideBarTypeZixun = 15;
NSInteger kPadSideBarTypeZongkong = 16;
NSInteger kPadSideBarTypePatient = 17;
NSInteger kPadSideBarTypeOperator = 18;
NSInteger kPadSideBarTypePaidui = 19;
NSInteger kPadSideBarTypeKaidanjilu = 20;
NSInteger kPadSideBarTypeGuadanjiesuan = 21;
NSInteger kPadSideBarType9ShoushuTixing = 22;
NSInteger kPadSideBarType9ShoushuAnpai = 23;

@interface PadSideBarViewController ()
{
    NSInteger localPosOperateCount;
    NSInteger H9NofityCount;
}

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *bottonView;
@property (nonatomic, strong) UITableView *sidebarTableView;
@property (nonatomic, assign) id<PadSideBarViewControllerDelegate> delegate;
@property (nonatomic) BOOL isShouyintai;
@end


@implementation PadSideBarViewController

- (id)initWithDelegate:(id<PadSideBarViewControllerDelegate>)delegate
{
    self = [super initWithNibName:@"PadSideBarViewController" bundle:nil];
    if (self)
    {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadLeftItem];
    
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self registerNofitificationForMainThread:kBSFetchStartInfoResponse];
    [self registerNofitificationForMainThread:kBSFetchStartPosResponse];
    [self registerNofitificationForMainThread:kBSFetchPosSessionResponse];
    [self registerNofitificationForMainThread:kBSPosSessionOperateResponse];
    [self registerNofitificationForMainThread:kUpdateLocalPosOperateNotification];
    [self registerNofitificationForMainThread:kUpdateH9NotifyNotification];
    [self registerNofitificationForMainThread:kPadAccountLogoutResponse];
    [self registerNofitificationForMainThread:kPadAccountChangeResponse];
    [self registerNofitificationForMainThread:kPadSelectMemberAndCardFinish];
    [self registerNofitificationForMainThread:kBSPadCashierSuccess];
    [self registerNofitificationForMainThread:kBSPadGiveGiftCard];
    [self registerNofitificationForMainThread:kBSPadAllotPerformance];
    [self registerNofitificationForMainThread:kBSCashMemberAgain];
    [self registerNofitificationForMainThread:kGoH9Notify];
    
    self.selectedIndex = 0;
    self.sidebarTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSideBarCellWidth, IC_SCREEN_HEIGHT - kPadSideBarBottomViewHeight) style:UITableViewStylePlain];
    self.sidebarTableView.backgroundColor = COLOR(96.0, 212.0, 212.0, 1.0);
    self.sidebarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sidebarTableView.dataSource = self;
    self.sidebarTableView.delegate = self;
    self.sidebarTableView.showsVerticalScrollIndicator = NO;
    self.sidebarTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.sidebarTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSideBarCellWidth, (self.sidebarTableView.frame.size.height - 6 * kPadSideBarCellHeight)/2.0)];
    headerView.backgroundColor = [UIColor clearColor];
    self.sidebarTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSideBarCellWidth, (self.sidebarTableView.frame.size.height - 6 * kPadSideBarCellHeight)/2.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.sidebarTableView.tableFooterView = footerView;
    
    self.bottonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.sidebarTableView.frame.size.height, kPadSideBarCellWidth, kPadSideBarBottomViewHeight)];
    self.bottonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottonView];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 32.0, (kPadSideBarCellWidth - 2 * 30.0)/2.0, 20.0)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    dateLabel.font = [UIFont boldSystemFontOfSize:20.0];
    dateLabel.tag = 101;
    [self.bottonView addSubview:dateLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 32.0 + 20.0 + 8.0, kPadSideBarCellWidth - 60.0, 48.0)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    timeLabel.font = IOS7FONT(48.0);
    timeLabel.tag = 102;
    [self.bottonView addSubview:timeLabel];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadSideBarCellWidth/2.0, 32.0, (kPadSideBarCellWidth - 2 * 32.0)/2.0, 20.0)];
    stateLabel.backgroundColor = [UIColor clearColor];
    stateLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    stateLabel.font = [UIFont boldSystemFontOfSize:17.0];
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.tag = 103;
    [self.bottonView addSubview:stateLabel];
    
    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stateButton.frame = CGRectMake(32.0, kPadSideBarBottomViewHeight - 32.0 - 48.0, kPadSideBarCellWidth - 2 * 32.0, 48.0);
    [stateButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [stateButton setTitleColor:COLOR(156.0, 113.0, 8.0, 1.0) forState:UIControlStateNormal];
    [stateButton setBackgroundImage:[[UIImage imageNamed:@"pad_side_open_close_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)] forState:UIControlStateNormal];
    [stateButton setBackgroundImage:[[UIImage imageNamed:@"pad_side_open_close_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)] forState:UIControlStateHighlighted];
    [stateButton addTarget:self action:@selector(didStateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    stateButton.tag = 104;
    [self.bottonView addSubview:stateButton];
    
    [self refreshBottomView];
    
    ///保存一个当前界面 供咨询处跳转用
    [SingletonManager sharedInstance].setttingVC = self;
}

- (void)reloadLeftItem
{
    kPadSideBarTypeHomePic = 0;
    kPadSideBarTypePos = 1;
    kPadSideBarTypeReserve = 2;
    kPadSideBarTypeMember = 3;
    kPadSidebarTypeHistory = 4;
    kPadSideBarTypeHospital = 5;
    kPadSideBarTypeSetting = 6;
    kPadSideBarTypeFuzhujiancha = 7;
    kPadSideBarTypeWenzhen = 8;
    kPadSideBarTypeCashier = 9;
    kPadSideBarTypeZhuyuan = 10;
    kPadSideBarTypeYaofang = 11;
    kPadSideBarTypeCount = 12;
    //kPadSideBarTypeStatistic = 8;
    
    if ( [PersonalProfile currentProfile].isHospital )
    {
        kPadSideBarTypeHospital = 5;
        //kPadSideBarTypeStatistic = 8;
    }
    else
    {
        kPadSideBarTypeSetting = 5;
        kPadSideBarTypeHospital = 8;
        kPadSideBarTypeCount = 8;
        //kPadSideBarTypeStatistic = 5;
    }
    
    NSArray* models = [PersonalProfile currentProfile].accessModels;
    if ( models.count > 0 )
    {
        kPadSideBarTypePos = 100;
        kPadSideBarTypeReserve = 100;
        kPadSideBarTypeMember = 100;
        kPadSidebarTypeHistory = 100;
        kPadSideBarTypeHospital = 100;
        kPadSideBarTypeSetting = 100;
        kPadSideBarTypeFuzhujiancha = 100;
        kPadSideBarTypeWenzhen = 100;
        kPadSideBarTypeCashier = 100;
        kPadSideBarTypeZhuyuan = 100;
        kPadSideBarTypeYaofang = 100;
        kPadSideBarTypeCount = 0;
        kPadSideBarTypeStatistic = 100;
        kPadSideBarTypeFenzhen = 100;
        kPadSideBarTypeZixun = 100;
        kPadSideBarTypeZongkong = 100;
        kPadSideBarTypePatient = 100;
        kPadSideBarTypeOperator = 100;
        kPadSideBarTypePaidui = 100;
        kPadSideBarTypeKaidanjilu = 100;
        kPadSideBarTypeGuadanjiesuan = 100;
        kPadSideBarType9ShoushuTixing = 100;
        kPadSideBarType9ShoushuAnpai = 100;
        
        NSInteger index = 1;
        for ( NSString* model in models )
        {
            if ( [model isKindOfClass:[NSDictionary class]] )
            {
                kPadSideBarTypeOperator = index++;
            }
            else if ( [model isEqualToString:@"shouyinkaidan"] )
            {
                kPadSideBarTypePos = index++;
            }
            else if ([model isEqualToString:@"fuzhujiancha"] )
            {
                kPadSideBarTypeFuzhujiancha = index++;
            }
            else if ([model isEqualToString:@"wenzhen"] )
            {
                kPadSideBarTypeWenzhen = index++;
            }
            else if ([model isEqualToString:@"shouyintai"] )
            {
                kPadSideBarTypeCashier = index++;
            }
            else if ([model isEqualToString:@"zhuyuan"] )
            {
                kPadSideBarTypeZhuyuan = index++;
            }
            else if ([model isEqualToString:@"yaofang"] )
            {
                kPadSideBarTypeYaofang = index++;
            }
            else if ( [model isEqualToString:@"fenzhen"] )
            {
                kPadSideBarTypeFenzhen = index++;
            }
            else if ( [model isEqualToString:@"gukezhogxin"] )
            {
                kPadSideBarTypeMember = index++;
            }
            else if ( [model isEqualToString:@"yuyue"] )
            {
                kPadSideBarTypeReserve = index++;
            }
            else if ( [model isEqualToString:@"zixun"] )
            {
                kPadSideBarTypeZixun = index++;
            }
            else if ( [model isEqualToString:@"zongkong"] )
            {
                kPadSideBarTypeZongkong = index++;
            }
            else if ( [model isEqualToString:@"bingrendagnan"] )
            {
                kPadSideBarTypePatient = index++;
            }
            else if ( [model isEqualToString:@"gukezhuangtai"] )
            {
                kPadSideBarTypePaidui = index++;
            }
            else if ( [model isEqualToString:@"lishidanju"] )
            {
                kPadSidebarTypeHistory = index++;
            }
            else if ( [model isEqualToString:@"kaidanjilu"] )
            {
                kPadSideBarTypeKaidanjilu = index++;
            }
            else if ( [model isEqualToString:@"guadanjiesuan"] )
            {
                kPadSideBarTypeGuadanjiesuan = index++;
            }
            else if ( [model isEqualToString:@"tixingtongzhi"] )
            {
                kPadSideBarType9ShoushuTixing = index++;
            }
            else if ( [model isEqualToString:@"shoushuanpan"] )
            {
                kPadSideBarType9ShoushuAnpai = index++;
            }
        }
        kPadSideBarTypeSetting = index++;
        kPadSideBarTypeCount = index++;
    }
    
    [self.sidebarTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ( [self.delegate isRootViewController] )
    {
        self.selectedIndex = 0;
        [self.sidebarTableView reloadData];
    }
    
    [super viewWillAppear:YES];
}

- (void)refreshBottomView
{
    UILabel *dateLabel = (UILabel *)[self.bottonView viewWithTag:101];
    UILabel *timeLabel = (UILabel *)[self.bottonView viewWithTag:102];
    UILabel *stateLabel = (UILabel *)[self.bottonView viewWithTag:103];
    UIButton *stateButton = (UIButton *)[self.bottonView viewWithTag:104];
    
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSDate *date = nil;
    if ( [profile.posID integerValue] == 0 )
    {
        dateLabel.text = @"";
        timeLabel.text = @"";
        stateLabel.text = @"";
        [stateButton setTitle:@"退出" forState:UIControlStateNormal];
    }
    else
    {
        if (profile.sessionID.integerValue != 0)
        {
            date = profile.openDate;
            stateLabel.text = LS(@"PadSideBarLastOpen");
            [stateButton setTitle:LS(@"PadSideBarBillClose") forState:UIControlStateNormal];
        }
        else
        {
            date = profile.closeDate;
            stateLabel.text = LS(@"PadSideBarLastClosed");
            [stateButton setTitle:LS(@"PadSideBarBillOpen") forState:UIControlStateNormal];
        }
        
        if (date != nil)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *datestr = [dateFormatter stringFromDate:date];
            dateLabel.text = [datestr substringToIndex:10];
            timeLabel.text = [datestr substringWithRange:NSMakeRange(11, 5)];
        }
    }
}

- (void)delayPoptoRoot
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

- (void)didStateButtonClick:(id)sender
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    if ( [profile.posID integerValue] == 0 )
    {
        NSString* phoneNumber = [PersonalProfile currentProfile].phoneNumber;
        [PersonalProfile deleteProfile];
        UINavigationController* rootViewController = self.navigationController;
        [[NSNotificationCenter defaultCenter] postNotificationName:kPadAccountChangeResponse object:nil userInfo:nil];
        
        PadLoginViewController *viewController = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
        viewController.userTextField.text = phoneNumber;
        CBRotateNavigationController *navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        [rootViewController presentViewController:navi animated:YES completion:nil];
        
        [self performSelector:@selector(delayPoptoRoot) withObject:nil afterDelay:1];
    }
    else
    {
        if (profile.sessionID.integerValue != 0)
        {
            //[[CBLoadingView shareLoadingView] show];
            BSPosSessionOperateRequest *request = [[BSPosSessionOperateRequest alloc] initWithType:kBSPosSessionClose];
            [request execute];
            
            NSString* phoneNumber = [PersonalProfile currentProfile].phoneNumber;
            [PersonalProfile deleteProfile];
            UINavigationController* rootViewController = self.navigationController;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPadAccountChangeResponse object:nil userInfo:nil];
            
            PadLoginViewController *viewController = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
            viewController.userTextField.text = phoneNumber;
            CBRotateNavigationController *navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
            [rootViewController presentViewController:navi animated:YES completion:nil];
            
            [self performSelector:@selector(delayPoptoRoot) withObject:nil afterDelay:1];
        }
        else
        {
            BSFetchPosSessionRequest *request = [[BSFetchPosSessionRequest alloc] init];
            if ( [request execute] )
            {
                [[CBLoadingView shareLoadingView] show];
            }
        }
    }
}

#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchStartInfoResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if (result == 0)
        {
            [self reloadLeftItem];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchStartPosResponse] || [notification.name isEqualToString:kBSFetchPosSessionResponse] || [notification.name isEqualToString:kBSPosSessionOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        [self refreshBottomView];
    }
    else if ([notification.name isEqualToString:kUpdateLocalPosOperateNotification])
    {
        localPosOperateCount = [notification.userInfo[@"count"] integerValue];
        [self.sidebarTableView reloadData];
    }
    else if ([notification.name isEqualToString:kUpdateH9NotifyNotification])
    {
        H9NofityCount = [notification.userInfo[@"count"] integerValue];
        [self.sidebarTableView reloadData];
    }
    else if ([notification.name isEqualToString:kPadAccountLogoutResponse] || [notification.name isEqualToString:kPadAccountChangeResponse])
    {
        self.selectedIndex = 0;
        [self.sidebarTableView reloadData];
        
        CBRotateNavigationController *naviController = nil;
        PadPicHomeViewController * centerViewController = [[PadPicHomeViewController alloc] initWithNibName:@"PadPicHomeViewController" bundle:nil];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
        
        [naviController setNavigationBarHidden:YES animated:NO];
        [self.mm_drawerController setCenterViewController:naviController];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        
        PadLoginViewController *viewController = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
        if ([notification.name isEqualToString:kPadAccountChangeResponse])
        {
            CDUser *userinfo = (CDUser *)notification.object;
            viewController.userTextField.text = userinfo.mobile;
        }
        CBRotateNavigationController *navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        [navi.navigationBar setCustomizedNaviBar:YES];
        if (IS_SDK8)
        {
            [self.navigationController.view addSubview:navi.view];
        }
        [self.mm_drawerController.centerViewController presentViewController:navi animated:NO completion:nil];
    }
    else if ([notification.name isEqualToString:kPadSelectMemberAndCardFinish])
    {
        NSNumber *toOrder = (NSNumber *)notification.object;
        if (toOrder.boolValue)
        {
            CDMemberCard *memberCard = (CDMemberCard *)[notification.userInfo objectForKey:@"card"];
            CDCouponCard *couponCard = (CDCouponCard *)[notification.userInfo objectForKey:@"coupon"];
            
            PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:memberCard couponCard:couponCard handno:nil];
            [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:viewController animated:YES];
        }
    }
    else if ( [notification.name isEqualToString:kBSPadCashierSuccess] )
    {
        [(UINavigationController*)self.mm_drawerController.centerViewController popToRootViewControllerAnimated:NO];
        CBRotateNavigationController *naviController = nil;
        
        if ( self.isShouyintai )
        {
            self.selectedIndex = kPadSideBarTypeCashier;
            [PersonalProfile currentProfile].yimeiWorkFlowArray = nil;
            PadHomeViewController * centerViewController = [[PadHomeViewController alloc] initWithNibName:@"PadHomeViewController" bundle:nil];
            centerViewController.isShouyintai = YES;
            self.isShouyintai = YES;
            naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
            [naviController setNavigationBarHidden:YES animated:NO];
            [self.mm_drawerController setCenterViewController:naviController];
            [self.sidebarTableView reloadData];
        }
        else if ( kPadSideBarTypePos != 100)
        {
            self.selectedIndex = kPadSideBarTypePos;
            [PersonalProfile currentProfile].yimeiWorkFlowArray = nil;
            PadHomeViewController * centerViewController = [[PadHomeViewController alloc] initWithNibName:@"PadHomeViewController" bundle:nil];
            naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
            [naviController setNavigationBarHidden:YES animated:NO];
            [self.mm_drawerController setCenterViewController:naviController];
            [self.sidebarTableView reloadData];
        }
    }
    else if ( [notification.name isEqualToString:kBSPadGiveGiftCard] || [notification.name isEqualToString:kBSPadAllotPerformance] )
    {
        NSNumber* popOperateID = notification.object;
        BOOL isPopGiveCard = false;
        if ([notification.name isEqualToString:kBSPadGiveGiftCard])
        {
            isPopGiveCard = true;
        }
        
        if ( popOperateID )
        {
            if ( isPopGiveCard )
            {
                CDMember *member = [notification.userInfo objectForKey:@"member"];
                PadGiveViewController *padGiveVC = [[PadGiveViewController alloc] initWithNibName:@"PadGiveViewController" bundle:nil];
                padGiveVC.member = member;
                padGiveVC.operateID = popOperateID;
                [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:padGiveVC animated:YES];
            }
            else
            {
                PadPosViewController *posViewController = [[PadPosViewController alloc] init];
                posViewController.operateID = popOperateID;
                [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:posViewController animated:YES];
            }
        }
    }
    else if ( [notification.name isEqualToString:kBSCashMemberAgain] )
    {
        CDMemberCard *memberCard = (CDMemberCard *)notification.object;
        
        PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:memberCard couponCard:nil handno:nil];
        [(UINavigationController*)self.mm_drawerController.centerViewController popViewControllerAnimated:NO];
        [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:viewController animated:NO];
    }
    else if ( [notification.name isEqualToString:kGoH9Notify] )
    {
        [(UINavigationController*)self.mm_drawerController.centerViewController popToRootViewControllerAnimated:NO];
        CBRotateNavigationController *naviController = nil;
        
        self.selectedIndex = kPadSideBarType9ShoushuTixing;
        
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"H9ShoushuBoard" bundle:nil];
        UIViewController* centerViewController = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"notify"];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
        [naviController setNavigationBarHidden:YES animated:NO];
        [self.mm_drawerController setCenterViewController:naviController];
        [self.sidebarTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Requied Methods

- (void)setPadSideBarType:(NSInteger)type
{
    self.selectedIndex = type;
    [self.sidebarTableView reloadData];
}

- (void)reloadData
{
    [self.sidebarTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kPadSideBarTypeCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadSideBarCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadSideBarCellIdentifier";
    PadSideBarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PadSideBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *imagestr = @"";
    cell.remindImageView.hidden = YES;
    if (indexPath.row == kPadSideBarTypeHomePic)
    {
        imagestr = @"pad_side_reserve";
        cell.titleLabel.text = @"主页";
    }
    else if (indexPath.row == kPadSideBarTypePos)
    {
        imagestr = @"pad_side_pos";
        cell.titleLabel.text = LS(@"PadSideBarTypePos");
        if (localPosOperateCount > 0)
        {
            cell.remindImageView.hidden = NO;
            cell.remindLabel.text = [NSString stringWithFormat:@"%d", localPosOperateCount];
            CGSize minSize = [cell.remindLabel.text sizeWithFont:cell.remindLabel.font constrainedToSize:CGSizeMake(1024.0, cell.remindLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
            CGFloat width = minSize.width;
            if (width < cell.remindImageView.frame.size.height - 2 * cell.remindLabel.frame.origin.x)
            {
                width = cell.remindImageView.frame.size.height - 2 * cell.remindLabel.frame.origin.x;
            }
            else if (width > 64.0)
            {
                width = 64.0;
            }
            cell.remindLabel.frame = CGRectMake(cell.remindLabel.frame.origin.x, cell.remindLabel.frame.origin.y, width, cell.remindLabel.frame.size.height);
            cell.remindImageView.frame = CGRectMake(cell.remindImageView.frame.origin.x, cell.remindImageView.frame.origin.y, 2 * cell.remindLabel.frame.origin.x + cell.remindLabel.frame.size.width, cell.remindImageView.frame.size.height);
        }
    }
    else if (indexPath.row == kPadSideBarTypeReserve)
    {
        imagestr = @"pad_side_reserve";
        cell.titleLabel.text = LS(@"PadSideBarTypeReserve");
    }
    else if (indexPath.row == kPadSideBarTypeMember)
    {
        imagestr = @"pad_side_member";
        cell.titleLabel.text = LS(@"PadSideBarTypeMember");
    }
    else if (indexPath.row == kPadSidebarTypeHistory)
    {
        imagestr = @"pad_side_history";
        cell.titleLabel.text = LS(@"PadSideBarTypeHistory");
    }
    else if (indexPath.row == kPadSideBarTypeStatistic)
    {
        imagestr = @"pad_side_statistic";
        cell.titleLabel.text = LS(@"PadSideBarTypeStatistic");
    }
    else if (indexPath.row == kPadSideBarTypeSetting)
    {
        imagestr = @"pad_side_setting";
        cell.titleLabel.text = LS(@"PadSideBarTypeSetting");
    }
    else if (indexPath.row == kPadSideBarTypeFuzhujiancha)
    {
        imagestr = @"pad_side_check";
        cell.titleLabel.text = @"检查";
    }
    else if (indexPath.row == kPadSideBarTypeWenzhen)
    {
        imagestr = @"pad_side_cashier";
        cell.titleLabel.text = @"问诊";
    }
    else if (indexPath.row == kPadSideBarTypeCashier)
    {
        imagestr = @"pad_side_cashier";
        cell.titleLabel.text = @"收银台";
    }
    else if (indexPath.row == kPadSideBarTypeZhuyuan)
    {
        imagestr = @"pad_side_zhuyuan";
        cell.titleLabel.text = @"住院";
    }
    else if (indexPath.row == kPadSideBarTypeYaofang)
    {
        imagestr = @"pad_side_yaofang";
        cell.titleLabel.text = @"药房";
    }
    else if (indexPath.row == kPadSideBarTypeHospital)
    {
        imagestr = @"pad_side_hospital";
        cell.titleLabel.text = @"医院";
    }
    else if (indexPath.row == kPadSideBarTypeFenzhen)
    {
        imagestr = @"pad_side_fenzhen";
        cell.titleLabel.text = @"分诊";
    }
    else if (indexPath.row == kPadSideBarTypeZixun)
    {
        imagestr = @"pad_side_zixun";
        cell.titleLabel.text = @"咨询";
    }
    else if (indexPath.row == kPadSideBarTypeZongkong)
    {
        imagestr = @"pad_side_zongkong";
        cell.titleLabel.text = @"总控";
    }
    else if (indexPath.row == kPadSideBarTypePatient)
    {
        imagestr = @"pad_side_patient";
        cell.titleLabel.text = @"病人";
    }
    else if (indexPath.row == kPadSideBarTypePaidui)
    {
        imagestr = @"pad_side_paidui";
        cell.titleLabel.text = @"顾客状态";
    }
    else if (indexPath.row == kPadSideBarTypeKaidanjilu)
    {
        imagestr = @"pad_side_history";
        cell.titleLabel.text = @"开单记录";
    }
    else if ( indexPath.row == kPadSideBarTypeGuadanjiesuan )
    {
        imagestr = @"pad_side_pos";
        cell.titleLabel.text = @"报单结算";
    }
    else if ( indexPath.row == kPadSideBarType9ShoushuTixing )
    {
        imagestr = @"pad_side_shoushutixing";
        cell.titleLabel.text = @"事件提醒";
        
        if (H9NofityCount > 0)
        {
            cell.remindImageView.hidden = NO;
            cell.remindLabel.text = [NSString stringWithFormat:@"%d", H9NofityCount];
            CGSize minSize = [cell.remindLabel.text sizeWithFont:cell.remindLabel.font constrainedToSize:CGSizeMake(1024.0, cell.remindLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
            CGFloat width = minSize.width;
            if (width < cell.remindImageView.frame.size.height - 2 * cell.remindLabel.frame.origin.x)
            {
                width = cell.remindImageView.frame.size.height - 2 * cell.remindLabel.frame.origin.x;
            }
            else if (width > 64.0)
            {
                width = 64.0;
            }
            cell.remindLabel.frame = CGRectMake(cell.remindLabel.frame.origin.x, cell.remindLabel.frame.origin.y, width, cell.remindLabel.frame.size.height);
            cell.remindImageView.frame = CGRectMake(cell.remindImageView.frame.origin.x, cell.remindImageView.frame.origin.y, 2 * cell.remindLabel.frame.origin.x + cell.remindLabel.frame.size.width, cell.remindImageView.frame.size.height);
        }
    }
    else if ( indexPath.row == kPadSideBarType9ShoushuAnpai )
    {
        imagestr = @"pad_side_shoushuanpai";
        cell.titleLabel.text = @"手术安排";
    }
    else
    {
        if ( indexPath.row <= kPadSideBarTypeOperator )
        {
            NSDictionary* dict = [PersonalProfile currentProfile].accessModels[indexPath.row - 1];
            imagestr = @"pad_side_workflow";
            cell.titleLabel.text = dict[@"name"];
        }
    }
    
    if (indexPath.row == self.selectedIndex)
    {
        imagestr = [NSString stringWithFormat:@"%@_h", imagestr];
        cell.titleLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        imagestr = [NSString stringWithFormat:@"%@_n", imagestr];
        cell.titleLabel.textColor = COLOR(175.0, 249.0, 250.0, 1.0);
    }
    
    cell.iconImageView.image = [UIImage imageNamed:imagestr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == kPadSideBarTypeReserve)
    {
        PersonalProfile* profile = [PersonalProfile currentProfile];
        if ([profile.isBook boolValue])
        {
            self.selectedIndex = indexPath.row;
            [self.sidebarTableView reloadData];
        }
    }
    else
    {
        self.selectedIndex = indexPath.row;
        [self.sidebarTableView reloadData];
    }
    
    CBRotateNavigationController *naviController = nil;
    
    if (indexPath.row == kPadSideBarTypeHomePic)
    {
        PadPicHomeViewController * centerViewController = [[PadPicHomeViewController alloc] initWithNibName:@"PadPicHomeViewController" bundle:nil];
        centerViewController.notShowHeader = TRUE;
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if (indexPath.row == kPadSideBarTypePos)
    {
        self.isShouyintai = NO;
        [PersonalProfile currentProfile].yimeiWorkFlowArray = nil;
        PadHomeViewController * centerViewController = [[PadHomeViewController alloc] initWithNibName:@"PadHomeViewController" bundle:nil];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if (indexPath.row == kPadSideBarTypeReserve)
    {
        PadBookMainViewController *viewController = [[PadBookMainViewController alloc] initWithNibName:@"PadBookMainViewController" bundle:nil];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    }
    else if (indexPath.row == kPadSideBarTypeMember)
    {
        PadMemberAndCardViewController *viewController = [[PadMemberAndCardViewController alloc] initWithViewType:kPadMemberAndCardDefault];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        viewController.rootNaviationVC = naviController;
    }
    else if (indexPath.row == kPadSidebarTypeHistory)
    {
        HistoryPosViewController *viewController = [[HistoryPosViewController alloc] initWithNibName:@"HistoryPosViewController" bundle:nil];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    }
    else if (indexPath.row == kPadSideBarTypeStatistic)
    {
        PersonalProfile* profile = [PersonalProfile currentProfile];

        NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=dashboard",profile.userName,profile.password];
        NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",profile.userName,profile.password];
        
        NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[profile token]];
        
        NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
        NSString* sign = [userData md5Hash];
        
        PadWebViewController* webViewController = [[PadWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",profile.baseUrl,profile.sql,sendParams,sign,[profile deviceString]]];
        webViewController.disableBounces = YES;
        webViewController.hideNavigation = YES;
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:webViewController];
    }
    else if (indexPath.row == kPadSideBarTypeSetting)
    {
        PadSettingViewController *viewController = [[PadSettingViewController alloc] initWithViewType:kPadSettingViewDefault];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    }
    else if (indexPath.row == kPadSideBarTypeHospital)
    {
#if 1
        PadHospitalMainViewController* vc = [[PadHospitalMainViewController alloc] initWithNibName:@"PadHospitalMainViewController" bundle:nil];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:vc];
#else
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"Zongkong" bundle:nil];
        QianTaiFenzhenMainViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
#endif
    }
    else if (indexPath.row == kPadSideBarTypeFenzhen)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"QianTaiFenzhen" bundle:nil];
        QianTaiFenzhenMainViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if (indexPath.row == kPadSideBarTypeZixun)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"ZixunBoard" bundle:nil];
        UIViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if (indexPath.row == kPadSideBarTypeZongkong)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"Zongkong" bundle:nil];
        UIViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if (indexPath.row == kPadSideBarTypePatient)
    {
        PadHospitalPatientMainViewController* vc = [[PadHospitalPatientMainViewController alloc] initWithNibName:@"PadHospitalPatientMainViewController" bundle:nil];
        vc.isMenuButton = YES;
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:vc];
    }
    else if (indexPath.row == kPadSideBarTypePaidui)
    {
        HJiaoHaoListViewController* vc = [[HJiaoHaoListViewController alloc] initWithNibName:@"HJiaoHaoListViewController" bundle:nil];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:vc];
    }
    else if (indexPath.row == kPadSideBarTypeKaidanjilu)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"YimeiHistoryStoryboard" bundle:nil];
        UIViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if (indexPath.row == kPadSideBarTypeGuadanjiesuan)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"GuadanBoard" bundle:nil];
        UIViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if (indexPath.row == kPadSideBarType9ShoushuTixing)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"H9ShoushuBoard" bundle:nil];
        UIViewController* centerViewController = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"notify"];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if (indexPath.row == kPadSideBarType9ShoushuAnpai)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"H9ShoushuBoard" bundle:nil];
        UIViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if ( indexPath.row  == kPadSideBarTypeFuzhujiancha)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"Check" bundle:nil];
        CheckMainViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if ( indexPath.row  == kPadSideBarTypeWenzhen)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"WenZhen" bundle:nil];
        WenZhenViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if ( indexPath.row  == kPadSideBarTypeCashier)
    {
        [PersonalProfile currentProfile].yimeiWorkFlowArray = nil;
        PadHomeViewController * centerViewController = [[PadHomeViewController alloc] initWithNibName:@"PadHomeViewController" bundle:nil];
        centerViewController.isShouyintai = YES;
        self.isShouyintai = YES;
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if ( indexPath.row  == kPadSideBarTypeZhuyuan)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"BingFang" bundle:nil];
        BingFangMainViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if ( indexPath.row  == kPadSideBarTypeYaofang)
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"Yaofang" bundle:nil];
        PadYaofangViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    }
    else if( indexPath.row <= kPadSideBarTypeOperator )
    {
        NSDictionary* dict = [PersonalProfile currentProfile].accessModels[indexPath.row - 1];
        [PersonalProfile currentProfile].yimeiWorkFlowArray = @[dict[@"id"]];
        [PersonalProfile currentProfile].yimeiWorkFlowName = dict[@"name"];
        if ([[PersonalProfile currentProfile].yimeiWorkFlowName isEqualToString:@"问诊"])
        {
            UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"WenZhen" bundle:nil];
            WenZhenViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
            naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
        }
        else
        {
            PadHomeViewController * centerViewController = [[PadHomeViewController alloc] initWithNibName:@"PadHomeViewController" bundle:nil];
            naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
        }
    }
    else
    {
        return;
    }
    
    [naviController setNavigationBarHidden:YES animated:NO];
    [self.mm_drawerController setCenterViewController:naviController];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSideBarItemSelected:)])
    {
        
    }
}

@end
