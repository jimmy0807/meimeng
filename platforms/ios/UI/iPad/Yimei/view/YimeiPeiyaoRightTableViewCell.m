//
//  YimeiPeiyaoRightTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/7/14.
//
//

#import "YimeiPeiyaoRightTableViewCell.h"

@interface YimeiPeiyaoRightTableViewCell ()
@property(nonatomic, weak)IBOutlet UIView* addView;
@property(nonatomic, weak)IBOutlet UIView* countView;
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, weak)IBOutlet UILabel* uomLabel;
@property(nonatomic, weak)IBOutlet UILabel* countLabel;
@end

@implementation YimeiPeiyaoRightTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)didMinusButtonPerssed:(id)sender
{
    NSInteger count = [self.item.count integerValue];
    if ( count > 1 )
    {
        count--;
    }
    self.item.count = @(count);
    self.countLabel.text = [NSString stringWithFormat:@"%d",count];
}

- (IBAction)didPlusButtonPerssed:(id)sender
{
    self.item.count = @([self.item.count integerValue] + 1);
    self.countLabel.text = [NSString stringWithFormat:@"%@",self.item.count];
}

- (void)setIsAddLine:(BOOL)isAddLine
{
    _isAddLine = isAddLine;
    self.addView.hidden = !isAddLine;
    self.countView.hidden = isAddLine;
}

- (void)setItem:(CDMedicalItem *)item
{
    _item = item;
    
    self.titleLabel.text = item.name;
    self.countLabel.text = [NSString stringWithFormat:@"%@",item.count];
    self.uomLabel.text = item.uomName;
}

@end
