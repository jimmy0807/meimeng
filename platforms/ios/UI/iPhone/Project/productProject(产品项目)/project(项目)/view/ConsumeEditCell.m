//
//  ConsumeEditCell.m
//  Boss
//
//  Created by jiangfei on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ConsumeEditCell.h"
#import "CDProjectTemplate+CoreDataClass.h"
#import "UIButton+WebCache.h"
#import "ConsumeGoodModel.h"
@interface ConsumeEditCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
/**  数量*/
@property (nonatomic,assign)NSUInteger num;
@end
@implementation ConsumeEditCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.numTextField.delegate = self;
    self.numTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setConsumable:(BSConsumable *)consumable
{
    _consumable = consumable;
    self.numTextField.text = [NSString stringWithFormat:@"%d",self.consumable.count];
    self.checkBtn.selected = consumable.isSelected;
    //图片
    [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:self.consumable.projectItem.imageSmallUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage"]];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
   
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger count = textField.text.integerValue;
    self.consumable.count = count;
}

#pragma mark 选中icon
- (IBAction)checkBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.consumable.isSelected = sender.selected;
}


#pragma mark 减号按钮
- (IBAction)reduceBtnClick:(UIButton *)sender {
    self.consumable.count -- ;
    if (self.consumable.count < 0) {
        self.consumable.count = 0;
    }
    self.numTextField.text = [NSString stringWithFormat:@"%d",self.consumable.count];
    
    
}
#pragma mark 加号按钮
- (IBAction)addBtnClick:(UIButton *)sender {
    self.consumable.count ++;

    self.numTextField.text = [NSString stringWithFormat:@"%d",self.consumable.count];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
