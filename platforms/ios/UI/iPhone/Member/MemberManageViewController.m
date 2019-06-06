//
//  MemberManageViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MemberManageViewController.h"
#import "BSCoreDataManager.h"
#import "BSEditCell.h"
#import "UIImage+Resizable.h"
#import "MemberViewController.h"
#import "ChineseToPinyin.h"
#import "BSFetchStoreListRequest.h"

#define kCellHeight         50
#define kSearchBarHeight    44


@interface StoreObj : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nameLetter;
@property (nonatomic, strong) CDStore *store;
-(id)initWithStore:(CDStore *)store;
@end

@implementation StoreObj
-(id)initWithStore:(CDStore *)store
{
    self = [super init];
    if (self) {
        if (store) {
            self.store = store;
            self.name = self.store.storeName;
        }
        else
        {
            self.name = @"全部";
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



@interface MemberManageViewController ()
{
    UITextField *textField;
    UIButton *hideBtn;
    NSArray *filterStores;
    
    bool isFirstLoadView;
}

@property (nonatomic, strong) NSMutableArray *stores;

@property(nonatomic, strong) UITableView *tableView;

@end


@implementation MemberManageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.hideKeyBoardWhenClickEmpty = true;
    
    self.title = LS(@"MemberManage");
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
//    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    isFirstLoadView = true;
    
    [self initData];
    
    [self registerNofitificationForMainThread:kBSFetchStoreListResponse];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(isFirstLoadView)
    {
        UIView *searchView = [self searchBar];
        [self.view addSubview:searchView];
        
        [self initTableView];
        
    }
    
    isFirstLoadView = false;
}

#pragma mark - init Data & View

- (void) initData
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSArray *storeIds = profile.shopIds;
    self.stores = [NSMutableArray array];
    if (storeIds.count > 0) {
        StoreObj *storeObj = [[StoreObj alloc] initWithStore:nil];
        
        [self.stores addObject:storeObj];
    }
   
    for (int i = 0; i < storeIds.count; i++)
    {
        NSNumber *storeID = [storeIds objectAtIndex:i];
        CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:storeID forKey:@"storeID"];
        if (store) {
            StoreObj *storeObj = [[StoreObj alloc] initWithStore:store];
            if (store.storeID.integerValue == profile.getCurrentStoreID.integerValue)
            {
                [self.stores insertObject:storeObj atIndex:1];
            }
            else
            {
                [self.stores addObject:storeObj];
            }
        }
    }
    
    
    filterStores = [NSArray arrayWithArray: self.stores];
}

- (UIView *)searchBar
{
    UIImage *search_bg = [[UIImage imageNamed:@"search_bg.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 50, 10, 10)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kSearchBarHeight)];
    imgView.userInteractionEnabled = YES;
    imgView.autoresizingMask = 0xff&~UIViewAutoresizingFlexibleHeight&~UIViewAutoresizingFlexibleTopMargin;
    imgView.image = search_bg;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, imgView.frame.size.width - 42, kSearchBarHeight)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont boldSystemFontOfSize:12];
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.autoresizingMask = 0xff;
    [textField addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [imgView addSubview:textField];
    
    return imgView;

}

- (void) initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, self.view.frame.size.width, self.view.frame.size.height - kSearchBarHeight) style:UITableViewStylePlain];
    self.tableView.autoresizingMask =0xff&~UIViewAutoresizingFlexibleTopMargin;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - request & notification
- (void)sendRequest
{
    BSFetchStoreListRequest *request = [[BSFetchStoreListRequest alloc] init];
    request.shopid = [PersonalProfile currentProfile].shopIds;
    [request execute];
}
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchStoreListResponse]) {
        if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] == 0) {
            [self initData];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Hide Keyboard
- (void)hideKeyBoard:(id)sender
{
    [self textFieldDidEndEditing:textField];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)field
{
    NSString *filterString = [NSString stringWithFormat:@"%@*",field.text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name like[cd]%@ || self.nameLetter like[cd]%@",filterString,filterString];
    filterStores = [self.stores filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filterStores.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSEditCellIdentifier";
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentField.enabled = NO;
        cell.contentField.text = @"";
        cell.contentField.placeholder = @"";
        cell.arrowImageView.hidden = NO;
    }
    
    StoreObj *storeObj = [filterStores objectAtIndex:indexPath.row];
    cell.titleLabel.text = storeObj.name;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StoreObj *storeObj = [filterStores objectAtIndex:indexPath.row];
    
    MemberViewController *viewController = [[MemberViewController alloc] initWithStore:storeObj.store];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

