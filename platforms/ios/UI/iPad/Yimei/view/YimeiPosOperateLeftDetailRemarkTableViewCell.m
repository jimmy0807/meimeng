//
//  YimeiPosOperateLeftDetailRemarkTableViewCell.m
//  meim
//
//  Created by jimmy on 17/2/7.
//
//

#import "YimeiPosOperateLeftDetailRemarkTableViewCell.h"

@interface YimeiPosOperateLeftDetailRemarkTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* remarkLabel;
@end

@implementation YimeiPosOperateLeftDetailRemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGSize)getHeight:(NSString*)s
{
    if ( s.length == 0 )
        return CGSizeZero;
    
    return [s sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(376, 9999) lineBreakMode:NSLineBreakByWordWrapping];
}

- (void)setRemarkString:(NSString *)remarkString
{
    _remarkString = remarkString;
    self.remarkLabel.text = remarkString;
    
    CGRect f = self.remarkLabel.frame;
    f.size.height = [YimeiPosOperateLeftDetailRemarkTableViewCell getHeight:remarkString].height;
    self.remarkLabel.frame = f;
}

@end
