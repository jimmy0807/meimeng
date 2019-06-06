//
//  HCustomerListCollectionViewCell.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "HCustomerListCollectionViewCell.h"

@interface HCustomerListCollectionViewCell ()

@property(nonatomic, weak)IBOutlet UILabel* nameLabel;      //名称
@property(nonatomic, weak)IBOutlet UILabel* mobileLabel;    //手机号码
@property(nonatomic, weak)IBOutlet UILabel* registLabel;    //登记日期
@property(nonatomic, weak)IBOutlet UILabel* operateLabel;   //是否就诊

@end

@implementation HCustomerListCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCustomer:(CDHCustomer *)customer
{
    self.nameLabel.text = customer.memberName;
    self.mobileLabel.text = customer.mobile;
    self.registLabel.text = customer.create_date;
}

@end
