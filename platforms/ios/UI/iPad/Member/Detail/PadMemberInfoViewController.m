//
//  PadMemberInfoViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadMemberInfoViewController.h"
#import "PadProjectConstant.h"
#import "UIImage+Resizable.h"
#import "PadMemberCell.h"
#import "PadCardInfoCell.h"
#import "PadMemberDetailViewController.h"
#import "PadCardProductViewController.h"
#import "PadMemberYiMeiOpereateTableViewCell.h"
#import "YimeiFullScreenPhotoViewController.h"
#import "PadMemberZixunRecordViewController.h"
#import "PadMemberWebViewController.h"

typedef enum kPadMemberAndCardSectionType
{
    kPadMemberAndCardSectionMember,
    kPadMemberAndCardSectionYimei,
    kPadMemberAndCardSectionYimeiCount,
    kPadMemberAndCardSectionCard = 1,
    kPadMemberAndCardSectionCoupon,
    kPadMemberAndCardSectionCount
}kPadMemberAndCardSectionType;

typedef enum kPadMemberInfoRowType
{
    kPadMemberInfoRowAvatar,
    kPadMemberInfoRowCount
}kPadMemberInfoRowType;

typedef enum kPadCardInfoRowType
{
    kPadCardInfoRowCardNumber,
    kPadCardInfoRowOverage,
    kPadCardInfoRowOverdraft,
    kPadCardInfoRowStoreName,
    kPadCardInfoRowRealCardNo,
    kPadCardInfoRowCount,
    kPadCardInfoRowActivation,
}kPadCardInfoRowType;

typedef enum kPadCouponInfoRowType
{
    kPadCouponInfoRowCardNumber,
    kPadCouponInfoRowWorth,
    kPadCouponInfoRowValidity,
    kPadCouponInfoRowTermsOfUse,
    kPadCouponInfoRowCount
}kPadCouponInfoRowType;

@interface PadMemberInfoViewController ()<PadMemberYiMeiOpereateTableViewCellDelegate>

@property (nonatomic, strong) NSMutableDictionary *cachePicParams;

@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong)PersonalProfile* profile;
@property (nonatomic, strong) NSMutableDictionary *expandpParams;

@end


@implementation PadMemberInfoViewController

- (id)init
{
    self = [super initWithNibName:@"PadMemberInfoViewController" bundle:nil];
    if (self)
    {
        self.view.frame = CGRectMake(0.0, 0.0, kPadMemberAndCardInfoWidth, IC_SCREEN_HEIGHT);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profile = [PersonalProfile currentProfile];
    self.expandpParams = [NSMutableDictionary dictionary];
    self.noKeyboardNotification = YES;
    self.cachePicParams = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.infoTableView.backgroundColor = [UIColor clearColor];
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.showsVerticalScrollIndicator = NO;
    self.infoTableView.showsHorizontalScrollIndicator = NO;
    self.infoTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.infoTableView];
    
    [self.infoTableView registerNib: [UINib nibWithNibName: @"PadMemberYiMeiOpereateTableViewCell" bundle: nil] forCellReuseIdentifier:@"PadMemberYiMeiOpereateTableViewCell"];
    
    [self registerNofitificationForMainThread:kBSFetchMemberOperateResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardDetailResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberResponse];

}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberOperateResponse])
    {
        [self.infoTableView reloadData];
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardDetailResponse])
    {
        [self.infoTableView reloadData];
    }
    else if ([notification.name isEqualToString:kBSFetchMemberResponse])
    {
        [self.infoTableView reloadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)clearMember
{
    _member = nil;
}

- (void)setMember:(CDMember *)member
{
    if (member.memberID.integerValue != _member.memberID.integerValue)
    {
        _member = member;
        [self.infoTableView reloadData];
        
        UIViewController *viewController = [self.navigationController.viewControllers lastObject];
        if ([viewController isKindOfClass:[PadMemberDetailViewController class]])
        {
            PadMemberDetailViewController *detailViewController = (PadMemberDetailViewController *)viewController;
            [detailViewController refreshWithMember:_member];
        }
        else if ([viewController isKindOfClass:[PadCardProductViewController class]])
        {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

- (void)setMemberCard:(CDMemberCard *)memberCard
{
    if (memberCard.cardID.integerValue != _memberCard.cardID.integerValue)
    {
        _memberCard = memberCard;
    }
    
    [self.infoTableView reloadData];
    UIViewController *viewController = [self.navigationController.viewControllers lastObject];
    if ([viewController isKindOfClass:[PadCardProductViewController class]])
    {
        PadCardProductViewController *productViewController = (PadCardProductViewController *)viewController;
        [productViewController refreshWithMemberCard:_memberCard];
    }
}

- (void)setCouponCard:(CDCouponCard *)couponCard
{
    if (couponCard.cardID.integerValue != _couponCard.cardID.integerValue)
    {
        _couponCard = couponCard;
        [self.infoTableView reloadData];
        
        UIViewController *viewController = [self.navigationController.viewControllers lastObject];
        if ([viewController isKindOfClass:[PadCardProductViewController class]])
        {
            PadCardProductViewController *productViewController = (PadCardProductViewController *)viewController;
            [productViewController refreshWithCouponCard:_couponCard];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( self.memberCard == nil && self.couponCard == nil && [self.profile.isYiMei boolValue] )
    {
        return kPadMemberAndCardSectionYimeiCount;
    }
    
    return kPadMemberAndCardSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.memberCard == nil && self.couponCard == nil && [self.profile.isYiMei boolValue] )
    {
        if ( section == kPadMemberAndCardSectionYimei )
        {
            return self.member.recentOperates.count;
        }
    }
    
    if (section == kPadMemberAndCardSectionMember)
    {
        if (self.member)
        {
            return kPadMemberInfoRowCount;
        }
    }
    else if (section == kPadMemberAndCardSectionCard)
    {
        if (self.memberCard && self.memberCard.cardNumber.length != 0)
        {
            return kPadCardInfoRowCount;
        }
    }
    else if (section == kPadMemberAndCardSectionCoupon)
    {
        if (self.couponCard && self.couponCard.cardNumber.length != 0)
        {
            return kPadCouponInfoRowCount;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.memberCard == nil && self.couponCard == nil && [self.profile.isYiMei boolValue] )
    {
        if ( indexPath.section == kPadMemberAndCardSectionYimei )
        {
#if 0
            BOOL bIsExpand = [self.expandpParams[@(indexPath.row)] boolValue];
            if ( bIsExpand )
            {
                CDPosOperate* op = self.member.recentOperates[indexPath.row];
                if ( op.yimei_before.count == 0 )
                    return 138;
                
                return 290;
            }
            return 77;
#else
            CDPosOperate* op = self.member.recentOperates[indexPath.row];
            if ( op.yimei_before.count == 0 )
                return 200;
            
            return 360;
#endif
        }
    }
    if (indexPath.section == kPadMemberAndCardSectionMember)
    {
        return kPadMemberCellHeight;
    }
    else if (indexPath.section == kPadMemberAndCardSectionCard || indexPath.section == kPadMemberAndCardSectionCoupon)
    {
        return kPadCardInfoCellHeight;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPadMemberAndCardSectionMember)
    {
        static NSString *CellIdentifier = @"PadMemberCellIdentifier";
        PadMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.member.image_url] placeholderImage:[UIImage imageNamed:@"pad_member_default"]];
       // [cell.avatarImageView setImageWithName:self.member.imageName tableName:@"born.member" filter:self.member.memberID fieldName:@"image" writeDate:self.member.lastUpdate placeholderString:@"pad_member_default" cacheDictionary:self.cachePicParams];
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openWebView)];
//        [cell.avatarImageView addGestureRecognizer:tapGesture];

        [cell.avatarButton addTarget:self action:@selector(openWebView) forControlEvents:UIControlEventTouchUpInside];
        
        cell.nameLabel.text = self.member.memberName;
        cell.phoneLabel.text = @"";
        cell.birthdayLabel.text = @"";
        cell.genderLabel.text = @"";
        if (self.member.mobile.length != 0 && self.member.mobile.length != 1)
        {
            if (self.member.mobile.length == 11)
            {
                cell.phoneLabel.text = [NSString stringWithFormat:@"%@*****%@", [self.member.mobile substringToIndex:3],[self.member.mobile substringFromIndex:8]];
                
                
                //                cell.phoneLabel.text = [NSString stringWithFormat:@"%@***%@",[self.member.mobile substringWithRange:NSMakeRange(0, 3)],[self.member.mobile substringWithRange:NSMakeRange(3, 4)],[self.member.mobile substringWithRange:NSMakeRange(7, 4)]];
            }
            else
            {
                cell.phoneLabel.text = self.member.mobile;
            }
        }
        if (self.member.birthday.length != 0 && self.member.birthday.length != 1)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            NSDate *date = [dateFormatter dateFromString:self.member.birthday];
            dateFormatter.dateFormat = @"yyyy.MM.dd";
            cell.birthdayLabel.text = [dateFormatter stringFromDate:date];
        }
        if ([self.member.gender isEqualToString:@"Male"] || [self.member.gender isEqualToString:@"Female"])
        {
            cell.genderLabel.text = LS(self.member.gender);
        }
        
        return cell;
    }
    else if ( self.memberCard == nil && self.couponCard == nil && indexPath.section == kPadMemberAndCardSectionYimei && [self.profile.isYiMei boolValue] )
    {
        PadMemberYiMeiOpereateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PadMemberYiMeiOpereateTableViewCell"];
        cell.delegate = self;
        
        CDPosOperate* op = self.member.recentOperates[indexPath.row];
        cell.operate = op;
        cell.expand = [self.expandpParams[@(indexPath.row)] boolValue];
        
        return cell;
    }
    else if (indexPath.section == kPadMemberAndCardSectionCard || indexPath.section == kPadMemberAndCardSectionCoupon)
    {
        static NSString *CellIdentifier = @"PadCardInfoCellIdentifier";
        PadCardInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadCardInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.arrowImageView.hidden = YES;
        cell.secondTitleLabel.hidden = YES;
        cell.secondDetailLabel.hidden = YES;
        cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, kPadMemberAndCardInfoWidth - 2 * 66.0, cell.titleLabel.frame.size.height);
        cell.detailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        cell.detailLabel.adjustsFontSizeToFitWidth = NO;
        cell.detailLabel.font = [UIFont systemFontOfSize:24.0];
        cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, 64.0, kPadMemberAndCardInfoWidth - 2 * 66.0, 20.0);
        if (indexPath.section == kPadMemberAndCardSectionCard)
        {
            if (indexPath.row == kPadCardInfoRowCardNumber)
            {
                cell.secondTitleLabel.hidden = NO;
                cell.secondDetailLabel.hidden = NO;
                cell.titleLabel.text = self.memberCard.priceList.name;
                cell.detailLabel.text = self.memberCard.cardNumber;
                cell.secondTitleLabel.text = @"卡内积分";
                cell.secondDetailLabel.text = [NSString stringWithFormat:@"%@", self.memberCard.points];
            }
            else if (indexPath.row == kPadCardInfoRowOverage)
            {
                cell.arrowImageView.hidden = NO;
                cell.secondTitleLabel.hidden = NO;
                cell.secondDetailLabel.hidden = NO;
                cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, (kPadMemberAndCardInfoWidth - 2 * 66.0 - 12.0)/2.0, cell.titleLabel.frame.size.height);
                cell.detailLabel.numberOfLines = 1;
                cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, 64.0, (kPadMemberAndCardInfoWidth - 2 * 66.0 - 12.0)/2.0, 24.0);
                cell.titleLabel.text = LS(@"PadMemberCardOverage");
                cell.detailLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), self.memberCard.amount.floatValue];
                cell.secondTitleLabel.text = LS(@"PadMemberCardItemWorth");
                //cell.secondDetailLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), ceil(self.memberCard.courseRemainAmount.floatValue)];
                cell.secondDetailLabel.text = @"";
            }
            else if (indexPath.row == kPadCardInfoRowOverdraft)
            {
                cell.titleLabel.text = LS(@"PadCardArrears");
                cell.detailLabel.textColor = COLOR(255.0, 110.0, 100.0, 1.0);
                cell.detailLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), self.memberCard.arrearsAmount.floatValue + self.memberCard.courseArrearsAmount.floatValue];
                
                cell.arrowImageView.hidden = NO;
                cell.secondTitleLabel.hidden = NO;
                cell.secondDetailLabel.hidden = NO;
                
                cell.secondTitleLabel.text = @"咨询记录";
            }
            else if (indexPath.row == kPadCardInfoRowStoreName)
            {
                cell.titleLabel.text = LS(@"PadCardStore");
                cell.detailLabel.text = self.memberCard.storeName;
                
                if ( self.memberCard.invalidDate.length > 1 )
                {
                    cell.arrowImageView.hidden = YES;
                    cell.secondTitleLabel.hidden = NO;
                    cell.secondDetailLabel.hidden = NO;
                    
                    cell.secondTitleLabel.text = @"有效期";
                    cell.secondDetailLabel.text = self.memberCard.invalidDate;
                }
            }
            else if (indexPath.row == kPadCardInfoRowRealCardNo)
            {
                cell.titleLabel.text = @"实体卡号";
                cell.detailLabel.text = self.memberCard.default_code.length > 0 ? self.memberCard.default_code : @"无";
                
                if ( self.memberCard.invalidDate.length > 1 )
                {
                    cell.arrowImageView.hidden = YES;
                    cell.secondTitleLabel.hidden = NO;
                    cell.secondDetailLabel.hidden = NO;
                    
                    cell.secondTitleLabel.text = @"";
                    cell.secondDetailLabel.text = @"";
                }
            }
            else if (indexPath.row == kPadCardInfoRowActivation)
            {
                cell.titleLabel.text = LS(@"PadWeCardActiveCode");
                cell.detailLabel.text = self.memberCard.captcha;
            }
        }
        else if (indexPath.section == kPadMemberAndCardSectionCoupon)
        {
            if (indexPath.row == kPadCouponInfoRowCardNumber)
            {
                cell.titleLabel.text = LS(@"PadGiftCardNumber");
                cell.detailLabel.text = self.couponCard.cardNumber;
            }
            else if (indexPath.row == kPadCouponInfoRowWorth)
            {
                cell.arrowImageView.hidden = NO;
                cell.secondTitleLabel.hidden = NO;
                cell.secondDetailLabel.hidden = NO;
                cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, (kPadMemberAndCardInfoWidth - 2 * 66.0 - 12.0)/2.0, cell.titleLabel.frame.size.height);
                cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, 64.0, (kPadMemberAndCardInfoWidth - 2 * 66.0 - 12.0)/2.0, 24.0);
                
                cell.titleLabel.text = LS(@"PadGiftCardAmount");
                cell.detailLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), self.couponCard.remainAmount.floatValue];
                //cell.detailLabel.text = @"";
                //cell.secondTitleLabel.text = LS(@"PadGiftCardItemWorth");
                //cell.secondDetailLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), self.couponCard.courseRemainAmount.floatValue];
            }
            else if (indexPath.row == kPadCouponInfoRowValidity)
            {
                cell.titleLabel.text = LS(@"PadGiftCardValidity");
                cell.detailLabel.text = self.couponCard.invalidDate;
                
                cell.arrowImageView.hidden = NO;
                cell.secondTitleLabel.hidden = NO;
                cell.secondDetailLabel.hidden = NO;
                
                cell.secondTitleLabel.text = @"咨询记录";
            }
            else if (indexPath.row == kPadCouponInfoRowTermsOfUse)
            {
                cell.titleLabel.text = LS(@"PadGiftCardTermsOfUse");
                cell.detailLabel.numberOfLines = 0;
                cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, 52.0, kPadMemberAndCardInfoWidth - 2 * 66.0, kPadCardInfoCellHeight - cell.detailLabel.frame.origin.y);
                cell.detailLabel.font = [UIFont systemFontOfSize:17.0];
                cell.detailLabel.adjustsFontSizeToFitWidth = YES;
                cell.detailLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
                cell.detailLabel.minimumScaleFactor = 14.0/17.0;
                cell.detailLabel.text = self.couponCard.remark;
            }
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.memberCard == nil && self.couponCard == nil && [self.profile.isYiMei boolValue] )
    {
        if ( indexPath.section == kPadMemberAndCardSectionYimei )
        {
            self.expandpParams[@(indexPath.row)] = @(![self.expandpParams[@(indexPath.row)] boolValue]);
            [self.infoTableView reloadData];
            return;
        }
    }
    
    if (indexPath.section == kPadMemberAndCardSectionMember)
    {
        PadMemberDetailViewController *detailViewController = [[PadMemberDetailViewController alloc] initWithMember:self.member];
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    }
    else if (indexPath.section == kPadMemberAndCardSectionCard && indexPath.row == kPadCardInfoRowOverage)
    {
        PadCardProductViewController *productViewController = [[PadCardProductViewController alloc] initWithMemberCard:self.memberCard];
        [self.navigationController pushViewController:productViewController animated:YES];
    }
    else if (indexPath.section == kPadMemberAndCardSectionCard && indexPath.row == kPadCardInfoRowOverdraft)
    {
        PadMemberZixunRecordViewController *zixunRecordViewController = [[PadMemberZixunRecordViewController alloc] initWithMember:self.member];
        [self.navigationController pushViewController:zixunRecordViewController animated:YES];
        NSLog(@"Selected");
    }
    else if (indexPath.section == kPadMemberAndCardSectionCoupon && indexPath.row == kPadCouponInfoRowWorth)
    {
        PadCardProductViewController *productViewController = [[PadCardProductViewController alloc] initWithCouponCard:self.couponCard];
        [self.navigationController pushViewController:productViewController animated:YES];
    }
    else if (indexPath.section == kPadMemberAndCardSectionCoupon && indexPath.row == kPadCouponInfoRowValidity)
    {
        PadMemberZixunRecordViewController *zixunRecordViewController = [[PadMemberZixunRecordViewController alloc] initWithMember:self.member];
        [self.navigationController pushViewController:zixunRecordViewController animated:YES];
        NSLog(@"Selected");
    }
}

- (void)didPhotoButtonPressed:(PadMemberYiMeiOpereateTableViewCell*)cell
{
    NSMutableArray* array = [NSMutableArray array];
    NSIndexPath* path = [self.infoTableView indexPathForCell:cell];
    CDPosOperate* op = self.member.recentOperates[path.row];
    for ( CDYimeiImage* image in op.yimei_before )
    {
        if ([image.take_time isEqualToString:@"before"]) {
            [array addObject:image.url];
        }
    }
    YimeiFullScreenPhotoViewController* vc = [[YimeiFullScreenPhotoViewController alloc] initWithNibName:@"YimeiFullScreenPhotoViewController" bundle:nil];
    vc.photos = array;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
}

// 术后照被点开 查看
- (void)didAfterPhotoButtonPressed:(PadMemberYiMeiOpereateTableViewCell*)cell {
    NSMutableArray* array = [NSMutableArray array];
    NSIndexPath* path = [self.infoTableView indexPathForCell:cell];
    CDPosOperate* op = self.member.recentOperates[path.row];
    for ( CDYimeiImage* image in op.yimei_before )
    {
        if ([image.take_time isEqualToString:@"after"]) {
            [array addObject:image.url];
        }
    }
    YimeiFullScreenPhotoViewController* vc = [[YimeiFullScreenPhotoViewController alloc] initWithNibName:@"YimeiFullScreenPhotoViewController" bundle:nil];
    vc.photos = array;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
}

- (void)reloadData
{
    [self.infoTableView reloadData];
}

- (void)openWebView
{
    PadMemberWebViewController *memberWebViewController = [[PadMemberWebViewController alloc] initWithMemberCard:self.memberCard];
    NSLog(@"%@",self.parentVC.navigationController);
    [self.parentVC.navigationController pushViewController:memberWebViewController animated:YES];
    
}

@end
