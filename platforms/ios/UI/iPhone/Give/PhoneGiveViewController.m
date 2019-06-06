//
//  PhoneGiveViewController.m
//  Boss
//
//  Created by lining on 16/9/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PhoneGiveViewController.h"
#import "GiveWeikaDataSource.h"
#import "GiveWeixinDataSource.h"
#import "BSFetchCardTemplateRequest.h"
#import "GiveWeikaCardViewController.h"
#import "GiveWeikaCouponViewController.h"
#import "GivePeople.h"
#import "FetchWXCardTemplateRequest.h"
#import "GiveWeixinViewController.h"
#import "CBLoadingView.h"
#import "BSFetchPosOperateRequest.h"
#import "CBMessageView.h"
#import "GiveHelpView.h"

typedef enum SelectedType
{
    SelectedType_weika,
    SelectedType_weixin
}SelectedType;

@interface PhoneGiveViewController ()<GiveWeikaDataSourceDelegate,GiveWeixinDataSourceDelegate>
@property (strong, nonatomic) IBOutlet UILabel *weikaLabel;
@property (strong, nonatomic) IBOutlet UILabel *weixinLabel;
@property (strong, nonatomic) IBOutlet UIImageView *weikaLine;
@property (strong, nonatomic) IBOutlet UIImageView *weixinLine;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GiveHelpView *helpView;

@property (nonatomic, assign) SelectedType selectedType;
@property (nonatomic, strong) GiveWeikaDataSource *weikaDataSource;
@property (nonatomic, strong) GiveWeixinDataSource *weixinDataSource;
@property (strong, nonatomic) GivePeople *givePeople;
@end

@implementation PhoneGiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    BNRightButtonItem *rightItem = [[BNRightButtonItem alloc] initWithTitle:@"提示"];
    rightItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.helpView = [GiveHelpView createView];
    
    [self initDataSource];
    self.selectedType = SelectedType_weika;
    
    self.title = @"赠送卡券";
    
    [self registerNofitificationForMainThread:kBSFetchCardTemplateResponse];
    [self registerNofitificationForMainThread:kBSFetchWXCardTemplateResponse];
    
    
    [self sendReqeust];
    
    if (self.operateID)
    {
        [self registerNofitificationForMainThread:kFetchPosCardOperateResponse];
        BSFetchPosOperateRequest *reqeust = [[BSFetchPosOperateRequest alloc] init];
        reqeust.operateID = self.operateID;
        [reqeust execute];
        [[CBLoadingView shareLoadingView] show];
    }

}


- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    self.givePeople = [[GivePeople alloc] init];
    self.givePeople.member_id = operate.member_id;
    self.givePeople.member_name = operate.member_name;
    self.givePeople.shop_id = operate.operate_shop_id;
    self.givePeople.mobile = operate.member_mobile;
    self.givePeople.operate = operate;
    
}

- (void)setMember:(CDMember *)member
{
    _member = member;
    self.givePeople = [[GivePeople alloc] init];
    self.givePeople.member_id = member.memberID;
    self.givePeople.member_name = member.memberName;
    self.givePeople.shop_id = member.storeID;
    self.givePeople.mobile = member.mobile;
    self.givePeople.member = member;
    
}


#pragma mark - initData
- (void)initDataSource
{
    self.weikaDataSource = [[GiveWeikaDataSource alloc] init];
    self.weixinDataSource = [[GiveWeixinDataSource alloc] init];
    
    self.weikaDataSource.delegate = self;
    self.weixinDataSource.delegate = self;
}

- (void)setSelectedType:(SelectedType)selectedType
{
    _selectedType = selectedType;
    if (selectedType == SelectedType_weika) {
        self.weikaLine.hidden = false;
        self.weikaLabel.textColor = COLOR(0, 148, 228,1);
        self.weixinLine.hidden = true;
        self.weixinLabel.textColor = COLOR(72, 72, 72, 1);
        
        self.tableView.dataSource = self.weikaDataSource;
        self.tableView.delegate = self.weikaDataSource;
        
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 5)];
        
        self.tableView.tableHeaderView = headView;
        
        [self reloadData];
    }
    else
    {
        self.weikaLine.hidden = true;
        self.weikaLabel.textColor = COLOR(72, 72, 72, 1);
        self.weixinLine.hidden = false;
        self.weixinLabel.textColor = COLOR(0, 148, 228,1);
        
        self.tableView.dataSource = self.weixinDataSource;
        self.tableView.delegate = self.weixinDataSource;
        [self reloadData];
    }
}

- (void)reloadData
{
    if (self.selectedType == SelectedType_weika) {
        [self.weikaDataSource reloadData];
        [self.tableView reloadData];
    }
    else
    {
        [self.weixinDataSource reloadData];
        [self.tableView reloadData];
    }
}

#pragma mark - CBBackButtonItemDelegate
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    if (self.isFromSuccessView) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - rightBarButtonDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    [self.helpView show];
}


#pragma mark - send request
- (void)sendReqeust
{
    BSFetchCardTemplateRequest *templateRequest = [[BSFetchCardTemplateRequest alloc] init];
    [templateRequest execute];
    
    FetchWXCardTemplateRequest *reqeust =[[FetchWXCardTemplateRequest alloc] init];
    [reqeust execute];
}



#pragma mark - receivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchCardTemplateResponse]) {
        NSNumber *ret = [notification.userInfo numberValueForKey:@"rc"];
        if (ret.integerValue == 0) {
            [self reloadData];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchWXCardTemplateResponse])
    {
        NSNumber *ret = [notification.userInfo numberValueForKey:@"rc"];
        if (ret.integerValue == 0) {
            [self reloadData];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
    else if ([notification.name isEqualToString:kFetchPosCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        CDPosOperate *operate = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:self.operateID forKey:@"operate_id"];
        if (operate) {
            self.operate = operate;
        }
        else
        {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"单据获取失败"];
            [messageView show];
        }

    }
    
}

#pragma mark - btn action
- (IBAction)didWeikaBtnPressed:(id)sender {
    if (self.selectedType != SelectedType_weika) {
        self.selectedType = SelectedType_weika;
    }
}
- (IBAction)didWeixinBtnPressed:(id)sender {
    if (self.selectedType != SelectedType_weixin) {
        self.selectedType = SelectedType_weixin;
    }
}





#pragma mark - GiveWeikaDataSourceDelegate
- (void)didWeikaTemplatePressed:(CDCardTemplate *)weikaTemplate
{
    if (weikaTemplate.card_type.integerValue == 2) {
        GiveWeikaCouponViewController *giveWeikaCouponVC = [[GiveWeikaCouponViewController alloc] init];
        giveWeikaCouponVC.cardTemplate = weikaTemplate;
        giveWeikaCouponVC.givePeople = self.givePeople;
        giveWeikaCouponVC.isFromMember = self.isFromMember;
        [self.navigationController pushViewController:giveWeikaCouponVC animated:YES];
    }
    else if (weikaTemplate.card_type.integerValue == 3)
    {
        GiveWeikaCardViewController *giveWeikaCardVC = [[GiveWeikaCardViewController alloc] init];
        giveWeikaCardVC.cardTemplate = weikaTemplate;
        giveWeikaCardVC.givePeople = self.givePeople;
        giveWeikaCardVC.isFromMember = self.isFromMember;
        [self.navigationController pushViewController:giveWeikaCardVC animated:YES];
    }
}

#pragma mark - GiveWeixinDataSourceDelegate
- (void)didWeixinTemplatedPressed:(CDWXCardTemplate *)wxTemplate
{
    GiveWeixinViewController *weixinVC = [[GiveWeixinViewController alloc] init];
    weixinVC.WXTemplate = wxTemplate;
//    weixinVC.memberPhone = self.givePeople.mobile;
    weixinVC.givePeople = self.givePeople;
    weixinVC.isFromMember = self.isFromMember;
    [self.navigationController pushViewController:weixinVC animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
