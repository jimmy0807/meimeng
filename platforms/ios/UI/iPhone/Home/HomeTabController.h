//
//  HomeTabController.h
//  Boss
//
//  Created by jimmy on 15/5/21.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeView.h"
#import "BNScanCodeViewController.h"

@interface HomeTabController : UITabBarController <BNScanCodeDelegate, QRCodeViewDelegate>

@end
