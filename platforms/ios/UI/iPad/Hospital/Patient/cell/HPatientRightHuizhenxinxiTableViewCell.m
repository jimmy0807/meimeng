//
//  HPatientRightHuizhenxinxiTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "HPatientRightHuizhenxinxiTableViewCell.h"


@interface HPatientRightHuizhenxinxiTableViewCell ()

@property(nonatomic, weak)IBOutlet UIImageView* logoImage;      //图像
@property(nonatomic, weak)IBOutlet UILabel* doctorLabel;       //医生
@property(nonatomic, weak)IBOutlet UILabel* dateLabel;       //日期
@property(nonatomic, weak)IBOutlet UILabel* reasonLabel;      //实际情况
@property(nonatomic, weak)IBOutlet UILabel* noteLabel;    //就诊意见
@property(nonatomic, weak)IBOutlet UILabel* typeLabel;    //类型
@property(nonatomic, weak)IBOutlet UIButton* photoButton;
@property(nonatomic, strong)IBOutlet NSLayoutConstraint* photoTopConstant;

@end


@implementation HPatientRightHuizhenxinxiTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHuizhen:(CDHHuizhen *)huizhen
{
    _huizhen = huizhen;
    
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:huizhen.doctor_url] placeholderImage:[UIImage imageNamed:@"pad_avatar_default"]];
    self.doctorLabel.text = huizhen.doctors_name;
    self.dateLabel.text = huizhen.create_date;
    self.reasonLabel.text = [NSString stringWithFormat:@"实际情况：%@",huizhen.reason];
    self.noteLabel.text = [NSString stringWithFormat:@"就诊意见：%@",huizhen.doctors_note];
    self.typeLabel.text = huizhen.description_str;
    
    if ( self.huizhen.photos.count == 0 )
    {
        self.photoButton.hidden = YES;
        self.photoTopConstant.active = NO;
    }
    else
    {
        self.photoButton.hidden = NO;
        self.photoTopConstant.active = YES;
    }
}

- (IBAction)didPhotoButtonPressed:(id)sender
{
    self.huizhenPhotoButtonPressed();
}

@end
