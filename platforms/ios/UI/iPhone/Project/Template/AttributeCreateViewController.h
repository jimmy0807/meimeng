//
//  AttributeCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kAttributeType
{
    kAttributeCreate,
    kAttributeEdit
}kAttributeType;


@interface AttributeCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithAttribute:(CDProjectAttribute *)attribute;

@end
