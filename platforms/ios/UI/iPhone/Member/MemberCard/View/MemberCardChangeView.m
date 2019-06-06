//
//  MemberCardChangeView.m
//  Boss
//
//  Created by lining on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardChangeView.h"
#import "MemberCardCell.h"

@implementation MemberCardChangeView

+ (instancetype)createView
{
    MemberCardChangeView *cardChangeView = [MemberCardChangeView loadFromNib];
    cardChangeView.backgroundColor = COLOR(0,0,0,0);
    cardChangeView.tableView.dataSource = cardChangeView;
    cardChangeView.tableView.delegate = cardChangeView;
    cardChangeView.bgBtn.backgroundColor = [UIColor blackColor];
    cardChangeView.bgBtn.alpha = 0.5;
    
    return cardChangeView;
}

- (IBAction)hideBtnPressed:(id)sender {
    [self hide];
}


#pragma mark - show & hide

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
//    [self performSelector:@selector(animation) withObject:nil afterDelay:0.1];
    [self layoutIfNeeded];
    [self animation];
}


- (void)animation
{
    [self removeConstraint:self.topConstraint];
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        self.bgBtn.alpha = 0.6;
        [self layoutIfNeeded];
    }];
}

- (void)hide
{
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(0);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        self.bgBtn.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MemberCardCell";
    MemberCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [MemberCardCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.arrowImgView.hidden = true;
    cell.valueLabel.hidden = true;
    
    cell.titleLabel.text = @"8折卡(1L2988988)";
    cell.detailLabel.text = @"可用余额￥2000.00";
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDMemberCard *card = [self.cards objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didChangedCard:)]) {
        [self.delegate didChangedCard:card];
    }
}

@end
