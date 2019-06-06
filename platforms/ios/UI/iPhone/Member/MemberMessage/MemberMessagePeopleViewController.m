//
//  MemberMessagePeopleViewController.m
//  Boss
//
//  Created by lining on 16/5/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberMessagePeopleViewController.h"
#import "FilterItemView.h"
#import "MemberFilterView.h"
#import "UIImage+Resizable.h"
#import "MemberMessagePeopleDataSource.h"
#import "BSFetchMemberRequest.h"
#import "PeopleBottomSelectedView.h"
#import "MemberMessageTemplateViewController.h"

@interface MemberMessagePeopleViewController ()<BottomSelectedViewDelegate,MemberMessagePeopleDataSouceDelegate,MemberFilterViewDelegate>
{
    UIButton *bgBtn;
    UIView *topView;
    UITextField *textField;
}
@property (nonatomic, strong) MemberMessagePeopleDataSource *dataSource;
@property (nonatomic, strong) MemberFilterView *filterView;
@property (nonatomic, strong) PeopleBottomSelectedView *bottomSelectedView;
@property (nonatomic, strong) NSArray *selectedPeoples;
@end

@implementation MemberMessagePeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"短信产品";
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"member_search_btn.png"] highlightedImage:[UIImage imageNamed:@"member_search_btn.png"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;

    self.filterView = [[MemberFilterView alloc] initWithStore:self.store];
    self.filterView.delegate = self;
//    filterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsZero);
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
    }];
    
    
//    UIView *bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:bottomView];
    
    self.bottomSelectedView = [PeopleBottomSelectedView createView];
    self.bottomSelectedView.delegate = self;
    [self.view addSubview:self.bottomSelectedView];
    [self.bottomSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom).offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
//        CGFloat multipliedBy = 44.0/320.0;
        make.height.equalTo(self.bottomSelectedView.mas_width).multipliedBy(44.0/320.0);
    }];
    
    
    self.dataSource = [[MemberMessagePeopleDataSource alloc] initWithTableView:self.filterView.tableView];
    self.dataSource.filterMembers = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.store.storeID];
    self.dataSource.delegate = self;
    
    [self searchBar];
    
    [self registerNofitificationForMainThread:kBSFetchMemberResponse];
//    [self sendRequest];
}

#pragma mark - search bar
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
    textField.placeholder = @"姓名/手机号码";
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


#pragma mark button action

- (void)didRightBarButtonItemClick:(id)sender
{
    [self showSearchView];
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

#pragma mark - MemberFilterViewDelegate
- (void)didFilterMembers:(NSArray *)filterMembers
{
    self.dataSource.filterMembers = filterMembers;
}

#pragma mark - send request
- (void)sendRequest
{
    BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithStoreID:self.store.storeID];
    [request execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberResponse]) {
        self.dataSource.filterMembers = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.store.storeID];
    }
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
    self.dataSource.filterMembers = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.store.storeID keyword:filterString];
}


#pragma mark - BottomSelectedViewDelegate
- (void)didAllSelectedBtnPressed:(BOOL)selected
{
    self.dataSource.allSelected = selected;
    
}

- (void)didSureBtnPressed
{
    MemberMessageTemplateViewController *messageTemplateVC = [[MemberMessageTemplateViewController alloc] init];
    messageTemplateVC.qunfa = true;
    messageTemplateVC.selectedPeoples = self.selectedPeoples;
    [self.navigationController pushViewController:messageTemplateVC animated:YES];
}

#pragma mark - MemberMessagePeopleDataSouceDelegate
- (void)didSelectedItemsChanged:(NSMutableOrderedSet *)items
{
    if (items.count == 0) {
        self.bottomSelectedView.sureBtn.enabled = false;
        self.bottomSelectedView.selectedLabel.hidden = true;
    }
    else
    {
        self.bottomSelectedView.sureBtn.enabled = true;
        self.bottomSelectedView.selectedLabel.hidden = false;
        self.bottomSelectedView.selectedLabel.text = [NSString stringWithFormat:@"已选(%d)",items.count];
    }
    self.selectedPeoples = items.array;
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
