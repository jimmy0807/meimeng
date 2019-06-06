//
//  PadGiveViewController.h
//  Boss
//
//  Created by lining on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "GivePeople.h"
@interface PadGiveViewController : ICCommonViewController
@property (strong, nonatomic) CDPosOperate *opereate;
@property (strong, nonatomic) NSNumber *operateID;
@property (strong, nonatomic) CDMember *member;

@end
