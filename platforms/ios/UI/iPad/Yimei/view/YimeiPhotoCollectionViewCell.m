//
//  YimeiPhotoCollectionViewCell.m
//  ds
//
//  Created by jimmy on 16/11/3.
//
//

#import "YimeiPhotoCollectionViewCell.h"

@interface YimeiPhotoCollectionViewCell ()

@end

@implementation YimeiPhotoCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setYimeiImage:(CDYimeiImage *)yimeiImage
{
    _yimeiImage = yimeiImage;
    if ( yimeiImage.small_url.length > 0 )
    {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:yimeiImage.small_url]];
    }
    else
    {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:yimeiImage.url]];
    }
    
    if ( [yimeiImage.take_time isEqualToString:@"before"] )
    {
        self.tagLabel.text = @"术前照";
        self.tagLabel.backgroundColor = COLOR(0, 0, 0, 0.4);
        self.tagLabel.hidden = NO;
    }
    else if ( [yimeiImage.take_time isEqualToString:@"after"] )
    {
        self.tagLabel.text = @"术后照";
        self.tagLabel.backgroundColor = COLOR(0, 0, 0, 0.4);
        self.tagLabel.hidden = NO;
    }
    else{
        self.tagLabel.hidden = YES;
    }
}

@end
