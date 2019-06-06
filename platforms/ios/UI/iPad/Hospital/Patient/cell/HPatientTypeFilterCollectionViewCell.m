//
//  HPatientTypeFilterCollectionViewCell.m
//  meim
//
//  Created by jimmy on 2017/7/18.
//
//

#import "HPatientTypeFilterCollectionViewCell.h"
#import "UIButton+WebCache.h"

@interface HPatientTypeFilterCollectionViewCell ()
@property(nonatomic, weak)IBOutlet UIImageView* checkedIconImageView;
@property(nonatomic, weak)IBOutlet UIButton* typeButton;
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@end

@implementation HPatientTypeFilterCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCategory:(CDHHuizhenCategory *)category
{
    _category = category;
    [self.typeButton sd_setImageWithURL:[NSURL URLWithString:category.image_url] forState:UIControlStateNormal];
    self.titleLabel.text = category.name;
}

- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    
    self.checkedIconImageView.hidden = !isChecked;
}

@end
