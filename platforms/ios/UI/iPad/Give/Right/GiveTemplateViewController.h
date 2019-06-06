//
//  GiveTemplateViewController.h
//  Boss
//
//  Created by lining on 16/4/15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "GivePeople.h"

typedef enum kTemplateType
{
    //('1', u'会员卡'), ('2', u'礼品券'), ('3', u'礼品卡')
    kTemplateType_coupon = 2,
    kTemplateType_card,
}kTemplateType;

@interface GiveTemplateViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) kTemplateType type;
@property (strong, nonatomic) GivePeople *givePeople;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)helpBtnPressed:(UIButton *)sender;

@end
