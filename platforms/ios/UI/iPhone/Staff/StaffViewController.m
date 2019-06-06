//
//  StaffViewController.m
//  Boss
//
//  Created by lining on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//


#define kCellHeight         60
#define kSearchBarHeight    44
#define kFilterHeight       70
#define kMarginSize         20

#import "StaffManagerViewController.h"
#import "BSFetchStaffDepartmentRequest.h"
#import "BSFetchStaffJobRequest.h"
#import "BSFetchUsers.h"
#import "BSFetchPosConfigRequest.h"
#import "StaffViewController.h"
#import "UIImage+Resizable.h"
#import "StaffCell.h"
#import "StaffFilterViewController.h"
#import "StaffDetailViewController.h"
#import "BSFetchStaffRoleRequest.h"
#import "BSFetchStaffRequest.h"


@interface StaffViewController ()<UITableViewDataSource, UITableViewDelegate, StaffCellDelegate>
{
    bool isFirstLoadView;
    UITextField *textField;
    UIButton *hideBtn;

}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *staffArray;
@property(nonatomic, strong) NSMutableDictionary *cachePicParams;
@property(nonatomic, strong) NSArray *filterArray;
@end

@implementation StaffViewController

- (void)initStaffJobDepartmentInfo
{
    BSFetchStaffJobRequest *jobRequest = [[BSFetchStaffJobRequest alloc]init];
    [jobRequest execute];
    
    BSFetchStaffDepartmentRequest *departmentRequest = [[BSFetchStaffDepartmentRequest alloc]init];
    [departmentRequest execute];
    
    BSFetchUsers *request = [[BSFetchUsers alloc]init];
    [request execute];
    
    BSFetchPosConfigRequest *posConRequest = [[BSFetchPosConfigRequest alloc] init];
    [posConRequest execute];
    
    BSFetchStaffRoleRequest *roleRequest = [[BSFetchStaffRoleRequest alloc] init];
    [roleRequest execute];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kBSStaffCreateResponse];
    [self registerNofitificationForMainThread:kBSUpdateStaffInfoResponse];
    
    [self initStaffJobDepartmentInfo];
  
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    if (self.shop) {
        self.navigationItem.title = self.shop.storeName;
    }
    else
    {
        self.navigationItem.title = @"全部";
    }
    
    
    
    
    
    UIImage *rightImage = [UIImage imageNamed:@"navi_add_n"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, rightImage.size.width, rightImage.size.height)];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"navi_add_h"] forState:UIControlStateHighlighted];
    if (IS_SDK7)
    {
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, IOS6_MARGINS - IOS7_MARGINS);
    }
    [rightButton addTarget:self action:@selector(didAddBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    isFirstLoadView = true;
    self.cachePicParams = [NSMutableDictionary dictionary];

    
    BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
    request.shop = self.shop;
    [request execute];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
        UIView *searchView = [self searchBar];
        [self.view addSubview:searchView];
        [self initData];
        [self initTableView];
//        [self initFilterView];
        [self initHideBtn];
    }
    isFirstLoadView = false;
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - init data & view
- (void)initData
{
    self.staffArray = [[BSCoreDataManager currentManager] fetchStaffsWithShopID:self.shop.storeID];
    self.filterArray = [NSArray arrayWithArray:self.staffArray];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, self.view.frame.size.width, self.view.frame.size.height -kSearchBarHeight) style:UITableViewStylePlain];
//    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff&~UIViewAutoresizingFlexibleTopMargin;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

-(void)initFilterView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kFilterHeight , self.view.frame.size.width , kFilterHeight)];
    bottomView.autoresizingMask = 0xff;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIImage *img = [[UIImage imageNamed:@"staff_btn_filter"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 150, 10, 20)];
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.autoresizingMask = 0xff;
    filterBtn.frame = CGRectMake((bottomView.frame.size.width - img.size.width)/2.0, (bottomView.frame.size.height - img.size.height)/2.0, img.size.width, img.size.height);
    [filterBtn setBackgroundImage:img forState:UIControlStateNormal];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:filterBtn];
}

-(UIView *)searchBar
{
    UIImage *search_bg = [[UIImage imageNamed:@"search_bg.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 50, 10, 10)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kSearchBarHeight)];
    imgView.userInteractionEnabled = YES;
    imgView.autoresizingMask = 0xff&~UIViewAutoresizingFlexibleTopMargin&~UIViewAutoresizingFlexibleHeight;
    imgView.image = search_bg;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, imgView.frame.size.width - 42, kSearchBarHeight)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont boldSystemFontOfSize:12];
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    textField.autoresizingMask = 0xff;
    [textField addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [imgView addSubview:textField];
    
    return imgView;
}

- (void)initHideBtn
{
    hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hideBtn.frame = self.view.bounds;
    hideBtn.autoresizingMask = 0xff;
    [hideBtn addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    hideBtn.hidden = YES;
    //    hideBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:hideBtn];

}

#pragma mark - notification
- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchStaffResponse])
    {
        NSDictionary *dict = notification.userInfo;
        if ([[dict objectForKey:@"rc"] integerValue] == 0) {
            [self initData];
            [self.tableView reloadData];
        }

    }
    else if ([notification.name isEqualToString:kBSStaffCreateResponse])
    {
        NSDictionary *dict = notification.userInfo;
        if ([[dict objectForKey:@"rc"] integerValue] == 0) {
            [self initData];
            [self.tableView reloadData];
        }

    }
    else if ([notification.name isEqualToString:kBSUpdateStaffInfoResponse])
    {
        [self.tableView reloadData];
    }
}

#pragma mark - Navigaiotn Right BarButton Pressed
- (void)didAddBarButtonClick:(id)sender
{
    StaffDetailViewController *staffDetail = [[StaffDetailViewController alloc]initWithNibName:NIBCT(@"StaffDetailViewController") bundle:nil];
    staffDetail.type = StaffDetailType_create;
    [self.navigationController pushViewController:staffDetail animated:YES];
}


#pragma mark - Hide Keyboard
- (void)hideKeyBoard:(id)sender
{
    [textField resignFirstResponder];
    hideBtn.hidden = YES;
    NSString *filterString = [NSString stringWithFormat:@"%@*",textField.text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name like[cd]%@ || self.nameLetter like[cd]%@",filterString,filterString];
    self.filterArray = [self.staffArray filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    hideBtn.hidden = NO;
}

#pragma mark - Filter Btn Pressed
- (void)filterBtnPressed:(UIButton *)btn
{
    StaffFilterViewController *filterVC = [[StaffFilterViewController alloc] initWithNibName:NIBCT(@"StaffFilterViewController") bundle:nil];
    [self.navigationController pushViewController:filterVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"indentifier";
    StaffCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[StaffCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.delegate = self;
    }
    CDStaff *staff = [self.filterArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = staff.name;
    cell.IDLable.text = [NSString stringWithFormat:@"%@",staff.staffID];
    cell.indexPath = indexPath;
    [cell.headImgView setImageWithName:staff.imgName tableName:@"hr.employee" filter:staff.staffID fieldName:@"image_medium" writeDate:staff.last_time placeholderString:@"user_default.png" cacheDictionary:self.cachePicParams completion:nil];
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [StaffCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return kSearchBarHeight;
    return 0;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [self searchBar];
//}


#pragma mark - StaffCellDelegate
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    StaffDetailViewController *staffDetail = [[StaffDetailViewController alloc]initWithNibName:NIBCT(@"StaffDetailViewController") bundle:nil];
    staffDetail.type = StaffDetailType_edit;
    CDStaff *staff = [self.filterArray objectAtIndex:indexPath.row];
    staffDetail.staff = staff;
    [self.navigationController pushViewController:staffDetail animated:YES];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
