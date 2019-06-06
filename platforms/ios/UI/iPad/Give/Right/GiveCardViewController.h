//
//  GiveCardViewController.h
//  Boss
//
//  Created by lining on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "GivePeople.h"

@interface GiveCardViewController : ICCommonViewController
@property (strong, nonatomic) GivePeople *givePeople;
@property (strong, nonatomic) CDCardTemplate *cardTemplate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sendBtnPressed:(UIButton *)sender;


@end
