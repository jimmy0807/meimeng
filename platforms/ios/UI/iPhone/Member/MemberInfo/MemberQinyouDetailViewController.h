//
//  MemberQinyouDetailViewController.h
//  Boss
//
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum QinyouType
{
    QinyouType_create,
    QinyouType_edit
}QinyouType;

@protocol MemberQinyouDetialVCDelegate <NSObject>
- (void)didEditParams:(NSDictionary *)params;
- (void)didAddQinyou:(CDMemberQinyou *)qinyou;
@end

@interface MemberQinyouDetailViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CDMemberQinyou *qinyou;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, assign) QinyouType type;
@end
