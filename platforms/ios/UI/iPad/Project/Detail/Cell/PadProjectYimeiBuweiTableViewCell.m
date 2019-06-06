//
//  PadProjectYimeiBuweiTableViewCell.m
//  meim
//
//  Created by jimmy on 17/2/6.
//
//

#import "PadProjectYimeiBuweiTableViewCell.h"

@interface PadProjectYimeiBuweiTableViewCell ()
@property(nonatomic, weak)IBOutlet UIButton* iconButton;
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, weak)IBOutlet UILabel* countLabel;
@end

@implementation PadProjectYimeiBuweiTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)didDeleteButtonPressed:(id)sender
{
    [self.delegate didPadProjectYimeiBuweiTableViewDeleteButtonPressed:self];
}

- (void)setBuwei:(CDYimeiBuwei *)buwei
{
    _buwei = buwei;
    
    if ( buwei )
    {
        [self.iconButton setImage:[UIImage imageNamed:@"Combined_Shape_Delete"] forState:UIControlStateNormal];
        self.titleLabel.text = buwei.name;
        self.titleLabel.textColor = COLOR(74, 74, 74, 1);
        self.countLabel.text = [NSString stringWithFormat:@"x%@",buwei.count];
    }
    else
    {
        [self.iconButton setImage:[UIImage imageNamed:@"Combined_Shape_Add"] forState:UIControlStateNormal];
        self.titleLabel.text = @"添加";
        self.titleLabel.textColor = COLOR(176, 176, 176, 1);
        self.countLabel.text = @"";
    }
}

- (void)setBuweiTitle:(NSString*)title
{
    if ( title.length > 0 )
    {
        self.titleLabel.text = title;
    }
    else
    {
        self.titleLabel.text = @"添加";
    }
    
    self.countLabel.text = @"";
}

@end
