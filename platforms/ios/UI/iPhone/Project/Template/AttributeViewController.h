//
//  AttributeViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@class AttributeViewController;

@interface AttributeViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithAttributeIDs:(NSArray *)attributeIds;

@end
