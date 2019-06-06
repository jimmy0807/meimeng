//
//  PadAdjustItemRemarkTableViewCell.m
//  meim
//
//  Created by jimmy on 17/2/10.
//
//

#import "PadAdjustItemRemarkTableViewCell.h"

@interface PadAdjustItemRemarkTableViewCell ()
@property(nonatomic, weak)IBOutlet UIImageView* remarkBgImageView;
@end

@implementation PadAdjustItemRemarkTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.remarkBgImageView.image = [[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
}

@end
