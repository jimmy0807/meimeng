//
//  HHuifangListCollectionViewCell.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "HHuifangListCollectionViewCell.h"

@interface HHuifangListCollectionViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* memberLabel;       //病人（member_id）
@property(nonatomic, weak)IBOutlet UILabel* categoryLabel;       //回访类型
@property(nonatomic, weak)IBOutlet UILabel* stateLabel;      //状态
@property(nonatomic, weak)IBOutlet UILabel* levleLabel;    //几天后回访(born.member.visit.levle)
@property(nonatomic, weak)IBOutlet UILabel* plantVisitDateLabel;    //计划回访日期
@property(nonatomic, weak)IBOutlet UILabel* plantVisitUserLabel;   //计划回访人
@end

@implementation HHuifangListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setVisit:(CDMemberVisit *)visit
{
    _visit = visit;
    
    self.memberLabel.text = visit.member_name;
    if ( [visit.category isEqualToString:@"potential"] )
    {
        self.categoryLabel.text = @"潜在客户";
    }
    else if ( [visit.category isEqualToString:@"operate"] )
    {
        self.categoryLabel.text = @"术后回访";
    }
    else if ( [visit.category isEqualToString:@"old"] )
    {
        self.categoryLabel.text = @"老客开发";
    }
    else if ( [visit.category isEqualToString:@"day"] )
    {
        self.categoryLabel.text = @"日常跟进";
    }
    else if ( [visit.category isEqualToString:@"festival"] )
    {
        self.categoryLabel.text = @"老客跟进";
    }
    
    if ( [visit.state isEqualToString:@"draft"] )
    {
        self.stateLabel.text = @"待回访";
    }
    else if ( [visit.state isEqualToString:@"done"] )
    {
        self.stateLabel.text = @"已回访";
    }
    else if ( [visit.state isEqualToString:@"finish"] )
    {
        self.stateLabel.text = @"已完成";
    }
    else if ( [visit.state isEqualToString:@"cancel"] )
    {
        self.stateLabel.text = @"已取消";
    }
    
    self.plantVisitDateLabel.text = [NSString stringWithFormat:@"计划回访:%@",visit.plant_visit_date];
    self.plantVisitUserLabel.text = [NSString stringWithFormat:@"计划回访人:%@",visit.plant_visit_user_name];
    self.levleLabel.text = visit.day;
}

@end
