//
//  HPatientListCollectionViewCell.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HPatientListCollectionViewCell.h"

@interface HPatientListCollectionViewCell ()
@property(nonatomic, weak)IBOutlet UIImageView* logoImage;      //图像
@property(nonatomic, weak)IBOutlet UILabel* memberLabel;       //病人（member_id）
@property(nonatomic, weak)IBOutlet UILabel* mobileLabel;       //电话号码
@property(nonatomic, weak)IBOutlet UILabel* stateLabel;      //状态
@property(nonatomic, weak)IBOutlet UILabel* doctorLabel;    //医生
@property(nonatomic, weak)IBOutlet UILabel* firstTreatDateLabel;    //初珍时间
@end

@implementation HPatientListCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setMember:(CDMember *)member
{
    _member = member;
    
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:member.image_url] placeholderImage:[UIImage imageNamed:@"pad_avatar_default"]];
    self.memberLabel.text = member.memberName;
    self.mobileLabel.text = member.mobile;
    self.stateLabel.text = member.status;
    self.doctorLabel.text = member.doctor_name;
    self.firstTreatDateLabel.text = member.first_treat_date;
}

@end
