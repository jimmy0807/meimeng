//
//  PadInputPasswordView.m
//  Boss
//
//  Created by lining on 16/1/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadInputPasswordView.h"

#define kMargin                 50           //键盘距离上下左右的边距
#define kRowMargin              8           //行间距
#define kColumnMargin           12          //列间距

#define kNumberBtnWidth         110         //数字按钮默认宽度 1 - 9
#define kNumberBtnHeight        75          //数字按钮默认高度

#define kLongBtnWidth           190         //其它键盘按钮的宽度  取消键 键盘消失键

#define kFontSize               18          //字体的默认大小


#define BG_COLOR                COLOR(207, 210, 213, 1)

#define kNormalKeyboardWidth    (3*kNumberBtnWidth + 3*kColumnMargin + kLongBtnWidth) //整个键盘的宽度
#define kNormalKeyboardHeight   (4*kNumberBtnHeight + 3*kRowMargin) //整个键盘的高度


#define kPasswordWidth          95 //单个密码框的宽度
#define kPasswordHeight         74 //单个密码框的高度
#define kPasswordMargin         1 //两个密码框之间的间隔
#define kPasswordCount          6 //密码个数 默认为6位
#define kPasswordStartTag       1000 //passwordView开始的tag值

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width  //屏幕宽度
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height //屏幕高度

@interface PadInputPasswordView ()

@property (nonatomic, assign) CGFloat money;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIView *keyBoardView; //键盘view
@property (nonatomic, strong) UIView *keyboardBgView; //键盘背景
@property (nonatomic, strong) NSArray *numbers; //随机生成的0-9
@property (nonatomic, strong) NSMutableString *password; //输入密码的个数
@end

@implementation PadInputPasswordView


- (instancetype)initWithMoney:(CGFloat)money delegate:(id<InputPasswordViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.delegate = delegate;
        self.password = [NSMutableString string];
        self.backgroundColor = COLOR(90, 211, 213,1);
        self.numbers = [self randomNumbers];
        CGFloat yCoord = 100.0;
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, SCREEN_WIDTH, 50)];
        self.moneyLabel.backgroundColor = [UIColor clearColor];
        self.moneyLabel.textAlignment = NSTextAlignmentCenter;
        self.moneyLabel.textColor = [UIColor whiteColor];
        self.moneyLabel.font = [UIFont systemFontOfSize:50];
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",money];
        [self addSubview:self.moneyLabel];
        
        yCoord += self.moneyLabel.frame.size.height + 10;
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yCoord, SCREEN_WIDTH, 20)];
        self.tipLabel.backgroundColor = [UIColor clearColor];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.font = [UIFont boldSystemFontOfSize:20];
        self.tipLabel.text = @"输入密码时请注意周边环境的安全";
        [self addSubview:self.tipLabel];
        
        yCoord += self.tipLabel.frame.size.height + 50;
        
        
       
        CGFloat width = kPasswordCount*kPasswordWidth - (kPasswordCount - 1)*kPasswordMargin;
        CGFloat x = (SCREEN_WIDTH - width)/2.0;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10 + x, yCoord, width - 20, kPasswordHeight)];
        bgView.backgroundColor = COLOR(245,245,245,1);
        [self addSubview:bgView];
        
        
        for (int i = 0; i < kPasswordCount; i++) {
            UIImage *normalImage = [UIImage imageNamed:@"password_middle_bg_n.png"];
            UIImage *highlighImage = [UIImage imageNamed:@"password_middle_bg_h.png"];
            if (i == 0) {
                normalImage = [UIImage imageNamed:@"password_left_bg_n.png"];
                highlighImage = [UIImage imageNamed:@"password_left_bg_h.png"];
            }
            
            if (i == kPasswordCount - 1) {
                normalImage = [UIImage imageNamed:@"password_right_bg_n.png"];
                highlighImage = [UIImage imageNamed:@"password_right_bg_h.png"];
            }
            
            UIImageView *passwordView = [[UIImageView alloc] initWithImage:normalImage highlightedImage:highlighImage];
            passwordView.tag = kPasswordStartTag + i;
            passwordView.frame = CGRectMake(x + i*(kPasswordWidth + kPasswordMargin), yCoord, kPasswordWidth, kPasswordHeight);
            [self addSubview:passwordView];
        }
        
        [self initKeyboardNumbers];
    }
    
    return self;
}


#pragma mark - 生成0-9随机数字
- (NSArray *)randomNumbers
{
    NSMutableArray *randomArray = [NSMutableArray array];
    NSMutableArray *orginArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",nil];
    int count = orginArray.count;
    for (int i = 0;  i< count; i ++) {
        int randomIdx = arc4random()%orginArray.count;
        randomArray[i] = orginArray[randomIdx];
        orginArray[randomIdx] = [orginArray lastObject];//为了更好的乱序
        [orginArray removeLastObject];
    }
    NSLog(@"randomArray: %@",randomArray);
    return randomArray;
}



#pragma mark - init 键盘
- (void)initKeyboardNumbers
{
    CGRect bgFrame = CGRectMake(0, (SCREEN_HEIGHT - kNormalKeyboardHeight - 2*kMargin), SCREEN_WIDTH, kNormalKeyboardHeight + 2*kMargin);
    self.keyboardBgView = [[UIView alloc] initWithFrame:bgFrame];
    self.keyboardBgView.backgroundColor = COLOR(245,245,245,1);
    [self addSubview:self.keyboardBgView];

    self.keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kNormalKeyboardWidth , kNormalKeyboardHeight)];
    [self.keyboardBgView addSubview:self.keyBoardView];
    
    self.keyBoardView.center = CGPointMake(self.keyboardBgView.frame.size.width/2.0, self.keyboardBgView.frame.size.height/2.0);
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            int idx = i*3+ j;
            NSString *title = self.numbers[idx];
            CGRect rect = CGRectMake(j*(kNumberBtnWidth + kColumnMargin),i *(kNumberBtnHeight + kRowMargin) , kNumberBtnWidth, kNumberBtnHeight);
            UIButton *btn = [self buttonWithFrame:rect title:title titleImage:nil seletor:nil];
            [self.keyBoardView addSubview:btn];
        }
    }
    
    UIButton *zeroBtn = [self buttonWithFrame:CGRectMake(kNumberBtnWidth + kColumnMargin, self.keyBoardView.frame.size.height - kNumberBtnHeight, kNumberBtnWidth,kNumberBtnHeight) title:self.numbers[9] titleImage:nil seletor:nil];
    [self.keyBoardView addSubview:zeroBtn];
    

    
    UIButton *deleteBtn = [self buttonWithFrame:CGRectMake(kNormalKeyboardWidth - kLongBtnWidth, 0, kLongBtnWidth, kNumberBtnHeight) title:nil titleImage:[UIImage imageNamed:@"number_key_dele.png"] seletor:@selector(deleteBtnPressed:)];
    [self.keyBoardView addSubview:deleteBtn];
    
    UIButton *sureBtn = [self buttonWithFrame:CGRectMake(deleteBtn.frame.origin.x, deleteBtn.frame.size.height + deleteBtn.frame.origin.y + kRowMargin,deleteBtn.frame.size.width , 2*kNumberBtnHeight + kRowMargin) title:@"确认" titleImage:nil seletor:@selector(sureBtnPressed:)];
    [sureBtn setTitleColor:COLOR(90, 211, 213,1) forState:UIControlStateNormal];
    [self.keyBoardView addSubview:sureBtn];
    
    
    UIButton *cancelBtn = [self buttonWithFrame:CGRectMake(deleteBtn.frame.origin.x, sureBtn.frame.size.height + sureBtn.frame.origin.y + kRowMargin,deleteBtn.frame.size.width , kNumberBtnHeight) title:@"取消" titleImage:[UIImage imageNamed:nil] seletor:@selector(cancelBtnPressed:)];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.keyBoardView addSubview:cancelBtn];
}


- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleImage:(UIImage *)titleImage seletor:(SEL)selector
{
    UIImage *noramlImage = [UIImage imageNamed:@"number_key_bg_n.png"];
    UIImage *highlightImage = [UIImage imageNamed:@"number_key_bg_h.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:noramlImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    if (titleImage) {
        [button setImage:titleImage forState:UIControlStateNormal];
    }
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (selector == nil) {
        selector = @selector(keyNumberPressed:);
    }
    
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - 清空密码
- (void)clear
{
    for (int i = 0; i < kPasswordCount; i++)
    {
        UIImageView *imageView = [self viewWithTag:kPasswordStartTag + i];
        imageView.highlighted = false;
    }
    self.password = [NSMutableString string];
}

#pragma mark - 键盘点击事件
- (void)keyNumberPressed:(UIButton *)button
{
    
    NSString *title = button.titleLabel.text;
    if (self.password.length < 6) {
        [self.password appendString:title];
        int tag = kPasswordStartTag + self.password.length - 1;
        UIImageView *imgView = [self viewWithTag:tag];
        imgView.highlighted = true;
        if (self.password.length == 6) {
            if ([self.delegate respondsToSelector:@selector(didInputPasswordDone:)]) {
                NSLog(@"输入密码完成:%@",self.password);
                
                [self.delegate didInputPasswordDone:self.password];
            }
        }
        if ([self.delegate respondsToSelector:@selector(didSelectedNumber:)]) {
            [self.delegate didSelectedNumber:title];
        }
    }
    else
    {
        ;
    }
   
}


- (void)deleteBtnPressed:(UIButton *)button
{
    if (self.password.length > 0) {
        int tag = kPasswordStartTag + self.password.length - 1;
        UIImageView *imgView = [self viewWithTag:tag];
        imgView.highlighted = false;
        self.password = [NSMutableString stringWithString:[self.password substringToIndex:self.password.length - 1]];
    }
    
}

- (void)sureBtnPressed:(UIButton *)button
{
    if (self.password.length == 6) {
        NSLog(@"");
        if ([self.delegate respondsToSelector:@selector(didInputPasswordDone:)]) {
            [self.delegate didInputPasswordDone:self.password];
        }
    }
    else
    {
        NSLog(@"请输入正确的密码位数");
    }
  
}

- (void)cancelBtnPressed:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didCancelBtnPressed)]) {
        [self.delegate didCancelBtnPressed];
    }
}
@end
