//
//  HPartnerPhotoCollectionViewCell.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "HPartnerPhotoCollectionViewCell.h"

@interface HPartnerPhotoCollectionViewCell ()
@end

@implementation HPartnerPhotoCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setYimeiImage:(CDYimeiImage *)yimeiImage
{
    _yimeiImage = yimeiImage;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:yimeiImage.url]];
}

@end
