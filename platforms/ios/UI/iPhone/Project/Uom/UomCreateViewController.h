//
//  UomCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kUomEditType
{
    kUomEdit,
    kUomCreate
}kUomEditType;


@interface UomCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithType:(kUomEditType)editType;
- (id)initWithUom:(CDProjectUom *)projectUom;

@end
