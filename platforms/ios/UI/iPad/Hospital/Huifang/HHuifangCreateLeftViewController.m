//
//  HPartnerCreateLeftViewController.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "HHuifangCreateLeftViewController.h"

@interface HHuifangCreateLeftViewController ()


@property(nonatomic, weak)IBOutlet UILabel* nameLabel;       //标题
@property(nonatomic, weak)IBOutlet UILabel* memberNameLabel;       //患者
@property(nonatomic, weak)IBOutlet UILabel* levleNameLabel;      //跟进阶段
@property(nonatomic, weak)IBOutlet UILabel* categoryLabel;    //回访类型
@property(nonatomic, weak)IBOutlet UILabel* productNamesLabel;    //项目
@property(nonatomic, weak)IBOutlet UILabel* plantVisitDateLabel;   //计划回访日期
@property(nonatomic, weak)IBOutlet UILabel* plantVisitUserLabel;    //计划回访人
@property(nonatomic, weak)IBOutlet UILabel* visitDateLabel;    //实际回访日期
@property(nonatomic, weak)IBOutlet UILabel* visitUserLabel;   //实际回访人




@end

@implementation HHuifangCreateLeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.visit.name;
    self.memberNameLabel.text = self.visit.member_name;
    self.levleNameLabel.text = self.visit.day;
    self.categoryLabel.text = self.visit.category;
    self.productNamesLabel.text = self.visit.product_names;
    self.plantVisitDateLabel.text = self.visit.plant_visit_date;
    self.plantVisitUserLabel.text = self.visit.plant_visit_user_name;
    self.visitUserLabel.text = self.visit.visit_user_name;
    self.visitDateLabel.text = self.visit.visit_date;
}

@end
