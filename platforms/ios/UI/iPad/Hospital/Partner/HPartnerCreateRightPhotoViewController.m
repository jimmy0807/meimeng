//
//  HPartnerCreateRightPhotoViewController.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "HPartnerCreateRightPhotoViewController.h"
#import "HPartnerPhotoCollectionViewCell.h"
#import "UploadPicToZimg.h"

@interface HPartnerCreateRightPhotoViewController ()
@property(nonatomic, weak)IBOutlet UICollectionView* collectionView;
@end

@implementation HPartnerCreateRightPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.partner.photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HPartnerPhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HPartnerPhotoCollectionViewCell" forIndexPath:indexPath];
    
    CDYimeiImage* yimeiImage = self.partner.photos[indexPath.row];
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
            HPartnerPhotoCollectionViewCell* cell2 = (HPartnerPhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
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
    else if ( [yimeiImage.status isEqualToString:@"success"] )
    {
        cell.progressBgView.hidden = YES;
        cell.progressLabel.text = @"";
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(195,145);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDYimeiImage* yimeiImage = self.partner.photos[indexPath.row];
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

- (void)didYimeiPhotoAdded
{
    [self realoadData];
}

@end
