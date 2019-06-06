//
//  BSSearchView.m
//  Boss
//
//  Created by lining on 16/10/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSSearchView.h"

@implementation BSSearchView

+ (instancetype)createView
{
    BSSearchView *searchView = [self loadFromNib];

    return searchView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = COLOR(233, 233, 233, 1);
    self.textField.layer.masksToBounds = true;
    self.textField.layer.cornerRadius = 4;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
//    if ([self.textField respondsToSelector:@selector(setTintColor:)]) {
//        self.textField.tintColor = [UIColor darkGrayColor];
//    }
    
    self.leftImgName = @"search";
    
    UIView *marginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    
    self.textField.leftView = marginView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;

    self.textField.rightView = marginView;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    
}


- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}


- (void)setLeftImgName:(NSString *)leftImgName
{
    _leftImgName = leftImgName;
    UIImage *leftImg = [UIImage imageNamed:leftImgName];
    if (leftImg == nil) {
        NSLog(@"left 没有此图片");
    }
    else
    {
        UIButton *leftImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftImgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
        [leftImgBtn setImage:leftImg forState:UIControlStateNormal];
        leftImgBtn.frame = CGRectMake(0, 0, leftImg.size.width + 15, leftImg.size.height );
        
        [leftImgBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.textField.leftView = leftImgBtn;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
    }
}


- (void)setRightImgName:(NSString *)rightImgName
{
    _rightImgName = rightImgName;
    UIImage *rightImg = [UIImage imageNamed:rightImgName];
    if (rightImg == nil) {
        NSLog(@"right 无此图片");
    }
    else
    {
        UIButton *rightImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightImgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [rightImgBtn setImage:rightImg forState:UIControlStateNormal];
        rightImgBtn.frame = CGRectMake(0, 0, rightImg.size.width + 10, rightImg.size.height );
        [rightImgBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.textField.rightView = rightImgBtn;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(didSearchWithText:)]) {
        [self.delegate didSearchWithText:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - button action
- (void)leftBtnPressed:(UIButton *)btn
{
    NSLog(@"leftBtnPressed");
    if ([self.delegate respondsToSelector:@selector(didLeftBtnPressed:)]) {
        [self.delegate didLeftBtnPressed:btn];
    }
    
}

- (void)rightBtnPressed:(UIButton *)btn
{
    NSLog(@"rightBtnPressed");
    if ([self.delegate respondsToSelector:@selector(didRightBtnPressed:)]) {
        [self.delegate didRightBtnPressed:btn];
    }
}


- (UIImage *)getImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}



@end
