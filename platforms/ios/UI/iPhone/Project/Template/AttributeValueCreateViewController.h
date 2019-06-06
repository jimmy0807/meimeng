//
//  AttributeValueCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kAttributeValueType
{
    kAttributeValueCreate,
    kAttributeValueEdit
}kAttributeValueType;


@interface AttributeValueCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithAttribute:(CDProjectAttribute *)attribute attributeValue:(CDProjectAttributeValue *)attributeValue;

@end
