//
//  BSSelectedView.m
//  Boss
//
//  Created by lining on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSSelectedView.h"
#import "FilterGuwenCell.h"

#define AnimationDuration 0.35

@interface BSSelectedView ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;

@end

@implementation BSSelectedView

+ (instancetype)createViewWithTitle:(NSString *)title
{
    BSSelectedView *selectedView = [self loadFromNib];
    selectedView.titleLabel.text = title;
    selectedView.hidden = true;
    [[UIApplication sharedApplication].keyWindow addSubview:selectedView];
    [selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    return selectedView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.bgBtn.backgroundColor = [UIColor blackColor];
    self.bgBtn.alpha = 0;
    [self removeConstraint:self.containerViewBottomConstraint];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(0);
    }];
}

- (void)setStringArray:(NSArray *)stringArray
{
    _stringArray = stringArray;
    [self.tableView reloadData];
}


#pragma mark - show & hide
- (void)show
{
    self.hidden = false;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
    }];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.bgBtn.alpha = 0.6;
        [self layoutIfNeeded];
    }];
}

- (void)hide
{
    self.hidden = false;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(0);
    }];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.bgBtn.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = true;
    }];
}

#pragma mark - btn action
- (IBAction)cancelBtnPressed:(id)sender {
    [self hide];
}
- (IBAction)bgBtnPressed:(id)sender {
    [self hide];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stringArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterGuwenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterGuwenCell"];
    if (cell == nil) {
        cell = [FilterGuwenCell createCell];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    
    if (self.currentSelectedIdx == indexPath.row) {
        cell.selectedImgView.hidden = false;
    }
    else
    {
        cell.selectedImgView.hidden = true;
    }
    cell.nameLabel.text = [self.stringArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.currentSelectedIdx == indexPath.row) {
        return;
    }
    else
    {
        self.currentSelectedIdx = indexPath.row;
    }
   
    [self.tableView reloadData];
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.1];
    if ([self.delegate respondsToSelector:@selector(didSelectedAtIndex:)]) {
        [self.delegate didSelectedAtIndex:indexPath.row];
    }
}




@end
