//
//  MemberCardInfoViewController.m
//  Boss
//
//  Created by lining on 16/3/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardInfoViewController.h"
#import "CBRightButtonItem.h"
#import "MemberCardInfoDataSource.h"
#import "BSFetchMemberCardDetailRequest.h"
#import "CBMessageView.h"
#import "MemberCardProjectViewController.h"
#import "MemberBuyProjectViewController.h"
#import "MemberChangeCardInfoViewController.h"
#import "MemberRecordViewController.h"
#import "BSEditMemberCardRequest.h"
#import "CBLoadingView.h"
#import "MemberCardOperateView.h"

#import "MemberCardRecedeViewController.h"
#import "MemberCardProjectRecedeViewController.h"
#import "MemberCardPayViewController.h"
#import "MemberCardMergeViewController.h"
#import "MemberCardUpgradeViewController.h"
#import "MemberCardActiveViewController.h"
#import "MemberCardExchangeViewController.h"
#import "MemberCardTurnShopViewController.h"

#import "MemberCardAmountDetailViewController.h"
#import "MemberCardPointViewController.h"
#import "MemberCardPayModeViewController.h"
#import "MemberCardLostViewController.h"
#import "MemberCardRepaymentViewController.h"
#import "MemberBuyCardItemViewController.h"
#import "MemberCardPointReedemViewController.h"
#import "ShopProductController.h"
#import "productProjectMainController.h"
#import "OperateManager.h"

@interface MemberCardInfoViewController ()<CBRightButtonItemDelegate,CardInfoDataSourceDelegate,CardOperateViewDelegate>
@property (nonatomic, strong) MemberCardInfoDataSource *dataSource;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) BNRightButtonItem *rightItem;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@end

@implementation MemberCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.rightItem = [[BNRightButtonItem alloc] initWithTitle:@"保存"];
    self.rightItem.delegate = self;
//    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    self.topBgView.backgroundColor = AppThemeColor;
    
    self.hideKeyBoardWhenClickEmpty = true;

    self.dataSource = [[MemberCardInfoDataSource alloc] init];
    self.dataSource.delegate = self;
    self.dataSource.memberCard = self.memberCard;
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    
    [self reloadView];
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardDetailResponse];
    [self registerNofitificationForMainThread:kBSEditMemberCardResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardProjectResponse];
    
    self.saveBtn.enabled = true;
    
    self.saveBtn.layer.cornerRadius = 2;
    self.saveBtn.clipsToBounds = true;
    self.saveBtn.backgroundColor = AppThemeColor;
    
    BSFetchMemberCardDetailRequest *detailRequest = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:self.memberCard.cardID];
    [detailRequest execute];
    
    
    if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0) {
        self.saveBtn.hidden = true;
        
        [self.view removeConstraint:self.tableViewBottomConstraint];
    }
}

#pragma mark -  reloadView
- (void)reloadView
{
    self.titleLabel.text = self.memberCard.priceList.name;
    self.detailLabel.text = self.memberCard.cardNo;

//    self.cardProjectCountLabel.text = [NSString stringWithFormat:@"%@",self.memberCard.card_project_count];
    self.cardProjectCountLabel.text = [NSString stringWithFormat:@"%d",[self getProjectCount]];
    
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f",[self.memberCard.amount floatValue]];
    self.pointLabel.text = [NSString stringWithFormat:@"%.2f",self.memberCard.points.floatValue];
    [self.tableView reloadData];
}


- (NSInteger)getProjectCount
{
    NSInteger count = 0;
    for (CDMemberCardProject *cardProject in self.memberCard.projects.array) {
        if (cardProject.remainQty.integerValue > 0) {
            count ++;
        }
    }
    return count;
}

#pragma mark - 
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    [[BSCoreDataManager currentManager] rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardDetailResponse]) {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0 ) {
            [self reloadView];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
    else if ([notification.name isEqualToString:kBSEditMemberCardResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        self.operateBtn.hidden = false;
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [[[CBMessageView alloc] initWithTitle:@"修改成功"] show];
            
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@1 afterDelay:0.25];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardProjectResponse])
    {
//        NSInteger projectCount = self.projectCount
        self.cardProjectCountLabel.text = [NSString stringWithFormat:@"%d",[self getProjectCount]];
    }
}

//- (void)popViewController
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - CBRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
//    if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0) {
//        [[[CBMessageView alloc] initWithTitle:@"当前用户无此权限"] show];
//        return;
//    }
//    MemberCardOperateView *operateView = [MemberCardOperateView operateViewWithCard:self.memberCard];
//    operateView.delegate = self;
//    [operateView show];
    
    
//    BSEditMemberCardRequest *request = [[BSEditMemberCardRequest alloc] initWithCard:self.memberCard];
//    request.params = self.params;
//    [request execute];
//    
//    [[CBLoadingView shareLoadingView] show];
    
}


#pragma mark - CardOperateViewDelegate
- (void)didOperateItemPressedWithType:(kPadMemberCardOperateType)type
{
    if (type == kPadMemberCardOperateRecharge) {
        MemberCardPayModeViewController *payModeVC = [[MemberCardPayModeViewController alloc] init];
        payModeVC.card = self.memberCard;
        payModeVC.operateType = type;
        [self.navigationController pushViewController:payModeVC animated:YES];
    }
    else if (type == kPadMemberCardOperateBuy)
    {
        NSLog(@"购买");
//        MemberCardPayViewController *payVC = [[MemberCardPayViewController alloc] init];
//        payVC.operateType = type;
//        [self.navigationController pushViewController:payVC animated:YES];
//        MemberBuyCardItemViewController *buyItemVC = [[MemberBuyCardItemViewController alloc] init];
//        buyItemVC.card = self.memberCard;
//        [self.navigationController pushViewController:buyItemVC animated:YES];
//        ShopProductController *shopProductVC = [[ShopProductController alloc] init];
//        shopProductVC.type = ShopControllerType_Buy;
//        [self.navigationController pushViewController:shopProductVC animated:YES];
        
        
        [OperateManager shareManager].memberCard = self.memberCard;
        
        ProductProjectMainController *projectVC = [[ProductProjectMainController alloc] init];
        projectVC.controllerType = ProductControllerType_Buy;
       
        [self.navigationController pushViewController:projectVC animated:YES];
        
    }
    else if (type == kPadMemberCardOperateExchange)
    {
        NSLog(@"退项目");
        MemberCardProjectRecedeViewController *recedeProjectVC = [[MemberCardProjectRecedeViewController alloc] init];
        recedeProjectVC.memberCard = self.memberCard;
        [self.navigationController pushViewController:recedeProjectVC animated:YES];
    }
    else if (type == kPadMemberCardOperateRepayment)
    {
        MemberCardRepaymentViewController *repaymentVC = [[MemberCardRepaymentViewController alloc] init];
        repaymentVC.memberCard = self.memberCard;
        [self.navigationController pushViewController:repaymentVC animated:YES];
    }
    else if (type == kPadMemberCardOperateRefund)
    {
        MemberCardRecedeViewController *recedeVC = [[MemberCardRecedeViewController alloc] init];
        recedeVC.card = self.memberCard;
        [self.navigationController pushViewController:recedeVC animated:YES];
    }
    else if (type == kPadMemberCardOperateReplacement)
    {
        MemberCardExchangeViewController *exchangeVC = [[MemberCardExchangeViewController alloc] init];
        exchangeVC.card = self.memberCard;
        [self.navigationController pushViewController:exchangeVC animated:YES];
    }
    else if (type == kPadMemberCardOperateActive)
    {
        MemberCardActiveViewController *activeVC = [[MemberCardActiveViewController alloc] init];
        activeVC.card = self.memberCard;
        [self.navigationController pushViewController:activeVC animated:YES];
    }
    else if (type == kPadMemberCardOperateLost)
    {
        MemberCardLostViewController *lostVC = [[MemberCardLostViewController alloc] init];
        lostVC.card = self.memberCard;
        [self.navigationController pushViewController:lostVC animated:YES];
    }
    else if (type == kPadMemberCardOperateMerger)
    {
        MemberCardMergeViewController *mergeVC = [[MemberCardMergeViewController alloc] init];
        mergeVC.card = self.memberCard;
        [self.navigationController pushViewController:mergeVC animated:YES];
    }
    else if (type == kPadMemberCardOperateUpgrade)
    {
        MemberCardUpgradeViewController *upgradeVC = [[MemberCardUpgradeViewController alloc] init];
        upgradeVC.card = self.memberCard;
        upgradeVC.operateType = type;
        [self.navigationController pushViewController:upgradeVC animated:YES];
    }
    else if (type == kPadMemberCardOperateRedeem)
    {
        NSLog(@"积分兑换");
        MemberCardPointReedemViewController *reedemVC = [[MemberCardPointReedemViewController alloc] init];
        reedemVC.card = self.memberCard;
        [self.navigationController pushViewController:reedemVC animated:YES];
        
    }
    else if (type == kPadMemberCardOperateTurnStore)
    {
        MemberCardTurnShopViewController *turnShopVC = [[MemberCardTurnShopViewController alloc] init];
        turnShopVC.card = self.memberCard;
        [self.navigationController pushViewController:turnShopVC animated:YES];
    }
}

#pragma mark - productProjectMainControllerDelegate
-(void)productProjectMainControllerPayBtnClickWith:(NSMutableArray*)goods
{
//    CDProjectTemplate
    NSLog(@"%@",goods);
}
#pragma mark - button action
- (IBAction)topBtnPressed:(UIButton *)sender {
    int idx = sender.tag - 101;
    if (idx == 0) {
        NSLog(@"余额");
//        MemberCardProjectViewController *cardProjectVC = [[MemberCardProjectViewController alloc] init];
//        cardProjectVC.memberCard = self.memberCard;
//        [self.navigationController pushViewController:cardProjectVC animated:YES];
        
        MemberCardAmountDetailViewController *amountDetailVC = [[MemberCardAmountDetailViewController alloc] init];
        amountDetailVC.card = self.memberCard;
        [self.navigationController pushViewController:amountDetailVC animated:YES];
    }
    else if (idx == 1)
    {
//        MemberBuyProjectViewController *buyProjectVC = [[MemberBuyProjectViewController alloc] init];
//        buyProjectVC.memberCard = self.memberCard;
//        [self.navigationController pushViewController:buyProjectVC animated:YES];
        MemberCardProjectViewController *cardProjectVC = [[MemberCardProjectViewController alloc] init];
        cardProjectVC.memberCard = self.memberCard;
        [self.navigationController pushViewController:cardProjectVC animated:YES];
        NSLog(@"卡内项目");
    }
    else if (idx == 2)
    {
        NSLog(@"积分");
//        MemberRecordViewController *recordVC = [[MemberRecordViewController alloc] init];
//        recordVC.card = self.memberCard;
//        [self.navigationController pushViewController:recordVC animated:YES];
        
        MemberCardPointViewController *cardPointVC = [[MemberCardPointViewController alloc] init];
        cardPointVC.card = self.memberCard;
        [self.navigationController pushViewController:cardPointVC animated:YES];
    }
}

#pragma mark - CardInfoDataSourceDelegate
- (void)didSelectedItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kCardInfoSectionOne) {
        if (indexPath.row == CardInfoSectionOne_row_jilu) {
            MemberRecordViewController *recordVC = [[MemberRecordViewController alloc] init];
            recordVC.card = self.memberCard;
            [self.navigationController pushViewController:recordVC animated:YES];
        }
    }
}

- (void)didEditParams:(NSDictionary *)params
{
    NSLog(@"params: %@",params);
    self.params = params;
    if (params.allKeys.count > 0) {
//        self.saveBtn.enabled = true;
//        self.navigationItem.rightBarButtonItem = self.rightItem;
        self.operateBtn.hidden = true;
    }
    else
    {
//        self.saveBtn.enabled = false;
//        self.navigationItem.rightBarButtonItem = nil;
        self.operateBtn.hidden = false;
    }
}


- (IBAction)chageBtnPressed:(UIButton *)sender {
//    MemberChangeCardInfoViewController *chageCardInfoVC = [[MemberChangeCardInfoViewController alloc] init];
//    chageCardInfoVC.memberCard = self.memberCard;
//    [self.navigationController pushViewController:chageCardInfoVC animated:YES];]
    
    BSEditMemberCardRequest *request = [[BSEditMemberCardRequest alloc] initWithCard:self.memberCard];
    request.params = self.params;
    [request execute];
    
    [[CBLoadingView shareLoadingView] show];
    
   
}

- (IBAction)operateBtnPressed:(id)sender {
    
    if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0) {
        [[[CBMessageView alloc] initWithTitle:@"当前用户无此权限"] show];
        return;
    }
    MemberCardOperateView *operateView = [MemberCardOperateView operateViewWithCard:self.memberCard];
    operateView.delegate = self;
    [operateView show];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
