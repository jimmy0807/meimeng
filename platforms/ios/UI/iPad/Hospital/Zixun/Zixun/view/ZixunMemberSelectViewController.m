//
//  ZixunMemberSelectViewController.m
//  meim
//
//  Created by 波恩公司 on 2017/11/2.
//


#import "ZixunMemberSelectViewController.h"
#import "UIImage+Resizable.h"
#import "PadSelectMemberCell.h"
#import "CBLoadingView.h"
#import "BSMemberRequest.h"
#import "BSFetchMemberRequest.h"
#import "BSFetchMemberCardRequest.h"
#import "PadMemberAndCardViewController.h"

#define kZixunMemberListWidth             340.0
#define kZixunMemberHeaderHeight          75.0

@interface ZixunMemberSelectViewController ()

@property (nonatomic, assign) kPadMemberAndCardViewType viewType;

@property (nonatomic, strong) NSNumber *storeID;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSArray *sectionKeyArray;
@property (nonatomic, strong) NSMutableDictionary *memberParams;
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UITableView *memberTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *memberSelectedButton;
@property (nonatomic, strong) UIButton *memberCreateButton;

@end

@implementation ZixunMemberSelectViewController

- (id)initWithViewType:(kPadMemberAndCardViewType)viewType
{
    self = [super initWithNibName:@"ZixunMemberSelectViewController" bundle:nil];
    if (self)
    {
        self.viewType = viewType;
        self.sectionKeyArray = [NSArray array];
        self.memberParams = [NSMutableDictionary dictionary];
        self.cachePicParams = [[NSMutableDictionary alloc] init];
        self.storeID = [[PersonalProfile currentProfile].shopIds firstObject];
        //self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID keyword:self.keyword];
        
        NSNumber* guwenID = nil;
        if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 && ![PersonalProfile currentProfile].employeeID )
        {
            self.members = @[];
        }
        else
        {
            if ([PersonalProfile currentProfile].roleOption >= RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
            {
                guwenID = [PersonalProfile currentProfile].employeeID;
                
            }
            
            self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID isTiYan:FALSE guwenID:guwenID];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.view.frame = CGRectMake(0.0, 0.0, kPadProjectSideViewWidth, IC_SCREEN_HEIGHT);
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024, 768)];
    maskView.backgroundColor = COLOR(0, 0, 0, 0.4);
    [self.view addSubview:maskView];
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(684.0, 0.0, kPadProjectSideViewWidth, IC_SCREEN_HEIGHT)];
    [self.view addSubview:self.rightView];
    [self registerNofitificationForMainThread:kBSMemberRequestSuccess];
    [self registerNofitificationForMainThread:kBSMemberRequestFailed];
    [self registerNofitificationForMainThread:kBSFetchMemberResponse];
    [self registerNofitificationForMainThread:kBSMemberCreateResponse];
    [self registerNofitificationForMainThread:kPadCreateMemberFinish];
    
    [self initView];
    [self initData];
    
    if ( self.keyword.length > 0 )
    {
        self.searchBar.text = self.keyword;
        BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithKeyword:self.keyword];
        [request execute];
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [maskView addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark init Methods

- (void)initView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kZixunMemberListWidth, 64.0)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(16.0, 0.0, kZixunMemberListWidth - 2 * 16.0, 64.0)];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"pad_background_white_color"]];
    UIImage *searchFieldImage = [[UIImage imageNamed:@"pad_member_search_field"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    [self.searchBar setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.placeholder = LS(@"PadMemberSearchPlaceholder");
    self.searchBar.delegate = self;
    [headerView addSubview:self.searchBar];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 64.0, kZixunMemberListWidth, 1.0)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
    [headerView addSubview:lineImageView];
    
    self.memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 75, kZixunMemberListWidth, IC_SCREEN_HEIGHT - 75) style:UITableViewStylePlain];
    self.memberTableView.backgroundColor = [UIColor whiteColor];
    self.memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.memberTableView.delegate = self;
    self.memberTableView.dataSource = self;
    self.memberTableView.showsVerticalScrollIndicator = NO;
    self.memberTableView.showsHorizontalScrollIndicator = NO;
    [self.rightView addSubview:self.memberTableView];
    self.memberTableView.tableHeaderView = headerView;
    //self.memberTableView.contentOffset = CGPointMake(0, self.searchBar.bounds.size.height);
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kZixunMemberListWidth, 75)];
    naviView.backgroundColor = [UIColor whiteColor];
    [self.rightView addSubview:naviView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0.0, 0.0, kZixunMemberHeaderHeight, kZixunMemberHeaderHeight);
    if (self.viewType == kPadMemberAndCardDefault)
    {
        UIImage *menuImage = [UIImage imageNamed:@"common_menu_icon"];
        [backButton setImage:menuImage forState:UIControlStateNormal];
        [backButton setImage:menuImage forState:UIControlStateHighlighted];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake((kPadNaviHeight - menuImage.size.height)/2.0, (kPadNaviHeight - menuImage.size.width)/2.0, (kPadNaviHeight - menuImage.size.height)/2.0, (kPadNaviHeight - menuImage.size.width)/2.0)];
    }
    else if (self.viewType == kPadMemberAndCardSelect)
    {
        [backButton setBackgroundImage:[UIImage imageNamed:@"pad_close_button_h"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"pad_close_button_h"] forState:UIControlStateHighlighted];
    }
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    
    self.memberSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //self.memberSelectedButton.frame = CGRectMake(78, 21, 183, 30);
    self.memberSelectedButton.frame = CGRectMake(0, 21, 300, 30);
    self.memberSelectedButton.userInteractionEnabled = NO;
//    self.memberSelectedButton.adjustsImageWhenHighlighted = NO;
    //[self.memberSelectedButton setImage:[UIImage imageNamed:@"pad_member_selectmember_n"] forState:UIControlStateNormal];
    //[self.memberSelectedButton setImage:[UIImage imageNamed:@"pad_member_selectmember_h"] forState:UIControlStateSelected];
    [self.memberSelectedButton setTitle:@"选择咨询会员" forState:UIControlStateNormal];
    [self.memberSelectedButton setTitleColor:COLOR(61, 61, 61, 1) forState:UIControlStateNormal];
    
    [naviView addSubview:self.memberSelectedButton];
//
//    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, self.memberSelectedButton.frame.size.width/2, self.memberSelectedButton.frame.size.height);
//    [leftButton addTarget:self action:@selector(didMemberLeftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    //[self.memberSelectedButton addSubview:leftButton];
//
//    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(self.memberSelectedButton.frame.size.width/2, 0, self.memberSelectedButton.frame.size.width/2, self.memberSelectedButton.frame.size.height);
//    [rightButton addTarget:self action:@selector(didMemberRightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    //[self.memberSelectedButton addSubview:rightButton];
//
//    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 75, naviView.frame.size.width, 1.0)];
//    lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
//    [naviView addSubview:lineImageView];
    
    
//    UIButton* addMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addMemberButton.adjustsImageWhenHighlighted = NO;
//    addMemberButton.frame = CGRectMake(0, 76, naviView.frame.size.width, naviView.frame.size.height - 76);
//    [addMemberButton setImage:[UIImage imageNamed:@"pad_member_addicon"] forState:UIControlStateNormal];
//    [addMemberButton setTitle:@"新建会员" forState:UIControlStateNormal];
//    [addMemberButton setTitleColor:COLOR(61, 61, 61, 1) forState:UIControlStateNormal];
//    addMemberButton.imageEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0);
//    addMemberButton.titleEdgeInsets = UIEdgeInsetsMake(0, -130, 0, 0);
//    addMemberButton.titleLabel.font = [UIFont systemFontOfSize:17];
//    [addMemberButton addTarget:self action:@selector(didMemberAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [naviView addSubview:addMemberButton];
    //self.memberCreateButton = addMemberButton;
    
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMemberHeaderHeight, 0.0, kPadMemberListWidth - 2 * kPadMemberHeaderHeight, kPadMemberHeaderHeight)];
    //    titleLabel.backgroundColor = [UIColor clearColor];
    //    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    //    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.text = LS(@"PadSelectMember");
    //    [naviView addSubview:titleLabel];
    //
    //    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    createButton.backgroundColor = [UIColor clearColor];
    //    createButton.frame = CGRectMake(kPadMemberListWidth - kPadMemberHeaderHeight - 20.0, 0.0, kPadMemberHeaderHeight + 20.0, kPadMemberHeaderHeight);
    //    [createButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    //    createButton.titleLabel.textAlignment = NSTextAlignmentRight;
    //    [createButton setTitle:LS(@"PadCreateMember") forState:UIControlStateNormal];
    //    [createButton setTitleColor:COLOR(168.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    //    [createButton addTarget:self action:@selector(didCreateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:createButton];
    //
    //    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadMemberHeaderHeight - 1.0, kPadMemberListWidth, 1.0)];
    //    lineImageView.backgroundColor = [UIColor clearColor];
    //    lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
    //    [naviView addSubview:lineImageView];
}

- (void)didMemberLeftButtonPressed:(id)sender
{
    self.memberSelectedButton.selected = NO;
    [self.memberCreateButton setTitle:@"新建会员" forState:UIControlStateNormal];
    self.memberCreateButton.imageEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0);
    self.memberCreateButton.titleEdgeInsets = UIEdgeInsetsMake(0, -130, 0, 0);
    
    NSNumber* guwenID = nil;
    if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 && ![PersonalProfile currentProfile].employeeID )
    {
        self.members = @[];
    }
    else
    {
        if ([PersonalProfile currentProfile].roleOption >= RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
        {
            guwenID = [PersonalProfile currentProfile].employeeID;
            
        }
        self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID isTiYan:FALSE guwenID:guwenID];
    }
    
    [self reloadMemberTableView];
}

- (void)didMemberRightButtonPressed:(id)sender
{
    self.memberSelectedButton.selected = YES;
    [self.memberCreateButton setTitle:@"新建体验会员" forState:UIControlStateNormal];
    self.memberCreateButton.imageEdgeInsets = UIEdgeInsetsMake(0, -120, 0, 0);
    self.memberCreateButton.titleEdgeInsets = UIEdgeInsetsMake(0, -100, 0, 0);
    
    NSNumber* guwenID = nil;
    if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 && ![PersonalProfile currentProfile].employeeID )
    {
        self.members = @[];
    }
    else
    {
        if ([PersonalProfile currentProfile].roleOption >= RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
        {
            guwenID = [PersonalProfile currentProfile].employeeID;
            
        }
        self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID isTiYan:TRUE guwenID:guwenID];
    }
    
    [self reloadMemberTableView];
}

- (void)didMemberAddButtonPressed:(id)sender
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didMemberCreateButtonClick:)])
//    {
//        [self.delegate didMemberCreateButtonClick:self.memberSelectedButton.selected];
//    }
}

- (void)initData
{
    if (self.members.count == 0)
    {
        //[[CBLoadingView shareLoadingView] show];
    }
    //[[BSMemberRequest sharedInstance] startMemberRequest];
    
    [self reloadMemberTableView];
}

- (void)reloadMemberTableView
{
    self.sectionKeyArray = [NSArray array];
    self.memberParams = [NSMutableDictionary dictionary];
    for (CDMember *member in self.members)
    {
        NSMutableArray *mutableArray = [self.memberParams objectForKey:member.memberNameSingleLetter];
        if (!mutableArray)
        {
            mutableArray = [NSMutableArray array];
            [self.memberParams setObject:mutableArray forKey:member.memberNameSingleLetter];
        }
        [mutableArray addObject:member];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    self.sectionKeyArray = [self.memberParams.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.memberTableView reloadData];
}

- (void)didBackButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMemberSelectCancel)])
    {
        [self.delegate didMemberSelectCancel];
    }
}

- (void)didCreateButtonClick:(id)sender
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didMemberCreateButtonClick:)])
//    {
//        [self.delegate didMemberCreateButtonClick:self.memberSelectedButton.selected];
//    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberRequestSuccess])
    {
        [[CBLoadingView shareLoadingView] hide];
        if (self.keyword.length == 0)
        {
            NSNumber* guwenID = nil;
            if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 && ![PersonalProfile currentProfile].employeeID )
            {
                self.members = @[];
            }
            else
            {
                if ([PersonalProfile currentProfile].roleOption >= RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
                {
                    guwenID = [PersonalProfile currentProfile].employeeID;
                    
                }
                self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID isTiYan:self.memberSelectedButton.selected guwenID:guwenID];
            }
            
            [self reloadMemberTableView];
        }
    }
    else if ([notification.name isEqualToString:kBSMemberRequestFailed])
    {
        [[CBLoadingView shareLoadingView] hide];
    }
    else if ([notification.name isEqualToString:kBSFetchMemberResponse])
    {
        if (notification.object == nil)
        {
            return;
        }
        self.members = (NSArray *)notification.object;
        [self reloadMemberTableView];
    }
    else if ([notification.name isEqualToString:kBSMemberCreateResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            self.keyword = @"";
            
            NSNumber* guwenID = nil;
            if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 && ![PersonalProfile currentProfile].employeeID )
            {
                self.members = @[];
            }
            else
            {
                if ([PersonalProfile currentProfile].roleOption >= RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
                {
                    guwenID = [PersonalProfile currentProfile].employeeID;
                    
                }
                self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID isTiYan:self.memberSelectedButton.selected guwenID:guwenID];
            }
            
            [self reloadMemberTableView];
        }
    }
    else if ([notification.name isEqualToString:kPadCreateMemberFinish])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            self.keyword = @"";
            NSNumber* guwenID = nil;
            if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 && ![PersonalProfile currentProfile].employeeID )
            {
                self.members = @[];
            }
            else
            {
                if ([PersonalProfile currentProfile].roleOption >= RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
                {
                    guwenID = [PersonalProfile currentProfile].employeeID;
                    
                }
                self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID isTiYan:self.memberSelectedButton.selected guwenID:guwenID];
            }
            
            [self reloadMemberTableView];
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionKeyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionKey = [self.sectionKeyArray objectAtIndex:section];
    NSArray *values = [self.memberParams objectForKey:sectionKey];
    
    return values.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadSelectMemberCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.sectionKeyArray objectAtIndex:section] isEqualToString:@"0"])
    {
        return 0;
    }
    
    return 24.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.memberTableView.frame.size.width, 24.0)];
    headerView.backgroundColor = COLOR(180.0, 218.0, 213.0, 1.0);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 1.0, kPadProjectSideCellWidth - 20.0, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    if ([[self.sectionKeyArray objectAtIndex:section] isEqualToString:@"a"])
    {
        titleLabel.text = @"#";
    }
    else
    {
        titleLabel.text = [self.sectionKeyArray objectAtIndex:section];
    }
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadSelectMemberCellIdentifier";
    PadSelectMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PadSelectMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *key = [self.sectionKeyArray objectAtIndex:indexPath.section];
    NSArray *members = [self.memberParams objectForKey:key];
    CDMember *member = [members objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = member.memberName;
    
    if ( member.mobile.length == 11 )
    {
        cell.detailLabel.text = [NSString stringWithFormat:@"%@*****%@", [member.mobile substringToIndex:3],[member.mobile substringFromIndex:8]];
    }
    else
    {
        cell.detailLabel.text = member.mobile;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [self.sectionKeyArray objectAtIndex:indexPath.section];
    NSArray *members = [self.memberParams objectForKey:key];
    CDMember *member = [members objectAtIndex:indexPath.row];
    NSLog(@" 左侧选择的会员=%@",member.memberID);    // 这个选择的会员ID 可以作为详细 咨询方案查询条件
    if (member.isDefaultCustomer.boolValue)
    {
        NSMutableArray *cardIds = [NSMutableArray array];
        NSArray *cards = member.card.array;
        for (NSInteger i = 0; i < cards.count; i++)
        {
            CDMemberCard *card = [cards objectAtIndex:i];
            [cardIds addObject:card.cardID];
        }
        
        if (cardIds.count > 0)
        {
            BSFetchMemberCardRequest *request = [[BSFetchMemberCardRequest alloc] initWithMemberCardIds:cardIds];
            [request execute];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didMemberSelectCancel)])
        {
            [self.delegate didMemberSelectCancel];
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:member, @"member", nil];
        if (member.card.count != 0)
        {
            [params setObject:[member.card.array objectAtIndex:0] forKey:@"card"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberAndCardFinish object:nil userInfo:params];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberFinish object:member userInfo:nil];
    }
}


#pragma mark -
#pragma mark UIDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AdditionTableViewShouldHide" object:nil];
    self.keyword = searchText;
    NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    
    NSNumber* guwenID = nil;
    if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 && ![PersonalProfile currentProfile].employeeID )
    {
        self.members = @[];
    }
    else
    {
        if ([PersonalProfile currentProfile].roleOption >= RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
        {
            guwenID = [PersonalProfile currentProfile].employeeID;
            
        }
        self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:storeID keyword:self.keyword guwenID:guwenID];
    }
    
    [self reloadMemberTableView];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.keyword = searchBar.text;
    if (self.keyword.length != 0)
    {
        NSString *regex = @"^[0-9]*[1-9][0-9]*$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject:self.keyword])
        {
            if (self.keyword.length < 4)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:LS(@"PadSearchMemberWithNumberFilters")
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
        else
        {
            if (self.keyword.length < 1)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:LS(@"PadSearchMemberWithNameFilters")
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
        
        BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithKeyword:self.keyword];
        [request execute];
    }
    else
    {
        NSNumber* guwenID = nil;
        if ( (NSInteger)[PersonalProfile currentProfile].roleOption == 10 && ![PersonalProfile currentProfile].employeeID )
        {
            self.members = @[];
        }
        else
        {
            if ([PersonalProfile currentProfile].roleOption >= RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
            {
                guwenID = [PersonalProfile currentProfile].employeeID;
                
            }
            self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID isTiYan:self.memberSelectedButton.selected guwenID:guwenID];
        }
        
        [self reloadMemberTableView];
    }
}

- (void)tap
{
    [self.delegate didMemberSelectCancel];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -160.0)
    {
        [self.searchBar becomeFirstResponder];
    }
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

@end

