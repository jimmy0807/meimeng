//
//  GestureUnlockView.m
//  Boss
//
//  Created by XiaXianBing on 15/3/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "GestureUnlockView.h"
#import "UIImage+Resizable.h"
#import "PersonalProfile.h"
#import "ICKeyChainManager.h"
#import "BSUserDefaultsManager.h"
#import "CBRotateNavigationController.h"
#import "BSLogoutRequest.h"
#import "BossPermissionManager.h"


#define kGestureUnlockMaxTime   5
#define kButtonPointTag         1000

#define kGLPointDiameter        66.0
#define kGLPointDistance        30.0
#define kGestureTextColor       COLOR(232.0, 232.0, 232.0, 1.0)
#define kGestureErrorColor      COLOR(232.0, 105.0, 30.0, 1.0)
#define kGLTopMargin            ((IS_SDK7 ? 0.0 : 20.0) + 24.0 + 12.0 + 20.0 + 44.0)
#define kGLBottomMargin         (24.0 + 20.0)
#define kGLLeftRightMargin      (IC_SCREEN_WIDTH - 3*kGLPointDiameter - 2*kGLPointDistance)/2.0
#define kGestureUnlockHeight    (3*kGLPointDiameter + 2*kGLPointDistance)
#define kGestureUnlockOriginY   ((IC_SCREEN_HEIGHT - kGestureUnlockHeight - kGLTopMargin - kGLBottomMargin)/2.0 - ((IC_SCREEN_WIDTH > 320.0) ? 20.0 : 0.0))

@interface GestureUnlockView ()

@property (nonatomic, strong) UIImage *pointImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGPoint lineStartPoint;
@property (nonatomic, assign) CGPoint lineEndPoint;
@property (nonatomic, strong) NSMutableArray *dotArray;
@property (nonatomic, strong) NSMutableArray *selectedDots;
@property (nonatomic, assign) BOOL drawFlag;

@property (nonatomic, strong) NSMutableArray *checkArray;

@end

@implementation GestureUnlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    
    return self;
}

- (void)gestureUnlockDidInActive
{
    [UIView beginAnimations:@"" context:@""];
    [UIView setAnimationDuration:0.4];
    self.frame = CGRectMake(self.frame.origin.x, IC_SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
}

- (id)initWithGestureUnlockType:(GestureUnlockType)unlockType
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    if (self)
    {
        self.type = unlockType;
        self.checkArray = [[NSMutableArray alloc] init];
        self.dotArray = [[NSMutableArray alloc] init];
        self.selectedDots = [[NSMutableArray alloc] init];
        self.pointImage = [UIImage imageNamed:@"gesture_lock_n"];
        self.selectedImage = [UIImage imageNamed:@"gesture_lock_h"];
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:self.frame];
        background.image = [UIImage imageNamed:@"gesture_background"];
        [self addSubview:background];
        
        UIImage *image = [UIImage imageNamed:@"wevip_logo"];
        CGFloat origin = kGestureUnlockOriginY;
        origin += (self.type == GestureUnlockType_Login || self.type == GestureUnlockType_SetPW_First) ? 12.0 : 0.0;
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - image.size.width) / 2.0, origin, image.size.width, image.size.height)];
        logoImageView.image = image;
        [self addSubview:logoImageView];
        origin += image.size.height + 12.0;
        
        self.messageBG = [[UIImageView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - 200.0)/2.0, origin - 4.0, 200.0, 28.0)];
        self.messageBG.backgroundColor = [UIColor clearColor];
        self.messageBG.image = [[UIImage imageNamed:@"gesture_lock_error_bg"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        self.messageBG.hidden = YES;
        [self addSubview:self.messageBG];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, origin, IC_SCREEN_WIDTH, 20.0)];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textColor = kGestureTextColor;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [self addSubview:self.messageLabel];
        origin += 20.0;
        
        if (self.type == GestureUnlockType_AddPW_First)
        {
            self.passStepVLabel = [[VLabel alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - 64.0)/2.0, origin, 64.0, 20.0)];
            self.passStepVLabel.backgroundColor = [UIColor clearColor];
            self.passStepVLabel.textAlignment = NSTextAlignmentCenter;
            self.passStepVLabel.textColor = kGestureTextColor;
            self.passStepVLabel.font = [UIFont boldSystemFontOfSize:14.0];
            self.passStepVLabel.text = LS(@"PassStep");
            [self addSubview:self.passStepVLabel];
            self.passStepButton = [[UIButton alloc] initWithFrame:CGRectMake(self.passStepVLabel.frame.origin.x - 8.0, self.passStepVLabel.frame.origin.y - 8.0, self.passStepVLabel.frame.size.width, self.passStepVLabel.frame.size.height + 16.0)];
            self.passStepButton.backgroundColor = [UIColor clearColor];
            [self.passStepButton addTarget:self action:@selector(doPassStepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.passStepButton];
            origin += 20.0;
        }
        origin += 44.0;
        
        for (int i = 0; i < 3; i++)
        {
            CGFloat yPoint = origin + i * (kGLPointDiameter + kGLPointDistance);
            for (int j = 0; j < 3; j++)
            {
                CGFloat xPoint = j * (kGLPointDiameter + kGLPointDistance);
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.image = self.pointImage;
                imageView.frame = CGRectMake(kGLLeftRightMargin + xPoint, yPoint, kGLPointDiameter, kGLPointDiameter);
                imageView.userInteractionEnabled = NO;
                imageView.tag = kButtonPointTag + i * 3 + j;
                [self addSubview:imageView];
                [self.dotArray addObject:imageView];
            }
        }
        
        self.forgetGLVLabel = [[VLabel alloc] initWithFrame:CGRectMake(20.0, IC_SCREEN_HEIGHT - 24.0 - 20.0, 100.0, 20.0)];
        self.forgetGLVLabel.backgroundColor = [UIColor clearColor];
        self.forgetGLVLabel.textAlignment = NSTextAlignmentCenter;
        self.forgetGLVLabel.textColor = kGestureTextColor;
        self.forgetGLVLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.forgetGLVLabel.text = LS(@"ForgetGesturepassWord");
        [self addSubview:self.forgetGLVLabel];
        self.forgetGLButton = [[UIButton alloc] initWithFrame:CGRectMake(self.forgetGLVLabel.frame.origin.x - 8.0, self.forgetGLVLabel.frame.origin.y - 8.0, self.forgetGLVLabel.frame.size.width + 16.0, self.forgetGLVLabel.frame.size.height + 16.0)];
        self.forgetGLButton.backgroundColor = [UIColor clearColor];
        [self.forgetGLButton addTarget:self action:@selector(doForgetGLButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.forgetGLButton];
        
        self.changeUSVLabel = [[VLabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 20.0 - 64.0, IC_SCREEN_HEIGHT - 24.0 - 20.0, 60.0, 20.0)];
        self.changeUSVLabel.backgroundColor = [UIColor clearColor];
        self.changeUSVLabel.textAlignment = NSTextAlignmentCenter;
        self.changeUSVLabel.textColor = kGestureTextColor;
        self.changeUSVLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.changeUSVLabel.text = LS(@"ChangeUserAccount");
        [self addSubview:self.changeUSVLabel];
        self.changeUSButton = [[UIButton alloc] initWithFrame:CGRectMake(self.changeUSVLabel.frame.origin.x - 8.0, self.changeUSVLabel.frame.origin.y - 8.0, self.changeUSVLabel.frame.size.width + 16.0, self.changeUSVLabel.frame.size.height + 16.0)];
        self.changeUSButton.backgroundColor = [UIColor clearColor];
        [self.changeUSButton addTarget:self action:@selector(doChangeUserButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.changeUSButton];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.imageView.userInteractionEnabled = NO;
        [self addSubview:self.imageView];
        
        [self resetGestureUnlock];
    }
    
    return self;
}

- (void)resetGestureUnlock
{
    for (NSInteger i = 0; i < self.dotArray.count; i++)
    {
        UIImageView *imageView = [self.dotArray objectAtIndex:i];
        imageView.image = self.pointImage;
    }
    
    self.messageLabel.hidden = YES;
    self.passStepVLabel.hidden = YES;
    self.passStepButton.hidden = YES;
    self.forgetGLVLabel.hidden = YES;
    self.forgetGLButton.hidden = YES;
    self.changeUSVLabel.hidden = YES;
    self.changeUSButton.hidden = YES;
    
    if (self.type == GestureUnlockType_AddPW_First)
    {
        self.messageLabel.hidden = NO;
        self.messageLabel.text = LS(@"PleaseDrawUnlockGesture");
        self.passStepVLabel.hidden = NO;
        self.passStepButton.hidden = NO;
    }
    else if (self.type == GestureUnlockType_SetPW_First)
    {
        self.messageLabel.hidden = NO;
        self.messageLabel.text = LS(@"PleaseDrawUnlockGesture");
        self.passStepVLabel.hidden = YES;
        self.passStepButton.hidden = YES;
    }
    else if (self.type == GestureUnlockType_AddPW_Second || self.type == GestureUnlockType_SetPW_Second)
    {
        self.messageLabel.hidden = NO;
        self.messageLabel.text = LS(@"DrawUnlockGestureAgain");
    }
    else if (self.type == GestureUnlockType_Login)
    {
        self.messageLabel.hidden = NO;
        NSString *timesKey = GestureUnlockTimes([[PersonalProfile currentProfile].userID stringValue]);
        NSString *userName = [PersonalProfile currentProfile].userName;
        if ([[ICKeyChainManager getPasswordForUsername:timesKey] integerValue] == 0)
        {
            self.messageBG.hidden = YES;
            self.messageLabel.textColor = kGestureTextColor;
            
            NSInteger prefixIndex = [userName rangeOfString:@"@"].location;
            NSInteger suffixIndex = [userName rangeOfString:@"."].location;
            if ( prefixIndex != NSNotFound && suffixIndex != NSNotFound )
            {
                self.messageLabel.text = [NSString stringWithFormat:LS(@"PhoneNumberGestureLogin"), [userName substringToIndex:prefixIndex + 1], [userName substringFromIndex:suffixIndex]];
            }
            else
            {
                prefixIndex = [userName length] / 3;
                suffixIndex = [userName length] - prefixIndex;
                int length = [userName length] - prefixIndex * 2;
                NSMutableString* asterisk = [[NSMutableString alloc] init];
                for ( int i =0; i < length; i++)
                {
                    [asterisk appendString:@"*"];
                }
                self.messageLabel.text = [NSString stringWithFormat:@"%@%@%@ %@",[userName substringToIndex:prefixIndex],asterisk,[userName substringFromIndex:suffixIndex],LS(@"PhoneNumberGestureLogin")];
            }
        }
        else if (([[ICKeyChainManager getPasswordForUsername:timesKey] integerValue] > 0) &&
                 ([[ICKeyChainManager getPasswordForUsername:timesKey] integerValue] < 5))
        {
            self.messageBG.hidden = NO;
            self.messageLabel.textColor = kGestureErrorColor;
            self.messageLabel.text = [NSString stringWithFormat:LS(@"UnlockFailedAndTimesAgain"), (5-[[ICKeyChainManager getPasswordForUsername:timesKey] integerValue])];
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockFailed:)])
            {
                [self.delegate gestureUnlockFailed:self];
            }
            
            [self removeFromSuperview];
        }
        
        self.forgetGLVLabel.hidden = NO;
        self.forgetGLButton.hidden = NO;
        self.changeUSVLabel.hidden = NO;
        self.changeUSButton.hidden = NO;
    }
}

- (void)doCancelButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockCancel:)])
    {
        [self.delegate gestureUnlockCancel:self];
    }
}

- (void)doPassStepButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockPassStep:)])
    {
        [self.delegate gestureUnlockPassStep:self];
    }
}

- (void)doForgetGLButtonClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:LS(@"ForgetGesturePasswordNeedReLogin")
                                                       delegate:self
                                              cancelButtonTitle:LS(@"Cancel")
                                              otherButtonTitles:LS(@"OK"), nil];
    [alertView show];
}

- (void)doChangeUserButtonClick:(id)sender
{
    BSLogoutRequest *request = [[BSLogoutRequest alloc] init];
    [request execute];
    
    [PersonalProfile deleteProfile];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockChangeAccount:)])
    {
        [self.delegate gestureUnlockChangeAccount:self];
    }
    
    [self removeFromSuperview];
}



#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *timesKey = GestureUnlockTimes([[PersonalProfile currentProfile].userID stringValue]);
        NSString *passwordKey = GestureUnlockPassword([PersonalProfile currentProfile].userID);
        [ICKeyChainManager deleteItemForUsername:timesKey];
        [ICKeyChainManager deleteItemForUsername:passwordKey];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockForgetGesture:)])
        {
            [self.delegate gestureUnlockForgetGesture:self];
        }
        
        [self removeFromSuperview];
    }
}



#pragma mark -
#pragma mark Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch)
    {
        for (UIImageView *imageView in self.dotArray)
        {
            CGPoint touchPoint = [touch locationInView:imageView];
            if ([imageView pointInside:touchPoint withEvent:nil])
            {
                self.lineStartPoint = imageView.center;
                self.drawFlag = YES;
                if (!self.selectedDots)
                {
                    self.selectedDots = [NSMutableArray arrayWithCapacity:9];
                }
                
                [self.selectedDots addObject:imageView];
                imageView.image = self.selectedImage;
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(touchBegin)])
    {
        [self.delegate touchBegin];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch)
    {
        if (!self.drawFlag)
        {
            for (UIImageView *imageView in self.dotArray)
            {
                CGPoint touchPoint = [touch locationInView:imageView];
                if ([imageView pointInside:touchPoint withEvent:nil])
                {
                    self.lineStartPoint = imageView.center;
                    self.drawFlag = YES;
                    if (!self.selectedDots)
                    {
                        self.selectedDots = [NSMutableArray arrayWithCapacity:9];
                    }
                    
                    [self.selectedDots addObject:imageView];
                    imageView.image = self.selectedImage;
                }
            }
        }
        else
        {
            self.lineEndPoint = [touch locationInView:self.imageView];
            for (UIImageView *imageView in self.dotArray)
            {
                CGPoint point = [touch locationInView:self];
                if (CGRectContainsPoint(imageView.frame, point))
                {
                    CGPoint pointInSubView = [touch locationInView:imageView];
                    CGFloat x = pointInSubView.x - kGLPointDiameter/2.0;
                    CGFloat y = pointInSubView.y - kGLPointDiameter/2.0;
                    if (x * x + y * y <= kGLPointDiameter/2.0 * kGLPointDiameter/2.0)
                    {
                        BOOL isContain = NO;
                        for (UIImageView *selectedImageView in self.selectedDots)
                        {
                            if (imageView == selectedImageView)
                            {
                                isContain = YES;
                                break;
                            }
                        }
                        
                        if (!isContain)
                        {
                            [self.selectedDots addObject:imageView];
                            imageView.image = self.selectedImage;
                        }
                    }
                }
            }
            
            self.imageView.image = [self drawUnlockLine];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.drawFlag = NO;
    self.imageView.image = nil;
    if (self.selectedDots.count == 0)
    {
        self.selectedDots = nil;
        [self resetGestureUnlock];
    }
    else
    {
        self.imageView.image = [self drawUnlockFinishLine];
        [self doGestureUnlock];
    }
    
    if ([self.delegate respondsToSelector:@selector(touchEnd)])
    {
        [self.delegate touchEnd];
    }
}


#pragma mark -
#pragma mark Required Methods

- (void)doGestureUnlock
{
    if (self.type == GestureUnlockType_AddPW_First || self.type == GestureUnlockType_SetPW_First)
    {
        // 设置密码最少为3位
        if (self.selectedDots.count < 3)
        {
            [self performSelector:@selector(doGestureUnlockPasswordTooShort) withObject:nil afterDelay:0.1];
        }
        else
        {
            [self performSelector:@selector(doGestureUnlockSecondStep) withObject:nil afterDelay:0.1];
        }
    }
    else if (self.type == GestureUnlockType_AddPW_Second || self.type == GestureUnlockType_SetPW_Second)
    {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.selectedDots.count; i++)
        {
            UIImageView *imageView = (UIImageView *)[self.selectedDots objectAtIndex:i];
            [mutableArray addObject:[NSNumber numberWithInteger:imageView.tag]];
        }
        
        if ([mutableArray isEqualToArray:self.checkArray])
        {
            NSData *passwordData = [NSKeyedArchiver archivedDataWithRootObject:mutableArray];
            NSString *passwordString = [passwordData base64Encoding];
            NSString *passwordKey = GestureUnlockPassword([PersonalProfile currentProfile].userID);
            if ([ICKeyChainManager storeUsername:passwordKey andPassword:passwordString])
            {
                [BSUserDefaultsManager sharedManager].rememberPassword = YES;
                [self performSelector:@selector(doGestureUnlockSuccess) withObject:nil afterDelay:0.1];
            }
            else
            {
                NSLog(@"保存钥匙串失败!!!");
                [BSUserDefaultsManager sharedManager].rememberPassword = YES;
                [self performSelector:@selector(doGestureUnlockSuccess) withObject:nil afterDelay:0.1];
            }
        }
        else
        {
            [self performSelector:@selector(doGestureUnlockFirstStep) withObject:nil afterDelay:0.1];
        }
    }
    else if (self.type == GestureUnlockType_Login)
    {
        NSString *passwordKey = GestureUnlockPassword([PersonalProfile currentProfile].userID);
        NSString *keychainString = [ICKeyChainManager getPasswordForUsername:passwordKey];
        NSMutableArray *gestureLockArray = [[NSMutableArray alloc] init];
        if (keychainString.length != 0)
        {
            NSData *keychainData = [[NSData alloc] initWithBase64Encoding:keychainString];
            gestureLockArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:keychainData];
        }
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.selectedDots.count; i++)
        {
            UIImageView *imageView = (UIImageView *)[self.selectedDots objectAtIndex:i];
            [mutableArray addObject:[NSNumber numberWithInteger:imageView.tag]];
        }
        
        if ([mutableArray isEqualToArray:gestureLockArray])
        {
            [self performSelector:@selector(doGestureUnlockSuccess) withObject:nil afterDelay:0.1];
        }
        else
        {
            [self performSelector:@selector(doGestureUnlockFailed) withObject:nil afterDelay:0.1];
        }
    }
}

- (void)doGestureUnlockPasswordTooShort
{
    self.imageView.image = [UIImage imageNamed:@""];
    self.selectedDots = nil;
    [self resetGestureUnlock];
    self.messageLabel.text = LS(@"GestureAtLeast3PleaseReEnter");
}

- (void)doGestureUnlockSecondStep
{
    for (NSInteger i = 0; i < self.selectedDots.count; i++)
    {
        UIImageView *imageView = (UIImageView *)[self.selectedDots objectAtIndex:i];
        NSInteger tag = imageView.tag;
        [self.checkArray addObject:[NSNumber numberWithInteger:tag]];
    }
    
    self.selectedDots = nil;
    self.imageView.image = nil;
    if (self.type == GestureUnlockType_AddPW_First)
    {
        self.type = GestureUnlockType_AddPW_Second;
    }
    else if (self.type == GestureUnlockType_SetPW_First)
    {
        self.type = GestureUnlockType_SetPW_Second;
    }
    
    [self resetGestureUnlock];
}

- (void)doGestureUnlockFirstStep
{
    self.selectedDots = nil;
    self.imageView.image = nil;
    [self.checkArray removeAllObjects];
    
    if (self.type == GestureUnlockType_AddPW_Second)
    {
        self.type = GestureUnlockType_AddPW_First;
    }
    else if (self.type == GestureUnlockType_SetPW_Second)
    {
        self.type = GestureUnlockType_SetPW_First;
    }
    
    [self resetGestureUnlock];
    self.messageLabel.text = LS(@"InconsistentWithPreviousInput");
}

- (void)doGestureUnlockSuccess
{
    NSString *timesKey = GestureUnlockTimes([[PersonalProfile currentProfile].userID stringValue]);
    [ICKeyChainManager storeUsername:timesKey andPassword:@"0"];
    
    if (self.type == GestureUnlockType_AddPW_Second)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockAddSuccess:)])
        {
            [self.delegate gestureUnlockAddSuccess:self];
        }
    }
    else if (self.type == GestureUnlockType_SetPW_Second)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockSetSuccess:)])
        {
            [self.delegate gestureUnlockSetSuccess:self];
        }
    }
    else if (self.type == GestureUnlockType_Login)
    {
        [self gestureUnlockDidInActive];
        if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockSuccess:)])
        {
            [self.delegate gestureUnlockSuccess:self];
        }
    }
}

- (void)doGestureUnlockFailed
{
    self.selectedDots = nil;
    self.imageView.image = nil;
    
    NSString *timesKey = GestureUnlockTimes([[PersonalProfile currentProfile].userID stringValue]);
    NSInteger timesValue = [[ICKeyChainManager getPasswordForUsername:timesKey] integerValue];
    timesValue ++;
    if (timesValue < kGestureUnlockMaxTime)
    {
        [self resetGestureUnlock];
        self.messageBG.hidden = NO;
        self.messageLabel.textColor = kGestureErrorColor;
        self.messageLabel.text = [NSString stringWithFormat:LS(@"UnlockFailedAndTimesAgain"), 5 - timesValue];
        [ICKeyChainManager storeUsername:timesKey andPassword:[NSString stringWithFormat:@"%d", timesValue]];
    }
    else if (timesValue >= kGestureUnlockMaxTime)
    {
        NSString *passwordKey = GestureUnlockPassword([PersonalProfile currentProfile].userID);
        [ICKeyChainManager deleteItemForUsername:timesKey];
        [ICKeyChainManager deleteItemForUsername:passwordKey];
        if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockFailed:)])
        {
            [self.delegate gestureUnlockFailed:self];
        }
        
        [self removeFromSuperview];
    }
}


#pragma mark -
#pragma mark - DrawGestureUnlockLine

- (UIImage *)drawUnlockLine
{
    UIImage *image = nil;
    CGFloat width = 8.0;
    CGSize size = self.imageView.frame.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width);
    CGContextSetShouldAntialias(context, TRUE);
    CGContextSetAllowsAntialiasing(context, TRUE);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, self.lineStartPoint.x, self.lineStartPoint.y);
    for (UIImageView *imageView in self.selectedDots)
    {
        CGPoint center = imageView.center;
        CGContextAddLineToPoint(context, center.x, center.y);
        CGContextMoveToPoint(context, center.x, center.y);
    }
    CGContextAddLineToPoint(context, self.lineEndPoint.x, self.lineEndPoint.y);
    CGContextStrokePath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)drawUnlockFinishLine
{
    UIImage *image = nil;
    CGFloat width = 8.0;
    CGSize size = self.imageView.frame.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    for (UIImageView *imageView in self.selectedDots)
    {
        imageView.image = self.selectedImage;
    }
    
    for (int i = 0; i < self.selectedDots.count - 1; i++)
    {
        UIImageView *startImageView = [self.selectedDots objectAtIndex:i];
        UIImageView *endImageView = [self.selectedDots objectAtIndex:i + 1];
        CGPoint startPoint = startImageView.center;
        CGPoint endPoint = endImageView.center;
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextMoveToPoint(context, endPoint.x, endPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    }
    CGContextStrokePath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)drawUnlockFailedLine
{
    UIImage *image = nil;
    self.messageBG.hidden = NO;
    CGFloat width = 8.0;
    CGSize size = self.imageView.frame.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    for (UIImageView *imageView in self.selectedDots)
    {
        imageView.image = nil;
    }
    
    for (int i = 0; i < self.selectedDots.count - 1; i++)
    {
        UIImageView *startImageView = [self.selectedDots objectAtIndex:i];
        UIImageView *endImageView = [self.selectedDots objectAtIndex:i + 1];
        CGPoint startPoint = startImageView.center;
        CGPoint endPoint = endImageView.center;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextMoveToPoint(context, endPoint.x, endPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    }
    CGContextStrokePath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
