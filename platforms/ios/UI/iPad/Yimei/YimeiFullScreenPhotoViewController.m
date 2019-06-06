//
//  YimeiFullScreenPhotoViewController.m
//  ds
//
//  Created by jimmy on 16/11/14.
//
//

#import "YimeiFullScreenPhotoViewController.h"

@interface YimeiFullScreenPhotoViewController ()

@end

@implementation YimeiFullScreenPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(GVPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}

- (UIImageView *)photoBrowser:(GVPhotoBrowser *)photoBrowser customizeImageView:(UIImageView *)imageView forIndex:(NSUInteger)index
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.photos[index]]];
    return imageView;
}

#pragma mark - GVPhotoBrowserDelegate
- (void)photoBrowser:(GVPhotoBrowser *)photoBrowser didSwitchToIndex:(NSUInteger)index
{
    
}

- (void)photoBrowserSingleTapped:(GVPhotoBrowser *)photoBrowser
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
