//
//  PosOperateAssignDetailViewController.h
//  Boss
//
//  Created by lining on 16/9/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "AllotObject.h"

typedef enum PeopleType
{
    PeopleType_Sale,
    PeopleType_Technician
}PeopleType;

@protocol PosOperateAssignDetailVCDelegate <NSObject>
@optional
- (void)didSureAllotObject:(AllotObject *)object type:(PeopleType)type edit:(BOOL)isEdit;

@end

@interface PosOperateAssignDetailViewController : ICCommonViewController<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) CGFloat maxAssignMoney;
@property (assign, nonatomic) NSInteger maxAssignCount;
@property (assign, nonatomic) CGFloat commissionRadio;
@property (strong, nonatomic) CDPosOperate *operate;
@property (strong, nonatomic) CDPosBaseProduct *product;
@property (strong, nonatomic) AllotObject *allotObject;
@property (assign, nonatomic) PeopleType peopleType;
@property (weak, nonatomic) id<PosOperateAssignDetailVCDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
