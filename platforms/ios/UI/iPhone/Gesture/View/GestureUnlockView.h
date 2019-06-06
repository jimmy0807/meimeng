//
//  GestureUnlockView.h
//  Boss
//
//  Created by XiaXianBing on 15/3/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLabel.h"

typedef enum GestureUnlockType
{
    GestureUnlockType_AddPW_First,
    GestureUnlockType_AddPW_Second,
    GestureUnlockType_SetPW_First,
    GestureUnlockType_SetPW_Second,
    GestureUnlockType_Login
    
}GestureUnlockType;

@class GestureUnlockView;
@protocol GestureUnlockViewDelegate <NSObject>
@optional
- (void)gestureUnlockSuccess:(GestureUnlockView *)gestureUnlockView;
- (void)gestureUnlockFailed:(GestureUnlockView *)gestureUnlockView;
- (void)gestureUnlockSetSuccess:(GestureUnlockView *)gestureUnlockView;
- (void)gestureUnlockAddSuccess:(GestureUnlockView *)gestureUnlockView;
// ButtonClick.
- (void)gestureUnlockCancel:(GestureUnlockView *)gestureUnlockView;
- (void)gestureUnlockPassStep:(GestureUnlockView *)gestureUnlockView;
- (void)gestureUnlockForgetGesture:(GestureUnlockView *)gestureUnlockView;
- (void)gestureUnlockChangeAccount:(GestureUnlockView *)gestureUnlockView;

//touchBegin
-(void)touchBegin;
-(void)touchEnd;
@end


@interface GestureUnlockView : UIView <UIAlertViewDelegate>

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *messageBG;
@property (nonatomic, strong) VLabel  *passStepVLabel;
@property (nonatomic, strong) VLabel  *forgetGLVLabel;
@property (nonatomic, strong) VLabel  *changeUSVLabel;
@property (nonatomic, strong) UIButton *passStepButton;
@property (nonatomic, strong) UIButton *forgetGLButton;
@property (nonatomic, strong) UIButton *changeUSButton;
@property (nonatomic, assign) GestureUnlockType type;
@property (nonatomic, assign) id<GestureUnlockViewDelegate> delegate;

- (id)initWithGestureUnlockType:(GestureUnlockType)unlockType;

- (void)gestureUnlockDidInActive;

@end
