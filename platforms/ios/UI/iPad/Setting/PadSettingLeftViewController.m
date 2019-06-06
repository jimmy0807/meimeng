//
//  PadSettingLeftViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSettingLeftViewController.h"
#import "PadSettingViewController.h"
#import "NSObject+MainThreadNotification.h"
#import "PersonalProfile.h"
//#import "meim-Swift.h"
#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif
#define kPadSettingCellHeight       72.0
#define kPadSettingSectionHeight    24.0

typedef enum kPadSettingSectionType
{
    kPadSettingSectionPos,
    kPadSettingSectionHardware,
    kPadSettingSectionPayAccount,
    kPadSettingSectionPosAccount,
    kPadSettingSectionCount
}kPadSettingSectionType;

typedef enum kPadSettingPosRowType
{
    kPadSettingPosHandNumber,
    kPadSettingPosFreeCombination,
    kPadSettingBlueToothKeyBoard,
    kPadSettingMultiKeshi,
    kPadSettingPosRowCount
}kPadSettingPosRowType;

typedef enum kPadSettingHardwareRowType
{
    kPadSettingHardwarePrinter,
    kPadSettingHardwareCodeScanner,
    kPadSettingHardwarePosMachine,
    
    //kPadSettingHardwareHandWriteBook,
    kPadSettingHardwareCamera,
     kPadSettingHardwareRowCount//手写本修改：交换kPadSettingHardwareRowCount/kPadSettingHardwareHandWriteBook就看得见
    
}kPadSettingHardwareRowType;

typedef enum kPadSettingPayAccountRowType
{
    kPadSettingPayAccount,
    kPadSettingPayAccountRowCount
}kPadSettingPayAccountRowType;

typedef enum kPadSettingPosAccountRowType
{
    kPadSettingPosAccount,
    kPadSettingPosAccountRowCount
}kPadSettingPosAccountRowType;


@interface PadSettingLeftViewController ()

@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, assign) kPadSettingDetailType selectedType;

@end

@implementation PadSettingLeftViewController

- (id)initWithDelegate:(id<PadSettingLeftViewControllerDelegate>)delegate
{
    self = [super initWithNibName:@"PadSettingLeftViewController" bundle:nil];
    if (self)
    {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    self.view.bounds = CGRectMake(0.0, 0.0, kPadSettingLeftSideViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSPadDidHandNumberChange];
    [self registerNofitificationForMainThread:kBSPadDidFreeCombinationChange];
    [self registerNofitificationForMainThread:kBSPadDidBlueToothKeyBoardChange];
    [self registerNofitificationForMainThread:@"kBSPadDidMultiKeshiChange"];
    
    
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSettingLeftSideViewWidth, kPadNaviHeight)];
    navi.backgroundColor = [UIColor whiteColor];
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIImage *backImage;
    if (self.viewType == kPadSettingViewDefault)
    {
        backImage = [UIImage imageNamed:@"common_menu_icon"];
    }
    else if (self.viewType == kPadSettingViewPosMachine || self.viewType == kPadSettingViewPayAccount)
    {
        backImage = [UIImage imageNamed:@"pad_navi_back_n"];
    }
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setImage:backImage forState:UIControlStateHighlighted];
    if (self.viewType == kPadSettingViewDefault)
    {
        [backButton setImageEdgeInsets:UIEdgeInsetsMake((kPadNaviHeight - backImage.size.height)/2.0, (kPadNaviHeight - backImage.size.width)/2.0, (kPadNaviHeight - backImage.size.height)/2.0, (kPadNaviHeight - backImage.size.width)/2.0)];
    }
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, kPadSettingLeftSideViewWidth - 2 * kPadNaviHeight, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadSetting");
    [navi addSubview:titleLabel];
    
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, kPadSettingLeftSideViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight) style:UITableViewStylePlain];
    self.settingTableView.backgroundColor = [UIColor clearColor];
    self.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    self.settingTableView.showsVerticalScrollIndicator = NO;
    self.settingTableView.showsHorizontalScrollIndicator = NO;
    self.settingTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.settingTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Required Methods

- (void)setViewType:(kPadSettingViewType)viewType
{
    _viewType = viewType;
    if (_viewType == kPadSettingViewPosMachine)
    {
        [self tableView:self.settingTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:kPadSettingHardwarePosMachine inSection:kPadSettingSectionHardware]];
    }
    else if (_viewType == kPadSettingViewPayAccount)
    {
        [self tableView:self.settingTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPadSettingSectionPayAccount]];
    }
    else if (_viewType == kPadSettingViewPosAccount)
    {
        [self tableView:self.settingTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kPadSettingSectionPosAccount]];
    }
}

- (void)didBackButtonClick:(id)sender
{
    if (self.viewType == kPadSettingViewDefault)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(backHomeLeftSideBar)])
        {
            [self.delegate backHomeLeftSideBar];
        }
    }
    else if (self.viewType == kPadSettingViewPosMachine || self.viewType == kPadSettingViewPayAccount)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(backPaymentView)])
        {
            [self.delegate backPaymentView];
        }
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSPadDidHandNumberChange])
    {
        UITableViewCell *cell = [self.settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kPadSettingPosHandNumber inSection:kPadSettingSectionPos]];
        UILabel *detailLabel = [cell.contentView viewWithTag:102];
        if ([PersonalProfile currentProfile].isUseHandNumber.boolValue)
        {
            detailLabel.text = LS(@"kPadSettingOpen");
        }
        else
        {
            detailLabel.text = LS(@"kPadSettingClose");
        }
    }
    else if ([notification.name isEqualToString:kBSPadDidFreeCombinationChange])
    {
        UITableViewCell *cell = [self.settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kPadSettingPosFreeCombination inSection:kPadSettingSectionPos]];
        UILabel *detailLabel = [cell.contentView viewWithTag:102];
        if ([PersonalProfile currentProfile].isFreeCombination.boolValue)
        {
            detailLabel.text = LS(@"kPadSettingOpen");
        }
        else
        {
            detailLabel.text = LS(@"kPadSettingClose");
        }
    }
    else if ([notification.name isEqualToString:kBSPadDidBlueToothKeyBoardChange])
    {
        UITableViewCell *cell = [self.settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kPadSettingBlueToothKeyBoard inSection:kPadSettingSectionPos]];
        UILabel *detailLabel = [cell.contentView viewWithTag:102];
        if ([PersonalProfile currentProfile].useBlueToothKeyBoard)
        {
            detailLabel.text = LS(@"kPadSettingOpen");
        }
        else
        {
            detailLabel.text = LS(@"kPadSettingClose");
        }
    }
    else if ([notification.name isEqualToString:@"kBSPadDidMultiKeshiChange"])
    {
        UITableViewCell *cell = [self.settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kPadSettingMultiKeshi inSection:kPadSettingSectionPos]];
        UILabel *detailLabel = [cell.contentView viewWithTag:102];
        if ([[PersonalProfile currentProfile].multiKeshiSetting intValue] == 0)
        {
            detailLabel.text = @"服务器";
        }
        else if ([[PersonalProfile currentProfile].multiKeshiSetting intValue] == 1)
        {
            detailLabel.text = @"单科室";
        }
        else if ([[PersonalProfile currentProfile].multiKeshiSetting intValue] == 2)
        {
            detailLabel.text = @"多科室";
        }
    }
    
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kPadSettingSectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kPadSettingSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSettingLeftSideViewWidth, kPadSettingSectionHeight)];
    headerView.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, kPadSettingLeftSideViewWidth - 2 * 20.0, kPadSettingSectionHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    titleLabel.textColor = COLOR(154.0, 156.0, 156.0, 1.0);
    [headerView addSubview:titleLabel];
    
    if (section == kPadSettingSectionPos)
    {
        titleLabel.text = LS(@"PadSettingPos");
    }
    else if (section == kPadSettingSectionHardware)
    {
        titleLabel.text = LS(@"PadSettingHardware");
    }
    else if (section == kPadSettingSectionPayAccount)
    {
        titleLabel.text = LS(@"PadSettingPayAccount");
    }
    else if (section == kPadSettingSectionPosAccount)
    {
        titleLabel.text = LS(@"PadSettingPosAccount");
    }
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPadSettingSectionPos)
    {
        return kPadSettingPosRowCount;
    }
    else if (section == kPadSettingSectionHardware)
    {
        return kPadSettingHardwareRowCount;
    }
    else if(section == kPadSettingSectionPayAccount)
    {
        return kPadSettingPayAccountRowCount;
    }
    else if (section == kPadSettingSectionPosAccount)
    {
        return kPadSettingPosAccountRowCount;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadSettingCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadSettingCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, (kPadSettingCellHeight - 20.0)/2.0, (kPadSettingLeftSideViewWidth - 2 * 20.0)/2.0, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        titleLabel.tag = 101;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0 + (kPadSettingLeftSideViewWidth - 2 * 20.0)/2.0, (kPadSettingCellHeight - 20.0)/2.0, (kPadSettingLeftSideViewWidth - 2 * 20.0)/2.0, 20.0)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.font = [UIFont systemFontOfSize:16.0];
        detailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        detailLabel.tag = 102;
        [cell.contentView addSubview:detailLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadSettingCellHeight - 0.5, kPadSettingLeftSideViewWidth, 1.0)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
        [cell.contentView addSubview:lineImageView];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:102];
    
    detailLabel.text = @"";
    kPadSettingDetailType type = kPadSettingDetailDefault;
    if (indexPath.section == kPadSettingSectionPos)
    {
        if (indexPath.row == kPadSettingPosHandNumber)
        {
            type = kPadSettingDetailHandNumber;
            titleLabel.text = LS(@"kPadSettingHandNumber");
            if ([PersonalProfile currentProfile].isUseHandNumber.boolValue)
            {
                detailLabel.text = LS(@"kPadSettingOpen");
            }
            else
            {
                detailLabel.text = LS(@"kPadSettingClose");
            }
        }
        else if (indexPath.row == kPadSettingPosFreeCombination)
        {
            type = kPadSettingDetailFreeCombination;
            titleLabel.text = LS(@"kPadSettingFreeCombination");
            if ([PersonalProfile currentProfile].isFreeCombination.boolValue)
            {
                detailLabel.text = LS(@"kPadSettingOpen");
            }
            else
            {
                detailLabel.text = LS(@"kPadSettingClose");
            }
        }
        else if (indexPath.row == kPadSettingBlueToothKeyBoard)
        {
            type = kPadSettingDetailBlueToothKeyBoard;
            titleLabel.text = @"使用蓝牙键盘";
            if ([PersonalProfile currentProfile].useBlueToothKeyBoard )
            {
                detailLabel.text = LS(@"kPadSettingOpen");
            }
            else
            {
                detailLabel.text = LS(@"kPadSettingClose");
            }
        }
        else if (indexPath.row == kPadSettingMultiKeshi)
        {
            type = kPadSettingDetailMultiKeshi;
            titleLabel.text = @"多科室设置";
            if ([PersonalProfile currentProfile].multiKeshiSetting.intValue == 0)
            {
                detailLabel.text = @"服务器";
            }
            else if ([PersonalProfile currentProfile].multiKeshiSetting.intValue == 1)
            {
                detailLabel.text = @"单科室";
            }
            else if ([PersonalProfile currentProfile].multiKeshiSetting.intValue == 2)
            {
                detailLabel.text = @"多科室";
            }
        }
    }
    else if (indexPath.section == kPadSettingSectionHardware)
    {
        if (indexPath.row == kPadSettingHardwarePrinter)
        {
            type = kPadSettingDetailPrinter;
            titleLabel.text = LS(@"kPadSettingPrinter");
        }
        else if (indexPath.row == kPadSettingHardwareCodeScanner)
        {
            type = kPadSettingDetailCodeScanner;
            titleLabel.text = LS(@"kPadSettingCodeScanner");
        }
        else if (indexPath.row == kPadSettingHardwarePosMachine)
        {
            type = kPadSettingDetailPosMachine;
            titleLabel.text = LS(@"kPadSettingPosMachine");
        }
        
//        else if (indexPath.row == kPadSettingHardwareHandWriteBook)
//        {
//            type = kPadSettingDetailHandWriteBook;
//            titleLabel.text = LS(@"kPadSettingHandWriteBook");
//        }
        else if (indexPath.row == kPadSettingHardwareCamera)
        {
            type = kPadSettingDetailCamera;
            titleLabel.text = LS(@"kPadSettingCamera");
        }
    }
    else if (indexPath.section == kPadSettingSectionPayAccount)
    {
        if (indexPath.row == kPadSettingPayAccount)
        {
            type = kPadSettingDetailPayAccount;
            titleLabel.text = LS(@"PadSettingPayAccount");
        }
    }
    else if (indexPath.section == kPadSettingSectionPosAccount)
    {
        if (indexPath.row == kPadSettingPosAccount)
        {
            type = kPadSettingDetailPosAccount;
            if ([[PersonalProfile currentProfile] userName].length != 0)
            {
                titleLabel.text = [[PersonalProfile currentProfile] userName];
            }
            else
            {
                titleLabel.text = @"";
            }
        }
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    detailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    if (self.selectedType == type)
    {
        cell.backgroundColor = COLOR(96.0, 211.0, 212.0, 1.0);
        cell.contentView.backgroundColor = COLOR(96.0, 211.0, 212.0, 1.0);
        titleLabel.textColor = [UIColor whiteColor];
        detailLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadSettingDetailWithType:)])
    {
        kPadSettingDetailType type = kPadSettingPosFreeCombination;
        if (indexPath.section == kPadSettingSectionPos)
        {
            if (indexPath.row == kPadSettingPosHandNumber)
            {
                type = kPadSettingDetailHandNumber;
            }
            else if (indexPath.row == kPadSettingPosFreeCombination)
            {
                type = kPadSettingDetailFreeCombination;
            }
            else if (indexPath.row == kPadSettingBlueToothKeyBoard)
            {
                type = kPadSettingDetailBlueToothKeyBoard;
            }
            else if (indexPath.row == kPadSettingMultiKeshi)
            {
                type = kPadSettingDetailMultiKeshi;
            }
        }
        else if (indexPath.section == kPadSettingSectionHardware)
        {
            if (indexPath.row == kPadSettingHardwarePrinter)
            {
                type = kPadSettingDetailPrinter;
            }
            else if (indexPath.row == kPadSettingHardwareCodeScanner)
            {
                type = kPadSettingDetailCodeScanner;
            }
            else if (indexPath.row == kPadSettingHardwarePosMachine)
            {
                type = kPadSettingDetailPosMachine;
            }
//            else if (indexPath.row == kPadSettingHardwareHandWriteBook)
//            {
//                type = kPadSettingDetailHandWriteBook;
//            }
            else if (indexPath.row == kPadSettingHardwareCamera)
            {
                type = kPadSettingDetailCamera;
            }
        }
        else if (indexPath.section == kPadSettingSectionPayAccount)
        {
            if (indexPath.row == kPadSettingPayAccount)
            {
                type = kPadSettingDetailPayAccount;
            }
        }
        else if (indexPath.section == kPadSettingSectionPosAccount)
        {
            if (indexPath.row == kPadSettingPosAccount)
            {
                type = kPadSettingDetailPosAccount;
            }
        }
        
        if (self.selectedType == kPadSettingDetailCamera) {
            if (self.selectedType != type && ![PersonalProfile currentProfile].isCameraSelected && [PersonalProfile currentProfile].cameraName != nil)
            {
                UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"请配置网络！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertControll addAction:okAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControll animated:YES completion:nil];
                return;
            }
        }
        
        ///进入手写本界面
//        if (indexPath.row == kPadSettingHardwareHandWriteBook && indexPath.section == kPadSettingSectionHardware) {
//            if (self.selectedType != type)
//            {
//                self.selectedType = type;
//                [tableView reloadData];
//                [self.delegate showHandWriteBookVC];
//            }
//
//
//        }
//        else{
            if (self.selectedType != type)
            {
                self.selectedType = type;
                [tableView reloadData];
                [self.delegate reloadSettingDetailWithType:self.selectedType];
            }
//        }
        
    }
}

@end
