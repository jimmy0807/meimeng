//
//  ProductCountView.m
//  Boss
//
//  Created by lining on 15/6/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ProductCountView.h"
#import "UIImage+Resizable.h"

#define KeyBoardHeight 258

@interface ProductCountView ()<UITextFieldDelegate>
{
    CGFloat textFiledMoveDistance;
}
@property(nonatomic, strong) UIButton *reduceBtn;
@property(nonatomic, strong) UIButton *addBtn;
@property(nonatomic, strong) UIButton *priceBtn;
@property(nonatomic, strong) UIButton *hideKeyBtn;
@end

@implementation ProductCountView

-(id)initWithPoint:(CGPoint)point count:(NSInteger)count
{
    self = [super init];
    if (self) {
        
        self.minCount = 1;
        self.maxCount = 9999;
        self.count = count;
        
        UIImage *reduce_img_n = [UIImage imageNamed:@"product_count_reduce_n.png"];
        UIImage *reduce_img_h = [UIImage imageNamed:@"product_count_reduce_h.png"];
        UIImage *reduce_img_disable = [UIImage imageNamed:@"product_count_reduce_disable.png"];
        
        UIImage *add_img_n = [UIImage imageNamed:@"product_count_add_n.png"];
        UIImage *add_img_h = [UIImage imageNamed:@"product_count_add_h.png"];
        UIImage *add_img_disable = [UIImage imageNamed:@"product_count_add_disable.png"];
        
        
        UIImage *price_bg = [[UIImage imageNamed:@"product_price_bg.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
        
        CGFloat xCoord = 0.0;
        CGFloat height = reduce_img_n.size.height;
        
        self.reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reduceBtn setBackgroundImage:reduce_img_n forState:UIControlStateNormal];
        [self.reduceBtn setBackgroundImage:reduce_img_h forState:UIControlStateHighlighted];
        [self.reduceBtn setBackgroundImage:reduce_img_disable forState:UIControlStateDisabled];
        [self addSubview:self.reduceBtn];
        [self.reduceBtn addTarget:self action:@selector(reduceBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.reduceBtn.frame = CGRectMake(xCoord, 0.0, reduce_img_n.size.width, height);
        if (self.count == 1) {
            self.reduceBtn.enabled = false;
        }
        [self addSubview:self.reduceBtn];
        
        xCoord += self.reduceBtn.frame.size.width;
        
        self.countField = [[UITextField alloc] initWithFrame:CGRectMake(xCoord, 0, price_bg.size.width+4, height)];
        self.countField.borderStyle = UITextBorderStyleNone;
        self.countField.background = price_bg;
//        self.countField.delegate = self;
        self.countField.font = [UIFont boldSystemFontOfSize:14];
        self.countField.textAlignment = NSTextAlignmentCenter;
        self.countField.keyboardType = UIKeyboardTypeNumberPad;
        self.countField.textColor = COLOR(104, 171, 245, 1);
        self.countField.text = [NSString stringWithFormat:@"%d",count];
        
        self.priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.priceBtn setBackgroundImage:price_bg forState:UIControlStateNormal];
        [self.priceBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
        [self.priceBtn setTitleColor:COLOR(104, 171, 245, 1) forState:UIControlStateNormal];
        self.priceBtn.frame = CGRectMake(xCoord, 0, price_bg.size.width, height);
//        [self addSubview:self.priceBtn];
        
        [self addSubview:self.countField];
        
        xCoord += self.countField.frame.size.width;
        
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addBtn setBackgroundImage:add_img_n forState:UIControlStateNormal];
        [self.addBtn setBackgroundImage:add_img_h forState:UIControlStateHighlighted];
        [self.addBtn setBackgroundImage:add_img_disable forState:UIControlStateDisabled];
        [self.addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.addBtn.frame = CGRectMake(xCoord, 0, add_img_n.size.width, height);
        [self addSubview:self.addBtn];
        
        xCoord += self.addBtn.frame.size.width;
        
        self.frame = CGRectMake(point.x, point.y, xCoord, height);
        
        self.hideKeyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.hideKeyBtn.frame = [UIScreen mainScreen].bounds;
        [self.hideKeyBtn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:self.hideKeyBtn];
        self.hideKeyBtn.backgroundColor = [UIColor clearColor];
        self.hideKeyBtn.hidden = YES ;
    }
    return self;
}

- (void)setDelegate:(id<ProductCountViewDelegate>)delegate
{
    _delegate = delegate;
    self.countField.delegate = delegate;
}

-(void)setCount:(NSInteger)count
{
    _count = count;
    
    if (count <= self.minCount) {
        self.reduceBtn.enabled = false;
        _count = self.minCount;
    }
    else
    {
        self.reduceBtn.enabled = true;
    }
    
    if (count >= self.maxCount) {
        self.addBtn.enabled = false;
        count = self.maxCount;
    }
    else
    {
        self.addBtn.enabled = true;
    }
//    [self.priceBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    self.countField.text = [NSString stringWithFormat:@"%d",count];
    if ([self.delegate respondsToSelector:@selector(countChanged:)]) {
        [self.delegate countChanged:self];
    }
}

- (void)reduceBtnPressed:(UIButton *)btn
{
    self.count--;
}

- (void)addBtnPressed:(UIButton *)btn
{
    self.count ++;
}

- (void)hideKeyBoard
{
    [self.countField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.hideKeyBtn.hidden = NO;
    CGRect textFrame = [textField convertRect:textField.frame toView:nil];
    float textY = textFrame.origin.y + textFrame.size.height;
    float bottomY = [UIScreen mainScreen].bounds.size.height - textY;
    if (bottomY > KeyBoardHeight) {
        textFiledMoveDistance = 0;
        return;
    }
    textFiledMoveDistance = KeyBoardHeight - bottomY;
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.window.frame;
    frame.origin.y -= textFiledMoveDistance;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.window.frame = frame;
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.hideKeyBtn.hidden = YES;
    self.count = [textField.text integerValue];
    
    if( textFiledMoveDistance == 0 )
    {
        return;
    }
    
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.window.frame;
    frame.origin.y += textFiledMoveDistance;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.window.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


@end
