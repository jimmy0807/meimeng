//
//  StaffManagerViewController.h
//  Boss
//
//  Created by lining on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface StaffManagerViewController : ICCommonViewController
@property(nonatomic, strong) NSMutableDictionary *dataDict;
- (void)initData;
@end
