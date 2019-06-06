//
//  CBRotateNavigationController.m
//  CardBag
//
//  Created by jimmy on 13-9-3.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "RotateNavigationController.h"

@interface RotateNavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;
@property (nonatomic,assign) BOOL isMoving;

@end


@implementation RotateNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
        self.isAnimationHiddenNavBar = YES;
    }
    return self;
}
-(void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor whiteColor], UITextAttributeTextColor,
                              [UIFont boldSystemFontOfSize:20.0], UITextAttributeFont,
                              nil];
        [self.navigationBar setTitleTextAttributes:dict];
    }
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:56/255.0 green:126/255.0 blue:245/255.0 alpha:1];
    
    
//    self.recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
//                                                                                action:@selector(paningGestureReceive:)];
//    [self.recognizer delaysTouchesBegan];
//    [self.view addGestureRecognizer:self.recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //[self.screenShotsList addObject:[self capture]];
    
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
   // [self.screenShotsList removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 截屏
-(UIImage *)capture
{
    CGRect rect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!iOS7) {
        CGContextClipToRect(context, rect);
    }
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark - 移动
-(void)moveViewWithX:(CGFloat)x
{
    x = x>320?320:x;
    x = x<0?0:x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.4 - (x/1000);
    blackMask.alpha = alpha;
    
    CGFloat aa = fabs(startBackViewX)/kkBackViewWidth;//背景截图x坐标的变化速率
    CGFloat y = x*aa; //背景截图的x的变化
    CGFloat lastScreenShotViewHeight = kkBackViewHeight;
    //TODO: FIX self.edgesForExtendedLayout = UIRectEdgeNone  SHOW BUG
    /**
     *  if u use self.edgesForExtendedLayout = UIRectEdgeNone; pls add
     
     if (!iOS7) {
     lastScreenShotViewHeight = lastScreenShotViewHeight - 20;
     }
     *
     */
    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,
                                            0,
                                            kkBackViewWidth,
                                            lastScreenShotViewHeight)];
    frame = lastScreenShotView.frame;
    frame.origin.x =5- x/kkBackViewWidth*5;
    frame.origin.y = 5-x/kkBackViewWidth*5;
    frame.size.width = kkBackViewWidth - frame.origin.x*2;
    frame.size.height = lastScreenShotViewHeight - frame.origin.y*2;
    lastScreenShotView.frame = frame;
    
}
-(BOOL)isBlurryImg:(CGFloat)tmp
{
    return YES;
}
#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDragBackNotification object:nil];
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        
        startBackViewX = startXX;
        [lastScreenShotView setFrame:CGRectMake(startBackViewX,
                                                lastScreenShotView.frame.origin.y,
                                                lastScreenShotView.frame.size.height,
                                                lastScreenShotView.frame.size.width)];
        
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50)
        {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        self.isAnimationHiddenNavBar = NO;
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}

@end
