//
//  HomeTabController.m
//  Boss
//
//  Created by jimmy on 15/5/21.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeTabController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "ServiceViewController.h"
#import "SupplierViewController.h"
#import "CBWebViewController.h"
#import "MessageViewController.h"

typedef enum HomeTabType
{
    HomeTabHome = 10000,
    HomeTabService,
    HomeTabSupplier,
    HomeTabSetting
}HomeTabType;

@interface HomeTabController ()
{
    PersonalProfile* profile;
    NSInteger tabBarCount;
}
@property(nonatomic, strong)NSMutableArray* tabButtons;
@property(nonatomic, strong)UIView* tabbarView;
@end

@implementation HomeTabController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_scan_n"] highlightedImage:[UIImage imageNamed:@"navi_scan_h"]];
//    rightButtonItem.delegate = self;
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    if ([self respondsToSelector: @selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if ([self respondsToSelector: @selector(setExtendedLayoutIncludesOpaqueBars:)])
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    if ([self respondsToSelector: @selector(setModalPresentationCapturesStatusBarAppearance:)])
    {
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    if ( [self.tabBar respondsToSelector:@selector(setTranslucent:)] )
    {
        self.tabBar.translucent = NO;
    }
    
    [self reloadViewControllers];
    
    if (!IS_SDK7)
    {
        [super setSelectedIndex:1];
        [self performSelector:@selector(ios6Workaround) withObject:nil afterDelay:0.2];
    }
    self.tabBar.alpha = 0;
}

- (void)ios6Workaround
{
    [super setSelectedIndex:0];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    if (IS_SDK7)
    {
        BNScanCodeViewController *viewController = [[BNScanCodeViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:viewController animated:NO];
    }

}

- (void)reloadViewControllers
{
    profile = [PersonalProfile currentProfile];
    //if ( profile.isLogin )
    {
        HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:NIBCT(@"HomeViewController") bundle:nil];
        ServiceViewController *serviceViewController = [[ServiceViewController alloc] initWithNibName:NIBCT(@"ServiceViewController") bundle:nil];
        
        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:NIBCT(@"SettingViewController") bundle:nil];
        
        if ( 1/*profile.roleOption == RoleOption_boss || profile.roleOption == RoleOption_shopManager*/ )
        {
            SupplierViewController *supplierViewController = [[SupplierViewController alloc] initWithNibName:NIBCT(@"SupplierViewController") bundle:nil];
            self.viewControllers = @[homeViewController,serviceViewController,supplierViewController,settingViewController];
        }
        else
        {
            self.viewControllers = @[homeViewController,serviceViewController,settingViewController];
        }
        
        [self customizeTabBar];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if ( self.tabButtons )
    {
        [self didCustomizedButtonPressed:self.tabButtons[selectedIndex]];
    }
    else
    {
        [super setSelectedIndex:selectedIndex];
    }
}

- (void)customizeTabBar
{
    if ( tabBarCount == self.viewControllers.count )
    {
        return;
    }
    
    [self.tabbarView removeFromSuperview];
    self.tabbarView = nil;
    
    self.tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    self.tabbarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:self.tabbarView.bounds];
    bgImageView.autoresizingMask = 0xff;
    
    bgImageView.image = [UIImage imageNamed:@"Home_Tabbar_BG.png"];
    [self.tabbarView addSubview:bgImageView];
    [self.view addSubview:self.tabbarView];
    
    NSArray* imageArray;
    NSArray* tagArray;
    
    if ( 1/*profile.roleOption == RoleOption_boss || profile.roleOption == RoleOption_shopManager*/ )
    {
        imageArray = @[@"Home_Tabbar_Home",@"Home_Tabbar_Service",@"Home_Tabbar_Supplier",@"Home_Tabbar_Setting"];
        tagArray = @[@(HomeTabHome),@(HomeTabService),@(HomeTabSupplier),@(HomeTabSetting)];
    }
    else
    {
        imageArray = @[@"Home_Tabbar_Home",@"Home_Tabbar_Service",@"Home_Tabbar_Setting"];
        tagArray = @[@(HomeTabHome),@(HomeTabSupplier),@(HomeTabSetting)];
    }
    
    CGFloat width = IC_SCREEN_WIDTH / imageArray.count;
    
    self.tabButtons = [NSMutableArray array];
    
    [imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop)
    {
        UIButton* btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        btn.frame = CGRectMake(width * index, 0, width, 50);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_N.png",obj]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_H.png",obj]] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_H.png",obj]] forState:UIControlStateSelected];
        [btn addTarget: self action: @selector(didCustomizedButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
        btn.tag = [tagArray[index] integerValue];
        [self.tabbarView addSubview:btn];
        
        if ( index == 0 )
        {
            btn.selected = YES;
        }
        
        [self.tabButtons addObject:btn];
     }];
}

- (void)didCustomizedButtonPressed:(UIButton*)button
{
    NSInteger currentIndex = self.selectedIndex;
    if ( currentIndex == button.tag - HomeTabHome )
        return;
    
    UIButton* btn = self.tabButtons[currentIndex];
    btn.selected = NO;
    button.selected = YES;
    
    NSLog(@"button.tag - HomeTabHome = %d",button.tag - HomeTabHome);
    [super setSelectedIndex:button.tag - HomeTabHome];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark QRCodeViewDelegate Methods

- (void)didQRBackButtonClick:(QRCodeView *)qrCodeView
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark -
#pragma mark BNScanCodeDelegate Methods

- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result
{
    NSLog(@"QRCodeScanResult: %@", result);
    if (result.length > 4)
    {
        NSString *substring = [result substringToIndex:4];
        if ([substring isEqualToString:@"http"])
        {
            CBWebViewController *webViewController = [[CBWebViewController alloc] initWithUrl:result];
            [self.navigationController pushViewController:webViewController animated:YES];
            return;
        }
    }
}


@end
