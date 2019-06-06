//
//  PosCategoryViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kPosCategoryType
{
    kPosCategoryDefault,
    kPosCategoryJustParent
}kPosCategoryType;

@interface PosCategoryViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithPosCategoryType:(kPosCategoryType)type posCategory:(CDProjectCategory *)posCategory;

@end
