//
//  YimeiFumaPhotoCollectionViewCell.m
//  meim
//
//  Created by jimmy on 2017/5/25.
//
//

#import "YimeiHuizhenPhotoCollectionViewCell.h"

@interface YimeiHuizhenPhotoCollectionViewCell ()

@end

@implementation YimeiHuizhenPhotoCollectionViewCell

- (void)setYimeiImage:(CDYimeiImage *)yimeiImage
{
    _yimeiImage = yimeiImage;
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
