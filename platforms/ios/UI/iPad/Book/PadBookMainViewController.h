//
//  PadBookMainViewController.h
//  Boss
//
//  Created by jimmy on 15/11/27.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface PadBookMainViewController : ICCommonViewController

@property(nonatomic)BOOL isCloseButton;
@property(nonatomic, strong)CDBook* focusBook;
@property(nonatomic, strong)NSString* bookPhoneNumber;
@property(nonatomic, strong)CDMember* bookMember;

@end
