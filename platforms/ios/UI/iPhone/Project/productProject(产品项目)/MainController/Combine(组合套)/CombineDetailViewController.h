//
//  CombineDetailViewController.h
//  ds
//
//  Created by lining on 2016/11/14.
//
//

#import "ICCommonViewController.h"
#import "BSSubItem.h"

@interface CombineDetailViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BSSubItem *subItem;

@end
