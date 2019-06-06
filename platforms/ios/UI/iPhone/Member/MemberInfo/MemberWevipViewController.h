//
//  MemberWevipViewController.h
//  Boss
//
//  Created by lining on 16/4/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberWevipViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) CDStore *store;
@end
