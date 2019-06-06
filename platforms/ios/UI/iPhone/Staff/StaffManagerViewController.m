//
//  StaffManagerViewController.m
//  Boss
//
//  Created by lining on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#define kCellHeight         50
#define kSearchBarHeight    44

#import "StaffManagerViewController.h"
#import "UIImage+Resizable.h"
#import "CBBackButtonItem.h"
#import "BSFetchStaffRequest.h"
#import "StaffViewController.h"
#import "ChineseToPinyin.h"
#import "PersonalProfile.h"


@interface ShopObj : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nameLetter;
@property (nonatomic, strong) CDStore *store;
@property (nonatomic, assign) NSInteger count;
-(id)initWithStore:(CDStore *)store;
@end

@implementation ShopObj
-(id)initWithStore:(CDStore *)store
{
    self = [super init];
    if (self) {
        if (store) {
            self.store = store;
            self.name = self.store.storeName;
            self.count = [[BSCoreDataManager currentManager] fetchStaffsWithShopID:self.store.storeID].count;
        }
        else
        {
            self.name = @"全部";
            self.count = [[BSCoreDataManager currentManager] fetchAllStaffs].count;
        }
    }
    return self;
}

-(void)setName:(NSString *)name
{
    _name = name;
    self.nameLetter = [ChineseToPinyin pinyinFromChiniseString:_name];
}

@end


@interface StaffManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *textField;
    UIButton *hideBtn;
    
    bool isFirstLoadView;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSArray *filterArray;

@end

@implementation StaffManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = LS(@"员工管理");
    
    
//    UIImage *rightImage = [UIImage imageNamed:@"navi_add_n"];
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, rightImage.size.width, rightImage.size.height)];
//    [rightButton setImage:rightImage forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"navi_add_h"] forState:UIControlStateHighlighted];
//    if (IS_SDK7)
//    {
//        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, IOS6_MARGINS - IOS7_MARGINS);
//    }
//    [rightButton addTarget:self action:@selector(didAddBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    isFirstLoadView = true;
  

    [self initData];
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kBSStaffCreateResponse];
    
    //[[[BSFetchStaffRequest alloc] init] execute];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(isFirstLoadView)
    {
        UIView *searchView = [self searchBar];
        [self.view addSubview:searchView];
        
        [self initTableView];
        
        [self initHideBtn];
    }
    
    isFirstLoadView = false;
}

- (void)initData
{
    self.dataArray = [NSMutableArray array];
    
    [self.dataArray addObject:[[ShopObj alloc] initWithStore:nil]];
    
    NSArray *stores = [[BSCoreDataManager currentManager] fetchStoreListWithShopID:nil];
    for (CDStore *store in stores) {
        if ([store.storeID integerValue] == [[PersonalProfile currentProfile].homeSelectedShopID integerValue]) {
            ShopObj *shopObj = [[ShopObj alloc] initWithStore:store];
            if (shopObj.count != 0) {
                [self.dataArray insertObject:shopObj atIndex:1];
            }
        }
        else
        {
            ShopObj *shopObj = [[ShopObj alloc] initWithStore:store];
            if (shopObj.count != 0) {
                [self.dataArray addObject:shopObj];
            }
        }
        
    }
    
    self.filterArray = [NSArray arrayWithArray:self.dataArray];
    
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, self.view.frame.size.width, self.view.frame.size.height - kSearchBarHeight) style:UITableViewStylePlain];
    self.tableView.autoresizingMask =0xff& ~UIViewAutoresizingFlexibleTopMargin;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
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

//隐藏键盘按钮
- (void)initHideBtn
{
    hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hideBtn.frame = self.view.bounds;
    [hideBtn addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    hideBtn.hidden = YES;
    hideBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:hideBtn];
}

#pragma mark - Navigaiotn Right BarButton Pressed
- (void)didAddBarButtonClick:(id)sender
{
    ;
}

#pragma mark - Hide Keyboard
- (void)hideKeyBoard:(id)sender
{
    [textField resignFirstResponder];
    hideBtn.hidden = YES;
    
    NSString *filterString = [NSString stringWithFormat:@"%@*",textField.text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name like[cd]%@ || self.nameLetter like[cd]%@",filterString,filterString];
    self.filterArray = [self.dataArray filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    hideBtn.hidden = NO;
}


#pragma mark - DidReceivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchStaffResponse]) {
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
    else if([notification.name isEqualToString:kBSFetchUsersResponse])
    {
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"indentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (kCellHeight - 20)/2.0 , 100, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.tag = 101;
        [cell.contentView addSubview:nameLabel];
        
        UIImage *accesoryImg = [UIImage imageNamed:@"user_arrow.png"];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - accesoryImg.size.width-90,( kCellHeight - 20)/2.0, 80, 20)];
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.font = [UIFont boldSystemFontOfSize:12];
        countLabel.tag = 102;
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:countLabel];
        
        
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - accesoryImg.size.width - 10, (kCellHeight - accesoryImg.size.height)/2.0, accesoryImg.size.width, accesoryImg.size.height)];
        accessoryImgView.image = accesoryImg;
        [cell.contentView addSubview:accessoryImgView];
        
        
        UIImage *lineImg = [[UIImage imageNamed:@"staff_line.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 1)];
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kCellHeight - 1, self.view.frame.size.width, 1)];
        lineImgView.image = lineImg;
        [cell.contentView addSubview:lineImgView];
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *countLabel = (UILabel *)[cell.contentView viewWithTag:102];
    ShopObj *shopObj = [self.filterArray objectAtIndex:indexPath.row];
    nameLabel.text = shopObj.name;
    
    countLabel.text = [NSString stringWithFormat:@"%d",shopObj.count];

    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return kSearchBarHeight;
    return 0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [self searchBar];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffViewController *staffVC = [[StaffViewController alloc] initWithNibName:NIBCT(@"StaffViewController") bundle:nil];
//    staffVC.dataArray = currentKeyAry;
//    staffVC.dataDict = self.dataDict;
    ShopObj *shopObj = [self.filterArray objectAtIndex:indexPath.row];
    staffVC.shop = shopObj.store;
    [self.navigationController pushViewController:staffVC animated:YES];
}

#pragma mark - MemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
