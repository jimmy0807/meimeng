//
//  PadNumberKeyboard.m
//  Boss
//
//  Created by lining on 16/1/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadNumberKeyboard.h"
#import "UIView+Frame.h"
#import "UIImage+Resizable.h"
#import "UITextField+ExtentRange.h"
#define kMargin     5           //键盘距离上下左右的边距
#define kRowMargin  8           //行间距
#define kColumnMargin  12       //列间距
#define kColumnLongMagin 30     //较大的列间距

#define kNumberBtnWidth 110     //数字按钮默认宽度 1 - 9
#define kNumberBtnHeight 75     //数字按钮默认高度

#define kLongBtnWidth   190     //其它键盘按钮的宽度  取消键 键盘消失键

#define kFontSize 18         //字体的默认大小

#define BG_COLOR    COLOR(245, 245, 245, 1)

#define kNormalKeyboardWidth    (3*kNumberBtnWidth + 2*kColumnMargin + kColumnLongMagin + kLongBtnWidth) //整个键盘的宽度

//#define kNormalKeyboardHeight   (4*kNumberBtnHeight + 3*kRowMargin) //整个键盘的高度


@interface PadNumberKeyboard ()
{
    float scaleFactor;// 缩放因子
}
@property (nonatomic, strong) UIView *keyBoardView; //键盘view
@property (nonatomic, strong) UIView *aceessoyView;
//@property (nonatomic, strong) NSMutableString *textString;
@end

@implementation PadNumberKeyboard


#pragma mark - init 初始化
- (instancetype)initWithTextField:(UITextField *)textField
{
    return [self initWithKeyboardWidth:kNormalKeyboardWidth textField:textField];
}

- (instancetype)initWithKeyboardWidth:(CGFloat)keyboardWidth textField:(UITextField *)textField
{
    self = [super init];
    if (self) {
        self.backgroundColor = BG_COLOR;//COLOR(207, 210, 213)
        self.autoresizingMask = 0;
        self.textField = textField;
//        self.textString = [NSMutableString string];
        [self initNumberKeyVeiwWithWidth:keyboardWidth];
        
//        self.textField.inputAccessoryView = [[UIView alloc] init];

        self.centerX = IC_SCREEN_WIDTH/2.0;
        
        
        self.aceessoyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
        self.aceessoyView.backgroundColor = [UIColor clearColor];
        [self.aceessoyView addSubview:self];
        self.textField.inputAccessoryView = self.aceessoyView;//之所以用acessoyView,因为inputView默认的有个背景
        self.textField.inputView = [[UIView alloc] init];
    }
    
    return self;
}


#pragma mark - init 键盘
- (void)initNumberKeyVeiwWithWidth:(CGFloat)width
{
    scaleFactor = width / kNormalKeyboardWidth;
    CGFloat keyboardHeight = (4*kNumberBtnHeight*scaleFactor + 3*kRowMargin*scaleFactor);
    self.keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, keyboardHeight)];
    [self addSubview:self.keyBoardView];
    
    CGRect frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, keyboardHeight + 2*kMargin);
    self.rect = frame;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            NSString *title = [NSString stringWithFormat:@"%d",i*3 + (j + 1)];
            
            CGRect rect = CGRectMake(j*(kNumberBtnWidth*scaleFactor + kColumnMargin*scaleFactor),i *(kNumberBtnHeight*scaleFactor + kRowMargin*scaleFactor) , kNumberBtnWidth*scaleFactor, kNumberBtnHeight*scaleFactor);
            
            UIButton *btn = [self buttonWithFrame:rect title:title titleImage:nil seletor:nil];
            [self.keyBoardView addSubview:btn];
        }
    }
    
    UIButton *zeroBtn = [self buttonWithFrame:CGRectMake(0, self.keyBoardView.height - kNumberBtnHeight *scaleFactor, 2*kNumberBtnWidth *scaleFactor + kColumnMargin*scaleFactor,kNumberBtnHeight * scaleFactor) title:@"0" titleImage:nil seletor:nil];
    [self.keyBoardView addSubview:zeroBtn];
   
    NSString *dianTitle = @"";
    if (self.textField.keyboardType == UIKeyboardTypeDecimalPad) {
        dianTitle = @".";
    }
    UIButton *dianBtn = [self buttonWithFrame:CGRectMake(zeroBtn.right + kColumnMargin *scaleFactor, zeroBtn.y,kNumberBtnWidth *scaleFactor, zeroBtn.height) title:dianTitle titleImage:nil seletor:nil];
    [self.keyBoardView addSubview:dianBtn];
    
    
    UIButton *deleteBtn = [self buttonWithFrame:CGRectMake(self.keyBoardView.width - kLongBtnWidth * scaleFactor, 0, kLongBtnWidth * scaleFactor, kNumberBtnHeight * scaleFactor) title:nil titleImage:[UIImage imageNamed:@"number_key_dele.png"] seletor:@selector(deleteBtnPressed:)];
    [self.keyBoardView addSubview:deleteBtn];
    
    UIButton *sureBtn = [self buttonWithFrame:CGRectMake(deleteBtn.x, deleteBtn.bottom + kRowMargin*scaleFactor,deleteBtn.width , 2*kNumberBtnHeight*scaleFactor + kRowMargin *scaleFactor) title:@"确认" titleImage:nil seletor:nil];
    [sureBtn setTitleColor:COLOR(90, 211, 213,1) forState:UIControlStateNormal];
    [self.keyBoardView addSubview:sureBtn];
    
    
    UIButton *doneBtn = [self buttonWithFrame:CGRectMake(deleteBtn.x, sureBtn.bottom + kRowMargin*scaleFactor,deleteBtn.width , kNumberBtnHeight * scaleFactor) title:nil titleImage:[UIImage imageNamed:@"number_key_down.png"] seletor:@selector(doneBtnPressed:)];
    [self.keyBoardView addSubview:doneBtn];
}


- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleImage:(UIImage *)titleImage seletor:(SEL)selector
{
    UIImage *noramlImage = [[UIImage imageNamed:@"number_key_bg_n.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage *highlightImage = [[UIImage imageNamed:@"number_key_bg_h.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:noramlImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    if (titleImage) {
        [button setImage:titleImage forState:UIControlStateNormal];
    }
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kFontSize * scaleFactor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (selector == nil) {
        selector = @selector(keyNumberPressed:);
    }
    
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    return button;
}

#pragma mark - 调整键盘的位置
- (void)setRect:(CGRect)rect
{
    _rect = rect;
    self.frame = rect;

    self.keyBoardView.center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
//     NSLog(@"keyBoardView %@",NSStringFromCGRect(self.keyBoardView.frame));
    self.aceessoyView.height = self.height;
}


#pragma mark - 键盘点击事件
- (void)keyNumberPressed:(UIButton *)button
{
    NSString *title = button.titleLabel.text;
    
    if ( title.length == 0 )
        return;
    
    if ([title isEqualToString:@"确认"])
    {
        [self.textField resignFirstResponder];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadNumberKeyboardDonePressed:)] )
        {
            [self.delegate didPadNumberKeyboardDonePressed:self.textField];
        }
    }
    else
    {
        NSMutableString *textString = [NSMutableString stringWithFormat:@"%@",self.textField.text];
        if ([self.textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        {
            NSRange range = NSMakeRange(textString.length, 0);
            if([self.textField.delegate textField:self.textField shouldChangeCharactersInRange:range replacementString:title])
            {
//旧代码
//                [textString appendString:button.titleLabel.text];
//                self.textField.text = textString;
                
                ///先获取光标的位置
                NSUInteger targetCursorPosition = [self.textField offsetFromPosition:self.textField.beginningOfDocument
                                                                          toPosition:self.textField.selectedTextRange.start];
                //新点的按钮文本
                [textString insertString:button.titleLabel.text atIndex:targetCursorPosition];
                self.textField.text = textString;
                //重置一下光标位置
                [self.textField setSelectedRange:NSMakeRange(targetCursorPosition+1, 0)];
            }
        }
        else
        {
            // 旧代码
            //            [textString appendString:button.titleLabel.text];
            //            self.textField.text = textString;
            
            ///先获取光标的位置
            NSUInteger targetCursorPosition = [self.textField offsetFromPosition:self.textField.beginningOfDocument
                                                                      toPosition:self.textField.selectedTextRange.start];
            //新点的按钮文本
            [textString insertString:button.titleLabel.text atIndex:targetCursorPosition];
            self.textField.text = textString;
            //重置一下光标位置
            [self.textField setSelectedRange:NSMakeRange(targetCursorPosition+1, 0)];
        }
        
    }
}

- (void)deleteBtnPressed:(UIButton *)button
{
    if (self.textField.text.length > 0) {
        NSMutableString *textString = [NSMutableString stringWithFormat:@"%@",self.textField.text];
        
        if ([self.textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            NSRange range = NSMakeRange(textString.length - 1, 1);
            if ([self.textField.delegate textField:self.textField shouldChangeCharactersInRange:range replacementString:@""]) {
                // 旧代码
//                NSString *text = [textString substringToIndex:textString.length - 1];
//                self.textField.text = text;
                ///先获取光标的位置
                NSUInteger targetCursorPosition = [self.textField offsetFromPosition:self.textField.beginningOfDocument
                                                                          toPosition:self.textField.selectedTextRange.start];
                
                NSLog(@"先获取光标的位置 %d",targetCursorPosition);
                if (targetCursorPosition > 0) {
                    //截取光标前后的字符
                    NSString *text2 = [textString substringFromIndex:targetCursorPosition];
                    NSString *text1 = [textString substringToIndex:targetCursorPosition-1];
                    NSLog(@"text2 = %@--text1= %@",text2,text1);
                    //光标删除之后的文本
                    self.textField.text = [NSString stringWithFormat:@"%@%@",text1,text2];
                    //重置一下光标位置
                    [self.textField setSelectedRange:NSMakeRange(targetCursorPosition-1, 0)];
                }
                else{
                    //防止光标在最左边还执行删字符
                    return;
                }
            }
        }
        else
        {
            // 旧代码
            //            NSString *text = [textString substringToIndex:textString.length - 1];
            //            self.textField.text = text;
            
            ///先获取光标的位置
            NSUInteger targetCursorPosition = [self.textField offsetFromPosition:self.textField.beginningOfDocument
                               toPosition:self.textField.selectedTextRange.start];

            NSLog(@"先获取光标的位置 %d",targetCursorPosition);
            if (targetCursorPosition > 0) {
                //截取光标前后的字符
                NSString *text2 = [textString substringFromIndex:targetCursorPosition];
                NSString *text1 = [textString substringToIndex:targetCursorPosition-1];
                NSLog(@"text2 = %@--text1= %@",text2,text1);
                //光标删除之后的文本
                self.textField.text = [NSString stringWithFormat:@"%@%@",text1,text2];
                //重置一下光标位置
                [self.textField setSelectedRange:NSMakeRange(targetCursorPosition-1, 0)];
            }
            else{
                //防止光标在最左边还执行删字符
                return;
            }

        }
    }
    
    NSLog(@"dele btn pressed");
}

- (void)doneBtnPressed:(UIButton *)button
{
    NSLog(@"done btn pressed");
    
    [self.textField resignFirstResponder];
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"PadKeyboard dealloc");
}
@end


@implementation UITextField (CustomKeyboard)

- (PadNumberKeyboard *)customNumberKeyBoard
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        self.inputAssistantItem.leadingBarButtonGroups = nil;
        self.inputAssistantItem.trailingBarButtonGroups = nil;
    }
    PadNumberKeyboard *keyboard = [[PadNumberKeyboard alloc] initWithTextField:self];
    return keyboard;
}

- (PadNumberKeyboard *)customNumberKeyBoardWithWidth:(CGFloat)width
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        self.inputAssistantItem.leadingBarButtonGroups = nil;
        self.inputAssistantItem.trailingBarButtonGroups = nil;
    }
    PadNumberKeyboard *keyboard = [[PadNumberKeyboard alloc] initWithKeyboardWidth:width textField:self];
    return keyboard;
}

@end

