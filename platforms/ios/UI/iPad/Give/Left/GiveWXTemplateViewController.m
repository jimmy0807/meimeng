//
//  GiveWXTemplateViewController.m
//  Boss
//
//  Created by lining on 16/6/2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveWXTemplateViewController.h"
#import "FetchWXCardTemplateRequest.h"
#import "WXTemplateCell.h"
#import "CBMessageView.h"
#import "GivePopupSelectWXGiveType.h"
#import "UIView+Frame.h"

@interface GiveWXTemplateViewController ()<WXTemplateCellDelegate>
@property (nonatomic, strong) NSArray *WXTemplates;
@property (nonatomic, strong) NSMutableDictionary *expandDict;
@property (nonatomic, strong) NSMutableDictionary *selectedDict;
@property (nonatomic, strong) NSMutableArray *selectedTemplates;
@end

@implementation GiveWXTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.expandDict = [NSMutableDictionary dictionary];
    self.selectedDict = [NSMutableDictionary dictionary];
    self.selectedTemplates = [NSMutableArray array];
    
    [self registerNofitificationForMainThread:kBSFetchWXCardTemplateResponse];
    [self sendRequest];
    [self reloadData];
    
}

#pragma mark - send request
- (void)sendRequest
{
    FetchWXCardTemplateRequest *reqeust =[[FetchWXCardTemplateRequest alloc] init];
    [reqeust execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
        [self reloadData];
    }
}


#pragma mark - reload data
- (void)reloadData
{
    self.WXTemplates = [[BSCoreDataManager currentManager] fetchWXCardTemplatesList];
    
    
    for (CDWXCardTemplate *template in self.WXTemplates) {
        NSNumber *expand = [self.expandDict objectForKey:template.template_id];
        if (expand == nil) {
            [self.expandDict setObject:@0 forKey:template.template_id];
        }
        
        NSNumber *selected = [self.selectedDict objectForKey:template.template_id];
        if (selected == nil) {
            [self.selectedDict setObject:@0 forKey:template.template_id];
        }
    }
    [self.tableView reloadData];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.WXTemplates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXTemplateCell"];
    if (cell == nil) {
        cell = [WXTemplateCell createCell];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CDWXCardTemplate *template = [self.WXTemplates objectAtIndex:indexPath.row];
    cell.imgView.image = [UIImage imageNamed:@"give_wx_template_default.png"];
    cell.WXTemplate = template;
    cell.indexPath = indexPath;
//    cell.nameLabel.text = template.title;
//    cell.countLabel.text = [NSString stringWithFormat:@"总库存:%@张",template.quantity];
//    cell.currentCountLabel.text = [NSString stringWithFormat:@"现有库存:%@张",template.current_quantity];
    
    if ([[self.expandDict objectForKey:template.template_id] boolValue]) {
        cell.expandView.hidden = false;
    }
    else
    {
        cell.expandView.hidden = true;
    }
    
    if ([[self.selectedDict objectForKey:template.template_id] boolValue]) {
        cell.circleImgView.highlighted = true;
    }
    else
    {
        cell.circleImgView.highlighted = false;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDWXCardTemplate *template = [self.WXTemplates objectAtIndex:indexPath.row];
    if ([[self.expandDict objectForKey:template.template_id] boolValue]) {
        return 272;
    }
    else
    {
        return 200;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 75)];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = @"选择模板";
    return label;
    
}

#pragma mark - WXTemplateCellDelegate
- (void)didSelectedBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    CDWXCardTemplate *WXTemplate = [self.WXTemplates objectAtIndex:indexPath.row];
    if ([WXTemplate.current_quantity integerValue] == 0) {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"已无库存"];
        [messageView showInView:self.view];
        return;
    }
    
    BOOL selected = ![[self.selectedDict objectForKey:WXTemplate.template_id] boolValue];
    [self.selectedDict setObject:[NSNumber numberWithBool:selected] forKey:WXTemplate.template_id];
    if (selected) {
        [self.selectedTemplates addObject:WXTemplate];
    }
    else
    {
        [self.selectedTemplates removeObject:WXTemplate];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NSString *btnTitle;
    if (self.selectedTemplates.count > 0) {
        btnTitle = [NSString stringWithFormat:@"确认(%d)",self.selectedTemplates.count];
    }
    else
    {
        btnTitle = @"确认";
    }
    
    [self.sureBtn setTitle:[NSString stringWithFormat:btnTitle,self.selectedTemplates.count] forState:UIControlStateNormal];
}

- (void)didExpandBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    CDWXCardTemplate *WXTemplate = [self.WXTemplates objectAtIndex:indexPath.row];
    BOOL expand = ![[self.expandDict objectForKey:WXTemplate.template_id] boolValue];
    [self.expandDict setObject:[NSNumber numberWithBool:expand] forKey:WXTemplate.template_id];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didSureBtnPressedAtIndexPath:(NSIndexPath *)indexPath withCount:(NSInteger)count
{
    CDWXCardTemplate *WXTemplate = [self.WXTemplates objectAtIndex:indexPath.row];
    if([WXTemplate.quantity integerValue] == count) {
        NSLog(@"一样");
        [self.expandDict setObject:[NSNumber numberWithBool:false] forKey:WXTemplate.template_id];
    }
    else
    {
        [self.expandDict setObject:[NSNumber numberWithBool:false] forKey:WXTemplate.template_id];
        NSLog(@"发送请求");
    }
     [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



#pragma mark - button action

- (IBAction)sureBtnPressed:(id)sender {
    if (self.selectedTemplates.count == 0) {
        [[[CBMessageView alloc] initWithTitle:@"请选择送的想送的券"]showInView:self.view];
        return;
    }
    [GivePopupSelectWXGiveType showWithNavigationController:self.rootNavigationVC member:self.member wxCardTemplates:self.selectedTemplates];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
