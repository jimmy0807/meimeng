//
//  PadMemberDetailViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadMemberDetailViewController.h"
#import "PadProjectConstant.h"
#import "PadMemberDetailCell.h"
#import "PadMemberRelativesCell.h"
#import "PadMemberConsumesCell.h"

typedef enum kPadMemberDetailSectionType
{
    kPadMemberDetailSectionInfo,
    kPadMemberDetailSectionRelatives,
    kPadMemberDetailSectionCount,
    kPadMemberDetailSectionConsumes,
}kPadMemberDetailSectionType;

typedef enum kPadMemberInfoRowType
{
    kPadMemberInfoRowIDNumber,
    kPadMemberInfoRowAddress,
    kPadMemberInfoRowGuwen,
    kPadMemberInfoRowShejishi,
    kPadMemberInfoRowShejizongjian,
    kPadMemberInfoRowSource,
    kPadMemberInfoRowMemberType,
    kPadMemberInfoRowEmail,
    kPadMemberInfoRowCount,
    kPadMemberInfoRowDianjia,
    kPadMemberInfoRowDudao,
    kPadMemberInfoRowDailishang,
    kPadMemberInfoRowJobTitle,
    kPadMemberInfoRowQQ,
    kPadMemberInfoRowWeiXin,
}kPadMemberInfoRowType;

@interface PadMemberDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSArray *relatives;
@property (nonatomic, strong) NSArray *recentOperates;
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) PersonalProfile *profile;

@end

@implementation PadMemberDetailViewController

- (id)initWithMember:(CDMember *)member
{
    self = [super initWithNibName:@"PadMemberDetailViewController" bundle:nil];
    if (self)
    {
        self.member = member;
        self.relatives = [[BSCoreDataManager currentManager] fetchMemberQinyouWithMember:self.member];
        self.recentOperates = self.member.recentOperates.array;
        self.view.frame = CGRectMake(0.0, 0.0, kPadMemberAndCardInfoWidth, IC_SCREEN_HEIGHT);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self registerNofitificationForMainThread:kBSFetchMemberQinyouResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberOperateResponse];
    [self registerNofitificationForMainThread:kPadEditMemberFinish];
    
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight) style:UITableViewStylePlain];
    self.detailTableView.backgroundColor = [UIColor clearColor];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.showsVerticalScrollIndicator = NO;
    self.detailTableView.showsHorizontalScrollIndicator = NO;
    self.detailTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.detailTableView];
    
    UIImageView *naviImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, kPadNaviHeight + 3.0)];
    naviImageView.backgroundColor = [UIColor clearColor];
    naviImageView.image = [UIImage imageNamed:@"pad_navi_background"];
    naviImageView.userInteractionEnabled = YES;
    [self.view addSubview:naviImageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0.0, 0.0, 2 * 66.0, kPadNaviHeight);
    UIImage *backImage = [UIImage imageNamed:@"pad_navi_back_n"];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(66.0 - kPadNaviHeight + 20.0, 0.0, kPadNaviHeight, kPadNaviHeight)];
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.image = backImage;
    [backButton addSubview:backImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, 0.0, 66.0, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = COLOR(148.0, 172.0, 172.0, 1.0);
    titleLabel.text = LS(@"PadMemberPersonalInfo");
    [backButton addSubview:titleLabel];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [naviImageView addSubview:backButton];
    
    UIButton* editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.backgroundColor = [UIColor clearColor];
    editButton.frame = CGRectMake(kPadMemberAndCardInfoWidth - 100, 0, 100, kPadNaviHeight);
    [editButton setTitleColor:COLOR(148.0, 172.0, 172.0, 1.0) forState:UIControlStateNormal];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(didEditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [naviImageView addSubview:editButton];
    
    self.profile = [PersonalProfile currentProfile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didEditButtonClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPadEditMemberNotification object:self.member userInfo:nil];
}

#pragma mark -
#pragma mark Required Methods

- (void)refreshWithMember:(CDMember *)member
{
    if (self.member.memberID.integerValue != member.memberID.integerValue)
    {
        self.member = member;
        self.relatives = [[BSCoreDataManager currentManager] fetchMemberQinyouWithMember:self.member];
        self.recentOperates = self.member.recentOperates.array;
        [self.detailTableView reloadData];
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberQinyouResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.relatives = [[BSCoreDataManager currentManager] fetchMemberQinyouWithMember:self.member];
            [self.detailTableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberOperateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.recentOperates = self.member.recentOperates.array;
            [self.detailTableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kPadEditMemberFinish])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self.detailTableView reloadData];
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kPadMemberDetailSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPadMemberDetailSectionInfo)
    {
        return [self.profile.isYiMei boolValue] ? kPadMemberInfoRowCount : (kPadMemberInfoRowSource + 1);
    }
    else if (section == kPadMemberDetailSectionRelatives)
    {
        return self.relatives.count;
    }
    else if (section == kPadMemberDetailSectionConsumes)
    {
        return self.recentOperates.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadMemberDetailCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPadMemberDetailSectionInfo)
    {
        static NSString *CellIdentifier = @"PadMemberDetailCellIdentifier";
        PadMemberDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadMemberDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.detailLabel.text = @"";
        if (indexPath.row == kPadMemberInfoRowJobTitle)
        {
            cell.titleLabel.text = LS(@"PadMemberInfoJobTitle");
            if (self.member.member_title_name.length != 0 && ![self.member.member_title_name isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.member_title_name;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowQQ)
        {
            cell.titleLabel.text = LS(@"PadMemberInfoQQ");
            if (self.member.member_qq.length != 0 && ![self.member.member_qq isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.member_qq;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowWeiXin)
        {
            cell.titleLabel.text = LS(@"PadMemberInfoWeiXin");
            if (self.member.member_wx.length != 0 && ![self.member.member_wx isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.member_wx;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowEmail)
        {
            cell.titleLabel.text = LS(@"PadMemberInfoEmail");
            if (self.member.email.length != 0 && ![self.member.email isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.email;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowIDNumber)
        {
            cell.titleLabel.text = LS(@"PadMemberInfoIDNumber");
            if (self.member.idCardNumber.length != 0 && ![self.member.idCardNumber isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.idCardNumber;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowAddress)
        {
            cell.titleLabel.text = LS(@"PadMemberInfoAddress");
            if (self.member.member_address.length != 0 && ![self.member.member_address isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.member_address;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowGuwen)
        {
            cell.titleLabel.text = @"顾问";
            if (self.member.employee_name.length != 0 && ![self.member.employee_name isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.employee_name;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowShejishi)
        {
            cell.titleLabel.text = @"设计师";
            if (self.member.member_shejishi_name.length != 0 && ![self.member.member_shejishi_name isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.member_shejishi_name;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowShejizongjian)
        {
            cell.titleLabel.text = @"设计总监";
            if (self.member.director_employee.length != 0 && ![self.member.director_employee isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.director_employee;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowSource)
        {
            cell.titleLabel.text = @"客户来源";
            if (self.member.member_source.length != 0 && ![self.member.member_source isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.member_source;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowMemberType )
        {
            cell.titleLabel.text = @"客户类型";
            if (self.member.yimei_member_type.length != 0 && ![self.member.yimei_member_type isEqualToString:@"0"])
            {
                if ( [self.member.yimei_member_type isEqualToString:@"pt"] )
                {
                    cell.detailLabel.text = @"PT";
                }
                else if ( [self.member.yimei_member_type isEqualToString:@"wip"] )
                {
                    cell.detailLabel.text = @"WIP";
                }
                else if ( [self.member.yimei_member_type isEqualToString:@"dd"] )
                {
                    cell.detailLabel.text = @"DD";
                }
                else if ( [self.member.yimei_member_type isEqualToString:@"dl"] )
                {
                    cell.detailLabel.text = @"DL";
                }
                else if ( [self.member.yimei_member_type isEqualToString:@"yg"] )
                {
                    cell.detailLabel.text = @"YG";
                }
                else if ( [self.member.yimei_member_type isEqualToString:@"vip"] )
                {
                    cell.detailLabel.text = @"VIP";
                }
                else if ( [self.member.yimei_member_type isEqualToString:@"dj"] )
                {
                    cell.detailLabel.text = @"DJ";
                }
                else if ( [self.member.yimei_member_type isEqualToString:@"dq"] )
                {
                    cell.detailLabel.text = @"DQ";
                }
            }
        }
        else if (indexPath.row == kPadMemberInfoRowDianjia)
        {
            cell.titleLabel.text = @"DJ";
            if (self.member.dj_partner.length != 0 && ![self.member.dj_partner isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.dj_partner;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowDudao)
        {
            cell.titleLabel.text = @"DD";
            if (self.member.dd_partner.length != 0 && ![self.member.dd_partner isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.dd_partner;
            }
        }
        else if (indexPath.row == kPadMemberInfoRowDailishang)
        {
            cell.titleLabel.text =@"DL";
            if (self.member.dl_partner.length != 0 && ![self.member.dl_partner isEqualToString:@"0"])
            {
                cell.detailLabel.text = self.member.dl_partner;
            }
        }
        
        return cell;
    }
    else if (indexPath.section == kPadMemberDetailSectionRelatives)
    {
        static NSString *CellIdentifier = @"PadMemberRelativesCellIdentifier";
        PadMemberRelativesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadMemberRelativesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.titleLabel.hidden = YES;
        cell.dividerLineView.frame = CGRectMake(66.0 + 120.0, cell.dividerLineView.frame.origin.y, kPadMemberAndCardInfoWidth - 2 * 66.0 - 120.0, cell.dividerLineView.frame.size.height);
        if (indexPath.row == 0)
        {
            cell.titleLabel.hidden = NO;
            cell.titleLabel.text = LS(@"PadMemberInfoRelatives");
        }
        else if (indexPath.row == self.relatives.count - 1)
        {
            cell.dividerLineView.frame = CGRectMake(66.0, cell.dividerLineView.frame.origin.y, kPadMemberAndCardInfoWidth - 2 * 66.0, cell.dividerLineView.frame.size.height);
        }
        
        CDMemberQinyou *relative = [self.relatives objectAtIndex:indexPath.row];
        cell.nameLabel.text = relative.name;
        cell.phoneLabel.text = relative.telephone;
        
        return cell;
    }
    else if (indexPath.section == kPadMemberDetailSectionConsumes)
    {
        static NSString *CellIdentifier = @"PadMemberConsumesCellIdentifier";
        PadMemberConsumesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadMemberConsumesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.titleLabel.hidden = YES;
        cell.dividerLineView.frame = CGRectMake(66.0 + 120.0, cell.dividerLineView.frame.origin.y, kPadMemberAndCardInfoWidth - 2 * 66.0 - 120.0, cell.dividerLineView.frame.size.height);
        if (indexPath.row == 0)
        {
            cell.titleLabel.hidden = NO;
            cell.titleLabel.text = LS(@"PadMemberInfoOperates");
        }
        else if (indexPath.row == self.recentOperates.count - 1)
        {
            cell.dividerLineView.frame = CGRectMake(66.0, cell.dividerLineView.frame.origin.y, kPadMemberAndCardInfoWidth - 2 * 66.0, cell.dividerLineView.frame.size.height);
        }
        
        CDPosOperate *operate = [self.recentOperates objectAtIndex:indexPath.row];
        cell.cardLabel.text = operate.card_name;
        cell.typeLabel.text = LS(operate.type);
        cell.amountLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), operate.nowAmount.floatValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *operateDate = [dateFormatter dateFromString:operate.operate_date];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
        cell.dateTimeLabel.text = [dateFormatter stringFromDate:operateDate];
        
        return cell;
    }
    
    return nil;
}

@end

