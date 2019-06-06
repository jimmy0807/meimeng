//
//  UomCategoryCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kUomCategoryEditType
{
    kUomCategoryEdit,
    kUomCategoryCreate
}kUomCategoryEditType;


@interface UomCategoryCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithType:(kUomCategoryEditType)editType;
- (id)initWithUomCategory:(CDProjectUomCategory *)uomCategory;

@end
