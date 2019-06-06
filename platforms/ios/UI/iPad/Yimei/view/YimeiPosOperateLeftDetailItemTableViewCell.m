//
//  YimeiPosOperateLeftDetailItemTableViewCell.m
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import "YimeiPosOperateLeftDetailItemTableViewCell.h"

@interface YimeiPosOperateLeftDetailItemTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* leftLabel;
@property(nonatomic, weak)IBOutlet UILabel* rightLabel;
@property(nonatomic, weak)IBOutlet UILabel* buweiLabel;
@property(nonatomic, weak)IBOutlet UIImageView* lineImageView;
@end

@implementation YimeiPosOperateLeftDetailItemTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.leftLabel.adjustsFontSizeToFitWidth = TRUE;
}

- (void)setProduct:(CDPosProduct *)product
{
    _product = product;
    
    self.leftLabel.text = product.product_name;
    self.rightLabel.text = [NSString stringWithFormat:@"x %@",product.product_qty];
    
    self.buweiLabel.text = product.part_display_name;//[YimeiPosOperateLeftDetailItemTableViewCell getBuweiString:product.yimei_buwei.array];
    
    CGRect f = self.buweiLabel.frame;
    f.size.height = [YimeiPosOperateLeftDetailItemTableViewCell buweiHeightString:self.buweiLabel.text].height;
    self.buweiLabel.frame = f;
}

- (void)setIsLastLine:(BOOL)isLastLine
{
    CGFloat orginalY = self.buweiLabel.frame.origin.y + self.buweiLabel.frame.size.height + 23;
    if ( isLastLine )
    {
        self.lineImageView.frame = CGRectMake(0, orginalY, 420, 1);
    }
    else
    {
        self.lineImageView.frame = CGRectMake(20, orginalY, 380, 1);
    }
}

+ (CGSize)buweiHeight:(NSArray*)buweis
{
    NSString* s = [YimeiPosOperateLeftDetailItemTableViewCell getBuweiString:buweis];
    return [YimeiPosOperateLeftDetailItemTableViewCell buweiHeightString:s];
}

+ (CGSize)buweiHeightString:(NSString*)s
{
    if ( s.length == 0 )
        return CGSizeZero;
    
    return [s sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(296, 999) lineBreakMode:NSLineBreakByWordWrapping];
}

+ (NSString*)getBuweiString:(NSArray*)buweis
{
    NSMutableString* s = [NSMutableString string];
    [buweis enumerateObjectsUsingBlock:^(CDYimeiBuwei* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [s appendFormat:@"%@    x%@",obj.name, obj.count];
        if ( idx != buweis.count - 1 )
        {
            [s appendString:@"\n"];
        }
    }];
    
    return s;
}

@end
