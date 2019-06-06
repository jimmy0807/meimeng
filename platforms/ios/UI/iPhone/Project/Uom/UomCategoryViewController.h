//
//  UomCategoryViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface UomCategoryViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithProjectUomCategoryID:(NSNumber *)uomCategoryID;

@end
