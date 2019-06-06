//
//  PosAllocationPersonViewController.h
//  Boss
//
//  Created by lining on 15/11/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "AllotObject.h"
typedef enum PersonType
{
    PersonType_Sale,
    PersonType_Technician
}PersonType;

@protocol PosAlloctionPersonDelegate <NSObject>
@optional
- (void)didSureAllotObject:(AllotObject *)object type:(PersonType)type edit:(BOOL)isEdit;

@end

@interface PosAllocationPersonViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(id)sender;

@property (assign, nonatomic) PersonType type;
@property (strong, nonatomic) AllotObject *allotObject;
@property (strong, nonatomic) CDPosBaseProduct *product;
@property (strong, nonatomic) CDPosOperate *operate;
@property (Weak, nonatomic) id<PosAlloctionPersonDelegate>delegate;
@property (assign, nonatomic) NSInteger maxAssignCount;
@property (assign, nonatomic) CGFloat maxAssignMoney;
@property (assign, nonatomic) CGFloat commissionRadio;
@end
