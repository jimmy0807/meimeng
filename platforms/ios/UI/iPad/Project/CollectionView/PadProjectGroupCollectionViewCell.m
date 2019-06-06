//
//  PadProjectGroupCollectionViewCell.m
//  meim
//
//  Created by jimmy on 2017/5/16.
//
//

#import "PadProjectGroupCollectionViewCell.h"
#import "UIImage+Resizable.h"

@interface PadProjectGroupCollectionViewCell ()
@property (nonatomic, strong)UILabel *tipsLabel;
@property (nonatomic, strong)UIImageView *tipsBackground;
@property (nonatomic, weak)IBOutlet UILabel *titleLabel;
@property (nonatomic, weak)IBOutlet UILabel *priceLabel;
@property (nonatomic, weak)IBOutlet UIImageView *imageView;

@end

@implementation PadProjectGroupCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tipsBackground = [[UIImageView alloc] initWithFrame:CGRectMake(1.5, 0.0, 96.0, 24.0)];
    self.tipsBackground.backgroundColor = [UIColor clearColor];
    self.tipsBackground.image = [[UIImage imageNamed:@"pad_project_tips"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    [self.contentView addSubview:self.tipsBackground];
    
    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, 96.0 - 2 * 8.0, 24.0)];
    self.tipsLabel.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"pad_project_tips"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 32.0, 12.0, 32.0)]];
    self.tipsLabel.numberOfLines = 1;
    self.tipsLabel.font = [UIFont systemFontOfSize:12.0];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.textColor = [UIColor whiteColor];
    [self.tipsBackground addSubview:self.tipsLabel];
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_project_background_n"]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_project_background_h"]];
}

- (void)setItem:(CDProjectItem *)item
{
    _item = item;
    
    self.titleLabel.text = item.itemName;
    self.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), item.totalPrice.floatValue];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"pad_project_default_square"]];
    
    [self setTipsText:@""];
    if (item.bornCategory.integerValue == kPadBornCategoryProduct)
    {
        if (item.inHandAmount.integerValue == 0)
        {
            [self setTipsText:LS(@"PadItemNonStocked")];
        }
        else if (item.inHandAmount.integerValue > 0)
        {
            [self setTipsText:[NSString stringWithFormat:LS(@"PadItemInStock"), item.inHandAmount.integerValue]];
        }
    }
}

- (void)setTipsText:(NSString *)text
{
    if (text.length == 0)
    {
        self.tipsBackground.hidden = YES;
        return;
    }
    
    self.tipsBackground.hidden = NO;
    self.tipsLabel.text = text;
    CGSize minSize = [self.tipsLabel.text sizeWithFont:self.tipsLabel.font constrainedToSize:CGSizeMake(1024.0, self.tipsLabel.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat maxWidth = minSize.width;
    if (maxWidth + 16.0 >= 96.0)
    {
        maxWidth = 96.0 - 16.0;
    }
    self.tipsLabel.frame = CGRectMake(self.tipsLabel.frame.origin.x, self.tipsLabel.frame.origin.y, maxWidth, self.tipsLabel.frame.size.height);
    self.tipsBackground.frame = CGRectMake(self.tipsBackground.frame.origin.x, self.tipsBackground.frame.origin.y, maxWidth + 16.0, self.tipsBackground.frame.size.height);
}

@end
