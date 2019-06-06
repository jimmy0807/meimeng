//
//  WXTemplateCell.m
//  Boss
//
//  Created by lining on 16/6/2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "WXTemplateCell.h"

@interface WXTemplateCell ()<UITextFieldDelegate>

@end

@implementation WXTemplateCell

+ (instancetype)createCell
{
    WXTemplateCell *cell = [self loadFromNib];
    cell.textField.delegate = cell;
    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    return cell;
}

- (void)setWXTemplate:(CDWXCardTemplate *)WXTemplate
{
    _WXTemplate = WXTemplate;
    self.nameLabel.text = WXTemplate.title;
    self.countLabel.text = [NSString stringWithFormat:@"总库存:%@张",WXTemplate.quantity];
    self.currentCountLabel.text = [NSString stringWithFormat:@"现有库存:%@张",WXTemplate.current_quantity];
    self.textField.text = [NSString stringWithFormat:@"%@",WXTemplate.quantity];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)circleBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedBtnPressedAtIndexPath:)]) {
        [self.delegate didSelectedBtnPressedAtIndexPath:self.indexPath];
    }
}

- (IBAction)arrowBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didExpandBtnPressedAtIndexPath:)]) {
        [self.delegate didExpandBtnPressedAtIndexPath:self.indexPath];
    }
}

#pragma mark- 
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [NSString stringWithFormat:@"%d",[textField.text integerValue]];
}

- (IBAction)sureBtnPressed:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(didSureBtnPressedAtIndexPath:withCount:)]) {
        [self.delegate didSureBtnPressedAtIndexPath:self.indexPath withCount:[self.textField.text integerValue]];
    }
}

@end
