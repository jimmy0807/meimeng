//
//  HomeYimeiWashTableViewCell.m
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import "HomeYimeiWashTableViewCell.h"

@interface HomeYimeiWashTableViewCell ()
@property(nonatomic, weak)IBOutlet UIButton* bgButton;
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UIImageView* vipImageView;
@property(nonatomic, weak)IBOutlet UILabel* timeLabel;
@property(nonatomic, weak)IBOutlet UIImageView* timeIcon;
@property(nonatomic, weak)IBOutlet UILabel* moneyLabel;
@property(nonatomic, weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic, weak)IBOutlet UIButton* deleteButton;
@property(nonatomic, weak)IBOutlet UIImageView* currentSelectImageView;
@property(nonatomic, weak)IBOutlet UIImageView* avatarMaskView;
@end

@implementation HomeYimeiWashTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.numberLabel.adjustsFontSizeToFitWidth = YES;
    self.moneyLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setPosOperate:(CDPosWashHand*)washHand indexPath:(NSIndexPath*)indexPath
{
    _washHand = washHand;
    _indexPath = indexPath;
    
    self.numberLabel.text = washHand.yimei_queueID;
    self.nameLabel.text = washHand.member_name;
#if 0
    if ( posOperate.yimei_member_type.length > 0 )
    {
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",posOperate.member.memberName,[posOperate.yimei_member_type uppercaseString]];
    }
    else
    {
        self.nameLabel.text = posOperate.member.memberName;
    }
#endif
#if 0
    if ( [posOperate.member.isDefaultCustomer boolValue] )
    {
        if ( posOperate.book.booker_name.length > 0 )
        {
            self.nameLabel.text = [NSString stringWithFormat:LS(@"PadBookedCustomer"), posOperate.book.booker_name];
        }
    }
#endif
    //CDWorkFlowActivity *a = [[BSCoreDataManager currentManager] findEntity:@"CDWorkFlowActivity" withValue:posOperate.currentWorkflowID forKey:@"workID"];
    if ( washHand.fumayao_time.length > 0 )
    {
        self.moneyLabel.text = washHand.fumayao_time;
    }
    else
    {
        self.moneyLabel.text = washHand.doctor_name;
    }
   
    
    self.timeLabel.text = washHand.operate_date;//[dateFormat stringFromDate:date];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:washHand.imageUrl] placeholderImage:[UIImage imageNamed:@"pad_avatar_default"]];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.contentView sendSubviewToBack:self.deleteButton];
}

- (void)setIsCurrentPos:(BOOL)isCurrentPos
{
    _isCurrentPos = isCurrentPos;

    if ( isCurrentPos )
    {
        self.numberLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.moneyLabel.textColor = [UIColor whiteColor];
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_C"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
        self.timeIcon.image = [UIImage imageNamed:@"pad_time_current_icon"];
    }
    else
    {
        self.numberLabel.textColor = COLOR(39, 39, 39, 1);
        self.nameLabel.textColor = COLOR(39, 39, 39, 1);
        self.moneyLabel.textColor = COLOR(67, 199, 199, 1);
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_N"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateHighlighted];
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
        self.timeIcon.image = [UIImage imageNamed:@"pad_time_icon"];
    }
}

- (IBAction)didBgButtonPressed:(id)sender
{
    [self.delegate didHomeYimeiWashTableViewCellPresssed:self];
}

@end
