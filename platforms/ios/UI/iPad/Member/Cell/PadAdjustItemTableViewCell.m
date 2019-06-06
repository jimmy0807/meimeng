//
//  PadAdjustItemTableViewCell.m
//  meim
//
//  Created by jimmy on 17/2/8.
//
//

#import "PadAdjustItemTableViewCell.h"

@interface PadAdjustItemTableViewCell ()
@property(nonatomic, weak)IBOutlet UIButton* iconButton;
@property(nonatomic, weak)IBOutlet UILabel* addItemLabel;
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, weak)IBOutlet UILabel* countLabel;
@property(nonatomic, weak)IBOutlet UILabel* amountLabel;
@end

@implementation PadAdjustItemTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCardProject:(CDPosProduct *)cardProject
{
    _cardProject = cardProject;
    
    //老代码
//    if ( cardProject )
//    {
//        self.iconButton.hidden = YES;
//        self.addItemLabel.hidden = YES;
//        self.titleLabel.text = cardProject.product_name;
//        self.amountLabel.text = [NSString stringWithFormat:@"￥%.02f",[cardProject.product_price floatValue] * [cardProject.product_qty integerValue]];
//        self.countLabel.text = [NSString stringWithFormat:@"x%@",cardProject.product_qty];
//    }
//    else
//    {
//        self.iconButton.hidden = NO;
//        self.addItemLabel.hidden = NO;
//        self.titleLabel.text = @"";
//        self.amountLabel.text = @"";
//        self.countLabel.text = @"";
//    }

    //新代码
    self.titleLabel.text = cardProject.product_name;
    self.countLabel.text = [NSString stringWithFormat:@"x%@",cardProject.product_qty];
}

@end
