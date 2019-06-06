//
//  EditShopCartViewController.h
//  Boss
//
//  Created by lining on 16/7/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface EditShopCartViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) CDPosProduct *product;
@property (nonatomic, strong) CDCurrentUseItem *useItem;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
