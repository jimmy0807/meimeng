//
//  ProductAttributeCollectionCell.m
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductAttributeCollectionCell.h"
#import "CDProjectAttributeValue.h"
@interface ProductAttributeCollectionCell()
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@end
@implementation ProductAttributeCollectionCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleBtn.layer.cornerRadius = 15;
    [self.titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}

-(void)longPress:(UILongPressGestureRecognizer*)gesture
{
    
    if (gesture.state == 1) {
        if ([_delegate respondsToSelector:@selector(productAttributeLongPressCellWithAttributeValue:)]) {
        
            [_delegate productAttributeLongPressCellWithAttributeValue:self.projectAttributeValue];
        }
    }
}
-(void)setProjectAttributeValue:(CDProjectAttributeValue *)projectAttributeValue
{
    _projectAttributeValue = projectAttributeValue;
    [self.titleBtn setTitle:projectAttributeValue.attributeValueName forState:UIControlStateNormal];
    self.titleBtn.selected = [projectAttributeValue.isSeleted boolValue];
    if ([projectAttributeValue.isSeleted boolValue]) {
        
            [self.titleBtn setBackgroundColor:[UIColor colorWithRed:11/255.0 green:169/255.0 blue:250/255.0 alpha:1]];
        }else{
            [self.titleBtn setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
        }
}

- (IBAction)titleBtnClick:(UIButton *)sender {
    self.projectAttributeValue.isSeleted = @(![self.projectAttributeValue.isSeleted boolValue]);
    if ([_delegate respondsToSelector:@selector(productAttributeChangeStatues:)]) {
        [_delegate productAttributeChangeStatues:self.projectAttributeValue];
    }
}
@end
