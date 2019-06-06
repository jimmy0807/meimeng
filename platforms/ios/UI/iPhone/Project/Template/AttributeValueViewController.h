//
//  AttributeValueViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BSAttributeLine.h"


@interface AttributeValueViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

//- (id)initWithAttributeID:(NSNumber *)attributeId isAddedAttributeValues:(NSArray *)attributeValueIds;
- (id)initWithBSAttributeLine:(BSAttributeLine *)bsAttributeLine;

@end
