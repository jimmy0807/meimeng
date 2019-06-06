//
//  CBLoadingView.m
//  CardBag
//
//  Created by lining on 13-8-12.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "CBLoadingView.h"
#import "NSObject+MainThreadNotification.h"
#import "ICRequestDef.h"
static CBLoadingView *loadingView =nil;

@interface CBLoadingView()
@property(nonatomic, strong)UIActivityIndicatorView *activity;
@end

@implementation CBLoadingView

+ (CBLoadingView *)shareLoadingView
{
    @synchronized(loadingView)
    {
        if (loadingView == nil)
        {
            loadingView = [[CBLoadingView alloc] init];
        }
    }
    [[[UIApplication sharedApplication].windows objectAtIndex:0] bringSubviewToFront:loadingView];
    
    return loadingView;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,1024,768)];
        [self addSubview:bottomView];
        UIImage *image = [UIImage imageNamed:@"common_alert_bg.png"];
        self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,80,80)];
        self.bgView.image = image;
        [self addSubview:self.bgView];
    }
    
    return self;
}

- (void)show
{
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [self showAtCenterPos:CGPointMake(IC_SCREEN_WIDTH/2 , IC_SCREEN_HEIGHT/2) inView:mainWindow];
}

- (void)showInView:(UIView *)view
{
    [self showAtCenterPos:CGPointMake(view.frame.size.width/2, view.frame.size.height/2 - 20.0 - 44.0) inView:view];
}

- (void)showAtCenterPos:(CGPoint)point inView:(UIView *)view
{
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    self.bgView.center = point;
    
    if ( self.activity == nil )
    {
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.bgView addSubview:self.activity];
    }
    
    self.activity.frame = CGRectMake(self.bgView.frame.size.width/2-self.activity.frame.size.width/2,self.bgView.frame.size.height/2-self.activity.frame.size.height/2,20,20);
    [self.activity startAnimating];

    [view addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}


#pragma mark - ReceivedNotification

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [self hide];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

