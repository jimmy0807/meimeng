//
//  FilterMonthDataSource.m
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FilterMonthDataSource.h"
#import "FilterMonthCell.h"

@interface FilterMonthDataSource ()<FilterMonthCellDelegate>
@property (nonatomic, strong) NSArray *months;

@end

@implementation FilterMonthDataSource


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.months = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    }
    return self;
}

- (CGFloat)getHeight
{
    return 50 * ceilf(self.months.count/4.0);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceilf(self.months.count/4.0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterMonthCell *monthCell = [tableView dequeueReusableCellWithIdentifier:@"FilterMonthCell"];
    if (monthCell == nil) {
        monthCell = [FilterMonthCell createCell];
        monthCell.backgroundColor = [UIColor clearColor];
        monthCell.selectionStyle = UITableViewCellSelectionStyleNone;
        monthCell.delegate = self;
    }
    
    NSInteger row = indexPath.row;
    NSInteger startIdx = row * 4;
   
    for (int i = 0; i < 4; i++) {
        NSInteger idx = startIdx + i;
        BOOL selected = false;
        if (idx < self.months.count) {
            NSString *month = self.months[idx];
            if ([month isEqualToString:self.currentMonth]) {
                selected = true;
            }
            [monthCell setBtnTitle:[NSString stringWithFormat:@"%@月",month] atIndex:idx selected:selected];
        }
        else
        {
            [monthCell setBtnTitle:nil atIndex:idx selected:selected];
        }
    }
    
    
    return monthCell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - FilterMonthCellDelegate
- (void)didSelectedBtnAtIndex:(NSInteger)index
{
    NSLog(@"index: %d",index);
    NSString *month = self.months[index];
    if ([month isEqualToString:self.currentMonth]) {
        return;
    }
    self.currentMonth = month;
    if ([self.delegate respondsToSelector:@selector(didSelectedMonth:)]) {
        [self.delegate didSelectedMonth:month];
    }
    
    
}

@end
