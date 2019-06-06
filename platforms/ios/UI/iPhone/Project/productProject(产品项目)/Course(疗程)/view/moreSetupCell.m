//
//  moreSetupCell.m
//  Boss
//
//  Created by jiangfei on 16/6/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "moreSetupCell.h"
#import "moreSetupModel.h"
#import "KeyBordAccessoryView.h"
@interface moreSetupCell ()<UITextFieldDelegate,KeyBordAccessoryViewDelegate>
@property (strong, nonatomic)UIButton *imageBtn;
@property (weak, nonatomic)UITextField *contentTextFiled;

@end
@implementation moreSetupCell

-(UIButton *)imageBtn
{
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageBtn;
}
-(UITextField *)contentTextFiled
{
    if (!_contentTextFiled) {
        UITextField *textField = [[UITextField alloc]init];
        _contentTextFiled = textField;
        _contentTextFiled.delegate = self;
        _contentTextFiled.textAlignment = NSTextAlignmentRight;
        _contentTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        KeyBordAccessoryView *accessoryView = [[[NSBundle mainBundle]loadNibNamed:@"KeyBordAccessoryView" owner:self options:nil]lastObject];
        accessoryView.accessoryDelegate = self;
        _contentTextFiled.inputAccessoryView = accessoryView;
        _contentTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _contentTextFiled.font = projectContentFont;
        _contentTextFiled.textColor = projectTextFieldColor;
    }
    return _contentTextFiled;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
   self.backgroundColor = [UIColor clearColor];
   self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageBtn];
    [self.contentView addSubview:self.contentTextFiled];
    self.textLabel.font = projectTitleFont;
}
//点击了完成item
-(void)keyBordAccessoryViewCompleteItemClick
{
    [self endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.setUpModel.textContent = textField.text;
    if ([_delegate respondsToSelector:@selector(moreSetupCellDelegateWith:andModel:)]) {
        [_delegate moreSetupCellDelegateWith:textField.text andModel:self.setUpModel];
    }
}
-(void)setSetUpModel:(moreSetupModel *)setUpModel
{
    _setUpModel = setUpModel;
   //name
    CGFloat btnW = 0;
    self.textLabel.text = setUpModel.name;
    [self.imageBtn removeFromSuperview];
    [self.contentTextFiled removeFromSuperview];
    //imageBtn
    [self.imageBtn setImage:[UIImage imageNamed:setUpModel.norImageName] forState:UIControlStateNormal];
    [self.imageBtn setImage:[UIImage imageNamed:setUpModel.selImageName] forState:UIControlStateSelected];
    self.imageBtn.selected = setUpModel.imageSeleted;
    //textField
    self.contentTextFiled.placeholder = setUpModel.placeHold;
    self.contentTextFiled.text = setUpModel.textContent;
    if ([setUpModel.name isEqualToString:@"产品"]) {//textField + btn
        //btn
        [self.contentView addSubview:self.imageBtn];
        btnW = self.imageBtn.currentImage.size.width;
        [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.equalTo(@(btnW));
        }];
        //textField
        [self.contentView addSubview:self.contentTextFiled];
        [self.contentTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageBtn.mas_left);
            make.top.equalTo(self.imageBtn.mas_top);
            make.bottom.equalTo(self.imageBtn.mas_bottom);
            make.width.equalTo(@(200));
        }];
        return;
    }else if (setUpModel.norImageName.length){
        //btn
        [self.contentView addSubview:self.imageBtn];
        btnW = self.imageBtn.currentImage.size.width;
        [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.equalTo(@(btnW));
        }];
        return;
    }else{
        //textField
        [self.contentView addSubview:self.contentTextFiled];
        [self.contentTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.equalTo(@(200));
        }];
    }
}
- (void)imageBtnClick:(UIButton *)sender {
    self.setUpModel.imageSeleted = !self.imageBtn.selected;
    if ([_delegate respondsToSelector:@selector(moreSetupCellEditImageBtnSeletedStatus:andModel:)]) {
        [_delegate moreSetupCellEditImageBtnSeletedStatus:self.setUpModel.imageSeleted andModel:self.setUpModel];
    }
}
@end
