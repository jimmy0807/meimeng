//
//  BSOptionViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface BSOptionViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithTitle:(NSString *)title options:(NSArray *)options selectedstr:(NSString *)selectedstr notification:(NSString *)notification;

@end
