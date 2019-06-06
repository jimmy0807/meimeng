//
//  MemberRecordDetailViewController.h
//  Boss
//
//  Created by lining on 16/4/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberRecordDetailViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *sectionArray; //  固定格式 [[{},{}],[{},{}],[{}]]
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *dataArray;
@end
