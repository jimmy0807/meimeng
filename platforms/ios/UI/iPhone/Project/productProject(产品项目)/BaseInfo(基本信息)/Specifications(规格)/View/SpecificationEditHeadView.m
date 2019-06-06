//
//  SpecificationEditHeadCell.m
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationEditHeadView.h"
#import "SpecificationEditModel.h"
@interface SpecificationEditHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation SpecificationEditHeadView
+(instancetype)specificationEditHeadView
{
    SpecificationEditHeadView *cell = [[[NSBundle mainBundle]loadNibNamed:@"SpecificationEditHeadView" owner:nil options:nil]lastObject];
    return cell;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.iconView.image = [UIImage imageNamed:@"member_message_people_selected_n"];
    self.titleLabel.font = projectContentFont;
}

-(void)setAttributeLine:(CDProjectAttributeLine *)attributeLine
{
    _attributeLine = attributeLine;
    self.titleLabel.text = attributeLine.attributeName;
    if ([self.attributeLine.isSelected boolValue]) {
        self.iconView.image = [UIImage imageNamed:@"member_message_people_selected_h"];
    }else{
         self.iconView.image = [UIImage imageNamed:@"member_message_people_selected_n"];
    }
}
-(void)setAttribute:(CDProjectAttribute *)attribute
{
    _attribute = attribute;
    if (attribute.attributeName.length) {
         self.titleLabel.text = attribute.attributeName;
        if ([_attribute.isSeleted boolValue]) {
            self.iconView.image = [UIImage imageNamed:@"member_message_people_selected_h"];
        }else{
            self.iconView.image = [UIImage imageNamed:@"member_message_people_selected_n"];
        }
    }
    
}
- (IBAction)imageBtnClick:(id)sender {
    
    self.attributeLine.isSelected = @(![self.attributeLine.isSelected boolValue]);
    self.attribute.isSeleted = @(![self.attribute.isSeleted boolValue]);
    if ([_delegate respondsToSelector:@selector(specificationEditHeadCellImageBtnClickWithLine:)]) {
        [_delegate specificationEditHeadCellImageBtnClickWithLine:self.attributeLine];
    }
    
}
@end
