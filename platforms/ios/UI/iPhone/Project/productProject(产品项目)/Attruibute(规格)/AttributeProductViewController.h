//
//  AttributeItemProductViewController.h
//  ds
//
//  Created by lining on 2016/11/8.
//
//

#import "ICCommonViewController.h"

@interface AttributeProductViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDProjectTemplate *projectTemplate;
@end
