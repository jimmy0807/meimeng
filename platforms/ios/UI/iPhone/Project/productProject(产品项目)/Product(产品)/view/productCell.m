//
//  productCell.m
//  Boss
//
//  Created by jiangfei on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "productCell.h"
#import "productModel.h"
#import "KeyBordAccessoryView.h"
/** 最右边的控件距离屏幕右边的距离*/
#define rightMargin 15.0
@interface productCell ()<UITextFieldDelegate,KeyBordAccessoryViewDelegate>
/** btnView(用来显示右边的箭头，选框，二维码按钮)*/
@property (nonatomic,weak)UIButton *imageBtn;
/** textFiledView*/
@property (nonatomic,weak)UITextField*textFiledView;
/** 箭头*/
@property (nonatomic,weak)UIImageView *arrowImage;
@end
@implementation productCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加子控件
        //textLabel
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = projectTitleFont;
        
    }
    return self;
}
-(void)keyBordAccessoryViewCompleteItemClick
{
    [self.textFiledView resignFirstResponder];
}
-(void)setIsJump:(BOOL)isJump
{
    _isJump = isJump;
    if (isJump) {
        self.textFiledView.userInteractionEnabled = NO;
    }else{
        self.textFiledView.userInteractionEnabled = YES;
    }
    
}
#pragma mark model的set方法
-(void)setCellModel:(productModel *)cellModel
{
    _cellModel = cellModel;
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UIButton class]] || [subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    CGFloat rightMrgin = -15;
    if (cellModel.type == 0) { //type 0:textField,
        UITextField *textF = [[UITextField alloc]init];
        self.textFiledView = textF;
        
        if (cellModel.textContent.length>0) {
            self.textFiledView.text = cellModel.textContent;
        }else{
            self.textFiledView.placeholder = cellModel.placeHold;
        }
        self.textFiledView.delegate = self;
        self.textFiledView.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textFiledView.font = projectContentFont;
        self.textFiledView.textColor = projectTextFieldColor;
        self.textFiledView.textAlignment = NSTextAlignmentRight;
        self.textFiledView.keyboardType = UIKeyboardTypeNumberPad;
        KeyBordAccessoryView *inputAccess = [KeyBordAccessoryView keyBordAccessoryView];
        inputAccess.accessoryDelegate = self;
        self.textFiledView.inputAccessoryView = inputAccess;
        [self.contentView addSubview:self.textFiledView];
        [self.textFiledView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(rightMrgin);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.textLabel.mas_left);
        }];
    }else if (cellModel.type == 1){//1:箭头+textField,
        
        UIImageView *arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:cellModel.norImageName]];
        self.arrowImage = arrowImage;
        [self.contentView addSubview:self.arrowImage];
        CGSize imageSize = arrowImage.image.size;
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(imageSize.width));
            make.height.equalTo(@(imageSize.height));
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(rightMrgin);
        }];
        
        
        UITextField *textF = [[UITextField alloc]init];
        self.textFiledView = textF;
        
        if (cellModel.textContent.length>0) {
            self.textFiledView.text = cellModel.textContent;
        }else{
            self.textFiledView.placeholder = cellModel.placeHold;
        }
        self.textFiledView.delegate = self;
        self.textFiledView.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textFiledView.font = projectContentFont;
        self.textFiledView.textColor = projectTextFieldColor;
        self.textFiledView.textAlignment = NSTextAlignmentRight;
        self.textFiledView.keyboardType = UIKeyboardTypeNumberPad;
        KeyBordAccessoryView *inputAccess = [KeyBordAccessoryView keyBordAccessoryView];
        inputAccess.accessoryDelegate = self;
        self.textFiledView.inputAccessoryView = inputAccess;
        [self.contentView addSubview:self.textFiledView];
        [self.textFiledView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImage.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.textLabel.mas_left);
        }];
        
                                   
    }else if (cellModel.type == 2){//2:选框,
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageBtn =  btn;
        self.imageBtn.selected = cellModel.imageSeleted;
        self.imageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _imageBtn.tag = 0;
        [btn setImage:[UIImage imageNamed:cellModel.norImageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:cellModel.selImageName] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(imagebtnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize btnSize = btn.currentImage.size;
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(rightMrgin);
            make.height.equalTo(@(btnSize.height));
            make.width.equalTo(@(150));
            make.centerY.equalTo(self.mas_centerY);
        }];
    }else{//3:二维码+textField
        
        UIButton *erBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageBtn = erBtn;
        self.imageBtn.tag = 1;
        [erBtn setImage:[UIImage imageNamed:cellModel.norImageName] forState:UIControlStateNormal];
        [self.contentView addSubview:erBtn];
        CGSize imageSize = self.imageBtn.currentImage.size;
        [erBtn addTarget:self action:@selector(imagebtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [erBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(imageSize.width));
            make.height.equalTo(@(imageSize.height));
        }];
        
        
        UITextField *textF = [[UITextField alloc]init];
        self.textFiledView = textF;
        
        if (cellModel.textContent.length>0) {
            self.textFiledView.text = cellModel.textContent;
        }else{
            self.textFiledView.placeholder = cellModel.placeHold;
        }
        self.textFiledView.delegate = self;
        self.textFiledView.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textFiledView.font = projectContentFont;
        self.textFiledView.textColor = projectTextFieldColor;
        self.textFiledView.textAlignment = NSTextAlignmentRight;
        self.textFiledView.keyboardType = UIKeyboardTypeNumberPad;
        KeyBordAccessoryView *inputAccess = [KeyBordAccessoryView keyBordAccessoryView];
        inputAccess.accessoryDelegate = self;
        self.textFiledView.inputAccessoryView = inputAccess;
        [self.contentView addSubview:self.textFiledView];
        [self.textFiledView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageBtn.mas_left).offset(-10);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.textLabel.mas_left);
        }];
    }
    self.textLabel.text = cellModel.name;
    
}
#pragma mark 编辑textField
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.cellModel.textContent = textField.text;
    if ([_delegate respondsToSelector:@selector(productCellTextFieldEndEdit:withCellModel:)]) {
        [_delegate productCellTextFieldEndEdit:self withCellModel:self.cellModel];
    }
}
#pragma mark 点击textfield的return按钮退下键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 右边的按钮被点击
-(void)imagebtnClick:(UIButton*)btn
{
    
    self.cellModel.imageSeleted = !self.cellModel.imageSeleted;
    if ([_delegate respondsToSelector:@selector(productCellTextFieldEndEdit:withCellModel:)]) {
        [_delegate productCellClickBtnWith:self.cellModel and:btn.tag];
    }
    
}
@end
