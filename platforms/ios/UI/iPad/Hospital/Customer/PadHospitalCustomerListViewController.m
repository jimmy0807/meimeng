//
//  PadHospitalCustomerListViewController.m
//  meim
//
//  Created by jimmy on 2017/4/14.
//
//

#import "PadHospitalCustomerListViewController.h"

#import "UIImage+Resizable.h"
#import "PadSelectMemberCell.h"
#import "CBLoadingView.h"
#import "FetchHCustomerRequest.h"

#define kPadMemberListWidth             300.0
#define kPadMemberHeaderHeight          75.0

@interface PadHospitalCustomerListViewController ()

@property (nonatomic, assign) kPadMemberAndCardViewType viewType;

@property (nonatomic, strong) NSNumber *storeID;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSArray *sectionKeyArray;
@property (nonatomic, strong) NSMutableDictionary *memberParams;
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;

@property (nonatomic, strong) UITableView *memberTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *memberSelectedButton;
@property (nonatomic, strong) UIButton *memberCreateButton;

@end

@implementation PadHospitalCustomerListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    
    self.sectionKeyArray = [NSArray array];
    self.memberParams = [NSMutableDictionary dictionary];
    self.cachePicParams = [[NSMutableDictionary alloc] init];
    self.storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    
    self.members = [[BSCoreDataManager currentManager] fetchAllCustomerWithStoreID:self.storeID];
    
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadProjectSideViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSFetchHCustomerResponse];
    [self registerNofitificationForMainThread:kHCustomerCreateResponse];
    
    [self initView];
    [self initData];
    
    [[[FetchHCustomerRequest alloc] init] execute];
}

#pragma mark -
#pragma mark init Methods

- (void)initView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadMemberListWidth, 64.0)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(12.0, 0.0, kPadMemberListWidth - 2 * 12.0, 64.0)];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"pad_background_white_color"]];
    UIImage *searchFieldImage = [[UIImage imageNamed:@"pad_member_search_field"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    [self.searchBar setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.placeholder = LS(@"PadMemberSearchPlaceholder");
    self.searchBar.delegate = self;
    [headerView addSubview:self.searchBar];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 64.0, kPadMemberListWidth, 1.0)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
    [headerView addSubview:lineImageView];
    
    self.memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 138, kPadMemberListWidth, IC_SCREEN_HEIGHT - 138) style:UITableViewStylePlain];
    self.memberTableView.backgroundColor = [UIColor whiteColor];
    self.memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.memberTableView.delegate = self;
    self.memberTableView.dataSource = self;
    self.memberTableView.showsVerticalScrollIndicator = NO;
    self.memberTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.memberTableView];
    self.memberTableView.tableHeaderView = headerView;
    self.memberTableView.contentOffset = CGPointMake(0, self.searchBar.bounds.size.height);
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadMemberListWidth, 138)];
    naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, kPadMemberHeaderHeight, kPadMemberHeaderHeight);
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_n"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_h"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    
    self.memberSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.memberSelectedButton.frame = CGRectMake(0, 0, kPadMemberListWidth, 75);
    self.memberSelectedButton.adjustsImageWhenHighlighted = NO;
    [self.memberSelectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.memberSelectedButton setTitle:@"客户" forState:UIControlStateNormal];
    self.memberSelectedButton.userInteractionEnabled = FALSE;
    [naviView addSubview:self.memberSelectedButton];
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 75, naviView.frame.size.width, 1.0)];
    lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
    [naviView addSubview:lineImageView];
    
    UIButton* addMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addMemberButton.adjustsImageWhenHighlighted = NO;
    addMemberButton.frame = CGRectMake(0, 76, naviView.frame.size.width, naviView.frame.size.height - 76);
    [addMemberButton setImage:[UIImage imageNamed:@"pad_member_addicon"] forState:UIControlStateNormal];
    [addMemberButton setTitle:@"新建客户" forState:UIControlStateNormal];
    [addMemberButton setTitleColor:COLOR(61, 61, 61, 1) forState:UIControlStateNormal];
    addMemberButton.imageEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0);
    addMemberButton.titleEdgeInsets = UIEdgeInsetsMake(0, -130, 0, 0);
    addMemberButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [addMemberButton addTarget:self action:@selector(didMemberAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:addMemberButton];
    self.memberCreateButton = addMemberButton;
}

- (void)didMemberAddButtonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMemberCreateButtonClick)])
    {
        [self.delegate didMemberCreateButtonClick];
    }
}

- (void)initData
{
    if (self.members.count == 0)
    {
        [[CBLoadingView shareLoadingView] show];
    }
    
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

#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchHCustomerResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if (self.keyword.length == 0)
        {
            self.members = [[BSCoreDataManager currentManager] fetchAllCustomerWithStoreID:self.storeID];
            [self reloadMemberTableView];
        }
    }
    else if ([notification.name isEqualToString:kHCustomerCreateResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            self.keyword = @"";
            self.members = [[BSCoreDataManager currentManager] fetchAllCustomerWithStoreID:self.storeID];
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
    cell.detailLabel.text = member.mobile;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [self.sectionKeyArray objectAtIndex:indexPath.section];
    NSArray *members = [self.memberParams objectForKey:key];
    CDMember *member = [members objectAtIndex:indexPath.row];
}


#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.keyword = searchText;
    NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    
    self.members = [[BSCoreDataManager currentManager] fetchAllCustomerWithStoreID:storeID keyword:self.keyword];
    
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
        
        FetchHCustomerRequest *request = [[FetchHCustomerRequest alloc] initWithKeyword:self.keyword];
        [request execute];
    }
    else
    {
        self.members = [[BSCoreDataManager currentManager] fetchAllCustomerWithStoreID:self.storeID];
        [self reloadMemberTableView];
    }
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
    //PadMemberAndCardViewController *viewController = (PadMemberAndCardViewController *)self.delegate;
    //[viewController didTextFieldEditDone:textField];
}

@end
