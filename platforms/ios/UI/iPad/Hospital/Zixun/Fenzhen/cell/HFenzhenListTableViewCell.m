//
//  HFenzhenListTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/4/14.
//
//

#import "HFenzhenListTableViewCell.h"

@interface HFenzhenListTableViewCell()<UIScrollViewDelegate>
{
    int moveDirection;
    CGFloat lastPosX;
}
@property(nonatomic, weak)IBOutlet UIButton* bgButton;
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeLabel;
@property(nonatomic, weak)IBOutlet UIImageView* timeIcon;
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, weak)IBOutlet UILabel* typeLabel;
@property(nonatomic, weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic, weak)IBOutlet UIButton* kaidianButton;
@property(nonatomic, weak)IBOutlet UIButton* qianzaikehuButton;
@end

@implementation HFenzhenListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
        
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width + 144, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
}

- (IBAction)didKaidanButtonPressed:(id)sender
{
    self.kaidanButtonPressed();
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
}

- (void)delay
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.contentView sendSubviewToBack:self.kaidianButton];
    [self.contentView sendSubviewToBack:self.qianzaikehuButton];
}

- (IBAction)didQianzaikeButtonPressed:(id)sender
{
    self.qianzaikeButtonPressed();
    [self delay];
}

- (IBAction)didCellButtonPressed:(id)sender
{
    self.cellButtonPressed(self.zixun);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.contentView sendSubviewToBack:self.kaidianButton];
    [self.contentView sendSubviewToBack:self.qianzaikehuButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( scrollView.contentOffset.x == 144 )
    {
        [self.contentView bringSubviewToFront:self.kaidianButton];
        [self.contentView bringSubviewToFront:self.qianzaikehuButton];
    }
    else
    {
        [self.contentView sendSubviewToBack:self.kaidianButton];
        [self.contentView sendSubviewToBack:self.qianzaikehuButton];
    }
}

- (void)setZixun:(CDHZixun *)zixun
{
    _zixun = zixun;
    
    self.nameLabel.text = zixun.customer_name;
    self.titleLabel.text = zixun.employee_name;
    self.timeLabel.text = zixun.time;
    self.typeLabel.text = zixun.advisory_product_names;
}

@end
