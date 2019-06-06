//
//  YimeiFumaPhotoView.m
//  meim
//
//  Created by jimmy on 2017/5/25.
//
//

#import "YimeiHuizhenPhotoView.h"
#import "YimeiHuizhenPhotoCollectionViewCell.h"
#import "UploadPicToZimg.h"
#import "UIImage+Orientation.h"
#import "UIImage+Scale.h"
#import "BSYimeiEditPosOperateRequest.h"
#import "EditWashHandRequest.h"

@interface YimeiHuizhenPhotoView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSInteger oringalCount;
}
@property(nonatomic, weak)IBOutlet UICollectionView* collectionView;
@property(nonatomic, strong)NSMutableArray* photosArray;
@end

@implementation YimeiHuizhenPhotoView

+ (void)showWithHuizhen:(CDHHuizhen*)huizhen
{
    YimeiHuizhenPhotoView* v = [YimeiHuizhenPhotoView loadFromNib];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:v];
    v.alpha = 0;
    v.huizhen = huizhen;
    
    [UIView animateWithDuration:0.2 animations:^{
        v.alpha = 1;
    }];
    
    v->oringalCount = v.huizhen.photos.count;
}

- (void)hide
{
    self.photosArray = [NSMutableArray array];
    BOOL isFailed = FALSE;
    for ( CDYimeiImage* image in self.huizhen.photos )
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
        [self doPhotoFinish];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    [self hide];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName: @"YimeiHuizhenPhotoCollectionViewCell" bundle: nil] forCellWithReuseIdentifier:@"YimeiHuizhenPhotoCollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.huizhen.photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YimeiHuizhenPhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YimeiHuizhenPhotoCollectionViewCell" forIndexPath:indexPath];
    
    CDYimeiImage* yimeiImage = self.huizhen.photos[indexPath.row];
    cell.yimeiImage = yimeiImage;
    
    if ( [yimeiImage.status isEqualToString:@"uploading"] )
    {
        cell.progressBgView.hidden = NO;
        cell.progressLabel.text = @"正在上传...";
    }
    else if ( [yimeiImage.status isEqualToString:@"prepare"] )
    {
        UploadPicToZimg* v = [UploadPicToZimg alloc];
        [v uploadPic:cell.photoImageView.image finished:^(BOOL ret, NSString *urlString) {
            YimeiHuizhenPhotoCollectionViewCell* cell2 = (YimeiHuizhenPhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
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
    return UIEdgeInsetsMake(30, 70, 30, 70);
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
    CDYimeiImage* yimeiImage = self.huizhen.photos[indexPath.row];
    if ( [yimeiImage.status isEqualToString:@"failed"] )
    {
        yimeiImage.status = @"prepare";
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)realoadData
{
    [self.collectionView reloadData];
}

- (IBAction)didPhotoButtonPressed:(UIButton*)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    alert.popoverPresentationController.sourceView = sender;
    alert.popoverPresentationController.sourceRect = sender.bounds;
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
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
    yimeiImage.huizhen = self.huizhen;
    yimeiImage.type = @"local";
    yimeiImage.status = @"prepare";
    [[BSCoreDataManager currentManager] save:nil];
    
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
    //NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if ( self.photosArray.count > 0 && oringalCount != self.photosArray.count )
    {
        //[params setObject:[self.photosArray componentsJoinedByString:@","] forKey:@"image_urls"];
        self.huizhen.picUrls = [self.photosArray componentsJoinedByString:@","];
//        EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
//        request.params = params;
//        request.notGoNext = YES;
//        request.hui = self.washHand;
//        [request execute];
    }
}

@end
