//
//  ConsumableCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/11.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BSSwitchCell.h"

typedef enum kConsumableEditType
{
    kConsumableEdit,
    kConsumableCreate
}kConsumableEditType;


@interface ConsumableCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, BSSwitchCellDelegate>

- (id)initWithConsumables:(NSMutableArray *)consumables;
- (id)initWithConsumables:(NSMutableArray *)consumables editIndex:(NSInteger)editIndex;

@end
