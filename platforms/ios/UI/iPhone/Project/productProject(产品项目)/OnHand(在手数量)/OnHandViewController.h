//
//  OnHandViewController.h
//  ds
//
//  Created by lining on 2016/11/16.
//
//

#import "ICCommonViewController.h"

@interface OnHandViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDProjectItem *projectItem;
@property (strong, nonatomic) CDProjectTemplate *projectTemplate;
@end
