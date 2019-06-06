//
//  MemberViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MemberViewController.h"
#import "BSCoreDataManager.h"
#import "UIImage+Resizable.h"
#import "BSFetchMemberRequest.h"
#import "MemberDetailViewController.h"
#import "MemberTableHeadView.h"
#import "MemberFunctionViewController.h"
#import "MemberAddViewController.h"
#import "MemberInfoDetailViewController.h"
#import "UIView+Frame.h"
#import "MemberWevipViewController.h"
#import "MemberCallRecordViewController.h"
#import "MemberMessagePeopleViewController.h"
#import "MemberFilterView.h"
#import "FilterView.h"
#import "MemberDataSource.h"
#import "MemberFilterViewController.h"
#import "BSFetchStaffRequest.h"
#import "MemberMessageViewController.h"
#import "MemberSaleSelectedCardViewController.h"
#import "OperateManager.h"
#import "CBMessageView.h"
#import "BSSearchView.h"
#import "BSSearchBarView.h"
#import "BSPopupArrowView.h"

#define kCellHeight         60
#define kSearchBarHeight    44
#define kMarginSize         20

@interface MemberViewController ()<MemberTableHeadViewDelegate,MemberDataSourceDelegate,BSSearchBarViewDelegate>
{
    bool isFirstLoadView;
    UITextField *textField;
    
    UIView *topView;
    
    UIButton *bgBtn;
    
    BSSearchBarView *headView;
    MemberFilterView *filterView;
}

@property (nonatomic, strong) CDStore *store;
@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, strong) NSMutableDictionary *cachePicParams;

@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSArray *filterMembers;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CBRefreshState refreshState;

@property (nonatomic, strong) UIButton *searchBar;
@property (nonatomic, strong) FilterView *filter;

@property (nonatomic, strong) MemberDataSource *dataSource;

@property (nonatomic, strong) BSPopupArrowView *popupArrowView;

@end

@implementation MemberViewController

#pragma mark - init
- (id)initWithStore:(CDStore *)store
{
    self = [super initWithNibName:NIBCT(@"MemberViewController") bundle:nil];
    if (self)
    {
        self.store = store;
        if (self.store)
        {
            self.title = store.storeName;
        }
        else
        {
            self.title = LS(@"TotalStore");
        }
        self.title = @"会员管理";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.cachePicParams = [NSMutableDictionary dictionary];
    
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);

    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"member_more.png"] highlightedImage:[UIImage imageNamed:@"member_more.png"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    if (self.isCashier) {
        self.title = @"选择会员";
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self registerNofitificationForMainThread:kBSFetchMemberResponse];
    [self registerNofitificationForMainThread:kBSUpdateMemberInfo];
    [self registerNofitificationForMainThread:kBSUpdateMemberResponse];
    [self registerNofitificationForMainThread:kBSCreateMemberResponse];
    

    [self fetchMembersWithStartIndex:0 filterString:textField.text];
    
//    isFirstLoadView = true;
    [self initArrowView];
    [self initView];
    [self searchBar];
    [self reloadData];
    
    //取顾问
    [[[BSFetchStaffRequest alloc] init] execute];
    
    
}


#pragma mark - init Data & View
- (void) initArrowView
{
    self.popupArrowView = [BSPopupArrowView createViewWithStyle:PopupViewStyle_Image];
    self.popupArrowView.delegate = self;
    //    self.popupArrowView.width = 100;
    //    self.popupArrowView.height = 200;
    
    NSMutableArray *dataArray = [NSMutableArray array];
    PopupItem *item = [[PopupItem alloc] init];
    item.imageName = @"member_add_icon.png";
    item.title = @"新建会员";
    item.function = @selector(didNewContactBtnPressed);
    [dataArray addObject:item];
    
    item = [[PopupItem alloc] init];
    item.imageName = @"member_call_icon.png";
    item.title = @"来电记录";
    item.function = @selector(didCallBtnPressed);
    [dataArray addObject:item];
    
    item = [[PopupItem alloc] init];
    item.imageName = @"member_message_icon.png";
    item.title = @"短信群发";
    item.function = @selector(didMessageBtnPressed);
    [dataArray addObject:item];
    
    item = [[PopupItem alloc] init];
    item.imageName = @"member_filter_icon.png";
    item.title = @"筛选";
    item.function = @selector(didFilterBtnPressed);
    [dataArray addObject:item];
    
    self.popupArrowView.items = dataArray;

}

- (UIView *)searchBar
{
    bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.backgroundColor = [UIColor blackColor];
    [bgBtn addTarget:self action:@selector(hideSearchView) forControlEvents:UIControlEventTouchUpInside];
    bgBtn.alpha = 0.0;

    [self.view addSubview:bgBtn];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    topView = [[UIView alloc] init];
//    topView.hidden = true;
    topView.alpha = 0.0;
    topView.backgroundColor = AppThemeColor;
   
    [[UIApplication sharedApplication].keyWindow addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(64);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [topView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
    
    UIImage *search_bg = [[UIImage imageNamed:@"member_search_blue_bg.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 50, 10, 10)];
    UIImageView *searchView = [[UIImageView alloc] initWithImage:search_bg];
    searchView.userInteractionEnabled = true;
//    [searchView setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
    [view addSubview:searchView];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset((kSearchBarHeight - search_bg.size.height)/2.0);
        make.height.offset(search_bg.size.height);
        make.centerY.offset(0);
        make.leading.offset(15);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [cancelBtn setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    [cancelBtn addTarget:self action:@selector(hideSearchView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(searchView.mas_trailing).offset(4);
        make.trailing.offset(-10);
        make.centerY.offset(0);
        make.width.offset(40);
    }];
    

    textField = [[UITextField alloc] init];
    textField.alpha = 0.6;
    textField.placeholder = @"名字 / 手机号码";
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    if ([textField respondsToSelector:@selector(tintColor)]) {
        textField.tintColor = [UIColor whiteColor];
    }
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont boldSystemFontOfSize:13];
    textField.returnKeyType = UIReturnKeyGoogle;
    textField.delegate = self;

    textField.textColor = [UIColor whiteColor];
    [textField addTarget:self action:@selector(hideSearchView) forControlEvents:UIControlEventEditingDidEndOnExit];
    [searchView addSubview:textField];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 30, 0, 0));
    }];
    
    
    return topView;
}

- (void) initView
{
    
    
    [self initTableView];
    
    UIView *view = [[UIView alloc] init];
    view.height = round(IC_SCREEN_WIDTH * 45/375.0);
    self.tableView.tableHeaderView = view;
    
    headView = [BSSearchBarView createView];
    headView.placeHolder = @"名字 / 手机号码";
    headView.delegate = self;
    [view addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
        
    }];

    
//    BSSearchView *searchView = [BSSearchView createView];
//    searchView.leftImgName = @"search.png";
//    
//    searchView.rightImgName = @"search_saoma.png";
//    [view addSubview:searchView];
//    
//    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsZero);
//    }];
    
    
//    if (!self.isCashier) {
//            }
}

- (void) initTableView
{
//    self.tableView = filterView.tableView;
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];

    self.dataSource = [[MemberDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.delegate = self;
    
    self.tableView.refreshDelegate = self;
    self.tableView.canRefresh = YES;
    self.tableView.canLoadMore = YES;
}

- (void) reloadData
{
    if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0) {
        if ([PersonalProfile currentProfile].employeeID) {
            self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.store.storeID guwenID:[PersonalProfile currentProfile].employeeID];
        }
        else
        {
            self.members = [NSArray array];
        }
    }
    else
    {
        self.members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.store.storeID];

    }
    self.filterMembers = [NSArray arrayWithArray:self.members];

    self.dataSource.filterMembers  = self.filterMembers;
//    [self.tableView reloadData];
}


#pragma mark -
#pragma mark button action

- (void)didBackBarButtonItemClick:(id)sender
{
    if (self.isCashier) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didRightBarButtonItemClick:(id)sender
{
//    [self showSearchView];
    [self.popupArrowView showArrowView:sender];
}

#pragma mark - show & hide Search View
- (void)showSearchView
{
    [UIView animateWithDuration:0.25 animations:^{
        topView.alpha = 1.0;
        bgBtn.alpha = 0.6;
    }];
    [textField becomeFirstResponder];
    [self forbidSwipGesture];
}

- (void)hideSearchView
{
    textField.text = @"";
    [textField resignFirstResponder];
}

#pragma mark - MemberTableHeadViewDelegate
- (void)didNewContactBtnPressed
{
    NSLog(@"%s",__FUNCTION__);
    
    if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0) {
        [[[CBMessageView alloc] initWithTitle:@"当前用户无此权限"] show];
        return;
    }
    
    
    MemberInfoDetailViewController *detailVC = [[MemberInfoDetailViewController alloc] init];
    detailVC.type = MemberInfoType_create;
    detailVC.store = self.store;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)didCallBtnPressed
{
    MemberCallRecordViewController *callRecordVC = [[MemberCallRecordViewController alloc] init];
    [self.navigationController pushViewController:callRecordVC animated:YES];
}
- (void)didwekaBtnPressed
{
    NSLog(@"%s",__FUNCTION__);
    MemberWevipViewController *wevipVC = [[MemberWevipViewController alloc] init];
    wevipVC.store = self.store;
    [self.navigationController pushViewController:wevipVC animated:YES];
}
- (void)didServiceBtnPressed
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)didMessageBtnPressed
{
    NSLog(@"%s",__FUNCTION__);
    
    MemberMessageViewController *messageVC = [[MemberMessageViewController alloc] init];
    messageVC.store = self.store;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)didFilterBtnPressed
{
    NSLog(@"%s",__FUNCTION__);
    MemberFilterViewController *filterVC = [[MemberFilterViewController alloc] init];
    filterVC.store = self.store;
    
    [self.navigationController pushViewController:filterVC animated:YES];
}


#pragma mark - request & notification

- (void)fetchMembersWithStartIndex:(NSInteger)startIndex filterString:(NSString *)filterString
{
    if (!self.isLoading)
    {
        BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithStoreID:self.store.storeID startIndex:startIndex];
        request.filterString = filterString;
        if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0)
        {
            request.guwenID = [PersonalProfile currentProfile].employeeID;
        }
        else
        {
            
        }
        [request execute];
        self.isLoading = true;
    }
}

- (void) didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberResponse]) {
        self.isLoading = false;
        [self.tableView stopWithRefreshState:self.refreshState];
        [self reloadData];
        [self.tableView reloadData];
    }
    else if ([notification.name isEqualToString:kBSUpdateMemberResponse]|| [notification.name isEqualToString:kBSCreateMemberResponse])
    {
        [self reloadData];
        [self.tableView reloadData];
//        [self fetchMembersWithStartIndex:0 filterString:nil];
    }
}

#pragma mark - MemoryWarning & dealloc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.tableView cleanCBrefreshView];
}

#pragma mark - BSSearchBarViewDelegate
- (void)didSearchWithText:(NSString *)text
{
     [self fetchMembersWithStartIndex:0 filterString:text];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)field
{
    [UIView animateWithDuration:0.25 animations:^{
        topView.alpha = 0.0;
        bgBtn.alpha = 0.0;
        
    }];
   [self addSwipGesture];
   
    
    NSString *filterString = nil;
    if (field.text.length != 0) {
        filterString = field.text;
    }
    [self fetchMembersWithStartIndex:0 filterString:filterString];
}


#pragma mark - MemberDataSourceDelegate
- (void)didSelectedMemberAtIndexPath:(NSIndexPath *)indexPath
{
    CDMember *member = [self.dataSource.filterMembers objectAtIndex:indexPath.row];
    if (!self.isCashier) {
        
        MemberFunctionViewController *memberFunctionVC = [[MemberFunctionViewController alloc] initWithNibName:@"MemberFunctionViewController" bundle:nil];
        memberFunctionVC.member = member;
        [self.navigationController pushViewController:memberFunctionVC animated:YES];
    }
    else
    {
        
        [OperateManager shareManager].posOperate.member = member;
        
        MemberSaleSelectedCardViewController *saleSelectedCardVC = [[MemberSaleSelectedCardViewController alloc] init];
        saleSelectedCardVC.isPopDismiss = true;
        saleSelectedCardVC.member = member;
        [self.navigationController pushViewController:saleSelectedCardVC animated:YES];
    }
    
}

#pragma mark -
#pragma mark CBRefreshDelegate Methods
- (void)scrollView:(UIScrollView *)scrollView withRefreshState:(CBRefreshState)state
{
    if (self.isLoading && self.refreshState == state)
    {
        return ;
    }
    
    self.refreshState = state;
    if (state == CBRefreshStateRefresh)
    {
        self.startIndex = 0;
    }
    else if (state == CBRefreshStateLoadMore)
    {
        if (textField.text.length > 0) {
            textField.text = @"";
            self.startIndex = 0;
        }
        self.startIndex = self.members.count;
    }
    
    [self fetchMembersWithStartIndex:self.startIndex filterString:textField.text];
}

@end
