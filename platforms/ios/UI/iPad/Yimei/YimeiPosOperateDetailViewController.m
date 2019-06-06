//
//  YimeiPosOperateDetailViewController.m
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import "YimeiPosOperateDetailViewController.h"
#import "YimeiPosOperateLeftDetailViewController.h"
#import "YimeiPosOperateRightDetailViewController.h"
#import "BSFetchPosProductRequest.h"
#import "YimeiSignAfterOperationViewController.h"
#import "PadMaskView.h"
#import "BSFetchPosConsumProduct.h"
#import "FetchWorkHandDetailRequest.h"
#import "CBLoadingView.h"
#import "EditWashHandRequest.h"
#import "HUDHelper.h"
#import "CamFiAPI.h"
#import "MWPhotoBrowser.h"
#import "CameraMedia.h"
#import "AFHTTPRequestOperation.h"
#import "SIOSocket.h"
#import "CamFiAPI.h"
#import "CamFiServerInfo.h"
#import "Utils.h"
#import "SSDPService.h"
#import "SSDPServiceBrowser.h"
#import "SSDPServiceTypes.h"
#import "CamFiClient.h"
#import "ResetIPManager.h"

@interface YimeiPosOperateDetailViewController ()<YimeiPosOperateLeftDetailViewControllerDelegate,YimeiPosOperateRightDetailViewControllerDelegate,SSDPServiceBrowserDelegate,MWPhotoBrowserDelegate>
@property(nonatomic, strong)CBRotateNavigationController* leftNavi;
@property(nonatomic, strong)CBRotateNavigationController* rightNavi;
@property(nonatomic, strong)YimeiPosOperateLeftDetailViewController* leftVc;
@property(nonatomic, strong)YimeiPosOperateRightDetailViewController* rightVc;
@property(nonatomic, strong)PadMaskView *maskView;

//browser
@property (nonatomic, strong) NSMutableArray* cameraMediaArray;
@property (nonatomic, strong) NSMutableArray* photos;
@property (nonatomic, strong) NSMutableArray* thumbs;
@property (nonatomic, strong) MWPhotoBrowser* borwser;

//socket
@property (nonatomic, strong) SIOSocket* socketIO;

@property (nonatomic, strong) SSDPServiceBrowser* ssdpBrowser;
@property (nonatomic, strong) NSMutableArray* clientArray;
@property (nonatomic, strong) NSMutableArray *cameraList;

@property (nonatomic) BOOL didSelectCamera;
@property (nonatomic, strong) NSString *cameraName;
@property (nonatomic) int cameraSelectIndex;
@property (nonatomic, strong) NSString *cameraIP;

@property (nonatomic, strong) UIButton *addCameraPhoto;

@property (nonatomic, strong) NSString *lastURLString;//去重
@property (nonatomic) BOOL isCameraConnected;
@property (nonatomic) BOOL isCheckingStatus;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YimeiPosOperateDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self forbidSwipGesture];
    
    self.leftVc = [[YimeiPosOperateLeftDetailViewController alloc] initWithNibName:@"YimeiPosOperateLeftDetailViewController" bundle:nil];
    self.leftVc.delegate = self;
    self.leftVc.washHand = self.washHand;
    self.leftNavi = [[CBRotateNavigationController alloc] initWithRootViewController:self.leftVc];
    self.leftNavi.navigationBarHidden = YES;
    [self.leftNavi.view addSubview:self.leftVc.view];
    [self.view addSubview:self.leftNavi.view];
    self.leftNavi.view.frame = CGRectMake(0.0, 0.0, 420, IC_SCREEN_HEIGHT);

    self.rightVc = [[YimeiPosOperateRightDetailViewController alloc] initWithNibName:@"YimeiPosOperateRightDetailViewController" bundle:nil];
    self.rightVc.delegate = self;
    self.rightVc.washHand = self.washHand;
    self.rightNavi = [[CBRotateNavigationController alloc] initWithRootViewController:self.rightVc];
    self.rightNavi.navigationBarHidden = YES;
    self.rightNavi.view.frame = CGRectMake(420.0, 0.0, 684, IC_SCREEN_HEIGHT);
    [self.rightNavi.view addSubview:self.rightVc.view];
    [self.view addSubview:self.rightNavi.view];
    
    self.clientArray = [NSMutableArray array];
    self.cameraList = [NSMutableArray array];
    //[[[BSFetchPosProductRequest alloc] initWithPosOperate:self.posOperate] execute];
    //[[[BSFetchPosConsumProduct alloc] initWithPosOperate:self.posOperate] execute];
    
    FetchWorkHandDetailRequest* request = [[FetchWorkHandDetailRequest alloc] init];
    NSLog(@"%@",self.washHand.operate_id);
    request.washHand = self.washHand;
    [request execute];
    
    [[CBLoadingView shareLoadingView] show];
    
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
    
    self.ssdpBrowser = [[SSDPServiceBrowser alloc] initWithServiceType:SSDPServiceType_UPnP_CamFi];
    self.ssdpBrowser.delegate = self;
    
    self.lastURLString = [NSString string];
    //self.isCameraConnected = [PersonalProfile currentProfile].isCameraSelected;
    
    
    [self registerNofitificationForMainThread:@"selectPhotoFromCamera"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startSocketIO];
    [self.rightVc startTimer];
    
    [CamFiAPI camFiStopReceivePhotos:^(NSError* error) {
        
        NSLog(@"%@", error);
    }];
    if(self.addCameraPhoto != nil)
    {
        self.addCameraPhoto.hidden = NO;
    }
    NSInteger role = [self.washHand.role_option integerValue];
    if ( role != YimeiWorkFlow_TakePhoto && role != YimeiWorkFlow_Fuzhujiancha)
    {
        return;
    }
    if ([PersonalProfile currentProfile].isCameraSelected)
    {
//        self.cameraName = [PersonalProfile currentProfile].cameraName;
//        NSDictionary *dict = @{@"CameraName":self.cameraName};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:dict];
//        [self.ssdpBrowser stopBrowsingForServices];
//        [self.ssdpBrowser startBrowsingForServices];
//                self.addCameraPhoto = [[UIButton alloc] initWithFrame:CGRectMake(925, 0, 99, 70)];
//                self.addCameraPhoto.backgroundColor = COLOR(96, 211, 212, 1);
//                [self.addCameraPhoto setTitle:@"相机照片" forState:UIControlStateNormal];
//                [self.addCameraPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [self.addCameraPhoto addTarget:self action:@selector(selectPhotoFromCamera) forControlEvents:UIControlEventTouchUpInside];
//                [[[UIApplication sharedApplication] keyWindow] addSubview:self.addCameraPhoto];
        
        self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(tryReconnect) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
        [self tryReconnect];
    }
//    else
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请在设置中连接设备" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:okAction];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.addCameraPhoto != nil)
    {
        self.addCameraPhoto.hidden = YES;
    }
    [self.timer invalidate];
    self.timer = nil;
    
    [self stopSocket];
    
    [self.rightVc clearUploadingState];
    [self.rightVc clearTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [CamFiAPI camFiStopReceivePhotos:^(NSError* error) {
        
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:@"selectPhotoFromCamera"] )
    {
        [self selectPhotoFromCamera];
    }
}

- (void)didYimeiPosOperateLeftDetailViewBackButtonPressed
{
    EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
    request.notGoNext = YES;
    request.wash = self.washHand;
    [request execute];
    
    //[self checkStillConnect];
    [self stopSocket];
    [self.addCameraPhoto removeFromSuperview];
    [self.rightVc removeNoti];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didYimeiPosOperateLeftDetailViewtakePhotoButtonPressed
{
    [self takePhotoByPad];
//    if(!self.isCameraConnected)
//    {
//        [self showConnecting];
//    }
}

- (void)tryReconnect
{
    WeakSelf

    self.cameraName = [PersonalProfile currentProfile].cameraName;
    NSDictionary *dict = @{@"CameraName":self.cameraName};
    
    [CamFiAPI camFiGetConfig:^(NSError *error, id responseObject) {
        if ( error )
        {
            weakSelf.isCameraConnected = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:nil];
        }
        else
        {
            if ( self.isCameraConnected )
            {
                return;
            }
            
            BOOL isSuccess = false;
            
            if ( responseObject )
            {
                if ( [responseObject isKindOfClass:[NSDictionary class]] )
                {
                    if ( responseObject[@"main"] )
                    {
                        isSuccess = true;
                    }
                }
                else if ( [responseObject isKindOfClass:[NSString class]] )
                {
                    NSString* find = responseObject;
                    if ( [find rangeOfString:@"mian"].location != NSNotFound )
                    {
                        isSuccess = true;
                    }
                }
            }
            
            if ( isSuccess == false )
            {
                weakSelf.isCameraConnected = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:nil];
                return;
            }
            
            weakSelf.isCameraConnected = YES;
            if (weakSelf.rightVc.maskView != nil)
            {
                [weakSelf.rightVc.maskView removeFromSuperview];
            }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:dict];
            
            [CamFiAPI camFiStartReceivePhotos:^(NSError* error) {
                if (error != nil)
                {
                    weakSelf.isCameraConnected = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:nil];
                }
                else
                {
                    //                    [weakSelf.ssdpBrowser stopBrowsingForServices];
                    //                    [weakSelf.ssdpBrowser startBrowsingForServices];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:dict];
                }
            }];
        }
    }];
    
#if 0
    WeakSelf
    if (self.isCameraConnected)
    {
        [self checkStillConnect];
        if (self.rightVc.maskView != nil)
        {
            [self.rightVc.maskView removeFromSuperview];
        }
    }
    else
    {
        self.isCameraConnected = YES;
        self.cameraName = [PersonalProfile currentProfile].cameraName;
        NSDictionary *dict = @{@"CameraName":self.cameraName};
        [CamFiAPI camFiStartReceivePhotos:^(NSError* error) {
            if (error != nil)
            {
                self.isCameraConnected = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:nil];
            }
            else
            {
                [weakSelf.ssdpBrowser stopBrowsingForServices];
                [weakSelf.ssdpBrowser startBrowsingForServices];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:dict];
            }
            NSLog(@"%@", error);
        }];
    }
#endif
}

- (void)showConnecting
{
    if (self.rightVc.maskView == nil) {
        self.rightVc.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, 603, 693)];
        self.rightVc.maskView.backgroundColor = COLOR(242, 245, 245, 1);
    }
    else
    {
        for(UIView *view in self.rightVc.maskView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(193, 142, 220, 220)];
    centerImageView.image = [UIImage imageNamed:@"pad_setting_wifi"];
    [self.rightVc.maskView addSubview:centerImageView];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 391, 603, 30)];
    statusLabel.text = @"正在搜索当前网络中的 CamFi";
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont systemFontOfSize:24];
    statusLabel.textColor = COLOR(96, 211, 212, 1);
    [self.rightVc.maskView addSubview:statusLabel];
    
    UILabel *netnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 448, 603, 14)];
    netnameLabel.text = [NSString stringWithFormat:@"网络名：",[PersonalProfile currentProfile].cameraName];
    netnameLabel.textAlignment = NSTextAlignmentCenter;
    netnameLabel.font = [UIFont systemFontOfSize:14];
    netnameLabel.textColor = COLOR(37, 37, 37, 1);
    [self.rightVc.maskView addSubview:netnameLabel];
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(250, 479, 20, 20)];
    loadingView.color = COLOR(54, 165, 271, 1);
    [loadingView startAnimating];
    [self.rightVc.maskView addSubview:loadingView];
    
    UILabel *waitingLabel = [[UILabel alloc] initWithFrame:CGRectMake(278, 479, 240, 14)];
    waitingLabel.text = @"等待中……";
    waitingLabel.textAlignment = NSTextAlignmentLeft;
    waitingLabel.font = [UIFont systemFontOfSize:14];
    waitingLabel.textColor = COLOR(37, 37, 37, 1);
    [self.rightVc.maskView addSubview:waitingLabel];
    
    [self.rightVc.view addSubview:self.rightVc.maskView];
    [self getCameraListAlreadySet];
    [self performSelector:@selector(showConnectFailed) withObject:nil afterDelay:5];
}

- (void)showConnectFailed
{
    if (self.rightVc.maskView == nil) {
        self.rightVc.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, 603, 693)];
        self.rightVc.maskView.backgroundColor = COLOR(242, 245, 245, 1);
    }
    else
    {
        for(UIView *view in self.rightVc.maskView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    if (self.isCameraConnected) {
        return;
    }
    
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(193, 142, 220, 220)];
    centerImageView.image = [UIImage imageNamed:@"pad_setting_nodevice"];
    [self.rightVc.maskView addSubview:centerImageView];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 392, 464, 60)];
    statusLabel.text = @"连接失败！请打开设置-相机，连接到CamFi的WIFI上。";
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont systemFontOfSize:24];
    statusLabel.textColor = COLOR(96, 211, 212, 1);
    statusLabel.numberOfLines = 2;
    [self.rightVc.maskView addSubview:statusLabel];
    
//    UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 448, 603, 56)];
//    failLabel.text = @"连接失败！请打开设置-相机，连接到CamFi的WIFI上。";
//    failLabel.textAlignment = NSTextAlignmentCenter;
//    failLabel.font = [UIFont systemFontOfSize:14];
//    failLabel.textColor = COLOR(37, 37, 37, 1);
//    failLabel.numberOfLines = 2;
//    [self.rightVc.maskView addSubview:failLabel];
    
    UIButton *usePadButton = [[UIButton alloc] initWithFrame:CGRectMake(233, 514, 137, 40)];
    [usePadButton setTitle:@"使用iPad拍照" forState:UIControlStateNormal];
    [usePadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    usePadButton.backgroundColor = COLOR(96, 211, 212, 1);
    usePadButton.layer.cornerRadius = 6;
    [usePadButton addTarget:self action:@selector(takePhotoByPad) forControlEvents:UIControlEventTouchUpInside];
    [self.rightVc.maskView addSubview:usePadButton];
    
    [self.rightVc.view addSubview:self.rightVc.maskView];
}

- (void)showBrowser
{
    //[HUDHelper hudWithView:self.view andMessage:nil];
    [CamFiAPI camFiGetImagesWithOffset:0 count:400 completionBlock:^(NSError* error, id responseObject) {
        
        //[HUDHelper hiddAllHUDForView:self.view animated:YES];
        NSLog(@"%@", responseObject);
        WeakSelf
        if (responseObject == nil) {
            
//            UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"获取400张图片失败" message:error.description delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
//            [v show];
            
            weakSelf.isCameraConnected = NO;
            [PersonalProfile currentProfile].isCameraConnected = NO;
            [[PersonalProfile currentProfile] save];
            //[weakSelf showConnectFailed];
            return;
        }
        [weakSelf.rightVc.maskView removeFromSuperview];
        weakSelf.cameraMediaArray = [NSMutableArray array];
        weakSelf.photos = [NSMutableArray array];
        weakSelf.thumbs = [NSMutableArray array];
        
        [responseObject enumerateObjectsUsingBlock:^(NSString* _Nonnull path, NSUInteger idx, BOOL* _Nonnull stop) {
            
            CameraMedia* media = [CameraMedia cameraMediaWithPath:path];
            if (!media.isVideo) {
                
                [weakSelf.cameraMediaArray insertObject:media atIndex:0];
                [weakSelf.photos insertObject:[MWPhoto photoWithURL:media.mediaURL] atIndex:0];
                [weakSelf.thumbs insertObject:[MWPhoto photoWithURL:media.mediaThumbURL] atIndex:0];
            }
        }];
        
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = YES;
        BOOL autoPlayOnAppear = NO;
        
        MWPhotoBrowser* browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = autoPlayOnAppear;
        [browser setCurrentPhotoIndex:0];
        
        _borwser = browser;
        
        [self.navigationController pushViewController:browser animated:YES];
    }];
}

- (void)takePhotoByPad
{
    [self.rightVc.maskView removeFromSuperview];
    self.addCameraPhoto.hidden = YES;
    [self.leftVc takePhotoByPad];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser*)photoBrowser
{
    return _photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser*)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser*)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser*)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser*)photoBrowser
{
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoBrowser:(MWPhotoBrowser*)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
#if 0
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:@"下载" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* originalImageAction = [UIAlertAction actionWithTitle:@"原始照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
        
        CameraMedia* media = [self.cameraMediaArray objectAtIndex:index];
        [self saveImageWithURL:media.mediaOriginalURL];
        [photoBrowser.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction* standardImageAction = [UIAlertAction actionWithTitle:@"标准照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        
        CameraMedia* media = [self.cameraMediaArray objectAtIndex:index];
        [self.leftVc savePhotoByCameraWitBigUrl:media.mediaURL.absoluteString subImageUrl:media.mediaThumbURL.absoluteString];
        [photoBrowser.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction* thumbImageAction = [UIAlertAction actionWithTitle:@"缩略照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        
        
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
        
    }];
    
    //[alertController addAction:originalImageAction];
    [alertController addAction:standardImageAction];
    //[alertController addAction:thumbImageAction];
    [alertController addAction:cancelAction];
    alertController.popoverPresentationController.sourceView = photoBrowser.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(930, 720, 100, 50);
    [photoBrowser presentViewController:alertController animated:YES completion:nil];
#endif
    
    CameraMedia* media = [self.cameraMediaArray objectAtIndex:index];
    [self.leftVc savePhotoByCameraWitBigUrl:media.mediaURL.absoluteString subImageUrl:media.mediaThumbURL.absoluteString];
    [photoBrowser.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Download

- (void)saveImageWithURL:(NSURL*)url
{
    [HUDHelper hudWithView:_borwser.view andMessage:nil];
    
    AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        [HUDHelper hiddAllHUDForView:_borwser.view animated:YES];
        [self.leftVc savePhotoByCamera:responseObject subImage:nil];

    }
                                            failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                                
                                                NSLog(@"Image error: %@", error);
                                                [HUDHelper hudWithView:_borwser.view andError:error];
                                            }];
    [requestOperation start];
}

- (void)saveImageToAlbumWithImage:(UIImage*)image
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        [HUDHelper hiddAllHUDForView:_borwser.view animated:YES];
        NSLog(@"Please enable the permissions in order to use your Photo Library. Check your permissions in Settings > Privacy > Photos");
        return;
    }
    else if (status == PHAuthorizationStatusRestricted) {
        [HUDHelper hiddAllHUDForView:_borwser.view animated:YES];
        NSLog(@"PHAuthorizationStatusRestricted");
        return;
    }
    else {
        __block NSString* assetId = nil;
        __block PHAssetChangeRequest* request = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            assetId = request.placeholderForCreatedAsset.localIdentifier;
        }
            completionHandler:^(BOOL success, NSError* _Nullable error) {
                if (!success) {
                    NSLog(@"Save failed: %@", error);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUDHelper hudWithView:_borwser.view andError:error];
                    });
                    return;
                }
                
                PHAsset* asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[ assetId ] options:nil].lastObject;
                                              
                PHAssetCollection* collection = [self camFiAssetCollection];
                if (collection == nil) {
                                                  
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUDHelper hiddAllHUDForView:_borwser.view animated:YES];
                    });
                    return;
                }
                                              
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] addAssets:@[ asset ]];
                }
                    completionHandler:^(BOOL success, NSError* _Nullable error) {
                    if (success) {
                        NSLog(@"Save successfully");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [HUDHelper hudSuccessedAnimationWithView:_borwser.view];
                        });
                    }
                    else {
                        NSLog(@"Save failed: %@", error);
                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                            
                            [HUDHelper hudWithView:_borwser.view andError:error];
                        });
                    }
                    }];
            }];
    }
}

- (PHAssetCollection*)camFiAssetCollection
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        
        return nil;
    }
    else if (status == PHAuthorizationStatusDenied) {
        NSLog(@"Please enable the permissions in order to use your Photo Library. Check your permissions in Settings > Privacy > Photos");
        return nil;
    }
    else if (status == PHAuthorizationStatusRestricted) {
        NSLog(@"PHAuthorizationStatusRestricted");
        return nil;
    }
    
    PHFetchResult<PHAssetCollection*>* collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection* collection in collectionResult) {
        
        if ([collection.localizedTitle isEqualToString:@"CamFi"]) {
            
            return collection;
        }
    }
    
    __block NSString* collectionId = nil;
    NSError* error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"CamFi"].placeholderForCreatedAssetCollection.localIdentifier;
    }
                                                         error:&error];
    
    if (error) {
        return nil;
    }
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[ collectionId ] options:nil].lastObject;
}

- (void)didYimeiPosOperateLeftDetailViewPhotoAdded
{
    self.addCameraPhoto.hidden = NO;
    [self.rightVc realoadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rightVc scrollToEnd];
    });
}

- (void)showYimeiSignAfterOperationViewController:(NSMutableDictionary*)params
{
    if ( self.maskView )
        return;
    
    self.maskView = [[PadMaskView alloc] init];
    [self.view addSubview:self.maskView];
    
    YimeiSignAfterOperationViewController* viewController = [[YimeiSignAfterOperationViewController alloc] initWithNibName:@"YimeiSignAfterOperationViewController" bundle:nil];
    viewController.washHand = self.washHand;
    viewController.params = params;
    
    __weak typeof(self) weakSelf = self;
    viewController.YimeiSignAfterOperationViewControllerFinished = ^(void)
    {
        //self.posOperate.current_workflow_activity_id = @(0);
        //[weakSelf.navigationController popToRootViewControllerAnimated:YES];
        [weakSelf.maskView hidden];
        weakSelf.maskView = nil;
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf.leftVc signFinished];
    };
    
    viewController.YimeiSignAfterOperationViewControllerCancel = ^(void)
    {
        [weakSelf.maskView hidden];
        weakSelf.maskView = nil;
    };
    
    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    [self.maskView addSubview:self.maskView.navi.view];
    [self.maskView show];
}

-(void)showCameraList
{
    if(self.cameraList.count == 0)
    {
        [self.rightVc.maskView removeFromSuperview];
        [self showConnectFailed];
        return;
    }
    
    if (self.rightVc.maskView == nil)
    {
        self.rightVc.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, 603, 693)];
        self.rightVc.maskView.backgroundColor = COLOR(242, 245, 245, 1);
    }
    else
    {
        for (UIView *view in self.rightVc.maskView.subviews)
        {
            [view removeFromSuperview];
        }
//        [self.rightVc.maskView removeFromSuperview];
    }
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(35, 0, 540, 620)];
    infoView.backgroundColor = [UIColor clearColor];
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 540, 85)];
//    titleLabel.text = @"装置";
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    titleLabel.textColor = COLOR(37, 37, 37, 1);
//    [infoView addSubview:titleLabel];
//
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 85, 540, 1)];
//    line.backgroundColor = COLOR(178, 178, 178, 1);
//    [infoView addSubview:line];
    
    UILabel *chooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 196, 540, 30)];
    chooseLabel.text = @"选择设备";
    chooseLabel.textAlignment = NSTextAlignmentCenter;
    chooseLabel.font = [UIFont systemFontOfSize:36];
    chooseLabel.textColor = COLOR(37, 37, 37, 1);
    [infoView addSubview:chooseLabel];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(120, 267, 300, 148)];
    mainView.layer.cornerRadius = 8;
    mainView.layer.borderColor = COLOR(178, 178, 178, 1).CGColor;
    mainView.layer.borderWidth = 1;
    self.cameraSelectIndex = 0;
    UIScrollView *deviceListScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 12, 300, 124)];
    for (int i = 0; i < self.cameraList.count; i++ )
    {
        if (self.cameraList.count == 0) {
            break;
        }
        else
        {
            self.cameraName = self.cameraList[self.cameraSelectIndex];
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, i*31, 300, 31)];
        if (i == self.cameraSelectIndex)
        {
            button.backgroundColor = COLOR(96, 211, 212, 1);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:COLOR(96, 211, 212, 1) forState:UIControlStateNormal];
        }
        button.tag = i;
        [button setTitle:self.cameraList[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectCamera:) forControlEvents:UIControlEventTouchUpInside];
        [deviceListScrollView addSubview:button];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, i*31+30, 300, 1)];
        line.backgroundColor = COLOR(178, 178, 178, 1);
        //[deviceListScrollView addSubview:line];
    }
    [mainView addSubview:deviceListScrollView];
    [infoView addSubview:mainView];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(222, 508, 97, 40)];
    confirmButton.backgroundColor = COLOR(96, 211, 212, 1);
    confirmButton.layer.cornerRadius = 6;
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmCamera) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:confirmButton];
    
    [self.rightVc.maskView addSubview:infoView];
    [self.rightVc.view addSubview:self.rightVc.maskView];
}

-(void)selectCamera:(UIButton *)button
{
    self.cameraSelectIndex = button.tag;
    [self showCameraList];
}

-(void)confirmCamera
{
    for (UIView *view in self.rightVc.maskView.subviews)
    {
        [view removeFromSuperview];
    }
    [self.rightVc.maskView removeFromSuperview];
    
    self.didSelectCamera = YES;
    self.isCameraConnected = YES;
    [PersonalProfile currentProfile].isCameraConnected = YES;
    [[PersonalProfile currentProfile] save];
    if (self.cameraList.count > self.cameraSelectIndex) {
        self.cameraName = self.cameraList[self.cameraSelectIndex];
    }
    if (self.clientArray.count > self.cameraSelectIndex && self.didSelectCamera) {
        self.cameraIP = ((CamFiClient *)self.clientArray[self.cameraSelectIndex]).servicePath;
    }
    [PersonalProfile currentProfile].cameraName = [NSString stringWithString:self.cameraName];
    [PersonalProfile currentProfile].cameraIP = [NSString stringWithString:self.cameraIP];
//    [self getWifiListByCamera];
    [[PersonalProfile currentProfile] save];
    
    NSDictionary *dict = @{@"CameraName":self.cameraName};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:dict];
//    self.addCameraPhoto = [[UIButton alloc] initWithFrame:CGRectMake(925, 0, 99, 70)];
//    self.addCameraPhoto.backgroundColor = COLOR(96, 211, 212, 1);
//    [self.addCameraPhoto setTitle:@"相机照片" forState:UIControlStateNormal];
//    [self.addCameraPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.addCameraPhoto addTarget:self action:@selector(selectPhotoFromCamera) forControlEvents:UIControlEventTouchUpInside];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:self.addCameraPhoto];
//    [CamFiAPI camFiStartReceivePhotos:^(NSError* error) {
//        
//        NSLog(@"%@", error);
//    }];
//    self.timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(checkStillConnect) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    [self.timer fire];
    
    [[ResetIPManager sharedInstance] reload];
}


- (void)selectPhotoFromCamera
{
    [self.leftVc selectPhotoFromCamera];
}

#pragma mark - SocketIO Delegate
- (void)startSocketIO
{
    WeakSelf
    
    if (_socketIO == nil) {
        [SIOSocket socketWithHost:[[CamFiServerInfo sharedInstance] eventURLString] response:^(SIOSocket* socket) {
            NSLog(@"socketIODidConnect:socket connect to server");
            _socketIO = socket;
            
            [socket on:@"file_added" callback:^(SIOParameterArray* args) {

                if ( [self.washHand.state isEqualToString:@"waiting"] )
                {
                    return;
                }
                
                CameraMedia* media = [CameraMedia cameraMediaWithPath:args.firstObject];
                if ([weakSelf.lastURLString isEqualToString:media.mediaURL.absoluteString])
                {
                    
                }
                else
                {
                    [weakSelf.leftVc savePhotoByCameraWitBigUrl:media.mediaURL.absoluteString subImageUrl:media.mediaThumbURL.absoluteString];
                    weakSelf.lastURLString = [NSString stringWithString:media.mediaURL.absoluteString];
                }
                
//                dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//                dispatch_async(queue, ^{
//                    CameraMedia* media = [CameraMedia cameraMediaWithPath:args.firstObject];
//                    if ([weakSelf.lastURLString isEqualToString:media.mediaURL.absoluteString])
//                    {
//
//                    }
//                    else
//                    {
//                        UIImage *smallImage = [UIImage imageWithData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:media.mediaThumbURL] returningResponse:NULL error:NULL]];
//                        UIImage *image = [UIImage imageWithData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:media.mediaURL] returningResponse:NULL error:NULL]];
//
//                        while ( smallImage == nil )
//                        {
//                            sleep(1);
//                            smallImage = [UIImage imageWithData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:media.mediaThumbURL] returningResponse:NULL error:NULL]];
//                        }
//
//                        if ( image == nil )
//                        {
//                            dispatch_async(dispatch_get_main_queue(), ^(){
//                                [weakSelf.leftVc savePhotoByCameraWitBigUrl:media.mediaURL.absoluteString subImage:smallImage];
//                            });
//                        }
//                        else
//                        {
//                            dispatch_async(dispatch_get_main_queue(), ^(){
//                                [weakSelf.leftVc savePhotoByCamera:image subImage:smallImage];
//                            });
//                        }
//
//                        weakSelf.lastURLString = [NSString stringWithString:media.mediaURL.absoluteString];
//                    }
//                });
//                NSLog(@"file_added:%@", args);
//                CameraMedia* media = [CameraMedia cameraMediaWithPath:args.firstObject];
//                NSLog(@"media:%@", media.mediaURL);
//
//                if ([weakSelf.lastURLString isEqualToString:media.mediaURL.absoluteString])
//                {
//
//                }
//                else
//                {
//                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:media.mediaURL]];
//                    UIImage *smallImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:media.mediaThumbURL]];
////                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        // Do the work in background
//                        [weakSelf.leftVc savePhotoByCamera:image subImage:smallImage];
////                    });
//                    weakSelf.lastURLString = [NSString stringWithString:media.mediaURL.absoluteString];
//                }
                //[self.imageView sd_setImageWithURL:media.mediaURL placeholderImage:nil];
            }];
            
//            [socket on:@"camera_add" callback:^(SIOParameterArray* args) {
//                [self.timer invalidate];
//                self.timer = nil;
//            }];
//
//            [socket on:@"camera_remove" callback:^(SIOParameterArray* args) {
////                UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"相机断开了" message:@"camera_remove" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
////                [v show];
//                 self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(tryReconnect) userInfo:nil repeats:YES];
//                 [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//                 [self.timer fire];
//                 [self tryReconnect];
//            }];
            
            socket.onDisconnect = ^{
                AFLogDebug(@"socket.io disconnected.");
                
//                UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"相机断开了" message:@"disconnected" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//                [v show];
                
                weakSelf.isCameraConnected = NO;
                [PersonalProfile currentProfile].isCameraConnected = NO;
                [[PersonalProfile currentProfile] save];
                
//                self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(tryReconnect) userInfo:nil repeats:YES];
//                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//                [self.timer fire];
//                [self tryReconnect];
            };
        }];
    }
}

- (void)stopSocket
{
    if (_socketIO != nil) {
        [_socketIO close];
        _socketIO = nil;
    }
}

- (void)checkStillConnect
{
    [CamFiAPI camFiGetImagesWithOffset:0 count:1 completionBlock:^(NSError* error, id responseObject) {
        
        //[HUDHelper hiddAllHUDForView:self.view animated:YES];
        //NSLog(@"%@", responseObject);
        if (responseObject == nil) {
//            UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"获取图片失败" message:error.description delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
//            [v show];
            
            WeakSelf
            weakSelf.isCameraConnected = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:nil];

//            self.addCameraPhoto.hidden = YES;
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备已断开（相机未开）" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                WeakSelf
//                weakSelf.isCameraConnected = NO;
//                [PersonalProfile currentProfile].isCameraConnected = NO;
//                [[PersonalProfile currentProfile] save];
//                [weakSelf.timer invalidate];
//
//            }];
//            [alert addAction:okAction];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }];
//    [self.ssdpBrowser stopBrowsingForServices];
//    [self.cameraList removeAllObjects];
//    [self.clientArray removeAllObjects];
//    [self.ssdpBrowser startBrowsingForServices];
//    [self performSelector:@selector(checkCameraList) withObject:nil afterDelay:5.0];
    NSLog(@"Checking connect status...");
    self.isCheckingStatus = YES;
    //return YES;
}

- (void)checkCameraList
{
    BOOL connecting = NO;
    for (NSString *cameraName in self.cameraList) {
        if ([cameraName isEqualToString:[PersonalProfile currentProfile].cameraName]) {
            connecting = YES;
        }
    }
    if (!connecting) {
        self.addCameraPhoto.hidden = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备已断开（相机未开）" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WeakSelf
            weakSelf.isCameraConnected = NO;
            [PersonalProfile currentProfile].isCameraConnected = NO;
            [[PersonalProfile currentProfile] save];
            [weakSelf.cameraList removeAllObjects];
            [weakSelf.clientArray removeAllObjects];
            [weakSelf.timer invalidate];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CamaraIsSet" object:nil userInfo:nil];

        }];
        [alert addAction:okAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - ssdp
-(void)getCameraListAlreadySet
{
    self.isCheckingStatus = NO;
    [self.ssdpBrowser stopBrowsingForServices];
    [self.cameraList removeAllObjects];
    [self.clientArray removeAllObjects];
    [self.ssdpBrowser startBrowsingForServices];
    [self performSelector:@selector(stopBrowser) withObject:nil afterDelay:5.0];
}

- (void)stopBrowser
{
    [self.ssdpBrowser stopBrowsingForServices];
}

#pragma mark - SSDP browser delegate methods

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error {
    
    NSLog(@"SSDP Browser got error: %@", error);
}

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service {
    
    NSLog(@"SSDP Browser found: %@", service.servicePath);
    [self.clientArray addObject:[CamFiClient camfiClientWithSSDPService:service]];
    for (CamFiClient *client in self.clientArray)
    {
        //        NSLog(@"%@", client.ssid);
        //        NSLog(@"%@", client.servicePath);
        //        NSLog(@"%@", client.username);
        //        NSLog(@"%@", client.password);
        //        NSLog(@"%@", client.channel);
        
        [self.cameraList addObject:client.ssid];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:self.cameraList.count];
    
    [self.cameraList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [dict setValue:obj forKey:obj];
        
    }];
    
    self.cameraList = [NSMutableArray arrayWithArray:dict.allValues];
//    if (!self.isCheckingStatus) {
//        [self performSelector:@selector(showCameraList) withObject:nil afterDelay:1.0];
//    }
    
    CamFiClient *client = [CamFiClient camfiClientWithSSDPService:service];
    if ( [client.ssid isEqualToString:[PersonalProfile currentProfile].cameraName] )
    {
        [self stopSocket];
        [self startSocketIO];
    }
}

-(void)ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service
{
    NSLog(@"SSDP Browser didRemove: %@", service);
}


@end
