//
//  SpecificationEditBoomView.m
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationEditBoomView.h"
#import "SpecificationEditModel.h"
@interface SpecificationEditBoomView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;

@end
@implementation SpecificationEditBoomView
+(instancetype)specificationEditBoomView
{
    SpecificationEditBoomView *boomView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    return boomView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_n"];
    [self.deleteBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:153/255.0 blue:151/255.0 alpha:1] forState:UIControlStateNormal];

}
- (IBAction)deleteBtnClick:(UIButton *)sender {
    NSLog(@"删除");
    self.isAllSeleted = NO;
    if (_deleteBlock) {
        _deleteBlock();
    }
}
-(void)setIsAllSeleted:(BOOL)isAllSeleted
{
    _isAllSeleted = isAllSeleted;
    if (_isAllSeleted) {
        self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_h"];
    }else{
        self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_n"];
    }
}
- (IBAction)iconBtnClick:(UIButton *)sender {//全选按钮被点击
    self.isAllSeleted = !self.isAllSeleted;
    if (self.isAllSeleted) {
        self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_h"];
    }else{
        self.iconImageView.image = [UIImage imageNamed:@"member_message_people_selected_n"];
    }
    if (_allSeletedBlock) {
        _allSeletedBlock(self.isAllSeleted);
    }
}

@end
