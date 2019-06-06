//
//  PadBookFloorView.m
//  Boss
//
//  Created by lining on 16/6/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadBookFloorView.h"

@interface PadBookFloorView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *floors;
@end

@implementation PadBookFloorView
- (instancetype) initWithFrame:(CGRect)frame floors:(NSArray *)floors
{
    self = [super init];
    if (self) {
        if (floors.count * 44 < frame.size.height) {
            frame.size.height = floors.count *44;
        }
        self.frame = frame;
        
        self.floors = floors;
        self.clipsToBounds = true;
        self.backgroundColor = COLOR(96, 211, 212,1);
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
    }
    
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.floors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = COLOR(96, 211, 212,1);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = 101;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
    }
    
    UILabel *titleLabel = [cell.contentView viewWithTag:101];
    CDRestaurantFloor *floor = [self.floors objectAtIndex:indexPath.row];
    titleLabel.text = floor.floorName;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedFloor:)]) {
        CDRestaurantFloor *floor = [self.floors objectAtIndex:indexPath.row];
        [self.delegate didSelectedFloor:floor];
    }
}

@end
