//
//  SpecificationCell.m
//  Boss
//
//  Created by jiangfei on 16/7/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationSectionHeadView.h"
#import "CDProjectAttributeLine.h"
#import "SpecificationEditModel.h"
@interface SpecificationSectionHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation SpecificationSectionHeadView
+(instancetype)specificationHeadView
{
    SpecificationSectionHeadView *cell = [[[NSBundle mainBundle]loadNibNamed:@"SpecificationSectionHeadView" owner:nil options:nil]lastObject];
    return cell;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = projectTitleFont;
    
    self.autoresizingMask = UIViewAutoresizingNone;
}
- (IBAction)addBtnClick:(id)sender {
    NSLog(@"添加");
    if ([_delegate respondsToSelector:@selector(specificationSectionHeadViewAddBtnClickWithLine:)]) {
        [_delegate specificationSectionHeadViewAddBtnClickWithLine:self.editModel];
    }
}
-(void)setAttributeLine:(CDProjectAttributeLine *)attributeLine
{
    _attributeLine = attributeLine;
    if (attributeLine.attributeName.length) {
        self.titleLabel.text = attributeLine.attributeName;
    }
}
-(void)setAttribute:(CDProjectAttribute *)attribute
{
    _attribute = attribute;
    if (attribute.attributeName.length) {
        self.titleLabel.text = attribute.attributeName;
    }
    
}
-(void)setEditModel:(SpecificationEditModel *)editModel
{
    _editModel = editModel;
    if (editModel.attributeLine) {
        self.attributeLine = editModel.attributeLine;
    }else if (editModel.attribute){
        self.attribute = editModel.attribute;
    }
}
@end
