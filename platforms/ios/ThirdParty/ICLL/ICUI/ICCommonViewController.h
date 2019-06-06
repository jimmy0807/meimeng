//
//  ICCommonViewController.h
//  CardBag
//
//  Created by jimmy on 13-9-23.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICCommonViewController : UIViewController<UITextFieldDelegate>

- (void)addSwipGesture;
- (void)forbidSwipGesture;


@property (nonatomic, assign) BOOL noKeyboardNotification;
@property (nonatomic, assign) BOOL hideKeyBoardWhenClickEmpty;


@end
