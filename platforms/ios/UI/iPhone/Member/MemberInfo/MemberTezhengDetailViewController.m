//
//  MemberTezhengDetailViewController.m
//  Boss
//
//  Created by lining on 16/4/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberTezhengDetailViewController.h"
#import "BSCommonSelectedItemViewController.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "BSUpdateMemberRequest.h"
#import "MemberAddTezhengViewController.h"

@interface MemberTezhengDetailViewController ()<BSCommonSelectedItemViewControllerDelegate,UITextViewDelegate>
{
    BNRightButtonItem *rightBtnItem;
}
@property (nonatomic, strong) CDMemberTeZheng *orignTezheng;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, assign) bool isChanged;

@end

@implementation MemberTezhengDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    rightBtnItem = [[BNRightButtonItem alloc]initWithTitle:@"完成"];
    rightBtnItem.delegate = self;
    
    self.describleTextview.delegate = self;
    
    if (self.tezheng) {
        self.type = kTezhengType_edit;
        self.navigationItem.title = self.tezheng.tz_name;
        [self orignTezheng:self.tezheng];
    }
    else
    {
        self.type = kTezhengType_create;
        self.navigationItem.title = @"新建特征";
        self.tezheng = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberTeZheng"];
    }
    
    if ([self.tezheng.tz_name length] > 0 && ![self.tezheng.tz_name isEqualToString:@"0"]) {
        self.nameFiled.text = self.tezheng.tz_name;
    }
    
    if ([self.tezheng.tz_describle length] > 0 && ![self.tezheng.tz_describle isEqualToString:@"0"]) {
        self.describleTextview.text = self.tezheng.tz_describle;
    }
    
    self.params = [NSMutableDictionary dictionary];
    
    [self registerNofitificationForMainThread:kBSUpdateMemberResponse];
}

- (void)orignTezheng:(CDMemberTeZheng *)tz
{
    if (!self.orignTezheng) {
        self.orignTezheng = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberTeZheng"];
    }
    self.orignTezheng.tz_name = self.tezheng.tz_name;
    self.orignTezheng.tz_describle = self.tezheng.tz_describle;
    
    [[BSCoreDataManager currentManager] save:nil];
}

- (void)setIsChanged:(bool)isChanged
{
    _isChanged = isChanged;
    if (self.params.allKeys.count > 0) {
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - CBBackButtonItemDelegate
- (void)didItemBackButtonPressed:(UIButton *)sender
{
    [self hideKeyboard:nil];
    [self rollback];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    [self hideKeyboard:nil];
    [self handleMemberRequest];
}


#pragma mark - request
- (void)handleMemberRequest
{
    if([self.tezheng.tz_name isEqualToString:@""]||self.tezheng.tz_name ==nil)
    {
        CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"名字不能为空" afterTimeHide:0.75];
        [message showInView:self.view];
        return;
    }
    
    [[CBLoadingView shareLoadingView] show];
    NSMutableArray *array = [NSMutableArray array];
    if (self.type == kTezhengType_edit) {
        NSArray *subArray = @[[NSNumber numberWithInt:kBSDataUpdate],self.tezheng.tz_id,self.params];
        [array addObject:subArray];
    }
    else if (self.type == kTezhengType_create)
    {
        NSArray *subArray = @[[NSNumber numberWithInt:kBSDataAdded],@0,self.params];
        [array addObject:subArray];
        
        
    }
    NSDictionary *dict = @{@"extended_ids":array};
    
    BSUpdateMemberRequest *updateRequest = [[BSUpdateMemberRequest alloc]initWithMember:self.member params:dict];
    [updateRequest execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSUpdateMemberResponse]) {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] == 0) {
            NSString *title;
            if (self.type == kTezhengType_edit) {
                title = @"修改成功";
            }
            else
            {
                title = @"添加成功";
            }
            CBMessageView *messgae = [[CBMessageView alloc]initWithTitle:title afterTimeHide:0.75];
            [messgae showInView:self.view];
            
            [self rollback];
            
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@1 afterDelay:1.5];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
}

#pragma mark - roll back

- (void)rollback
{
    [[BSCoreDataManager currentManager] rollback];
    [[BSCoreDataManager currentManager] deleteObject:self.orignTezheng];
    [[BSCoreDataManager currentManager] save:nil];
}



- (IBAction)selectedBtnPressed:(id)sender {
    BSCommonSelectedItemViewController *selectedVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
    selectedVC.hasAddButton = true;
    selectedVC.delegate = self;
    selectedVC.notificationName = kBSFetchExtendResponse;
    
    NSArray *extends = [[BSCoreDataManager currentManager] fetchExtends];
    
    selectedVC.userData = extends;
    selectedVC.dataArray = [NSMutableArray array];
    
    int currentIdx = -1;
    for (CDExtend *extend in extends) {
        [selectedVC.dataArray addObject:extend.extend_name];
        if ([self.tezheng.tz_name isEqualToString:extend.extend_name]) {
            currentIdx = [extends indexOfObject:extend];
        }
    }
    
    selectedVC.currentSelectIndex = currentIdx;
    [self.navigationController pushViewController:selectedVC animated:YES];
}


#pragma mark - BSCommonSelectedItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    NSArray *extends = userData;
    CDExtend *extend = [extends objectAtIndex:index];
    self.tezheng.extend = extend;
    self.tezheng.tz_name = extend.extend_name;
    self.nameFiled.text = self.tezheng.tz_name;
    if ([self.tezheng.tz_name isEqualToString:self.orignTezheng.tz_name])
    {
        [self.params removeObjectForKey:@"extended_id"];
    }
    else
    {
        [self.params setObject:self.tezheng.extend.extend_id forKey:@"extended_id"];
    }
    self.isChanged = true;
}

-(void)didAddButtonPressed:(id)userData
{
    MemberAddTezhengViewController *addTzVC = [[MemberAddTezhengViewController alloc] init];
    [self.navigationController pushViewController:addTzVC animated:YES];
}

-(void)willReloadViewController:(BSCommonSelectedItemViewController *)contoller
{
    NSArray *extends = [[BSCoreDataManager currentManager] fetchExtends];
    
    contoller.userData = extends;
    contoller.dataArray = [NSMutableArray array];
    for (CDExtend *extend in extends) {
        [contoller.dataArray addObject:extend.extend_name];
    }
    [contoller reloadData];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        return;
    }
    if (![self.tezheng.tz_describle isEqualToString:textView.text]) {
        self.tezheng.tz_describle = textView.text;
        if ([self.tezheng.tz_describle isEqualToString:self.orignTezheng.tz_describle])
        {
            [self.params removeObjectForKey:@"description"];
        }
        else
        {
            [self.params setObject:self.tezheng.tz_describle forKey:@"description"];
        }
        self.isChanged = true;
    }
    
}

#pragma mark - hideKeyboard
- (IBAction)hideKeyboard:(id)sender {
    [self.describleTextview resignFirstResponder];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
