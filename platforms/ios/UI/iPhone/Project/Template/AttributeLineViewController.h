//
//  AttributeLineViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "AttributeCell.h"
#import "AttributeValueCell.h"

@interface AttributeLineViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, AttributeCellDelegate, AttributeValueCellDelegate>

- (id)initWithProjectTemplate:(CDProjectTemplate *)projectTemplate attributeLines:(NSMutableArray *)attributeLines;

@end
