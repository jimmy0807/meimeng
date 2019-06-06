//
//  MemberCardOrTicketViewController.m
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardOrCouponViewController.h"
#import "MemberCardDataSource.h"
#import "MemberCardInfoViewController.h"
#import "MemberCreateCardViewController.h"
#import "BNActionSheet.h"
#import "MemberCreateCardViewController.h"
#import "CBMessageView.h"
#import "BossPermissionManager.h"
#import "ImportMemberCardViewController.h"
#import "BSFetchMemberCardRequest.h"
#import "BSFetchMemberDetailRequest.h"
#import "MemberCouponDataSource.h"
#import "MemberCouponInfoViewController.h"
#import "BSFetchCouponCardRequest.h"

typedef enum SelectedType
{
    SelectedType_Card,
    SelectedType_Coupon,
}SelectedType;

@interface MemberCardOrCouponViewController ()<MemberCardDataSourceDelegate,BNRightButtonItemDelegate,BNActionSheetDelegate,MemberCouponDataSourceDelegate>
@property (nonatomic, strong) MemberCardDataSource *cardDataSource;
@property (nonatomic, strong) MemberCouponDataSource *couponDataSouce;
@property (nonatomic, assign) SelectedType selectedType;
@end

@implementation MemberCardOrCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;

    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.title = @"会员卡/券";
    
    self.topBgView.backgroundColor = AppThemeColor;
    
    
    [self.cardBtn setTitleColor:AppThemeColor forState:UIControlStateSelected];
    [self.couponBtn setTitleColor:AppThemeColor forState:UIControlStateSelected];
    
    self.selectedType = SelectedType_Card;
    
//    NSLayoutConstraint
    self.scollView.scrollEnabled = false;
    self.noCardTipLabel.text = @"通过开卡、充值的会员卡\n会显示在这里";
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
    [self registerNofitificationForMainThread:kBSFetchCouponCardResponse];
    [self registerNofitificationForMainThread:kBSImportMemberCardResponse];
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    
    
    BSFetchMemberCardRequest *fetchCardRequest = [[BSFetchMemberCardRequest alloc] initWithMemberID:self.member.memberID];
    [fetchCardRequest execute];
    
    
    BSFetchCouponCardRequest *fetchCouponRequest = [[BSFetchCouponCardRequest alloc] initWithMemberId:self.member.memberID];
    [fetchCouponRequest execute];
    
    
    [self initTableViewDataSource];
    [self reloadView];
}


#pragma mark - init data source
- (void) initTableViewDataSource
{
    self.cardDataSource = [[MemberCardDataSource alloc] init];
    self.cardDataSource.delegate = self;
    self.cardTableView.dataSource = self.cardDataSource;
    self.cardTableView.delegate = self.cardDataSource;
   
    self.couponDataSouce = [[MemberCouponDataSource alloc] init];
    self.couponDataSouce.delegate = self;
    self.couponTableView.delegate = self.couponDataSouce;
    self.couponTableView.dataSource = self.couponDataSouce;
}



#pragma mark - reload view
- (void)reloadView
{
    if (self.selectedType == SelectedType_Card) {
        [self reloadCardView];
    }
    else
    {
        [self reloadCouponView];
    }
}

- (void)reloadCardView
{
    NSArray *memberCards = self.member.card.array;
    if (memberCards.count > 0) {
        self.noCardView.hidden = true;
        self.cardTableView.hidden = false;
        
        self.cardDataSource.memberCards = memberCards;
        [self.cardTableView reloadData];
    }
    else
    {
        self.noCardView.hidden = false;
        self.cardTableView.hidden = true;
    }
}

- (void)reloadCouponView
{
    NSArray *coupons = self.member.coupons.array;
    if (coupons.count > 0) {
        self.noCouponView.hidden = true;
        self.couponTableView.hidden = false;
        self.couponDataSouce.couponCards = coupons;
        [self.couponTableView reloadData];
    }
    else
    {
        self.noCouponView.hidden = false;
        self.couponTableView.hidden = true;
    }
}



#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardResponse]) {
        [self reloadCardView];
    }
    else if ([notification.name isEqualToString:kBSFetchCouponCardResponse])
    {
        [self reloadView];
    }
    else if ([notification.name isEqualToString:kBSImportMemberCardResponse])
    {
//        BSFetchMemberDetailRequest *reqeust = [[BSFetchMemberDetailRequest alloc] initWithMember:self.member];
//        [reqeust execute];
        
        BSFetchMemberCardRequest *fetchCardRequest = [[BSFetchMemberCardRequest alloc] initWithMemberID:self.member.memberID];
        [fetchCardRequest execute];
    }
    else if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        BSFetchMemberCardRequest *fetchCardRequest = [[BSFetchMemberCardRequest alloc] initWithMemberID:self.member.memberID];
        [fetchCardRequest execute];
    }
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    BNActionSheet *actionSheet = [[BNActionSheet alloc] initWithItems:@[@"开卡",@"导入会员卡"] cancelTitle:nil delegate:self];
    [actionSheet show];
}

#pragma mark - BNActionSheetDelegate
- (void)bnActionSheet:(BNActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index: %d",buttonIndex);
    if (buttonIndex == 0) {
        [self openCard:nil];
    }
    else
    {
        [self importCard];
    }
}


#pragma mark - //开卡
- (void)openCard:(UIButton *)button
{
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( profile.posID.integerValue > 0 )
    {
        if ( [profile.havePos boolValue] )
        {
            
        }
        else
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"您的账号不能开卡,请确认您选择的POS里是否有支付方式"];
            [view showInView:self.view];
            return;
        }
    }
    else
    {
        CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"你的账号没有绑定POS"];
        [view showInView:self.view];
        return;
    }
    
    MemberCreateCardViewController *createCard = [[MemberCreateCardViewController alloc]initWithNibName:NIBCT(@"MemberCreateCardViewController") bundle:nil];
 
    char c = 'A'+arc4random_uniform(26);
    int n = (arc4random()%901)+100;
    NSRange range = NSMakeRange(7, 4);
    NSString *phoneNumber = self.member.mobile;
    if([self.member.mobile isEqualToString:@"0"]||[self.member.mobile isEqualToString:@""]||self.member.mobile==nil)
    {
        phoneNumber = [NSString stringWithFormat:@"%d",(arc4random()%9001)+1000];
    }
    NSString *subString = [phoneNumber substringWithRange:range];
    NSString *memberNo = [NSString stringWithFormat:@"%@%c%d%@",profile.businessId,c,n,subString];
    createCard.randomString = memberNo;
    createCard.memberID = self.member.memberID;
    [self.navigationController pushViewController:createCard animated:YES];
}

#pragma mark - //导入卡
- (void)importCard
{
    if([[[PersonalProfile currentProfile].reachItems objectForKey:BossReachItems_Vip] integerValue] != BossAccountManager)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"OnlyManagerCanImportMemberCard")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        ImportMemberCardViewController *viewController = [[ImportMemberCardViewController alloc] initWithMember:self.member];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - button action

- (IBAction)memberCardPressed:(id)sender {
    if (self.cardBtn.isSelected) {
        return;
    }
//    self.SecondLayoutConstraint.active = true;
    [self.scollView addConstraint:self.SecondLayoutConstraint];
    self.cardView.hidden = false;
    self.couponBtn.selected = false;
    self.cardBtn.selected = true;
    
    self.selectedType = SelectedType_Card;
    
    [self reloadView];

}

- (IBAction)memberCouponPressed:(UIButton *)sender {
    
    if (self.couponBtn.isSelected) {
        return;
    }
//    self.SecondLayoutConstraint.active = false;
    [self.scollView removeConstraint:self.SecondLayoutConstraint];
    self.cardView.hidden = true;
    self.cardBtn.selected = false;
    self.couponBtn.selected = true;
    
    self.selectedType = SelectedType_Coupon;
    
    [self reloadView];
    
}

- (IBAction)openCardPressed:(id)sender {
    [self openCard:nil];
}

#pragma mark - MemberCardDataSourceDelegate
- (void)didSelectctdedMemberCard:(CDMemberCard *)memberCard
{
    MemberCardInfoViewController *cardInfoVC = [[MemberCardInfoViewController alloc] init];
    cardInfoVC.memberCard = memberCard;
    [self.navigationController pushViewController:cardInfoVC animated:YES];
}

#pragma mark - MemberCouponDataSourceDelegate
- (void)didSelectctdedCouponCard:(CDCouponCard *)couponCard
{
    MemberCouponInfoViewController *couponInfoVC = [[MemberCouponInfoViewController alloc] init];
    couponInfoVC.couponCard = couponCard;
    [self.navigationController pushViewController:couponInfoVC animated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


@implementation CMButton

- (void)setHighlighted:(BOOL)highlighted
{
    return;
}

@end
