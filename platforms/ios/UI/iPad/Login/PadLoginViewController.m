//
//  PadLoginViewController.m
//  Boss
//
//  Created by lining on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadLoginViewController.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "GestureUnlockViewController.h"
#import "BSLoginRequest.h"
#import "BSUserDefaultsManager.h"
#import "BSPadDataRequest.h"
#import "PadWebViewController.h"
#import "StoreCollectionViewCell.h"
#import "BSCreateDeviceRequest.h"
#import "BSFetchStartInfoRequest.h"
#import "BSFetchStaffRequest.h"
#import "BossPermissionManager.h"
#import "FetchCompanyUUIDRequest.h"
#import "BSPrintPosOperateRequest.h"
#import "FetchWXCardUrlRequest.h"
#import "BSChangeStoreRequest.h"

@interface PadLoginViewController ()<GestureUnlockViewControllerDelegate,VLabelDelegate,PadWebViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL isRememberPw;
}
@property(nonatomic, weak)IBOutlet VLabel* registerLabel;
@property(nonatomic, weak)IBOutlet UIView* selectStoreView;
@property(nonatomic, weak)IBOutlet UIView* changeStoreView;
@property(nonatomic, weak)IBOutlet UILabel* currentStoreLabel;
@property(nonatomic, weak)IBOutlet UICollectionView* storeCollectionView;
@property(nonatomic, strong)NSMutableArray* storeNameArray;
@property(nonatomic, strong)NSMutableArray* storeIdArray;
@property(nonatomic, strong)NSNumber* changeStoreID;
@property(nonatomic, strong)NSString* changeStoreName;

@end

@implementation PadLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.userTextField.delegate = self;
//    self.pwdTextField.delegate = self;
#ifdef BossTest
    self.userTextField.text = @"18688880001"; //收银员:13522223333  //经理:13912345678
    self.pwdTextField.text = @"123456";
#endif
    self.pwdTextField.secureTextEntry = true;
    
    isRememberPw = true;
    
    self.registerLabel.delegate = self;
    
    [self.storeCollectionView registerClass:[StoreCollectionViewCell class] forCellWithReuseIdentifier:@"StoreCollectionViewCell"];
    self.selectStoreView.hidden = YES;
    self.changeStoreView.hidden = YES;
    [self registerNofitificationForMainThread:kBSLoginResponse];
    [self registerNofitificationForMainThread:kBSFetchStoreListResponse];
    [self registerNofitificationForMainThread:kBSChangeStoreResponse];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Button Action
- (IBAction)eyeBtnPressed:(id)sender {
    self.eyeImgView.highlighted = !self.eyeImgView.highlighted;
    self.pwdTextField.secureTextEntry = !self.eyeImgView.highlighted;
}

- (IBAction)loginBtnPressed:(id)sender {
    NSLog(@"登录");
    if (self.userTextField.text.length == 0 || self.pwdTextField.text.length == 0) {
        CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:@"用户名或密码为空"];
        [msgView show];
        return;
    }
    
    /*
     
     V9N00000060 http://dianshang.xinzhuiguoji.com
     V9N00000059 http://ds.mega.wang
     V9N00000080 http://ds.xyam999.com
     V9N00000091 http://hengshi.we-erp.com 东湖
     
     https://www.pgyer.com/xinzhuiguoji
     https://www.pgyer.com/mega
     https://www.pgyer.com/bornxyam
     https://fir.im/hengshi
     */
    
    /*
     profile.baseUrl = @"http://hengshi.we-erp.com";
     profile.sql = @"V9N00000091";
     */
    
    PersonalProfile *profile = [[PersonalProfile alloc] init];
    profile.baseUrl = @"http://ds.xyam999.com";
    profile.sql = @"V9N00000080";
    profile.born_uuid = @"born_uuid";
    [profile save];
    
    BSCreateDeviceRequest *request = [[BSCreateDeviceRequest alloc] initWithUserName:self.userTextField.text password:self.pwdTextField.text];
    [request execute];
    
//    BSLoginRequest *req = [[BSLoginRequest alloc] initWithUserName:self.userTextField.text password:self.pwdTextField.text];
//    [req execute];
//    [[CBLoadingView shareLoadingView] show];
}

- (void)vLabel:(VLabel *)vLabel touchesWtihTag:(NSInteger)tag
{
    PadWebViewController* webViewController = [[PadWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",SERVER_IP,@"/site/register_mobile"]];
    webViewController.isCloseButton = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didObserveSchemeFind:(NSURLRequest*)request
{
}

#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSLoginResponse]) {
        
        [[CBLoadingView shareLoadingView] hide];
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            self.selectStoreView.hidden = NO;
            NSArray *stores = [[BSCoreDataManager currentManager] fetchAllStoreList];
            self.storeNameArray = [NSMutableArray array];
            self.storeIdArray = [NSMutableArray array];
            NSInteger *currentIdx = -1;
            for (int i = 0;  i < stores.count; i++) {
                CDStore *store = [stores objectAtIndex:i];
                currentIdx = i;
                if([[PersonalProfile currentProfile].shopIds containsObject:store.storeID])
                {
                    [self.storeNameArray addObject:store.storeName];
                    [self.storeIdArray addObject:store.storeID];
                    if (store.storeID == [PersonalProfile currentProfile].bshopId) {
                        self.currentStoreLabel.text = store.storeName;
                    }
                }
            }
            [self.storeCollectionView reloadData];
            NSLog(@"%@",self.storeNameArray);
            
//            if (isRememberPw)
//            {
//                NSString *passwordKey = GestureUnlockPassword([[PersonalProfile currentProfile].userID stringValue]);
//                NSString *keychainString = [ICKeyChainManager getPasswordForUsername:passwordKey];
//                if (keychainString.length == 0)
//                {
//                    GestureUnlockViewController *gestureUnlockVC = [[GestureUnlockViewController alloc] initWithNibName:@"GestureUnlockViewController" bundle:nil];
//                    gestureUnlockVC.type = GestureUnlockType_AddPW_First;
//                    gestureUnlockVC.delegate = self;
//                    [self.navigationController pushViewController:gestureUnlockVC animated:YES];
//                }
//                else
//                {
//                    [BSUserDefaultsManager sharedManager].rememberPassword = YES;
//                    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                    
//                    [[BSPadDataRequest sharedInstance] startDataRequest];
//                }
//            }
//            else
//            {
//                [BSUserDefaultsManager sharedManager].rememberPassword = NO;
//                self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                [self dismissViewControllerAnimated:YES completion:nil];
//                
//                [[BSPadDataRequest sharedInstance] startDataRequest];
//            }
        }
        else
        {
            NSString *message = [notification.userInfo objectForKey:@"rm"];
            UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [view show];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchStoreListResponse]){
        [[CBLoadingView shareLoadingView] hide];
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            self.selectStoreView.hidden = NO;
            NSArray *stores = [[BSCoreDataManager currentManager] fetchAllStoreList];
            self.storeNameArray = [NSMutableArray array];
            self.storeIdArray = [NSMutableArray array];
            NSInteger *currentIdx = -1;
            for (int i = 0;  i < stores.count; i++) {
                CDStore *store = [stores objectAtIndex:i];
                currentIdx = i;
                if([[PersonalProfile currentProfile].shopIds containsObject:store.storeID])
                {
                    [self.storeNameArray addObject:store.storeName];
                    [self.storeIdArray addObject:store.storeID];
                    if (store.storeID == [PersonalProfile currentProfile].bshopId) {
                        self.currentStoreLabel.text = store.storeName;
                    }
                }
            }
            [self.storeCollectionView reloadData];
            NSLog(@"%@",self.storeNameArray);
        }
        else{
            NSString *message = [notification.userInfo objectForKey:@"rm"];
            UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [view show];
        }
    }
    else if ([notification.name isEqualToString:kBSChangeStoreResponse]){
        [[CBLoadingView shareLoadingView] hide];
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            self.currentStoreLabel.text = self.changeStoreName;
            [PersonalProfile currentProfile].bshopId = self.changeStoreID;
            [[PersonalProfile currentProfile] save];
        }
        else{
            NSString *message = [notification.userInfo objectForKey:@"rm"];
            UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [view show];
        }
    }
}

#pragma mark -
#pragma mark GestureUnlockViewControllerDelegate Methods

- (void)passStep:(GestureUnlockViewController *)gestureUnlockVC
{
    [BSUserDefaultsManager sharedManager].rememberPassword = NO;
    [self dismissViewControllerAnimated:YES completion:nil];

    [[BSPadDataRequest sharedInstance] startDataRequest];
}

- (void)addGestureSuccess:(GestureUnlockViewController *)gestureUnlockVC
{
    [BSUserDefaultsManager sharedManager].rememberPassword = YES;
    [self dismissViewControllerAnimated:YES completion:nil];

    [[BSPadDataRequest sharedInstance] startDataRequest];
}

#pragma mark -
#pragma mark 选择门店

- (IBAction)closeViewBtnPressed:(id)sender {
    self.changeStoreView.hidden = YES;
}

- (IBAction)changeStoreBtnPressed:(id)sender {
    if (self.storeIdArray.count > 1){
        self.changeStoreView.hidden = NO;
    }
    [self.storeCollectionView reloadData];
}

- (IBAction)finishChooseStoreBtnPressed:(id)sender {
    self.selectStoreView.hidden = NO;

    BSFetchStartInfoRequest *request2 = [[BSFetchStartInfoRequest alloc] init];
    [request2 execute];
    
    [BossPermissionManager sharedManager].haveFetchPermission = false;
    [[BossPermissionManager sharedManager] fetchPermission];

    [[[FetchCompanyUUIDRequest alloc] init] execute];
    
    //[[[FetchWXCardUrlRequest alloc] init] execute];
    
    BSFetchStaffRequest *staffRequest = [[BSFetchStaffRequest alloc] init];
    NSLog(@"UserId : %@",[PersonalProfile currentProfile].userID);
    staffRequest.userID = [PersonalProfile currentProfile].userID;
    [staffRequest execute];
        
    [[[BSPrintPosOperateRequest alloc] init] getBoardcastIP];
    if (isRememberPw)
    {
        NSString *passwordKey = GestureUnlockPassword([[PersonalProfile currentProfile].userID stringValue]);
        NSString *keychainString = [ICKeyChainManager getPasswordForUsername:passwordKey];
        if (keychainString.length == 0)
        {
            GestureUnlockViewController *gestureUnlockVC = [[GestureUnlockViewController alloc] initWithNibName:@"GestureUnlockViewController" bundle:nil];
            gestureUnlockVC.type = GestureUnlockType_AddPW_First;
            gestureUnlockVC.delegate = self;
            [self.navigationController pushViewController:gestureUnlockVC animated:YES];
        }
        else
        {
            [BSUserDefaultsManager sharedManager].rememberPassword = YES;
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [[BSPadDataRequest sharedInstance] startDataRequest];
        }
    }
    else
    {
        [BSUserDefaultsManager sharedManager].rememberPassword = NO;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[BSPadDataRequest sharedInstance] startDataRequest];
    }
}

#pragma mark -
#pragma mark collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.storeNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreCollectionViewCell" forIndexPath:indexPath];
    cell.storeNameLabel.text = self.storeNameArray[indexPath.row];
    cell.storeNameLabel.layer.cornerRadius = 5;
    cell.storeNameLabel.clipsToBounds = YES;
    if (self.storeIdArray[indexPath.row] == [PersonalProfile currentProfile].bshopId) {
        cell.storeNameLabel.textColor = [UIColor whiteColor];
        cell.storeNameLabel.backgroundColor = COLOR(96, 211, 212, 1);
    }
    else {
        cell.storeNameLabel.textColor = COLOR(37, 37, 37, 1);
        cell.storeNameLabel.backgroundColor = [UIColor whiteColor];
        cell.storeNameLabel.layer.borderWidth = 1;
        cell.storeNameLabel.layer.borderColor = [COLOR(220, 224, 224, 1) CGColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.changeStoreName = self.storeNameArray[indexPath.row];
    self.changeStoreID = self.storeIdArray[indexPath.row];
    BSChangeStoreRequest *request = [[BSChangeStoreRequest alloc] initWithShopId:self.changeStoreID];
    [request execute];
    self.changeStoreView.hidden = YES;
}

@end
