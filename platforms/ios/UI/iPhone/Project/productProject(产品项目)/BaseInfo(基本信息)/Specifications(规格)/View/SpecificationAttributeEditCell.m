//
//  SpecificationAttributeEditCell.m
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationAttributeEditCell.h"
#import "SpecificationEditModel.h"
@interface SpecificationAttributeEditCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@end
@implementation SpecificationAttributeEditCell
+(instancetype)specificationAttributeEditCell
{
    SpecificationAttributeEditCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"SpecificationAttributeEditCell" owner:nil options:nil]lastObject];
    return cell;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_n"];
    self.titleLabelView.textColor = [UIColor colorWithRed:252/255.0 green:153/255.0 blue:151/255.0 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)iconBtnClick:(UIButton *)sender {
    self.attributeValue.isSeleted = @(![self.attributeValue.isSeleted boolValue]);
//    if ([self.attributeValue.isSeleted boolValue]) {
//        self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_h"];
//    }else{
//        self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_n"];
//    }
    if ([_delegate respondsToSelector:@selector(specificationAttributeEditCellWith:)]) {
        [_delegate specificationAttributeEditCellWith:self.attributeValue];
    }
}
-(void)setAttributeValue:(CDProjectAttributeValue *)attributeValue
{
    _attributeValue = attributeValue;
    
    self.titleLabelView.text = attributeValue.attributeValueName;
    
    CDProjectAttributePrice *attributePrice = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttributePrice" withValue:attributeValue.attributeValueID forKey:[NSString stringWithFormat:@"templateID == %@ && attributeValueID", self.attributeLine.templateID]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",[attributePrice.extraPrice floatValue]];
    if ([self.attributeValue.isSeleted boolValue]) {
        self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_h"];
    }else{
        self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_n"];
    }
    
}
@end
