//
//  HPartnerListCollectionViewCell.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "HPartnerListCollectionViewCell.h"

@interface HPartnerListCollectionViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;       //渠道商名称
@property(nonatomic, weak)IBOutlet UILabel* partnerCategoryLabel;       //分类
@property(nonatomic, weak)IBOutlet UILabel* cityRegionLabel;      //地区
@property(nonatomic, weak)IBOutlet UILabel* designerEmployeeLabel;    //设计师
@property(nonatomic, weak)IBOutlet UILabel* businessEmployeeLabel;    //业务

@end

@implementation HPartnerListCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setPartner:(CDPartner *)partner
{
    _partner = partner;
    
    self.nameLabel.text = partner.name;
    self.partnerCategoryLabel.text = [NSString stringWithFormat:@"类型: %@",partner.partner_category];
    self.cityRegionLabel.text = [NSString stringWithFormat:@"区域: %@",partner.street];
    self.designerEmployeeLabel.text = [NSString stringWithFormat:@"设计师: %@",partner.designer_employee_name];
    self.businessEmployeeLabel.text = [NSString stringWithFormat:@"业务: %@",partner.business_employee_name];
}

@end
