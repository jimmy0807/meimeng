//
//  YimeiFumaPhotoCollectionViewCell.m
//  meim
//
//  Created by jimmy on 2017/5/25.
//
//

#import "YimeiFumaPhotoCollectionViewCell.h"

@interface YimeiFumaPhotoCollectionViewCell ()

@end

@implementation YimeiFumaPhotoCollectionViewCell

- (void)setYimeiImage:(CDYimeiImage *)yimeiImage
{
    _yimeiImage = yimeiImage;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    if ( [yimeiImage.status isEqualToString:@"success"] )
    {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:yimeiImage.small_url] placeholderImage:self.photoImageView.image];
    }
    else
    {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:yimeiImage.url]];
    }
}

@end
