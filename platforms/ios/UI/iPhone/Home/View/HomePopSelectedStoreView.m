//
//  HomePopSelectedStoreView.m
//  Boss
//
//  Created by lining on 16/8/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "HomePopSelectedStoreView.h"
#import "FilterGuwenCell.h"

@interface HomePopSelectedStoreView ()
@property (strong, nonatomic) NSArray *storeList;
@property (strong, nonatomic) IBOutlet UIImageView *tableViewBg;
@end

@implementation HomePopSelectedStoreView

+ (instancetype)createView
{
    HomePopSelectedStoreView *storeView = [self loadFromNib];

    [storeView initView];
    return storeView;
}


- (void)initView
{
    self.selectedIdx = -1;
    self.backgroundColor = [UIColor clearColor];
    
    self.hidden = true;
    self.bgBtn.alpha = 0.0;
    self.tableView.alpha = 0.0;
    self.tableViewBg.alpha = 0.0;
    
    self.tableView.layer.cornerRadius = 2;
    self.tableView.layer.masksToBounds = true;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self reloadData];
}

- (void)reloadData
{
    self.storeList = [[BSCoreDataManager currentManager] fetchItems:@"CDStore" sortedByKey:@"storeID" ascending:YES];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterGuwenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterGuwenCell"];
    if (cell == nil) {
        cell = [FilterGuwenCell createCell];
        cell.backgroundColor = [UIColor clearColor];
    }

    
    CDStore *store = [self.storeList objectAtIndex:indexPath.row];
    if (indexPath.row == self.selectedIdx) {
        cell.nameLabel.textColor = COLOR(0, 165, 254, 1);
        cell.selectedImgView.hidden = false;
    }
    else
    {
        cell.nameLabel.textColor = [UIColor grayColor];
        cell.selectedImgView.hidden = true;
    }
    cell.nameLabel.text = store.storeName;
    
    return cell;
}


- (void)setSelectedIdx:(NSInteger)selectedIdx
{
    _selectedIdx = selectedIdx;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == self.selectedIdx) {
        return;
    }
    self.selectedIdx = indexPath.row;

    CDStore *store = [self.storeList objectAtIndex:indexPath.row];

    if ([self.delegate respondsToSelector:@selector(didSelectedStore:)]) {
        [self.delegate didSelectedStore:store];
    }
    [self hide];
    
    
}

#pragma mark - show & hide
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    [self reloadData];
    
    self.hidden = false;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgBtn.alpha = 0.6;
        self.tableView.alpha = 1;
        self.tableViewBg.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgBtn.alpha = 0;
        self.tableView.alpha = 0;
        self.tableViewBg.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = true;
        [self removeFromSuperview];
    }];
}


- (IBAction)bgBtnPressed:(id)sender {
    [self hide];
    if ([self.delegate respondsToSelector:@selector(didSelectedStore:)]) {
        [self.delegate didSelectedStore:nil];
    }
}

@end
