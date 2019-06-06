//
//  PadAccountViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/12/9.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadAccountViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "PadAccountConstant.h"
#import "BSFetchUsers.h"
#import "BSLogoutRequest.h"
#import "UIImage+Resizable.h"
#import "NSObject+MainThreadNotification.h"
#import "PadLoginViewController.h"
#import "CBRotateNavigationController.h"

@interface PadAccountViewController ()

@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) PersonalProfile *profile;
@property (nonatomic, strong) CDUser *userinfo;

@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITableView *accountTableView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation PadAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self forbidSwipGesture];
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSFetchUsersResponse];
    
    self.profile = [PersonalProfile currentProfile];
    self.userinfo = [[BSCoreDataManager currentManager] findEntity:@"CDUser" withValue:self.profile.userID forKey:@"user_id"];
    self.accounts = [[BSCoreDataManager currentManager] fetchChangedUsersWithCurrentUserID:self.profile.userID];
    BSFetchUsers *request = [[BSFetchUsers alloc] init];
    [request execute];
    
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kPadAccountContentWidth, 0.0, kPadAccountSideViewWidth, IC_SCREEN_HEIGHT)];
    rightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightView];
    
    self.accountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, kPadAccountSideViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight) style:UITableViewStylePlain];
    self.accountTableView.backgroundColor = [UIColor clearColor];
    self.accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.accountTableView.delegate = self;
    self.accountTableView.dataSource = self;
    self.accountTableView.showsVerticalScrollIndicator = NO;
    self.accountTableView.showsHorizontalScrollIndicator = NO;
    self.accountTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [rightView addSubview:self.accountTableView];
    
    [self initContentScrollView];
    [self initNaviBar];
}

- (void)initContentScrollView
{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(14.5, kPadNaviHeight, kPadAccountContentWidth - 2 * 14.5, IC_SCREEN_HEIGHT - kPadNaviHeight)];
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    self.contentScrollView.scrollEnabled = YES;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height + 4.0);
    [self.view addSubview:self.contentScrollView];
    
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 16.0, self.contentScrollView.frame.size.width, 2 * self.contentScrollView.frame.size.height)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.image = [[UIImage imageNamed:@"pad_project_background_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    contentView.tag = 101;
    [self.contentScrollView addSubview:contentView];
    
    UIImageView *tipsBackground = [[UIImageView alloc] initWithFrame:CGRectMake(1.5, 0.0, 96.0, 24.0)];
    tipsBackground.backgroundColor = [UIColor clearColor];
    tipsBackground.image = [[UIImage imageNamed:@"pad_project_tips"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    [contentView addSubview:tipsBackground];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, 96.0 - 2 * 8.0, 24.0)];
    tipsLabel.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"pad_project_tips"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 32.0, 12.0, 32.0)]];
    tipsLabel.numberOfLines = 1;
    tipsLabel.font = [UIFont systemFontOfSize:12.0];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor whiteColor];
    NSArray *localPosOperate = [[BSCoreDataManager currentManager] fetchLocalPosOperates:@"operate_date"];
    tipsLabel.text = [NSString stringWithFormat:LS(@"PadAccountCurrentPosOperate"), localPosOperate.count];
    [tipsBackground addSubview:tipsLabel];
    
    CGSize minSize = [tipsLabel.text sizeWithFont:tipsLabel.font constrainedToSize:CGSizeMake(1024.0, tipsLabel.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat maxWidth = minSize.width;
    if (maxWidth + 16.0 >= 96.0)
    {
        maxWidth = 96.0 - 16.0;
    }
    tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, tipsLabel.frame.origin.y, maxWidth, tipsLabel.frame.size.height);
    tipsBackground.frame = CGRectMake(tipsBackground.frame.origin.x, tipsBackground.frame.origin.y, maxWidth + 16.0, tipsBackground.frame.size.height);
    
    CGFloat originX = 68.5;
    CGFloat contentWidth = kPadAccountContentWidth - 2 * 14.5 - 2 * 68.5;
    CGFloat originY = 40.0 + 32.0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, (contentWidth - 8.0)/2.0, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountCashier");
    [contentView addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + contentWidth/2.0 + 4.0, originY, (contentWidth - 8.0)/2.0, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountLoginTime");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, (contentWidth - 8.0)/2.0, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1001;
    [contentView addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + contentWidth/2.0 + 4.0, originY, (contentWidth - 8.0)/2.0, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1002;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
    originY += 32.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountPointOfSale");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1003;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
    originY += 32.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountMembershipCardIncome");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1004;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
    originY += 32.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountBankCardIncome");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1005;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
    originY += 32.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountCashIncome");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1006;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
}

- (void)reloadContentScrollView
{
    UIImageView *contentView = (UIImageView *)[self.contentScrollView viewWithTag:101];
    UILabel *nameLabel = (UILabel *)[contentView viewWithTag:1001];
    UILabel *loginLabel = (UILabel *)[contentView viewWithTag:1002];
    UILabel *addressLabel = (UILabel *)[contentView viewWithTag:1003];
    UILabel *cardLabel = (UILabel *)[contentView viewWithTag:1004];
    UILabel *bankLabel = (UILabel *)[contentView viewWithTag:1005];
    UILabel *cashLabel = (UILabel *)[contentView viewWithTag:1006];
    
    nameLabel.text = self.userinfo.name;
    NSString *datestr = @"-";
    if (self.profile.openDate)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
        datestr = [dateFormatter stringFromDate:self.profile.openDate];
    }
    loginLabel.text = datestr;
    addressLabel.text = self.profile.companyAddress;
    cardLabel.text = [NSString stringWithFormat:LS(@"PadAccountAmount"), 1000.0];
    bankLabel.text = [NSString stringWithFormat:LS(@"PadAccountAmount"), 1000.0];
    cashLabel.text = [NSString stringWithFormat:LS(@"PadAccountAmount"), 1000.0];
}

- (void)initNaviBar
{
    self.naviBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kPadNaviHeight + 3.0)];
    self.naviBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pad_navi_background"]];
    [self.view addSubview:self.naviBar];
    
    UIImage *menuImage = [UIImage imageNamed:@"common_menu_icon"];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.backgroundColor = [UIColor clearColor];
    menuButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    [menuButton setImage:menuImage forState:UIControlStateNormal];
    [menuButton setImage:menuImage forState:UIControlStateHighlighted];
    [menuButton setImageEdgeInsets:UIEdgeInsetsMake((kPadNaviHeight - menuImage.size.height)/2.0, (kPadNaviHeight - menuImage.size.width)/2.0, (kPadNaviHeight - menuImage.size.height)/2.0, (kPadNaviHeight - menuImage.size.width)/2.0)];
    [menuButton addTarget:self action:@selector(didMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, kPadAccountContentWidth - 2 * kPadNaviHeight, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadAccount");
    [self.naviBar addSubview:titleLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadAccountContentWidth - 1.0, 0.0, 1.0, IC_SCREEN_HEIGHT)];
    lineImageView.backgroundColor = COLOR(216.0, 230.0, 230.0, 1.0);
    [self.naviBar addSubview:lineImageView];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutButton.backgroundColor = [UIColor clearColor];
    self.logoutButton.frame = CGRectMake(kPadAccountContentWidth - kPadNaviHeight, 0.0, kPadNaviHeight, kPadNaviHeight);
    self.logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.logoutButton setTitle:LS(@"PadAccountLogout") forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:COLOR(169.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(didLogoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:self.logoutButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = COLOR(255.0, 111.0, 104.0, 1.0);
    self.confirmButton.frame = CGRectMake(kPadAccountContentWidth - 150.0, 0.0, 150.0, kPadNaviHeight);
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.confirmButton setTitle:LS(@"PadAccountLogoutConfirm") forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(didLogoutConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.alpha = 0.0;
    [self.naviBar addSubview:self.confirmButton];

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadAccountContentWidth, (kPadNaviHeight - 24.0)/2.0, kPadAccountSideViewWidth, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadAccountChange");
    [self.naviBar addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Required Methods

- (void)didMenuButtonClick:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)didLogoutButtonClick:(id)sender
{
    [UIView animateWithDuration:0.24 animations:^{
        self.logoutButton.alpha = 0.0;
        self.confirmButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)didLogoutConfirmButtonClick:(id)sender
{
    [PersonalProfile deleteProfile];
    UINavigationController* rootViewController = self.navigationController;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPadAccountLogoutResponse object:nil userInfo:nil];
    
    PadLoginViewController *viewController = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
    CBRotateNavigationController *navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    [rootViewController presentViewController:navi animated:YES completion:nil];
    
    [self performSelector:@selector(delayPoptoRoot) withObject:nil afterDelay:0.5];
}


#pragma mark -
#pragma mark NSNotification Methods
- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchUsersResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.userinfo = [[BSCoreDataManager currentManager] findEntity:@"CDUser" withValue:self.profile.userID forKey:@"user_id"];
            [self reloadContentScrollView];
            self.accounts = [[BSCoreDataManager currentManager] fetchChangedUsersWithCurrentUserID:self.profile.userID];
            [self.accountTableView reloadData];
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
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accounts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadAccountCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadSettingCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        UIImageView *normalImageView = [[UIImageView alloc] init];
        normalImageView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = normalImageView;
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.backgroundColor = COLOR(233.0, 237.0, 237.0, 1.0);
        cell.selectedBackgroundView = selectedImageView;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, (kPadAccountCellHeight - 20.0)/2.0, (kPadAccountSideViewWidth - 2 * 20.0)/2.0, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        titleLabel.tag = 101;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0 + (kPadAccountSideViewWidth - 2 * 20.0)/2.0, (kPadAccountCellHeight - 20.0)/2.0, (kPadAccountSideViewWidth - 2 * 20.0)/2.0, 20.0)];
        phoneNumberLabel.backgroundColor = [UIColor clearColor];
        phoneNumberLabel.textAlignment = NSTextAlignmentRight;
        phoneNumberLabel.font = [UIFont systemFontOfSize:16.0];
        phoneNumberLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        phoneNumberLabel.tag = 102;
        [cell.contentView addSubview:phoneNumberLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadAccountCellHeight - 0.5, kPadAccountSideViewWidth, 1.0)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
        [cell.contentView addSubview:lineImageView];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *phoneNumberLabel = (UILabel *)[cell.contentView viewWithTag:102];
    
    CDUser *user = [self.accounts objectAtIndex:indexPath.row];
    titleLabel.text = user.name;
    phoneNumberLabel.text = user.mobile;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:LS(@"PadAccountChangeConfirm")
                                                       delegate:self
                                              cancelButtonTitle:LS(@"Cancel")
                                              otherButtonTitles:LS(@"OK"), nil];
    alertView.tag = indexPath.row;
    [alertView show];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [PersonalProfile deleteProfile];
        CDUser *userinfo = [self.accounts objectAtIndex:alertView.tag];
        UINavigationController* rootViewController = self.navigationController;
        [[NSNotificationCenter defaultCenter] postNotificationName:kPadAccountChangeResponse object:userinfo userInfo:nil];
        
        PadLoginViewController *viewController = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
        viewController.userTextField.text = userinfo.mobile;
        CBRotateNavigationController *navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        [rootViewController presentViewController:navi animated:YES completion:nil];
        
        [self performSelector:@selector(delayPoptoRoot) withObject:nil afterDelay:0.5];
    }
    
}

- (void)delayPoptoRoot
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
