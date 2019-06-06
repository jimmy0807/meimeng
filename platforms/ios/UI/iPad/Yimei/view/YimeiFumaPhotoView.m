//
//  YimeiFumaPhotoView.m
//  meim
//
//  Created by jimmy on 2017/5/25.
//
//

#import "YimeiFumaPhotoView.h"
#import "YimeiFumaPhotoCollectionViewCell.h"
#import "UploadPicToZimg.h"
#import "UIImage+Orientation.h"
#import "UIImage+Scale.h"
#import "BSYimeiEditPosOperateRequest.h"
#import "EditWashHandRequest.h"
#import "BNCameraView.h"

@interface YimeiFumaPhotoView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
{
    NSInteger oringalCount;
}
@property(nonatomic, weak)IBOutlet UICollectionView* collectionView;
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, strong)NSMutableArray* photosArray;
@property(nonatomic, strong)UIScrollView* bigPicScrollView;
@property(nonatomic, strong)UIPageControl* bigPicPageControl;
@property(nonatomic, assign)int showImageIndex;
@property(nonatomic, strong)NSMutableArray* beforeArray;
@property(nonatomic, strong)NSMutableArray* afterArray;
@property(nonatomic, strong)NSMutableArray* checkArray;
@property(nonatomic, strong)NSString* takeTime;
@property(nonatomic)BOOL shouldSave;

@end

@implementation YimeiFumaPhotoView

+ (void)showWithOperate:(CDPosWashHand*)washHand
{
    YimeiFumaPhotoView* v = [YimeiFumaPhotoView loadFromNib];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:v];
    v.alpha = 0;
    v.washHand = washHand;
    
    [UIView animateWithDuration:0.2 animations:^{
        v.alpha = 1;
    }];
    
    v->oringalCount = v.washHand.yimei_before.count;
//    if (v.washHand.currentWorkflowID.integerValue == 4) {
        v.titleLabel.text = @"查看照片";
        v.beforeArray = [NSMutableArray array];
        v.afterArray = [NSMutableArray array];
        v.checkArray = [NSMutableArray array];
        for (int i = 0; i < v.washHand.yimei_before.count; i++){
            //NSLog(@"Taketime:%@",v.washHand.yimei_before[i].take_time);
            if ([v.washHand.yimei_before[i].take_time isEqualToString:@"report"]){
                [v.checkArray addObject:v.washHand.yimei_before[i]];
            }
            else if ([v.washHand.yimei_before[i].take_time isEqualToString:@"after"]){
                [v.afterArray addObject:v.washHand.yimei_before[i]];
            }
            else {
                [v.beforeArray addObject:v.washHand.yimei_before[i]];
            }
        }
//    }
}

- (void)hide
{
    self.photosArray = [NSMutableArray array];
    BOOL isFailed = FALSE;
    for ( CDYimeiImage* image in self.washHand.yimei_before )
    {
        if ( [image.status isEqualToString:@"success"] )
        {
            [self.photosArray addObject:image.url];
#if 0
            if ( [image.imageID integerValue] == 0 )
            {
                [self.photosArray addObject:image.url];
            }
            else
            {
                continue;
            }
#endif
        }
        else
        {
            isFailed = TRUE;
        }
    }
    
    if ( isFailed )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"警告" message:@"还有文件尚未上传成功,点击\"仍要提交\"忽略没有上传成功的图片\n点击\"取消\"手动在右侧重新上传" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"仍要提交", nil];
        [v show];
        
        return;
    }
    else
    {
        if(_shouldSave){
            [self doPhotoFinish];
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    _shouldSave = NO;
    [self hide];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName: @"YimeiFumaPhotoCollectionViewCell" bundle: nil] forCellWithReuseIdentifier:@"YimeiFumaPhotoCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(0,  1);
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewFooter"];
    flowLayout.footerReferenceSize = CGSizeMake(0,  1);
//    if (self.beforeArray == nil){
//        self.beforeArray = [NSMutableArray array];
//    }
//    if (self.afterArray == nil){
//        self.afterArray = [NSMutableArray array];
//    }
//    if (self.checkArray == nil){
//        self.checkArray = [NSMutableArray array];
//    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (self.washHand.currentWorkflowID.integerValue == 4) {
        if (section == 0)
        {
            return self.beforeArray.count+1;
        }
        else if (section == 1)
        {
            return self.afterArray.count+1;
        }
        else
        {
            return self.checkArray.count+1;
        }
//    }
//    return self.washHand.yimei_before.count+1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    NSLog(@"%@",self.washHand);
//    if (self.washHand.currentWorkflowID.integerValue == 4) {
//        return 2;
//    }
    return 3;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                    withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = COLOR(37, 37, 37, 1);
    if (indexPath.section == 0){
        label.text = @"术前照";
    }
    else if (indexPath.section == 1){
        label.text = @"术后照";
    }
    else {
        label.text = @"辅助检查照片";
    }
    label.backgroundColor = [UIColor whiteColor];
    [headView addSubview:label];
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
//    if (self.washHand.currentWorkflowID.integerValue == 4) {
        return CGSizeMake(self.frame.size.width, 1);
//    }
//    else {
//        return CGSizeMake(0, 0);
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YimeiFumaPhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YimeiFumaPhotoCollectionViewCell" forIndexPath:indexPath];
    CDYimeiImage* yimeiImage = [[CDYimeiImage alloc] init];

    if (indexPath.section == 0) {
        if (indexPath.row == self.beforeArray.count) {
            cell.progressLabel.text = @"";
            cell.photoImageView.image = [UIImage imageNamed:@"yimei_camera"];
            cell.progressBgView.hidden = YES;
            cell.backgroundColor = COLOR(242, 242, 242, 1);
            return cell;
        }
        else
        {
            yimeiImage = self.beforeArray[indexPath.row];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == self.afterArray.count) {
            cell.progressLabel.text = @"";
            cell.photoImageView.image = [UIImage imageNamed:@"yimei_camera"];
            cell.progressBgView.hidden = YES;
            cell.backgroundColor = COLOR(242, 242, 242, 1);
            return cell;
        }
        else
        {
            yimeiImage = self.afterArray[indexPath.row];
        }
    }
    else{
        if (indexPath.row == self.checkArray.count) {
            cell.progressLabel.text = @"";
            cell.photoImageView.image = [UIImage imageNamed:@"yimei_camera"];
            cell.progressBgView.hidden = YES;
            cell.backgroundColor = COLOR(242, 242, 242, 1);
            return cell;
        }
        else
        {
            yimeiImage = self.checkArray[indexPath.row];
        }
    }
//    CDYimeiImage* yimeiImage = self.washHand.yimei_before[indexPath.row];
    //if (self.washHand.currentWorkflowID.integerValue == 4) {
    NSString *takeTime = @"";
    if (indexPath.section == 0) {
        yimeiImage = self.beforeArray[indexPath.row];
        takeTime = @"before";
    }
    else if (indexPath.section == 1) {
        yimeiImage = self.afterArray[indexPath.row];
        takeTime = @"after";
    }
    else{
        yimeiImage = self.checkArray[indexPath.row];
        takeTime = @"report";
    }
    //}
    cell.yimeiImage = yimeiImage;
    
    if ( [yimeiImage.status isEqualToString:@"uploading"] )
    {
        cell.progressBgView.hidden = NO;
        cell.progressLabel.text = @"正在上传...";
    }
    else if ( [yimeiImage.status isEqualToString:@"prepare"] )
    {
        UploadPicToZimg* v = [UploadPicToZimg alloc];
        
        [v uploadPic:cell.photoImageView.image withTakeTime:takeTime finished:^(BOOL ret, NSString *urlString) {
//        [v uploadPic:cell.photoImageView.image finished:^(BOOL ret, NSString *urlString) {
            YimeiFumaPhotoCollectionViewCell* cell2 = (YimeiFumaPhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            if ( cell != cell2 )
            {
                NSLog(@"cell != cell2 看看");
            }
            
            if ( ret )
            {
                yimeiImage.status = @"success";
                cell2.progressBgView.hidden = YES;
                cell2.progressLabel.text = @"";
                yimeiImage.type = @"server_local";
                
                [[SDWebImageManager sharedManager] saveImageToCache:cell2.photoImageView.image forURL:[NSURL URLWithString:urlString]];
                NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:yimeiImage.url]];
                [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:YES];
                yimeiImage.url = urlString;
                yimeiImage.small_url = [NSString stringWithFormat:@"%@?w=300",urlString];
                [[BSCoreDataManager currentManager] save:nil];
            }
            else
            {
                yimeiImage.status = @"failed";
                cell2.progressBgView.hidden = NO;
                cell2.progressLabel.text = @"上传失败\n点击重试";
            }
        }];
        cell.progressLabel.text = @"正在上传...";
    }
    else if ( [yimeiImage.status isEqualToString:@"failed"] )
    {
        cell.progressBgView.hidden = NO;
        cell.progressLabel.text = @"上传失败\n点击重试";
    }
    else// if ( [yimeiImage.status isEqualToString:@"success"] )
    {
        cell.progressBgView.hidden = YES;
        cell.progressLabel.text = @"";
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(185,137);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(60, 70, 40, 70);
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
    CGRect rect = [collectionView convertRect:[collectionView cellForItemAtIndexPath:indexPath].frame toView:self];
    CGFloat y = rect.origin.y;
    if (indexPath.section == 0) {
        if (indexPath.row == self.beforeArray.count) {
            [self didPhotoButtonPressed:[collectionView cellForItemAtIndexPath:indexPath] withYInView:y];
            _takeTime = @"before";
            return;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == self.afterArray.count) {
            [self didPhotoButtonPressed:[collectionView cellForItemAtIndexPath:indexPath] withYInView:y];
            _takeTime = @"after";
            return;
        }
    }
    else{
        if (indexPath.row == self.checkArray.count) {
            [self didPhotoButtonPressed:[collectionView cellForItemAtIndexPath:indexPath] withYInView:y];
            _takeTime = @"report";
            return;
        }
    }
    CDYimeiImage* yimeiImage = self.washHand.yimei_before[indexPath.row];
    if ( [yimeiImage.status isEqualToString:@"failed"] )
    {
        yimeiImage.status = @"prepare";
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
    else{
//        if (self.washHand.currentWorkflowID.integerValue == 4) {
            if (indexPath.section == 0) {
                [self showBigPic:indexPath.row inArray:self.beforeArray];
            }
            else if (indexPath.section == 1) {
                [self showBigPic:indexPath.row inArray:self.afterArray];
            }
            else{
                [self showBigPic:indexPath.row inArray:self.checkArray];
            }
//        }
//        else{
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//            for(int i = 0; i<self.washHand.yimei_before.count; i++){
//                [array addObject:self.washHand.yimei_before[i]];
//            }
//            [self showBigPic:indexPath.row inArray:array];
//        }
    }
}

- (void)realoadData
{
    [self.collectionView reloadData];
}

- (IBAction)didSavePressed:(UIButton*)sender {
    _shouldSave = YES;
    [self hide];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoSaved" object:nil userInfo:nil];
    //[self doPhotoFinish];
}

- (void)didPhotoButtonPressed:(UICollectionViewCell *)sender withYInView:(CGFloat)y
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WeakSelf;
        [BNCameraView showinView:self takPhoto:^(UIImage *image) {
            [weakSelf dealPhotoImage:image];
        }];
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.delegate = self;
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    alert.popoverPresentationController.sourceView = sender;
    alert.popoverPresentationController.sourceRect = sender.bounds;
    if (y > 400){
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    else{
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.allowsEditing)
    {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    image = [image orientation];
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat imageDestWidth = imageWidth;
    CGFloat imageDestHeight = imageHeight;
    if (imageWidth > 1024)
    {
        imageDestWidth = 1024;
        imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
    }
    if (imageDestHeight > 768)
    {
        imageDestWidth = imageDestWidth * 768 / imageDestHeight;
        imageDestHeight = 768;
    }
    
    
    UIImage* compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
    
    NSString* url = [NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]];
    [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:url]];
    
    imageDestWidth = 200;
    imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
    compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
    NSString* small_url = [NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]];
    [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:small_url]];
    
    CDYimeiImage* yimeiImage = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
    yimeiImage.url = url;
    yimeiImage.small_url = small_url;
    yimeiImage.washhand = self.washHand;
    yimeiImage.type = @"local";
    yimeiImage.status = @"prepare";
    yimeiImage.take_time = _takeTime;
    [[BSCoreDataManager currentManager] save:nil];
    if ([_takeTime isEqualToString:@"before"])
    {
        [self.beforeArray addObject:yimeiImage];
    }
    else if ([_takeTime isEqualToString:@"after"])
    {
        [self.afterArray addObject:yimeiImage];
    }
    else
    {
        [self.checkArray addObject:yimeiImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
    
    [self.collectionView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 )
    {
        [self doPhotoFinish];
    }
}
- (void)doPhotoFinish
{
    if ( self.photosArray.count > 0 && oringalCount != self.photosArray.count )
    {
//        [self uploadBeforePhoto];
//        [self uploadAfterPhoto];
//        [self uploadCheckPhoto];
        
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        NSMutableArray *beforeUrlArray = [NSMutableArray array];
        for (CDYimeiImage *yimeiImage in self.beforeArray)
        {
            [beforeUrlArray addObject:yimeiImage.url];
        }
        NSMutableArray *afterUrlArray = [NSMutableArray array];
        for (CDYimeiImage *yimeiImage in self.afterArray)
        {
            [afterUrlArray addObject:yimeiImage.url];
        }
        NSMutableArray *checkUrlArray = [NSMutableArray array];
        for (CDYimeiImage *yimeiImage in self.checkArray)
        {
            [checkUrlArray addObject:yimeiImage.url];
        }
        [params setObject:[NSString stringWithFormat:@"%@|%@|%@", [beforeUrlArray componentsJoinedByString:@","], [afterUrlArray componentsJoinedByString:@","], [checkUrlArray componentsJoinedByString:@","]] forKey:@"image_urls"];
//        [params setObject:@"before" forKey:@"take_time"];
        EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
        request.params = params;
        request.notGoNext = YES;
        request.wash = self.washHand;
        [request execute];
    }
//    NSMutableDictionary* params = [NSMutableDictionary dictionary];
//    if ( self.photosArray.count > 0 && oringalCount != self.photosArray.count )
//    {
//        [params setObject:[self.photosArray componentsJoinedByString:@","] forKey:@"image_urls"];
//        [params setObject:@"" forKey:@"take_time"];
//        EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
//        request.params = params;
//        request.notGoNext = YES;
//        request.wash = self.washHand;
//        [request execute];
//    }
}

- (void)uploadBeforePhoto
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSMutableArray *photoUrlArray = [NSMutableArray array];
    for (CDYimeiImage *yimeiImage in self.beforeArray)
    {
        [photoUrlArray addObject:yimeiImage.url];
    }
    [params setObject:[photoUrlArray componentsJoinedByString:@","] forKey:@"image_urls"];
    [params setObject:@"before" forKey:@"take_time"];
    EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
    request.params = params;
    request.notGoNext = YES;
    request.wash = self.washHand;
    [request execute];
}

- (void)uploadAfterPhoto
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSMutableArray *photoUrlArray = [NSMutableArray array];
    for (CDYimeiImage *yimeiImage in self.afterArray)
    {
        [photoUrlArray addObject:yimeiImage.url];
    }
    [params setObject:[photoUrlArray componentsJoinedByString:@","] forKey:@"image_urls"];
    [params setObject:@"after" forKey:@"take_time"];
    EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
    request.params = params;
    request.notGoNext = YES;
    request.wash = self.washHand;
    [request execute];
}

- (void)uploadCheckPhoto
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSMutableArray *photoUrlArray = [NSMutableArray array];
    for (CDYimeiImage *yimeiImage in self.checkArray)
    {
        [photoUrlArray addObject:yimeiImage.url];
    }
    [params setObject:[photoUrlArray componentsJoinedByString:@","] forKey:@"image_urls"];
    [params setObject:@"report" forKey:@"take_time"];
    EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
    request.params = params;
    request.notGoNext = YES;
    request.wash = self.washHand;
    [request execute];
}

- (void)showBigPic:(int)imageIndex inArray:(NSArray *)array
{
    CGFloat height = IC_SCREEN_HEIGHT;
    if (!IS_SDK7) {
        height = IC_SCREEN_HEIGHT -20;
    }
    self.bigPicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, height)];
    self.bigPicScrollView.showsHorizontalScrollIndicator = false;
    self.bigPicScrollView.pagingEnabled = true;
    self.bigPicScrollView.backgroundColor = [UIColor blackColor];
    for (int i = 0; i < array.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH*i, 0, IC_SCREEN_WIDTH, self.bigPicScrollView.frame.size.height)];
        [self.bigPicScrollView addSubview:view];
        
        float yRadio = height/480;
        
        CDYimeiImage *img = array[i];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:view.frame];
        [imgView sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:nil];
        
        float xRadio = IC_SCREEN_WIDTH/view.bounds.size.width;
        imgView.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, view.bounds.size.height*xRadio);
        imgView.backgroundColor = [UIColor clearColor];
        
        imgView.center = CGPointMake(IC_SCREEN_WIDTH/2.0, height/2);
        if (i == 0) {
            imgView.frame = CGRectMake(0, height - view.bounds.size.height, IC_SCREEN_WIDTH, view.bounds.size.height*xRadio);
        }
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imgView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBigPic)];
        [view addGestureRecognizer:tapGesture];
    }
    
    self.bigPicScrollView.contentSize = CGSizeMake(IC_SCREEN_WIDTH *array.count,self.bigPicScrollView.frame.size.height);
    self.bigPicScrollView.delegate = self;
    
    self.bigPicPageControl = [[UIPageControl alloc] init];
    self.bigPicPageControl.numberOfPages = array.count;
    self.bigPicPageControl.userInteractionEnabled = NO;
    //self.bigPicPageControl.currentPage = imageIndex;
    CGRect currentFrame = self.bigPicScrollView.frame;
    currentFrame.origin.x = currentFrame.size.width * imageIndex;
    currentFrame.origin.y = 0;
    [self.bigPicScrollView scrollRectToVisible:currentFrame animated:NO];
    [self addSubview:self.bigPicScrollView];
    self.bigPicScrollView.hidden = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == self.bigPicScrollView){
        CGPoint offset = scrollView.contentOffset;
        self.bigPicPageControl.currentPage = offset.x / (self.bounds.size.width); //计算当前的页码
        [self.bigPicScrollView setContentOffset:CGPointMake(self.bounds.size.width * (self.bigPicPageControl.currentPage),self.bigPicScrollView.contentOffset.y) animated:YES]; //设置scrollview的显示为当前滑动到的页面
    }
}

- (void)closeBigPic
{
    self.bigPicScrollView.hidden = YES;
    [self.bigPicScrollView removeFromSuperview];
}

- (void)dealPhotoImage:(UIImage*)image
{
    image = [image orientation];
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat imageDestWidth = imageWidth;
    CGFloat imageDestHeight = imageHeight;
    if (imageWidth > 1024)
    {
        imageDestWidth = 1024;
        imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
    }
    
    UIImage* compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
    
    NSString* url = [NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]];
    [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:url]];
    
    imageDestWidth = 200;
    imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
    compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
    NSString* small_url = [NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]];
    [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:small_url]];
    
    CDYimeiImage* yimeiImage = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
    yimeiImage.url = url;
    yimeiImage.small_url = small_url;
    yimeiImage.washhand = self.washHand;
    yimeiImage.type = @"local";
    yimeiImage.status = @"prepare";
    yimeiImage.take_time = _takeTime;
    [[BSCoreDataManager currentManager] save:nil];
    if ([_takeTime isEqualToString:@"before"])
    {
        [self.beforeArray addObject:yimeiImage];
    }
    else if ([_takeTime isEqualToString:@"after"])
    {
        [self.afterArray addObject:yimeiImage];
    }
    else
    {
        [self.checkArray addObject:yimeiImage];
    }
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    picker = nil;
    
    [self.collectionView reloadData];
}
@end
