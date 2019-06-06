//
//  MemberFilterView.m
//  Boss
//
//  Created by lining on 16/5/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFilterView.h"
#import "FilterMonthDataSource.h"
#import "FilterGuwenDataSource.h"
#import "FilterEditTextDataSource.h"
#import "BSMemberFilterRequest.h"
#import "CBMessageView.h"

@interface MemberFilterView ()<FilterMonthDataSourceDelegate,FilterGuwenDataSoruceDelegate,FilterEditTextDataSourceDelegate>
{
    FilterItemView *currentItemView;
    
    CGFloat maxFilterHeight;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UITableView *filterTableView;
@property (nonatomic, strong) NSMutableDictionary *dataSourceDict;
@property (nonatomic, strong) UIView *bgTableView;
@property (nonatomic, strong) NSMutableDictionary *filterParams;

@end
@implementation MemberFilterView

- (instancetype)initWithStore:(CDStore *)store
{
    self = [super init];
    if (self) {
        
        maxFilterHeight = IC_SCREEN_HEIGHT * 0.5;
        
        self.backgroundColor = COLOR(245, 245, 245, 1);
        self.tableView = [[UITableView alloc] init];
        self.filterView = [[FilterView alloc] init];
        self.filterView.delegate = self;
        self.bgView = [[UIView alloc] init];
        
        [self addSubview:self.tableView];
        [self addSubview:self.bgView];
        [self addSubview:self.filterView];
        
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.equalTo(self.filterView.mas_width).multipliedBy(1/8.0);
        }];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.filterView.mas_bottom);
            make.bottom.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
        }];
        
        
        self.bgView.hidden = true;
        self.bgView.backgroundColor = COLOR(0, 0, 0, 0);
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.filterView.mas_bottom);
            make.bottom.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
        }];
        
        self.bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bgBtn.backgroundColor = COLOR(0, 0, 0, 1);
        self.bgBtn.alpha = 0.0;
        [self.bgView addSubview:self.bgBtn];
        [self.bgBtn addTarget:self action:@selector(hideFilter:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
        
        
        self.bgTableView = [[UIView alloc] init];
        self.bgTableView.backgroundColor = [UIColor whiteColor];
        [self.bgView addSubview:self.bgTableView];
        self.bgTableView.clipsToBounds = true;
        [self.bgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.equalTo(@0);
        }];
        
        self.filterTableView = [[UITableView alloc] init];
        //        self.filterTableView.dataSource = [self.dataSourceDict objectForKey:FilterTypeGuwen];
        //        self.filterTableView.delegate = [self.dataSourceDict objectForKey:FilterTypeGuwen];
        self.filterTableView.bounces = false;
        self.filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.filterTableView.hidden = false;
        self.filterTableView.backgroundColor = [UIColor clearColor];
        [self.bgTableView addSubview:self.filterTableView];
        [self.filterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.equalTo(@(maxFilterHeight));
        }];
        
        
        [self initDataSource];
        
        
        self.filterParams = [NSMutableDictionary dictionary];
        [self registerNofitificationForMainThread:kBSFilterMemberResponse];
        
    }
    
    return self;

}


- (void)initDataSource
{
    self.dataSourceDict = [NSMutableDictionary dictionary];
    for (NSString *title in self.filterView.filterTitles) {
        if ([title isEqualToString:FilterTypeBirthday]) {
         
            FilterMonthDataSource *dataSource = [[FilterMonthDataSource alloc] init];
            dataSource.delegate = self;
            [self.dataSourceDict setObject:dataSource forKey:title];
            
        }
        else if ([title isEqualToString:FilterTypeGuwen])
        {
            FilterGuwenDataSource *dataSource = [[FilterGuwenDataSource alloc] initWithStore:self.store];
//            dataSource.store = self.store;
            dataSource.delegate = self;
            [self.dataSourceDict setObject:dataSource forKey:title];
        }
        else
        {
            FilterEditTextDataSource *dataSource = [[FilterEditTextDataSource alloc] init];
            dataSource.delegate = self;
            dataSource.type = title;
            [self.dataSourceDict setObject:dataSource forKey:title];
        }
    }
}


- (void)hideFilter:(UIButton *)btn
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self animationToHeight:@0];
    currentItemView.normalBtn.selected = false;
}

#pragma mark - send request
- (void)sendFilterRequest
{
    if (self.filterParams.allKeys.count == 0 ) {
        if ([self.delegate respondsToSelector:@selector(notSendRequestWhenFilterIsNull)]) {
            if ([self.delegate notSendRequestWhenFilterIsNull]) {
                return;
            }
        }
    }
    
    if (self.store) {
        self.filterParams[@"shop_id"] = self.store.storeID;
    }
    BSMemberFilterRequest *filterRequest = [[BSMemberFilterRequest alloc] initWithParams:self.filterParams];
    [filterRequest execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFilterMemberResponse]) {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            self.filterMembers = notification.object;
            if ([self.delegate respondsToSelector:@selector(didFilterMembers:)]) {
                [self.delegate didFilterMembers:self.filterMembers];
            }
        }
    }
}

#pragma mark - FilterViewDelegate
- (void)didFilterItemViewPressed:(FilterItemView *)itemView
{
    
    if (![currentItemView.tagString isEqualToString:itemView.tagString]) {
        currentItemView.normalBtn.selected = false;
        itemView.normalBtn.selected = true;
        currentItemView = itemView;
    }
    self.bgView.hidden = false;
    
   
    FilterBaseDataSource *dataSource = [self.dataSourceDict objectForKey:currentItemView.tagString];
    if (currentItemView.normalBtn.selected) {
        
        if ([currentItemView.tagString isEqualToString:FilterTypeBirthday]) {
            FilterMonthDataSource *source = (FilterMonthDataSource *)dataSource;
            self.filterTableView.dataSource = source;
            self.filterTableView.delegate = source;
        }
        else if ([currentItemView.tagString isEqualToString:FilterTypeGuwen])
        {
            FilterGuwenDataSource *source = (FilterGuwenDataSource *)dataSource;
            self.filterTableView.dataSource = source;
            self.filterTableView.delegate = source;
        }
        else
        {
            FilterEditTextDataSource *source = (FilterEditTextDataSource *)dataSource;
            source.tableView = self.filterTableView;
        }
        [self.filterTableView reloadData];
        
        CGFloat height = [dataSource getHeight];
        if (height >= maxFilterHeight) {
            height = maxFilterHeight;
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/30.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self animationToHeight:@(height)];
        });
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/30.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self animationToHeight:@(0)];
        });
    }
}

- (void)didCancelFilterItemSelected:(FilterItemView *)itemView
{
    if ([itemView.tagString isEqualToString:FilterTypeBirthday]) {
        FilterMonthDataSource *dataSource = [self.dataSourceDict objectForKey:itemView.tagString];
        dataSource.currentMonth = nil;
        
        [self.filterParams removeObjectForKey:@"birthday_month"];
        [self sendFilterRequest];
    }
    
    else if ([itemView.tagString isEqualToString:FilterTypeGuwen])
    {
        FilterGuwenDataSource *dataSource = [self.dataSourceDict objectForKey:itemView.tagString];
        dataSource.currentStaff = nil;
        [self.filterParams removeObjectForKey:@"employee_id"];
        [self sendFilterRequest];
    }
    else
    {
        FilterEditTextDataSource *dataSource = [self.dataSourceDict objectForKey:itemView.tagString];
        dataSource.minValue = nil;
        dataSource.maxValue = nil;
        
        if ([dataSource.type isEqualToString:FilterTypeShopCount]) {
            [self.filterParams removeObjectForKey:@"un_consume_day"];
            [self.filterParams removeObjectForKey:@"consume_day"];
        }
        else if ([dataSource.type isEqualToString:FilterTypeHuoyue])
        {
            [self.filterParams removeObjectForKey:@"is_active_member"];
            [self.filterParams removeObjectForKey:@"active_member_threshold"];
        }
        else if ([dataSource.type isEqualToString:FilterTypeYue])
        {
            [self.filterParams removeObjectForKey:@"min_amount"];
            [self.filterParams removeObjectForKey:@"max_amount"];
        }
        else if ([dataSource.type isEqualToString:FilterTypeChongzhi])
        {
            [self.filterParams removeObjectForKey:@"min_recharge_amount"];
            [self.filterParams removeObjectForKey:@"max_recharge_amount"];
        }
        else if ([dataSource.type isEqualToString:FilterTypeConsume])
        {
            //        [self.filterParams setObject:dataSource.minValue forKey:@"min_recharge_amount"];
            //        [self.filterParams setObject:dataSource.maxValue forKey:@"max_recharge_amount"];
        }
        else if ([dataSource.type isEqualToString:FilterTypeZhuce])
        {
            [self.filterParams removeObjectForKey:@"min_register_day"];
            [self.filterParams removeObjectForKey:@"max_register_day"];
        }

        [self sendFilterRequest];
    }

}

- (void)animationToHeight:(NSNumber *)height
{
    [UIView animateWithDuration:(0.25) animations:^{
        if (height.integerValue == 0) {
            self.bgBtn.alpha = 0;
        }
        else
        {
            self.bgBtn.alpha = 0.1;
        }
        [self.bgTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.equalTo(height);
        }];
        [self.bgView layoutIfNeeded];
    }completion:^(BOOL finished) {
        //        self.filterTableView.hidden = false;
        if ([height integerValue]== 0) {
            self.bgView.hidden = true;
        }
    }];

}

#pragma mark - DataSourceDelegate

#pragma mark - FilterMonthDataSourceDelegate
- (void)didSelectedMonth:(NSString *)month
{
    [self.filterTableView reloadData];
    [self hideFilter:nil];
    
    currentItemView.normalBtn.hidden = true;
    currentItemView.selectedBtn.hidden = false;
    [currentItemView.selectedBtn setTitle:[NSString stringWithFormat:@"%@月",month] forState:UIControlStateNormal];
    
    [self.filterParams setObject:month forKey:@"birthday_month"];
    [self sendFilterRequest];
}

#pragma mark - FilterGuwenDataSoruceDelegate
- (void)didSelectedGuwen:(CDStaff *)staff
{
    [self.filterTableView reloadData];
    [self hideFilter:nil];
    currentItemView.normalBtn.hidden = true;
    currentItemView.selectedBtn.hidden = false;
    [currentItemView.selectedBtn setTitle:staff.name forState:UIControlStateNormal];
    
    [self.filterParams setObject:staff.staffID forKey:@"employee_id"];
    [self sendFilterRequest];
}

#pragma mark - FilterEditTextDataSourceDelegate
- (void)didFilterSureBtnPressed:(FilterEditTextDataSource *)dataSource
{
    if (dataSource.minValue == nil && dataSource.maxValue == nil) {
        [[[CBMessageView alloc] initWithTitle:@"请填写筛选条件"] show];
        return;
    }
    if ([dataSource.type isEqualToString:FilterTypeShopCount]) {
        
        if (dataSource.minValue && dataSource.maxValue) {
            [[[CBMessageView alloc] initWithTitle:@"到店数只能填写其中一个"] show];
            return;
        }
        else
        {
            if (dataSource.minValue) {
                [self.filterParams setObject:[NSNumber numberWithFloat:dataSource.minValue.floatValue] forKey:@"un_consume_day"];
            }
            else
            {
                [self.filterParams setObject:[NSNumber numberWithFloat:dataSource.maxValue.floatValue] forKey:@"consume_day"];
            }
        }
    }
    else if ([dataSource.type isEqualToString:FilterTypeHuoyue])
    {
        [self.filterParams setObject:[NSNumber numberWithBool:YES] forKey:@"is_active_member"];
        [self.filterParams setObject:[NSNumber numberWithFloat:dataSource.minValue.floatValue] forKey:@"active_member_threshold"];
    }
    else if ([dataSource.type isEqualToString:FilterTypeYue])
    {
        if (dataSource.minValue && dataSource.maxValue) {
            if (dataSource.minValue.floatValue - dataSource.maxValue.floatValue >= 0.01) {
                [[[CBMessageView alloc] initWithTitle:@"最小值应该小于最大值"] show];
                return;
            }
        }
        if (dataSource.minValue) {
            [self.filterParams setObject:[NSNumber numberWithFloat:dataSource.minValue.floatValue] forKey:@"min_amount"];
        }
        if (dataSource.maxValue) {
            [self.filterParams setObject:[NSNumber numberWithFloat:dataSource.maxValue.floatValue] forKey:@"max_amount"];
        }
    }
    else if ([dataSource.type isEqualToString:FilterTypeChongzhi])
    {
        if (dataSource.minValue && dataSource.maxValue) {
            if (dataSource.minValue.floatValue - dataSource.maxValue.floatValue >= 0.01) {
                [[[CBMessageView alloc] initWithTitle:@"最小值应该小于最大值"] show];
                return;
            }
        }
        if (dataSource.minValue) {
            [self.filterParams setObject:[NSNumber numberWithFloat:dataSource.minValue.floatValue] forKey:@"min_recharge_amount"];
        }
        if (dataSource.maxValue) {
            [self.filterParams setObject:[NSNumber numberWithFloat:dataSource.maxValue.floatValue] forKey:@"max_recharge_amount"];
        }
    }
    else if ([dataSource.type isEqualToString:FilterTypeConsume])
    {
//        [self.filterParams setObject:dataSource.minValue forKey:@"min_recharge_amount"];
//        [self.filterParams setObject:dataSource.maxValue forKey:@"max_recharge_amount"];
    }
    else if ([dataSource.type isEqualToString:FilterTypeZhuce])
    {
        if (dataSource.minValue && dataSource.maxValue) {
            if ([dataSource.minValue compare:dataSource.maxValue] == NSOrderedDescending) {
                [[[CBMessageView alloc] initWithTitle:@"起始时间应该小于结束时间"] show];
                return;
            }
        }
        if (dataSource.minValue) {
            [self.filterParams setObject:dataSource.minValue forKey:@"min_register_day"];
        }
        if (dataSource.maxValue) {
            [self.filterParams setObject:dataSource.maxValue forKey:@"max_register_day"];
        }
    }
    currentItemView.normalBtn.hidden = true;
    currentItemView.selectedBtn.hidden = false;
    [self hideFilter:nil];
    [currentItemView.selectedBtn setTitle:dataSource.type forState:UIControlStateNormal];
    [self sendFilterRequest];
}

- (void)didFilterCancelBtnPressed:(FilterEditTextDataSource *)dataSource
{
    [self hideFilter:nil];
}


#pragma mark - initDatePicker
- (void)initDatePicker
{
    
}
@end
