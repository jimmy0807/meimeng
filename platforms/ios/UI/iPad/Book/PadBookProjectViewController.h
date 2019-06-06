//
//  PadBookProjectViewController.h
//  Boss
//
//  Created by lining on 15/12/16.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol PadBookProjectDelegate <NSObject>
@optional
- (void) didSelectedProjectItem:(CDProjectItem *)projectItem;

@end

@interface PadBookProjectViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (Weak, nonatomic) id<PadBookProjectDelegate>delegate;

- (IBAction)backBtnPressed:(id)sender;

@end
