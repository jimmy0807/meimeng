//
//  MemberFunctionViewController.m
//  Boss
//
//  Created by lining on 16/3/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFunctionViewController.h"
#import "MemberFunctionCell.h"
#import "MemberInfoViewController.h"
#import "MemberCardOrCouponViewController.h"
#import "BSFetchMemberDetailRequest.h"
#import "BSFetchMemberTezhengRequest.h"
#import "BSFetchMemberQinyouRequest.h"
#import "MemberRecordViewController.h"
#import "PayCell.h"
#import "MemberItemCell.h"
#import "MemberInfoDetailViewController.h"
#import "MemberTezhengViewController.h"
#import "MemberQinyouViewController.h"
#import "BSFetchCommentRequest.h"

#import "BSFetchCommentTypeRequest.h"
#import "MemberCommentViewController.h"
#import "BSFetchMemberFollowRequest.h"
#import "MemberFollowViewController.h"
#import "MemberFunctionHeadView.h"
#import "MemberTableHeadView.h"
#import "MemberProductViewController.h"
#import "BSFetchProductPriceListRequest.h"
#import "MemberMessageTemplateViewController.h"
#import "MemberSaleSelectedCardViewController.h"
#import "MemberFeedbackViewController.h"
#import "CBMessageView.h"
#import "PhoneGiveViewController.h"


typedef enum FunctionItemIndex
{
    FunctionItemIndex_Telephone,
    FunctionItemIndex_SendMessage,
    FunctionItemIndex_Sale,
    FunctionItemIndex_Vip,
    FunctionItemIndex_JiLu,
    FunctionItemIndex_GenJin,
    FunctionItemIndex_JiFen,
}FunctionItemIndex;

NSInteger row_qiankuan = -1;
NSInteger row_give = 0;
NSInteger row_consume = 1;
NSInteger row_comment = 2;
NSInteger row_tezheng = 3;
NSInteger row_qinyou = 4;
NSInteger row_feedback = 5;
NSInteger row_num = 6;


@interface MemberFunctionViewController ()<MemberFunctionCellDelegate,MemberFunctionHeadViewDelagate,UIAlertViewDelegate>
{
    MemberFunctionHeadView *headView;
}
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic, strong) NSArray *comments;

@end

@implementation MemberFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    self.title = @"会员详情";
   
    
    [self initData];
    [self sendRequest];
   
    
//    SectionRow_qiankuan = -1;
    
    [self registerNofitificationForMainThread:kBSUpdateMemberResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberDetailResponse];
    [self registerNofitificationForMainThread:kBSFetchCommentResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberQinyouResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberTezhengResponse];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
    self.tableView.tableHeaderView = view;
    headView = [MemberFunctionHeadView createView];
    headView.delegate = self;
    [view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [self reloadTopView];
    [self reloadHeadView];

    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 20)];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    
    //取卡类型
    BSFetchProductPriceListRequest *request = [[BSFetchProductPriceListRequest alloc]init];
    [request execute];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}


- (void)reloadHeadView
{
    headView.nameLabel.text = self.member.memberName;
    headView.headImgView.layer.cornerRadius = self.headImgView.frame.size.width/2.0;
    headView.headImgView.clipsToBounds = YES;
    [headView.headImgView setImageWithName:self.member.imageName tableName:@"born.member" filter:self.member.memberID fieldName:@"image" writeDate:self.member.lastUpdate placeholderString:@"user_default" cacheDictionary:nil completion:nil];
    
    NSLog(@"mobile: %@",self.member.mobile);

    if ([self.member.gender isEqualToString:@"Male"]) {
        headView.genderLabel.text = @"男";
    }
    else if ([self.member.gender isEqualToString:@"Female"])
    {
        headView.genderLabel.text = @"女";
    }
    
    
//    headView.phoneLabel.text = [self sepreatePhoneString];
    headView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.member.amount floatValue]];

}


- (void)reloadTopView
{
    self.nameLabel.text = self.member.memberName;
    self.headImgView.layer.cornerRadius = self.headImgView.frame.size.width/2.0;
    self.headImgView.clipsToBounds = YES;
    [self.headImgView setImageWithName:self.member.imageName tableName:@"born.member" filter:self.member.memberID fieldName:@"image" writeDate:self.member.lastUpdate placeholderString:@"user_default" cacheDictionary:nil completion:nil];
    
    NSLog(@"mobile: %@",self.member.mobile);
    
    if ([self.member.gender isEqualToString:@"Male"]) {
        self.genderLabel.text = @"男";
    }
    else if ([self.member.gender isEqualToString:@"Female"])
    {
        self.genderLabel.text = @"女";
    }
    
    
    self.phoneLabel.text = [self sepreatePhoneString];
//    headView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.member.amount floatValue]];
    
}

- (NSString *)sepreatePhoneString
{
    NSString *sepreateString;
    if (self.member.mobile.length == 11) {
        sepreateString = [NSString stringWithFormat:@"%@-%@-%@",[self.member.mobile substringWithRange:NSMakeRange(0, 3)],[self.member.mobile substringWithRange:NSMakeRange(3, 4)],[self.member.mobile substringWithRange:NSMakeRange(7, 4)]];
    }
    else
    {
        sepreateString = self.member.mobile;
    }
    return sepreateString;
}

- (void)initData
{

    self.comments = [[BSCoreDataManager currentManager] fetchCommentsWithMember:self.member];
    
    self.itemsArray = [NSMutableArray array];
    
    //拨打电话
    FunctionItem * item = [[FunctionItem alloc] init];
    item.imageName = @"member_call.png";
    item.itemIndex = FunctionItemIndex_Telephone;
    item.title = @"拨打电话";
//    item.function = @selector(didItemTelePressed:);
    [self.itemsArray addObject:item];

    //发送祝福
    item = [[FunctionItem alloc] init];
    item.imageName = @"member_message.png";
    item.itemIndex = FunctionItemIndex_SendMessage;
    item.title = @"发送祝福";
//    item.function = @selector(didItemMessagePressed:);
    [self.itemsArray addObject:item];
    
    //快速销售
    item = [[FunctionItem alloc] init];
    item.imageName = @"member_sale.png";
    item.itemIndex = FunctionItemIndex_Sale;
    item.title = @"快速销售";
//    item.function = @selector(didItemSalePressed:);
    [self.itemsArray addObject:item];
    
    
    //积分兑换
    item = [[FunctionItem alloc] init];
    item.imageName = @"member_jifen.png";
    item.itemIndex = FunctionItemIndex_JiFen;
    item.title = @"积分兑换";
//    item.function = @selector(didItemJiFenPressed:);
//    [self.itemsArray addObject:item];
    
    
    //会员卡/券
    item = [[FunctionItem alloc] init];
    item.imageName = @"member_huiyuan.png";
    item.itemIndex = FunctionItemIndex_Vip;
    item.title = @"会员卡/券";
//    item.function = @selector(didItemVipPressed:);
    [self.itemsArray addObject:item];
    
    //记录
    item = [[FunctionItem alloc] init];
    item.imageName = @"member_jilu.png";
    item.itemIndex = FunctionItemIndex_JiLu;
    item.title = @"记录";
//    item.function = @selector(didItemVipPressed:);
    [self.itemsArray addObject:item];
    
    //跟进表
    item = [[FunctionItem alloc] init];
    item.imageName = @"member_genjin.png";
    item.itemIndex = FunctionItemIndex_GenJin;
    item.title = @"跟进表";
    //    item.function = @selector(didItemJiFenPressed:);
    [self.itemsArray addObject:item];

}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSUpdateMemberResponse]) {
        [self reloadTopView];
        [self reloadHeadView];
    }
    else if ([notification.name isEqualToString:kBSFetchMemberDetailResponse])
    {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [self reloadTopView];
        [self reloadHeadView];
    }
    else if ([notification.name isEqualToString:kBSFetchCommentResponse])
    {
        self.comments = [[BSCoreDataManager currentManager] fetchCommentsWithMember:self.member];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([notification.name isEqualToString:kBSFetchMemberQinyouResponse])
    {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([notification.name isEqualToString:kBSFetchMemberTezhengResponse])
    {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}


#pragma mark - send request
- (void)sendRequest
{
    BSFetchMemberDetailRequest *request = [[BSFetchMemberDetailRequest alloc] initWithMember:self.member];
    [request execute];
    
    BSFetchMemberTezhengRequest *tezhengRequest = [[BSFetchMemberTezhengRequest alloc] initWithMember:self.member];
    [tezhengRequest execute];
    
    BSFetchMemberQinyouRequest *qinyouRequest = [[BSFetchMemberQinyouRequest alloc] initWithMember:self.member];
    [qinyouRequest execute];
    
    BSFetchCommentRequest *commentRequest = [[BSFetchCommentRequest alloc] init];
    commentRequest.member = self.member;
    [commentRequest execute];
    
    BSFetchCommentTypeRequest *typeRequest = [[BSFetchCommentTypeRequest alloc] init];
    [typeRequest execute];
    
    
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return ceil(self.itemsArray.count/3.0);
    }
    else
    {
        return row_num;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        MemberFunctionCell *functionCell = [tableView dequeueReusableCellWithIdentifier:@"member_function_cell"];
        if (functionCell == nil) {
            functionCell = [MemberFunctionCell createCell];
            functionCell.delegate = self;
        }
        
        functionCell.row = row;
        NSInteger startIdx = row * ROW_ITEM_COUNT;
        for (int i = 0; i < ROW_ITEM_COUNT; i++) {
            NSInteger index = startIdx + i;
            if (index < self.itemsArray.count) {
                [functionCell setItem:self.itemsArray[index] withIndex:i];
            }
            else
            {
                [functionCell setItem:nil withIndex:i];
            }
        }
        
        return functionCell;
    }
    else
    {
        MemberItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberItemCell"];
        if (cell == nil) {
            cell = [MemberItemCell createCell];
//            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        cell.arrowImgViewHidden = false;
        cell.countLabel.textColor = COLOR(157, 157, 157, 1);
        if (row == row_qiankuan) {
            cell.iconImgView.image = [UIImage imageNamed:@"member_qian_icon.png"];
            cell.titleLabel.text = @"欠款";
            cell.countLabel.text = [NSString stringWithFormat:@"￥%.2f",200.0f];
            cell.countLabel.textColor = [UIColor redColor];
            cell.arrowImgViewHidden = true;
        }
        else if (row == row_give)
        {
            cell.iconImgView.image = [UIImage imageNamed:@"member_give_icon.png"];
            cell.titleLabel.text = @"赠送卡券";
            cell.countLabel.text = @"";
        }
        else if (row == row_consume)
        {
            cell.iconImgView.image = [UIImage imageNamed:@"member_money_icon.png"];
            cell.titleLabel.text = @"已购买的项目";
            cell.countLabel.text = @"";
//            cell.countLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.member.arrearsAmount floatValue]];
        }
        else if (row == row_comment) {
            cell.iconImgView.image = [UIImage imageNamed:@"member_pinglun_icon.png"];
            cell.titleLabel.text = @"已评论";
            cell.countLabel.text = [NSString stringWithFormat:@"%d",self.comments.count];
        }
        else if (row == row_tezheng)
        {
            cell.iconImgView.image = [UIImage imageNamed:@"member_tezheng_icon.png"];
            cell.titleLabel.text = @"特征";
            if (self.member.tezhengs.count == 0) {
                NSLog(@"---------");
            }
            cell.countLabel.text = [NSString stringWithFormat:@"%d",self.member.tezhengs.count];
        }
        else if (row == row_feedback)
        {
            cell.iconImgView.image = [UIImage imageNamed:@"member_feedback.png"];
            cell.titleLabel.text = @"护理反馈";
            if (self.member.feedbacks.count == 0) {
                NSLog(@"---------");
            }
            cell.countLabel.text = [NSString stringWithFormat:@"%d",self.member.feedbacks.count];
        }
        else if (row == row_qinyou)
        {
            cell.iconImgView.image = [UIImage imageNamed:@"member_qinyou_icon.png"];
            cell.titleLabel.text = @"家庭亲友";
            cell.countLabel.text = [NSString stringWithFormat:@"%d",self.member.qinyous.count];
        }
        
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return IC_SCREEN_WIDTH *0.25;
    }
    else
    {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 0.1;
    }
    else if (section == 1)
    {
        return 30;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 8,200, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"TA的";
        label.textColor = [UIColor grayColor];
        [view addSubview:label];
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        if (indexPath.row == row_give) {
            PhoneGiveViewController *phoneGiveVC = [[PhoneGiveViewController alloc] init];
            phoneGiveVC.member = self.member;
            phoneGiveVC.isFromMember = true;
            [self.navigationController pushViewController:phoneGiveVC animated:YES];
        }
        else if (indexPath.row == row_consume) {
            MemberProductViewController *productVC = [[MemberProductViewController alloc] init];
            productVC.member = self.member;
            [self.navigationController pushViewController:productVC animated:YES];
        }
        else if (indexPath.row == row_comment) {
            NSLog(@"已评论");
            MemberCommentViewController *commentVC = [[MemberCommentViewController alloc] init];
            commentVC.member = self.member;
            [self.navigationController pushViewController:commentVC animated:YES];
            
        }
        else if (indexPath.row == row_tezheng)
        {
            NSLog(@"特征");
            MemberTezhengViewController *tzVC = [[MemberTezhengViewController alloc] init];
            tzVC.member = self.member;
            [self.navigationController pushViewController:tzVC animated:YES];
        }
        else if (indexPath.row == row_qinyou)
        {
            NSLog(@"家庭亲友");
            MemberQinyouViewController *qyVC = [[MemberQinyouViewController alloc] init];
            qyVC.member = self.member;
            [self.navigationController pushViewController:qyVC animated:YES];
        }
        else if (indexPath.row == row_feedback)
        {
            MemberFeedbackViewController *feedbackVC = [[MemberFeedbackViewController alloc] init];
            feedbackVC.member = self.member;
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
    }
}


#pragma mark - MemberFunctionCellDelegate

- (void)didSelectedItemAtIdx:(NSInteger)idx
{
    FunctionItem *item = self.itemsArray[idx];
    NSLog(@"%@",item.title);
    if (item.itemIndex == FunctionItemIndex_Telephone) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[self sepreatePhoneString] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
//        [alertView show];
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.member.mobile];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }
    else if (item.itemIndex == FunctionItemIndex_SendMessage)
    {
        MemberMessageTemplateViewController *messgeTemplateVC = [[MemberMessageTemplateViewController alloc] init];
        messgeTemplateVC.member = self.member;
        [self.navigationController pushViewController:messgeTemplateVC animated:YES];
        
    }
    else if (item.itemIndex == FunctionItemIndex_Sale)
    {
        
        if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0) {
            [[[CBMessageView alloc] initWithTitle:@"当前用户无此权限"] show];
            return;
        }

        MemberSaleSelectedCardViewController *selectedCardVC = [[MemberSaleSelectedCardViewController alloc] init];
        selectedCardVC.member = self.member;
        [self.navigationController pushViewController:selectedCardVC animated:YES];
    }
    else if (item.itemIndex == FunctionItemIndex_JiFen)
    {
        
    }
    else if (item.itemIndex == FunctionItemIndex_Vip)
    {
        MemberCardOrCouponViewController *cardViewController = [[MemberCardOrCouponViewController alloc] init];
        cardViewController.member = self.member;
        [self.navigationController pushViewController:cardViewController animated:YES];
    }
    else if (item.itemIndex == FunctionItemIndex_JiLu)
    {
        MemberRecordViewController *recordVC = [[MemberRecordViewController alloc] init];
        recordVC.member = self.member;
        recordVC.type = RecordType_Member;
        [self.navigationController pushViewController:recordVC animated:YES];
    }
    else if (item.itemIndex == FunctionItemIndex_GenJin)
    {
//        BSFetchMemberFollowRequest *followRequest = [[BSFetchMemberFollowRequest alloc] init];
//        [followRequest execute];
        MemberFollowViewController *followVC = [[MemberFollowViewController alloc] init];
        followVC.member = self.member;
        [self.navigationController pushViewController:followVC animated:YES];
    }
}

#pragma mark - MemberFunctionHeadViewDelagate
- (void) didEditBtnPressed
{
    MemberInfoDetailViewController *detailInfoVC = [[MemberInfoDetailViewController alloc] init];
    detailInfoVC.member = self.member;
    [self.navigationController pushViewController:detailInfoVC animated:YES];
}

#pragma mark - btn action
- (IBAction)memberInfoPressed:(id)sender {
//    MemberInfoViewController *infoVC = [[MemberInfoViewController alloc] init];
//    infoVC.member = self.member;
//    [self.navigationController pushViewController:infoVC animated:YES];
    
    MemberInfoDetailViewController *detailInfoVC = [[MemberInfoDetailViewController alloc] init];
    detailInfoVC.member = self.member;
    [self.navigationController pushViewController:detailInfoVC animated:YES];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    NSLog(@"buttonIndex: %d",buttonIndex) ;
//    if (buttonIndex == 1) {
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.member.mobile];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebview];
//    }
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)backBtnPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
