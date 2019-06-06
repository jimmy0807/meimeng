//
//  YimeiPosOperateRightPhotoViewController.m
//  ds
//
//  Created by jimmy on 16/11/3.
//
//

#import "YimeiPosOperateRightPhotoViewController.h"
#import "YimeiPhotoCollectionViewCell.h"
#import "UploadPicToZimg.h"
#import "ZJImageMagnification.h"
#import "UIImage+Scale.h"
#import "BSUserDefaultsManager.h"

@interface YimeiPosOperateRightPhotoViewController ()
@property(nonatomic, weak)IBOutlet UICollectionView* collectionView;
@property(nonatomic, weak)IBOutlet UILabel* naviLabel;
@property(nonatomic, strong)NSMutableArray* imageArray;
@property(nonatomic, strong)NSString* cameraName;

@property (nonatomic, strong)IBOutlet UIButton *addCameraPhoto;
@property(nonatomic)BOOL isUpLoading;
@property(nonatomic)NSTimer* timer;
@property(nonatomic)NSInteger downloadingBytes;
@property(nonatomic)NSInteger lastestBytes;
@property(nonatomic)NSTimeInterval downloadStartTime;
@property(nonatomic, strong)CDYimeiImage* downloadingImage;
@property(nonatomic, strong)CDYimeiImage* lastestDownloadingImage;
@end

@implementation YimeiPosOperateRightPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName: @"YimeiPhotoCollectionViewCell" bundle: nil] forCellWithReuseIdentifier:@"YimeiPhotoCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoCollectionHeader"];
    [self registerNofitificationForMainThread:kFetchWashHandDetailResponse];
    [self registerNofitificationForMainThread:@"CamaraIsSet"];
    [self preparePhotos];
    
//    self.addCameraPhoto = [[UIButton alloc] initWithFrame:CGRectMake(505, 0, 99, 70)];
//    self.addCameraPhoto.backgroundColor = COLOR(96, 211, 212, 1);
//    [self.addCameraPhoto setTitle:@"相机照片" forState:UIControlStateNormal];
//    [self.addCameraPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([PersonalProfile currentProfile].cameraName == nil)
    {
        self.addCameraPhoto.hidden = YES;
    }
    [self.addCameraPhoto addTarget:self action:@selector(selectPhotoFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [self startTimer];
//    [self performSelector:@selector(test) withObject:nil afterDelay:5];
//    self.imageArray = [NSMutableArray array];
    
//    [[[UIApplication sharedApplication] keyWindow] addSubview:self.addCameraPhoto];
}

//- (void)test
//{
//    static int i = 0;
//
//    if ( i == 2 )
//        return;
//    i++;
//    [self performSelector:@selector(test) withObject:nil afterDelay:5];
//
//    CDYimeiImage* image = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
//    image.small_url = @"https://www.baidu.com/img/bd_logo1.png?qua=high&where=super";
//    image.url = @"https://www.baidu.com/img/bd_logo1.png?qua=high&where=super";
//    image.status = @"prepare";
//
//    [self.imageArray addObject:image];
//
//    [self.collectionView reloadData];
//}

- (void)selectPhotoFromCamera
{
    self.addCameraPhoto.enabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPhotoFromCamera" object:nil];
    [self performSelector:@selector(delayToEnable) withObject:nil afterDelay:3.0];
}

- (void)delayToEnable
{
    self.addCameraPhoto.enabled = YES;
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kFetchWashHandDetailResponse] )
    {
        [_imageArray removeAllObjects];
        if (self.washHand.role_option.integerValue == 7) {
            self.naviLabel.text = @"检查";
            for (int i = 0; i < self.washHand.yimei_before.count; i++) {
                if ([self.washHand.yimei_before[i].take_time isEqualToString:@"report"])
                {
                    [_imageArray addObject:self.washHand.yimei_before[i]];
                }
            }
        }
        else {
            for (int i = 0; i < self.washHand.yimei_before.count; i++) {
                if ([self.washHand.yimei_before[i].take_time isEqualToString:@"before"] || [self.washHand.yimei_before[i].take_time isEqualToString:@"after"])
                {
                    [_imageArray addObject:self.washHand.yimei_before[i]];
                }
            }
            self.naviLabel.text = @"照片";
        }
        [self.collectionView reloadData];
    }
    else if ( [notification.name isEqualToString:@"CamaraIsSet"] )
    {
        if ([[notification.userInfo objectForKey:@"CameraName"] length ] > 0)
        {
            if ( ![self.cameraName isEqualToString:[NSString stringWithFormat:@"%@ 已连接",[notification.userInfo objectForKey:@"CameraName"]]] )
            {
                self.cameraName = [NSString stringWithFormat:@"%@ 已连接",[notification.userInfo objectForKey:@"CameraName"]];
                if ( [BSUserDefaultsManager sharedManager].useBigPhoto )
                {
                    [[SDWebImageManager sharedManager] cancelAll];
                }
                
                self.isUpLoading = FALSE;
                [self realoadData];
            }
        }
        else
        {
            if ( ![self.cameraName isEqualToString:[NSString stringWithFormat:@"%@ 已断开",[PersonalProfile currentProfile].cameraName]] )
            {
                self.cameraName =[NSString stringWithFormat:@"%@ 已断开",[PersonalProfile currentProfile].cameraName];
                [self.collectionView reloadData];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.cameraName != nil && self.cameraName.length > 0) {
        return CGSizeMake(1024,34);
    }
    return CGSizeMake(0,0);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoCollectionHeader" forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        for (UIView *subView in reuseableView.subviews) {
            [subView removeFromSuperview];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 23, 300, 16)];
        label.text = self.cameraName;
        label.textColor = COLOR(149, 171, 171, 1);
        [reuseableView addSubview:label];
    }
    return reuseableView;
}

-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        CGPoint location = [longRecognizer locationInView:self.collectionView];
        //成为第一响应者，需重写该方法
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除吗" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:location];
            CDYimeiImage* yimeiImage = _imageArray[indexPath.row];
            [self.imageArray removeObject:yimeiImage];
            yimeiImage.washhand = nil;
            [self realoadData];
        }]];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YimeiPhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YimeiPhotoCollectionViewCell" forIndexPath:indexPath];
    
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    
    longPressGesture.minimumPressDuration=1.5f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];
    
    CDYimeiImage* yimeiImage = _imageArray[indexPath.row];
    cell.yimeiImage = yimeiImage;

    if ( [yimeiImage.status isEqualToString:@"uploading"] )
    {
        cell.progressBgView.hidden = NO;
        cell.progressLabel.text = @"正在上传...";
    }
    else if ( [yimeiImage.status isEqualToString:@"prepare"] )
    {
        cell.progressLabel.text = @"准备上传...";
        cell.progressBgView.hidden = NO;
    }
    else if ( [yimeiImage.status isEqualToString:@"failed"] )
    {
        cell.progressBgView.hidden = NO;
        cell.progressLabel.text = @"上传失败\n点击重试";
    }
    else if ( [yimeiImage.status isEqualToString:@"success"] )
    {
        cell.progressBgView.hidden = YES;
        cell.progressLabel.text = @"";
    }
    else
    {
        cell.progressBgView.hidden = YES;
        cell.progressLabel.text = @"";
    }
    
    if ( ![BSUserDefaultsManager sharedManager].useBigPhoto )
    {
        cell.progressBgView.hidden = YES;
        cell.progressLabel.text = @"";
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(172,130);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(25, 30, 25, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDYimeiImage* yimeiImage = _imageArray[indexPath.row];
    
    if ( ![BSUserDefaultsManager sharedManager].useBigPhoto )
    {
        if ( ![yimeiImage.type isEqualToString:@"server"]  )
        {
            return;
        }
        
        if ( yimeiImage.url.length == 0 )
        {
            return;
        }
        
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:yimeiImage.url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"123");
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            YimeiPhotoCollectionViewCell* cell = (YimeiPhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            [ZJImageMagnification scanBigImageWithImageView:cell.photoImageView image:image alpha:1];
            NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:yimeiImage.url]];
            [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:YES];
        }];
        
        return;
    }
    
    if ( [yimeiImage.status isEqualToString:@"failed"] )
    {
        //heres
        if ( yimeiImage.url.length > 0 )
        {
            yimeiImage.status = @"prepare";
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            [self reloadUploadImage];
        }
//        else
//        {
//            dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//            dispatch_async(queue, ^{
//                UIImage *image = [UIImage imageWithData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:yimeiImage.bigImageUrl]] returningResponse:NULL error:NULL]];
//                if ( image )
//                {
//                    CGFloat imageWidth = image.size.width;
//                    CGFloat imageHeight = image.size.height;
//
//                    CGFloat imageDestWidth = imageWidth;
//                    CGFloat imageDestHeight = imageHeight;
//                    if (imageWidth > 1024)
//                    {
//                        imageDestWidth = 1024;
//                        imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
//                    }
//
//                    UIImage* compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
//
//                    dispatch_async(dispatch_get_main_queue(), ^(){
//                        NSString* url = [NSString stringWithFormat:@"big_%lld",(NSInteger)[[NSDate date] timeIntervalSince1970] * 1000];
//                        [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:url]];
//
//                        yimeiImage.url = url;
//
//                        yimeiImage.status = @"prepare";
//                        [[BSCoreDataManager currentManager] save:nil];
//                        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//                    });
//                }
//            });
//        }
    }
    else if ( [yimeiImage.status isEqualToString:@"success"] )
    {
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:yimeiImage.url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            YimeiPhotoCollectionViewCell* cell = (YimeiPhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            [ZJImageMagnification scanBigImageWithImageView:cell.photoImageView image:image alpha:1];
            NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:yimeiImage.url]];
            [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:YES];  
        }];
    }
}

- (void)realoadData
{
    [self preparePhotos];

    BOOL find = FALSE;
    for ( CDYimeiImage* yimeiImage in self.imageArray )
    {
        if ( [yimeiImage.status isEqualToString:@"uploading"] )
        {
            find = TRUE;
        }
    }
    
    if ( !find )
    {
        self.isUpLoading = FALSE;
    }
    
    [self reloadUploadImage];
    
    [self.collectionView reloadData];
}

- (void)scrollToEnd
{
    if ( self.collectionView.contentSize.height > self.collectionView.frame.size.height )
    {
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentSize.height - self.collectionView.frame.size.height) animated:TRUE];
    }
    
    BOOL find = FALSE;
    for ( CDYimeiImage* yimeiImage in self.imageArray )
    {
        if ( [yimeiImage.status isEqualToString:@"uploading"] )
        {
            find = TRUE;
        }
    }
    
    if ( !find )
    {
        self.isUpLoading = FALSE;
        [self reloadUploadImage];
    }
}

- (void)preparePhotos
{
    _imageArray = [[NSMutableArray alloc] init];
    if (self.washHand.role_option.integerValue == 7) {
        self.naviLabel.text = @"检查";
        for (int i = 0; i < self.washHand.yimei_before.count; i++) {
            if ([self.washHand.yimei_before[i].take_time isEqualToString:@"report"])
            {
                [_imageArray addObject:self.washHand.yimei_before[i]];
            }
        }
    }
    else {
        for (int i = 0; i < self.washHand.yimei_before.count; i++) {
            if ([self.washHand.yimei_before[i].take_time isEqualToString:@"before"] || [self.washHand.yimei_before[i].take_time isEqualToString:@"after"])  
            {
                [_imageArray addObject:self.washHand.yimei_before[i]];
            }
        }
        self.naviLabel.text = @"照片";
    }
}

- (void)clearUploadingState
{
    self.isUpLoading = TRUE;
}

- (void)reloadUploadImage
{
    if ( ![BSUserDefaultsManager sharedManager].useBigPhoto )
    {
        return;
    }
    
    //[SDWebImageManager sharedManager].imageDownloader.maxConcurrentDownloads = 2;
    
    if ( self.isUpLoading )
    {
        NSLog(@"正在上传");
        return;
    }
    
    NSLog(@"要循环了");
    
    self.downloadingImage = nil;
    
    for ( CDYimeiImage* yimeiImage in self.imageArray )
    {
        if ( [yimeiImage.status isEqualToString:@"prepare"] )
        {
            NSLog(@"找到了");
            UploadPicToZimg* v = [UploadPicToZimg alloc];

            self.isUpLoading = TRUE;
            yimeiImage.status = @"uploading";
            [[BSCoreDataManager currentManager] save:nil];
            
            self.downloadingBytes = 0;
            self.downloadingImage = yimeiImage;
            self.downloadStartTime = [[NSDate date] timeIntervalSince1970];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:yimeiImage.url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                self.downloadingBytes = receivedSize;
                self.downloadStartTime = [[NSDate date] timeIntervalSince1970];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                self.downloadingImage = nil;
                if ( image == nil )
                {
                    self.isUpLoading = FALSE;
                    yimeiImage.status = @"failed";
                    [[BSCoreDataManager currentManager] save:nil];
                    [self.collectionView reloadData];
                    [self reloadUploadImage];
                    
                    return;
                }
                
                dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    NSString* url = yimeiImage.url;
                    __block UIImage* compressedImage = image;
                    CGFloat imageWidth = image.size.width;
                    CGFloat imageHeight = image.size.height;
                        
                    CGFloat imageDestWidth = imageWidth;
                    CGFloat imageDestHeight = imageHeight;
                    if (imageWidth > 1024)
                    {
                        NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:yimeiImage.url]];
                        [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:YES];
                        
                        NSString* key2 = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
                        [[SDWebImageManager sharedManager].imageCache removeImageForKey:key2 fromDisk:YES];
                        
                        imageDestWidth = 1024;
                        imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
                        compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
                        
                        url = [NSString stringWithFormat:@"big_%lld",(NSInteger)[[NSDate date] timeIntervalSince1970] * 1000];
                        [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:url]];
                    }
                        
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        yimeiImage.url = url;
                        yimeiImage.status = @"uploading";
                        [[BSCoreDataManager currentManager] save:nil];
                        
                        NSString* key2 = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
                        [[SDWebImageManager sharedManager].imageCache removeImageForKey:key2 fromDisk:NO];
                            
                        [v uploadPic:compressedImage withWorkFlowId:self.washHand.role_option.integerValue finished:^(BOOL ret, NSString *urlString){
                            compressedImage = nil;
                            self.isUpLoading = false;
                            NSLog(@"上传完成");
                            if ( ret )
                            {
                                yimeiImage.status = @"success";
                                yimeiImage.type = @"server_local";
                                NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:yimeiImage.url]];
                                [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:FALSE];
                                
                                yimeiImage.url = urlString;
                            }
                            else
                            {
                                yimeiImage.status = @"failed";

                            }
                            [[BSCoreDataManager currentManager] save:nil];
                            [self.collectionView reloadData];
                            [self reloadUploadImage];
                        }];
                    });
                });
            }];
            
            break;
        }
    }
}

- (void)clearTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer
{
    if ( ![BSUserDefaultsManager sharedManager].useBigPhoto )
    {
        return;
    }
    
    WeakSelf
    [self clearTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTimeOut) userInfo:nil repeats:TRUE];
//    self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf checkTimeOut];
//    }];
}

- (void)checkTimeOut
{
    if ( self.lastestDownloadingImage !=  self.downloadingImage )
    {
        self.lastestDownloadingImage = self.downloadingImage;
        self.lastestBytes = self.downloadingBytes;
        return;
    }
        
    if ( [[NSDate date] timeIntervalSince1970] - self.downloadStartTime >= 2000 )
    {
        if ( self.downloadingBytes - self.lastestBytes <= 1024 )
        {
            self.downloadingImage.status = @"failed";
            [[BSCoreDataManager currentManager] save];
            
            [[SDWebImageManager sharedManager] cancelAll];
            
            self.isUpLoading = FALSE;
            
            [self realoadData];
        }
    }
    
    self.lastestBytes = self.downloadingBytes;
    self.lastestDownloadingImage = self.downloadingImage;
}

- (void)dealloc
{
    
}

@end
