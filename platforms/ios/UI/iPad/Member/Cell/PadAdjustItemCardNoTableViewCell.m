//
//  PadAdjustItemCardNoTableViewCell.m
//  meim
//
//  Created by jimmy on 17/2/8.
//
//

#import "PadAdjustItemCardNoTableViewCell.h"

@interface PadAdjustItemCardNoTableViewCell ()
@property(nonatomic, weak)IBOutlet UIImageView* cardNoBgImageView;
@property(nonatomic, weak)IBOutlet UIImageView* amountBgImageView;
@property(nonatomic, weak)IBOutlet UIImageView* pointBgImageView;
@end

@implementation PadAdjustItemCardNoTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cardNoBgImageView.image = [[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    self.amountBgImageView.image = [[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    self.pointBgImageView.image = [[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
}

- (void)setCard:(CDMemberCard *)card
{
    _card = card;
    
    self.cardNoTextField.text = card.cardNo;
    self.amountTextField.text = card.amount;
    self.pointTextField.text = card.points;
}

@end
