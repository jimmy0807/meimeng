//
//  GivePopupInputPhoneNumber.h
//  Boss
//
//  Created by jimmy on 16/6/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadMaskView.h"

@interface GivePopupInputPhoneNumber : UIView

+ (instancetype)createView;

@property(nonatomic, weak)UINavigationController* outNavigationController;
@property(nonatomic, weak)CDMember* member;
@property(nonatomic, weak)NSArray* wxCardTemplates;
@property(nonatomic, weak)PadMaskView *maskView;

@end
