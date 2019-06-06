//
//  GiveTicketProjectViewController.h
//  Boss
//
//  Created by lining on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol TicketProjectSelectedDelegate <NSObject>
- (void)didSureSeletedItems:(NSArray *)items;
@end

@interface GiveTicketProjectViewController : ICCommonViewController

@property (strong, nonatomic) NSArray *existIds;
@property (strong, nonatomic) NSArray *itemArray;
@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (Weak, nonatomic) id<TicketProjectSelectedDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnPressed:(UIButton *)sender;
- (IBAction)sureBtnPressed:(id)sender;

@end
