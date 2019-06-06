//
//  SubItemCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/11.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BSSwitchCell.h"

typedef enum kSubItemEditType
{
    kSubItemEdit,
    kSubItemCreate
}kSubItemEditType;


@interface SubItemCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, BSSwitchCellDelegate>

- (id)initWithSubItems:(NSMutableArray *)subItems projectType:(kPadBornCategoryType)projectType;
- (id)initWithSubItems:(NSMutableArray *)subItems editIndex:(NSInteger)editIndex projectType:(kPadBornCategoryType)projectType;

@end
