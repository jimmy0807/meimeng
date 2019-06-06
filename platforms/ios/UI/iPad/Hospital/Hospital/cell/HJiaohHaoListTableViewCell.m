//
//  HJiaohHaoListTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "HJiaohHaoListTableViewCell.h"


@interface HJiaohHaoListTableViewCell ()

@property(nonatomic, weak)IBOutlet UILabel* noLabel; //号码
@property(nonatomic, weak)IBOutlet UILabel* nameLabel; //病人
@property(nonatomic, weak)IBOutlet UILabel* departmentLabel;       //诊室
@property(nonatomic, weak)IBOutlet UILabel* operateNameLabel;       //手术
@property(nonatomic, weak)IBOutlet UILabel* stateLabel;      //状态
@property(nonatomic, weak)IBOutlet UIImageView* noBgImageView;      //状态

@end


@implementation HJiaohHaoListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.departmentLabel.preferredMaxLayoutWidth = 430;
}

- (void)setJiaohao:(CDHJiaoHao *)jiaohao
{
    _jiaohao = jiaohao;
    
    //self.noLabel.text = jiaohao.queue;
    self.nameLabel.text = jiaohao.customer_name;
//    if ( jiaohao.doctor_name.length > 0 )
//    {
//        self.departmentLabel.text = [NSString stringWithFormat:@"%@(%@)",jiaohao.keshi_name, jiaohao.doctor_name];
//    }
//    else
//    {
//        self.departmentLabel.text = jiaohao.keshi_name;
//    }

    self.departmentLabel.text = jiaohao.keshi_name;
    
    self.operateNameLabel.text = jiaohao.advisory_product_names;
    self.noLabel.text = jiaohao.queue_no;
    self.stateLabel.text = jiaohao.state;
    
    self.noBgImageView.hidden = ![jiaohao.is_update boolValue];
}

@end
