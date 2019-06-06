//
//  PosCategoryCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BSEditCell.h"

typedef enum kPosCategoryEditType
{
    kPosCategoryEdit,
    kPosCategoryCreate,
    kPosCategoryCreateParent,
    kPosCategoryCreateSub
}kPosCategoryEditType;


@interface PosCategoryCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithType:(kPosCategoryEditType)editType posCategory:(CDProjectCategory *)category;

@end
