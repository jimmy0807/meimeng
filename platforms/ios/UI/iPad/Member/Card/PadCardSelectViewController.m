//
//  PadCardSelectViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadCardSelectViewController.h"
#import "PadProjectConstant.h"
#import "UIImage+Resizable.h"
#import "PadSelectCardCell.h"
#import "BSFetchMemberDetailRequest.h"
#import "BSFetchMemberCardRequest.h"
#import "BSFetchCouponCardRequest.h"
#import "BSFetchMemberQinyouRequest.h"
#import "BSFetchMemberCardDetailRequest.h"
#import "PadCardCreateViewController.h"
#import "PadMemberAndCardViewController.h"
#import "PopupCardQrCodeView.h"
#import "PadGiveViewController.h"
#import "BSFetchMemberDetailReqeustN.h"
#import "CBLoadingView.h"
#import "DeleteCouponCardRequest.h"
#import "CBMessageView.h"

#define kPadCardListWidth             300.0
#define kPadCardHeaderHeight          75.0
#define kPadCardCreateButtonHeight    60.0

#define kPadCardDetailHighlightedColor      COLOR(135.0, 153.0, 153.0, 1.0)
#define kPadCardDetailDividerLineColor      COLOR(209.0, 220.0, 220.0, 1.0)

typedef enum kPadSelectCardSection
{
    kPadSelectCardMemberCardSection,
    kPadSelectCardCouponCardSection,
    kPadSelectCardSectionCount
}kPadSelectCardSection;

@interface PadCardSelectViewController ()<PadSelectCardCellDelegate>{
    BOOL hasRefreshCardTableView;//已经刷新过
    BOOL hasPostSelectMemberCardFinish;//已经发过kPadSelectMemberCardFinish通知
}

@property (nonatomic, assign) kPadMemberAndCardViewType viewType;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSArray *memberCards;
@property (nonatomic, strong) NSArray *couponCards;
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDCouponCard *couponCard;

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UITableView *cardTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation PadCardSelectViewController

- (id)initWithMember:(CDMember *)member viewType:(kPadMemberAndCardViewType)viewType
{
    self = [super initWithNibName:@"PadCardSelectViewController" bundle:nil];
    if (self)
    {
        self.member = member;
        self.viewType = viewType;
        self.memberCard = nil;
        self.couponCard = nil;
        self.memberCards = [NSArray array];
        self.couponCards = [NSArray array];
        
        [self initMemberAndCouponCards];
    }
    
    return self;
}

- (id)initWithMember:(CDMember *)member memberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard *)couponCard
{
    self = [super initWithNibName:@"PadCardSelectViewController" bundle:nil];
    if (self)
    {
        self.member = member;
        self.viewType = kPadMemberAndCardSelect;
        self.memberCard = memberCard;
        self.couponCard = couponCard;
        self.memberCards = [NSArray array];
        self.couponCards = [NSArray array];
        if (self.memberCard == nil && self.member.card.array.count == 1)
        {
            CDMemberCard *memberCard = (CDMemberCard *)[self.member.card.array objectAtIndex:0];
            if (memberCard.cardNumber.length != 0)
            {
                self.memberCard = memberCard;
                [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberCardFinish object:self.memberCard userInfo:nil];
            }
        }
        
        [self initMemberAndCouponCards];
    }
    
    return self;
}

- (void)initMemberAndCouponCards
{
    NSMutableArray *cards = [NSMutableArray array];
    for (int i = 0; i < self.member.card.count; i++)
    {
        CDMemberCard *card = [self.member.card.array objectAtIndex:i];
        if (card.cardNumber.length != 0)
        {
            [cards addObject:card];
        }
    }
    self.memberCards = [NSArray arrayWithArray:cards];
    
    cards = [NSMutableArray array];
    for (int i = 0; i < self.member.coupons.count; i++)
    {
        CDCouponCard *card = [self.member.coupons.array objectAtIndex:i];
        if (card.cardNumber.length != 0)
        {
            [cards addObject:card];
        }
    }
    self.couponCards = [NSArray arrayWithArray:cards];
    
    if ( self.memberCard == nil && self.member.card.array.count == 1 )
    {
        CDMemberCard *memberCard = (CDMemberCard *)[self.member.card.array objectAtIndex:0];
        if ( memberCard.cardNumber.length != 0 )
        {
            self.memberCard = memberCard;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberCardFinish object:self.memberCard userInfo:nil];
        }
        
        [self refreshConfirmButton];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self forbidSwipGesture];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadProjectSideViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kPadSelectMemberCardFinish];
    [self registerNofitificationForMainThread:kPadSelectCouponCardFinish];
    [self registerNofitificationForMainThread:kBSFetchCouponCardResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardDetailResponse];
    [self registerNofitificationForMainThread:kBSGiveTicketResponse];
    [self registerNofitificationForMainThread:kBSGiveCardResponse];
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    
    [self initView];
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark init Methods

- (void)initView
{
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadCardListWidth, kPadCardHeaderHeight)];
    naviView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:naviView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0.0, 0.0, kPadCardHeaderHeight, kPadCardHeaderHeight);
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_n"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_h"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadCardHeaderHeight, 0.0, kPadCardListWidth - 2 * kPadCardHeaderHeight, kPadCardHeaderHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.member.memberName;
    [naviView addSubview:titleLabel];
    
    if (self.isMemberSelected && self.viewType != kPadMemberAndCardBook)
    {
        UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        changeButton.backgroundColor = [UIColor clearColor];
        changeButton.frame = CGRectMake(kPadCardListWidth - kPadCardHeaderHeight - 20.0, 0.0, kPadCardHeaderHeight + 20.0, kPadCardHeaderHeight);
        [changeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        changeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [changeButton setTitle:LS(@"PadChangeMember") forState:UIControlStateNormal];
        [changeButton setTitleColor:COLOR(168.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
        [changeButton addTarget:self action:@selector(didChangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:changeButton];
        
        
    }
    
    
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadCardHeaderHeight, kPadCardListWidth, 1.0)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
    [naviView addSubview:lineImageView];
    
    self.cardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadCardHeaderHeight, kPadCardListWidth, IC_SCREEN_HEIGHT - kPadCardHeaderHeight - kPadCardCreateButtonHeight) style:UITableViewStylePlain];
    self.cardTableView.backgroundColor = [UIColor clearColor];
    self.cardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cardTableView.delegate = self;
    self.cardTableView.dataSource = self;
    self.cardTableView.showsVerticalScrollIndicator = NO;
    self.cardTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.cardTableView];
    
    //if ( [PersonalProfile currentProfile].roleOption == 4 )
    {
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - kPadCardCreateButtonHeight, kPadCardListWidth, kPadCardCreateButtonHeight)];
        self.confirmButton.backgroundColor = [UIColor clearColor];
        self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
        [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.confirmButton];
        [self refreshConfirmButton];
    }
    
    if (self.viewType == kPadMemberAndCardDefault)
    {
        [self.confirmButton setTitle:LS(@"PadRestaurantBilling") forState:UIControlStateNormal];
    }
    else if (self.viewType == kPadMemberAndCardSelect)
    {
        [self.confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    }
}

- (void)initData
{
    if (self.member.coupons.count > 0)
    {
        for (int i=0; i<self.member.coupons.count; i++)
        {
            if (self.member.coupons[i].remainAmount.floatValue > 0)
            {
                return;
            }
        }
    }
    BSFetchMemberDetailRequestN *detailRequest = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:self.member.memberID];
    [detailRequest execute];
    [[CBLoadingView shareLoadingView] show];
    
    //BSFetchMemberQinyouRequest *relativeRrequest = [[BSFetchMemberQinyouRequest alloc] initWithMember:self.member];
    //[relativeRrequest execute];
}

- (void)refreshConfirmButton
{
    if ( self.couponCard )
    {
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    }
    else if (self.memberCard == nil || self.memberCard.state.integerValue != kPadMemberCardStateActive )
    {
        [self.confirmButton setTitleColor:COLOR(168.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    }
}

- (void)didBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCardSelectCancel:)])
    {
        [self.delegate didCardSelectCancel:self.isMemberSelected];
    }
    
        
}

- (void)didChangeButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCardSelectCancel:)])
    {
        [self.delegate didCardSelectCancel:NO];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    ///限定会员卡修改
    //旧代码
//    if ( self.couponCard )
//    {
//
//    }
//    else if (self.memberCard == nil || self.memberCard.state.integerValue != kPadMemberCardStateActive)
//    {
//        return;
//    }
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didCardSelectMemberCard:couponCard:toOrder:)])
//    {
//        BOOL toOrder = YES;
//        if (self.viewType == kPadMemberAndCardSelect)
//        {
//            toOrder = NO;
//        }
//        [self.delegate didCardSelectMemberCard:self.memberCard couponCard:self.couponCard toOrder:toOrder];
//    }
    //新代码
    if (self.memberCard == nil || self.memberCard.state.integerValue != kPadMemberCardStateActive)
    {
        //NSLog(@"还没选会员卡呢");
        [[[CBMessageView alloc] initWithTitle:@"您还没选会员卡呢"] show];
    }else{
        //NSLog(@"已选选会员卡");
        if (self.delegate && [self.delegate respondsToSelector:@selector(didCardSelectMemberCard:couponCard:toOrder:)])
        {
            BOOL toOrder = YES;
            if (self.viewType == kPadMemberAndCardSelect)
            {
                toOrder = NO;
            }
            [self.delegate didCardSelectMemberCard:self.memberCard couponCard:self.couponCard toOrder:toOrder];
        }
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kPadSelectMemberCardFinish])
    {
        self.memberCard = (CDMemberCard *)notification.object;
        [self.cardTableView reloadData];
    }
    else if ([notification.name isEqualToString:kPadSelectCouponCardFinish])
    {
        self.couponCard = (CDCouponCard *)notification.object;
        [self.cardTableView reloadData];
    }
    else if ([notification.name isEqualToString:kBSFetchCouponCardResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self initMemberAndCouponCards];
            [self.cardTableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self initMemberAndCouponCards];
            [self.cardTableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardDetailResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.member.memberID forKey:@"memberID"];
            [self initMemberAndCouponCards];
            [self.cardTableView reloadData];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    else if ([notification.name isEqualToString:kBSGiveTicketResponse] || [notification.name isEqualToString:kBSGiveCardResponse])
    {
        BSFetchMemberDetailRequestN *detailRequest = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:self.member.memberID];
        [detailRequest execute];
    }
    else if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            BSFetchMemberDetailRequestN *detailRequest = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:self.member.memberID];
            [detailRequest execute];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberDetailResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self initMemberAndCouponCards];
            [self.cardTableView reloadData];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kPadSelectCardSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPadSelectCardMemberCardSection)
    {
        return self.memberCards.count;
    }
    else if (section == kPadSelectCardCouponCardSection)
    {
        return self.couponCards.count + 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kPadSelectCardMemberCardSection)
    {
        if (self.memberCards.count == 0)
        {
            return 0;
        }
    }
    else if (section == kPadSelectCardCouponCardSection)
    {
        if (self.couponCards.count == 0)
        {
            return 0;
        }
    }
    
    return 24.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == kPadSelectCardMemberCardSection)
    {
        if (self.memberCards.count == 0)
        {
            return nil;
        }
    }
    else if (section == kPadSelectCardCouponCardSection)
    {
        if (self.couponCards.count == 0)
        {
            return nil;
        }
    }
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24)];
    v.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, kPadCardListWidth - 2 * 20.0, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    titleLabel.textColor = COLOR(154.0, 156.0, 156.0, 1.0);
    titleLabel.tag = 101;
    [v addSubview:titleLabel];
    
    if (section == kPadSelectCardMemberCardSection)
    {
        titleLabel.text = LS(@"PadMemberCard");
    }
    else if (section == kPadSelectCardCouponCardSection)
    {
        titleLabel.text = LS(@"PadGiftCardCoupons");
    }
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadSelectCardCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == kPadSelectCardCouponCardSection && indexPath.row == 0 )
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"giveCard"];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"giveCard"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView* iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_card_giveCard"]];
            iconImageView.frame = CGRectMake(26, 23, 30, 29);
            [cell.contentView addSubview:iconImageView];
            
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 27, 200, 21)];
            titleLabel.text = @"赠送卡券";
            titleLabel.font = [UIFont systemFontOfSize:16];
            //titleLabel.textColor = COLOR(175, 208, 208, 1);
            [cell.contentView addSubview:titleLabel];
        }
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"PadSelectCardCellIdentifier";
        PadSelectCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadSelectCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
       
        ///限定会员卡修改
        //老得写法
        [cell isSelectImageViewSelected:NO];
        NSLog(@"self.memberCards.count = %d",self.memberCards.count);
        CDMemberCard *memberCard;
        if (indexPath.row<self.memberCards.count) {
             memberCard = [self.memberCards objectAtIndex:indexPath.row];
        }
       
        NSLog(@"self.memberCard.cardID=%@,memberCard.cardID=%@, indexPath = %d,%d",self.memberCard.cardID,memberCard.cardID,indexPath.section,indexPath.row);
        //新写法
//        if (indexPath.section == kPadSelectCardMemberCardSection) {
//            if (!hasRefreshCardTableView) {
//                if (self.memberCards.count>1) {
//
//                    if (indexPath.row == 0) {
//                        ///默认第一张卡被选中 发通知让中间的InfotableView刷新
//                        CDMemberCard *memberCard = [self.memberCards objectAtIndex:indexPath.row];
//
//                        if (self.memberCard.cardID!=memberCard.cardID) {
//                             [cell isSelectImageViewSelected:YES];
//                        }
//
//                        NSLog(@"self.memberCard.cardID=%@ , memberCard.cardID =%@",self.memberCard.cardID,memberCard.cardID);
//
//                        if (!hasPostSelectMemberCardFinish)
//                        {
//                            self.memberCard = memberCard;
//                            [self refreshConfirmButton];
//                            [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberCardFinish object:memberCard userInfo:nil];
//
//                        }
//                        hasPostSelectMemberCardFinish = YES;//避免重复发通知
//                    }else{
//                        [cell isSelectImageViewSelected:NO];
//
//                    }
//                }else{
//                    [cell isSelectImageViewSelected:YES];
//
//                }
//            }else{
//                [cell isSelectImageViewSelected:NO];
//
//            }
//        }
//        else{
//            ///赠送礼品券section
//            [cell isSelectImageViewSelected:NO];
//
//        }
        
        
        
        //[cell isSelectImageViewSelected:NO];
        //CDMemberCard *memberCard = [self.memberCards objectAtIndex:indexPath.row];
        //NSLog(@"self.memberCard.cardID=%@,memberCard.cardID=%@, indexPath = %d,%d",self.memberCard.cardID,memberCard.cardID,indexPath.section,indexPath.row);
        ///默认第一张卡被选中 发通知让中间的InfotableView刷新
        if (!hasRefreshCardTableView){
            if (indexPath.row==0&&self.memberCard==nil) {
                
                self.memberCard = [self.memberCards objectAtIndex:0];
                [cell isSelectImageViewSelected:YES];
                [self refreshConfirmButton];
                [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberCardFinish object:self.memberCard userInfo:nil];
            }
        }
        
        
        cell.stateImageView.hidden = YES;
        cell.indexPath = indexPath;
        
        if (indexPath.section == kPadSelectCardMemberCardSection)
        {
            CDMemberCard *memberCard;
            if (indexPath.row<self.memberCards.count) {
                memberCard = [self.memberCards objectAtIndex:indexPath.row];
            }
            NSLog(@"Card:%@\nList%@",memberCard, memberCard.priceList);
            cell.titleLabel.text = memberCard.cardName;
            if (self.memberCard.cardID.integerValue == memberCard.cardID.integerValue)
            {
                 //NSLog(@"~~~~~~self.memberCard.cardID=memberCard.cardID%d",indexPath.row);
                 [cell isSelectImageViewSelected:YES];
                
            }
            
            if (memberCard.state.integerValue != kPadMemberCardStateActive)
            {
                cell.stateImageView.hidden = NO;
                if (memberCard.state.integerValue == kPadMemberCardStateDraft)
                {
                    cell.stateLabel.text = LS(@"PadMemberCardStateDraft");
                }
                else if (memberCard.state.integerValue == kPadMemberCardStateLost)
                {
                    cell.stateLabel.text = LS(@"PadMemberCardStateLost");
                }
                else if (memberCard.state.integerValue == kPadMemberCardStateReplacement)
                {
                    cell.stateLabel.text = LS(@"PadMemberCardStateReplacement");
                }
                else if (memberCard.state.integerValue == kPadMemberCardStateMerger)
                {
                    cell.stateLabel.text = LS(@"PadMemberCardStateMerger");
                }
                else if (memberCard.state.integerValue == kPadMemberCardStateUnlink)
                {
                    cell.stateLabel.text = LS(@"PadMemberCardStateUnlink");
                }
            }
            else if ( [memberCard.isInvalid boolValue] )
            {
                cell.stateImageView.hidden = NO;
                cell.stateLabel.text = @"已过期";
            }
            
            cell.qrButton.hidden = !cell.stateImageView.hidden;
        }
        else if (indexPath.section == kPadSelectCardCouponCardSection)
        {
            CDCouponCard *couponCard = [self.couponCards objectAtIndex:indexPath.row - 1];
            if ( couponCard.cardName.length == 0 )
            {
                cell.titleLabel.text = couponCard.cardNumber;
            }
            else
            {
                cell.titleLabel.text = [NSString stringWithFormat:@"%@\n%@",couponCard.cardNumber,couponCard.cardName];
            }
            
            if (self.couponCard.cardID.integerValue == couponCard.cardID.integerValue)
            {
                [cell isSelectImageViewSelected:YES];
            }
            
            cell.qrButton.hidden = YES;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ///限定会员卡修改
    hasRefreshCardTableView = YES;///该成员变量用来对默认第一张卡被选中进行控制
    if (indexPath.section == kPadSelectCardMemberCardSection)
    {
        CDMemberCard *memberCard;
        if (indexPath.row<=self.memberCards.count) {
            memberCard = [self.memberCards objectAtIndex:indexPath.row];
        }
        NSLog(@"选中self.memberCard.cardID=%@,memberCard.cardID=%@, indexPath = %d,%d",self.memberCard.cardID,memberCard.cardID,indexPath.section,indexPath.row);
        if (self.memberCard.cardID.integerValue == memberCard.cardID.integerValue)
        {
            self.memberCard = nil;
        }
        else
        {
            self.memberCard = memberCard;
            //BSFetchMemberCardDetailRequest *reuqest = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:self.memberCard.cardID];
            //[reuqest execute];
        }
        
        [self refreshConfirmButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberCardFinish object:self.memberCard userInfo:nil];
    }
    else if (indexPath.section == kPadSelectCardCouponCardSection)
    {
        if ( indexPath.row == 0 )
        {
            if ( [[PersonalProfile currentProfile].posID integerValue] == 0 )
            //if ( [PersonalProfile currentProfile].roleOption !=  4 )
            {
                return;
            }
            
            PadGiveViewController *padGiveVC = [[PadGiveViewController alloc] init];
            padGiveVC.member = self.member;
            [self.rootNavigationVC pushViewController:padGiveVC animated:YES];
            return;
        }
        
        
        CDCouponCard *coupon = [self.couponCards objectAtIndex:indexPath.row - 1];
        if (self.couponCard.cardID.integerValue == coupon.cardID.integerValue)
        {
            self.couponCard = nil;
        }
        else
        {
            self.couponCard = coupon;
        }
        
        [self refreshConfirmButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectCouponCardFinish object:self.couponCard userInfo:nil];
    }
    [self.cardTableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == kPadSelectCardCouponCardSection && indexPath.row > 0 )
    {
        return TRUE;
    }
    
    return FALSE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete )
    {
        if ( indexPath.section == kPadSelectCardCouponCardSection && indexPath.row > 0 )
        {
            WeakSelf;
            UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"确定要删除优惠券吗?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *save = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CDCouponCard *coupon = [self.couponCards objectAtIndex:indexPath.row - 1];
                [weakSelf deleteCouponCard:coupon];
            }];
            
            [alertControll addAction:cancel];
            [alertControll addAction:save];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControll animated:YES completion:nil];
        }
    }
}

- (void)deleteCouponCard:(CDCouponCard*)coupon
{
    WeakSelf;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"member_id"] = self.member.memberID;
    params[@"coupon_id"] = coupon.cardID;
    DeleteCouponCardRequest* request = [[DeleteCouponCardRequest alloc] init];
    request.params = params;
    [request execute];
    [[CBLoadingView shareLoadingView] show];
    
    request.finished = ^(NSDictionary *params) {
        [[CBLoadingView shareLoadingView] hide];
        if ( [params[@"rc"] integerValue] == 0 )
        {
            coupon.member = nil;
            [[BSCoreDataManager currentManager] deleteObject:coupon];
            [[BSCoreDataManager currentManager] save];
            [weakSelf initMemberAndCouponCards];
            [weakSelf.cardTableView reloadData];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:params[@"rm"]] show];
        }
    };
}

#pragma mark -
#pragma mark PadNumberKeyboardDelegate Methods

- (void)didPadNumberKeyboardDonePressed:(UITextField*)textField
{
    [self didTextFieldEditDone:textField];
}

- (void)didTextFieldEditDone:(UITextField *)textField
{
    PadMemberAndCardViewController *viewController = (PadMemberAndCardViewController *)self.delegate;
    [viewController didTextFieldEditDone:textField];
}

#pragma mark -
#pragma mark PadSelectCardCellDelegate Methods
- (void)didCardQrCodePressedAtIndexPath:(NSIndexPath*)path
{
    CDMemberCard *memberCard = [self.memberCards objectAtIndex:path.row];
    [PopupCardQrCodeView showWithMemberCard:memberCard];
}


- (void)dealloc
{
    
}

@end
