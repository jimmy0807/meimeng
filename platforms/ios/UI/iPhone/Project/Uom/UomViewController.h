//
//  UomViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface UomViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithProjectUomID:(NSNumber *)uomID;

@end
