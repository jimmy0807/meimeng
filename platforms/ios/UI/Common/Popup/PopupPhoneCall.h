//
//  PopupPhoneCall.h
//  Boss
//
//  Created by jimmy on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupPhoneCall : UIView

@property(nonatomic, weak)UINavigationController* navigationController;
@property(nonatomic, strong)NSString* phoneNumber;

+ (instancetype)show;
+ (instancetype)showWithNavigationController:(UINavigationController*)navigationController phoneNumber:(NSString*)phoneNumber;

@end
