//
//  PhoneGiveViewController.h
//  Boss
//
//  Created by lining on 16/9/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface PhoneGiveViewController : ICCommonViewController

@property (strong, nonatomic) CDMember *member;
@property (strong, nonatomic) CDPosOperate *operate;
@property (strong, nonatomic) NSNumber *operateID;
@property (assign, nonatomic) BOOL isFromSuccessView;
@property (assign, nonatomic) BOOL isFromMember;
@end
