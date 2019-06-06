//
//  CBMessageView.m
//  CardBag
//
//  Created by jimmy on 13-8-6.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "CBMessageView.h"
#import "ICColoredLabel.h"

@implementation CBMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString*)title
{
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.5) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    UIImage* imageBG = [UIImage imageNamed:@"messageView.png"];
    self = [super initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    if (self)
    {
        self.backgroundImageView = [[UIImageView alloc]initWithImage:imageBG];
        self.backgroundImageView.userInteractionEnabled = YES;
        [self addSubview:self.backgroundImageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, imageBG.size.width - 40, imageBG.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        //label.shadowColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        [label setNumberOfLines:0];
        [self.backgroundImageView addSubview: label];

        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen ] bounds].size.height);
        [button addTarget: self action: @selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: button];
    }
    
    return self;
}
- (id)initWithTitle:(NSString *)title afterTimeHide:(double)time
{
    timer = [NSTimer scheduledTimerWithTimeInterval:(time) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    UIImage* imageBG = [UIImage imageNamed:@"messageView.png"];
    self = [super initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    if (self)
    {
        self.backgroundImageView = [[UIImageView alloc]initWithImage:imageBG];
        self.backgroundImageView.userInteractionEnabled = YES;
        [self addSubview:self.backgroundImageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, imageBG.size.width - 40, imageBG.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        //label.shadowColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        [label setNumberOfLines:0];
        [self.backgroundImageView addSubview: label];
        
        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen ] bounds].size.height);
        [button addTarget: self action: @selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: button];
    }
    
    return self;
    
}
- (id)initWithTitle:(NSString*)title KeyWordTextArray:(NSArray*)array orTextString:(NSString*)str withColor:(UIColor*)color
{
    timer = [NSTimer scheduledTimerWithTimeInterval:(2.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    UIImage* imageBG = [UIImage imageNamed:@"common_TextOnly_Popup.png"];
    self = [super initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    if (self)
    {
        self.backgroundImageView = [[UIImageView alloc]initWithImage:imageBG];
        self.backgroundImageView.userInteractionEnabled = YES;
        [self addSubview:self.backgroundImageView];
        
        ICColoredLabel* label = [[ICColoredLabel alloc] initWithFrame: CGRectMake(10, 0, imageBG.size.width - 20, imageBG.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = COLOR(132, 115, 93, 0.75);
        label.shadowColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        [label setNumberOfLines:0];
        [self.backgroundImageView addSubview: label];
        [label setText:title WithFont:label.font AndColor:label.textColor];
        if ( array )
        {
            [label setKeyWordTextArray:array WithFont:label.font AndColor:color];
        }
        else if ( str )
        {
            [label setKeyWordTextString:str WithFont:label.font AndColor:color];
        }
        
        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen ] bounds].size.height);
        [button addTarget: self action: @selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: button];
    }
    
    return self;
}

- (void)setForeverShow
{
    isForeverTitle = TRUE;
    if ( timer )
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)didTap:(id)sender
{
    [self hide];
}

-(void)onTimer
{
    [self hide];
}

-(void)show
{
    [self showAtCenterPos:CGPointMake(IC_SCREEN_WIDTH/2, IC_SCREEN_HEIGHT/2)];
}

-(void)showAtCenterPos:(CGPoint)point
{
    UIWindow *mainWindow=[[UIApplication sharedApplication].windows objectAtIndex:0];
    [mainWindow addSubview: self];
    self.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen ] bounds].size.height);
    self.alpha = 0.0;
    self.backgroundImageView.center = point;
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.alpha = 1.0;
    [UIView setAnimationDelegate: self];
    [UIView commitAnimations];
}

-(void)showInView:(UIView*)view
{
    [view addSubview:self];
    self.frame = view.bounds;
    self.alpha = 0.0;
    self.backgroundImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.alpha = 1.0;
    [UIView setAnimationDelegate: self];
    [UIView commitAnimations];
}

-(void)hide
{
    if ( timer || isForeverTitle )
    {
        isForeverTitle = FALSE;
        
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: 0.5];
        self.alpha = 0.0;
        [UIView setAnimationDidStopSelector: @selector(stoped)];
        [UIView setAnimationDelegate: self];
        [UIView commitAnimations];
        
        [timer invalidate];
        timer = nil;
    }
}

-(void)stoped
{
    if ( [self.delegate respondsToSelector:@selector(messageViewWillDisAppear:)] )
    {
        [self.delegate messageViewWillDisAppear:self];
    }
    
    [self removeFromSuperview];
}

@end

