//
//  PadRestaurantViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadRestaurantViewController.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "BSFetchBookRequest.h"
#import "BSRestaurantRequest.h"
#import "HomeAddPosOperateCell.h"
#import "PadRestaurantEditViewController.h"
#import "PadPosOperateCell.h"
#import "PadTextInputViewController.h"
#import "BSCreateRestaurantOperateRequest.h"
#import "BSDeleteRestaurantOperateRequest.h"
#import "CBLoadingView.h"
#import "BSHandleBookRequest.h"

#define PadRestaurantCollectionCellIdentifier          @"PadRestaurantCollectionCellIdentifier"
#define PadRestaurantCollectionHeaderIdentifier        @"PadRestaurantCollectionHeaderIdentifier"

#define kPadRestaurantSideViewWidth         300.0
#define kPadRestaurantSegmentItemHeight     29.0

typedef enum kPadTakeoutSortType
{
    kPadTakeoutSortByTime,
    kPadTakeoutSortByPrice
}kPadTakeoutSortType;

@interface PadRestaurantViewController ()<PadTextInputViewControllerDelegate>

@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UITableView *floorTableView;
@property (nonatomic, strong) PadRestaurantCollectionView *tableCollectionView;
//@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *takeoutTableView;
@property (nonatomic, strong) UITableView *posOperateTableView;
@property (nonatomic, strong) UITableView *reservationTableView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIImageView *rightView;
@property (nonatomic, strong) UIButton *billingButton;

@property (nonatomic, strong) CDPosOperate *projectOperate;
@property (nonatomic, assign) NSInteger segmentedIndex;
@property (nonatomic, strong) BNSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *restaurantFloors;
@property (nonatomic, strong) NSArray *restaurantTables;
@property (nonatomic, strong) CDRestaurantFloor *selectedFloor;
@property (nonatomic, strong) CDRestaurantTable *selectedTable;
@property (nonatomic, assign) NSInteger selectedCustomerIndex;
@property (nonatomic, strong) NSMutableDictionary* imageCacheDictionary;

@property (nonatomic, strong) NSArray *takeouts;
@property (nonatomic, assign) kPadTakeoutSortType sortType;
@property (nonatomic, strong) NSArray *posOperates;
@property (nonatomic, strong) NSArray *reservations;

@property(nonatomic, strong)PadMaskView *maskView;
@property(nonatomic)kPadTextInputType inputType;

@end


@implementation PadRestaurantViewController

- (id)initWithDelegate:(id<PadRestaurantViewControllerDelegate>)delegate
{
    self = [super initWithNibName:@"PadRestaurantViewController" bundle:nil];
    if (self)
    {
        self.delegate = delegate;
        self.selectedCustomerIndex = -1;
        self.segmentedIndex = 0;
        self.takeouts = [[BSCoreDataManager currentManager] fetchTakeoutPosOperates:@"operate_date"];
        self.posOperates = [[BSCoreDataManager currentManager] fetchLocalPosOperates:@"operate_id"];
        self.reservations = [[BSCoreDataManager currentManager] fetchTodayBooks];
        self.restaurantFloors = [[BSCoreDataManager currentManager] fetchAllRestaurantFloor];
        self.imageCacheDictionary = [NSMutableDictionary dictionary];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLocalPosOperateNotification object:nil userInfo:@{@"count":@(self.posOperates.count)}];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = COLOR(239.0, 242.0, 242.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kFetchBookResponse];
    [self registerNofitificationForMainThread:kBSCreateBookResponse];
    [self registerNofitificationForMainThread:kBSEditBookResponse];
    [self registerNofitificationForMainThread:kBSDeleteBookResponse];
    [self registerNofitificationForMainThread:kBSRestaurantRequestSuccess];
    [self registerNofitificationForMainThread:kFetchRestaurantTableResponse];
    [self registerNofitificationForMainThread:kBSRestaurantRequestFailed];
    [self registerNofitificationForMainThread:kBSPadCashierSuccess];
    [self registerNofitificationForMainThread:kBSPadAllotPerformance];
    [self registerNofitificationForMainThread:kBSPadGiveGiftCard];
    [self registerNofitificationForMainThread:kCreateRestaurantOperateResponse];
    
    [self initLeftSide];
    [self initRightSide];
    [self initNavi];
    
    if (self.restaurantFloors.count > 0)
    {
        self.selectedFloor = [self.restaurantFloors objectAtIndex:0];
    }
    else
    {
        self.selectedFloor = nil;
    }
    
    [[BSRestaurantRequest sharedInstance] startRestaurantRequest];
    BSFetchBookRequest *request = [[BSFetchBookRequest alloc] init];
    [request execute];
    
    self.maskView = [[PadMaskView alloc] init];
    [self.view addSubview:self.maskView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.restaurantFloors = [[BSCoreDataManager currentManager] fetchAllRestaurantFloor];
    
    if ( self.selectedFloor && [self.restaurantFloors indexOfObject:self.selectedFloor] == NSNotFound )
    {
        self.selectedFloor = nil;
        if ( self.restaurantFloors.count > 0 )
        {
            self.selectedFloor = self.restaurantFloors[0];
        }
    }
    
    if ( !self.selectedFloor )
    {
        [self fetchTakeoutPosOperates];
        [self.takeoutTableView reloadData];
    }
    else
    {
        [self reloadFloorTables];
    }
    
    self.posOperates = [[BSCoreDataManager currentManager] fetchLocalPosOperates:@"operate_id"];
    [self.posOperateTableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLocalPosOperateNotification object:nil userInfo:@{@"count":@(self.reservations.count)}];
    
    if (self.segmentedIndex == 0)
    {
        
    }
    else if (self.segmentedIndex == 1)
    {
        self.reservations = [[BSCoreDataManager currentManager] fetchTodayBooks];
        [self.reservationTableView reloadData];
    }
    
    [self.floorTableView reloadData];
}

- (void)initLeftSide
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(kPadRestaurantCollectionCellWidth, kPadRestaurantCollectionCellHeight)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(18.0, 16.0, 16.0, 16.0);
    layout.minimumLineSpacing = 16.0;
    layout.minimumInteritemSpacing = 0.0;
    
//    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(152.0, kPadNaviHeight, IC_SCREEN_WIDTH - 2 * 152.0, 72.0)];
//    self.headerView.backgroundColor = COLOR(239.0, 242.0, 242.0, 1.0);
//    self.headerView.userInteractionEnabled = YES;
//    self.headerView.hidden = YES;
//    [self.view addSubview:self.headerView];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (72.0 - 20.0)/2.0, 64.0, 20.0)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont systemFontOfSize:15.0];
//    titleLabel.textColor = COLOR(134.0, 157.0, 157.0, 1.0);
//    titleLabel.text = @"排序:";
//    [self.headerView addSubview:titleLabel];
//    
//    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(75.0, (72.0 - 24.0)/2.0, 64.0, 24.0)];
//    background.backgroundColor = [UIColor clearColor];
//    background.image = [UIImage imageNamed:@"Home_tab_item_bg"];
//    background.tag = 1000;
//    [self.headerView addSubview:background];
//    
//    UIButton *timeSortButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    timeSortButton.backgroundColor = [UIColor clearColor];
//    timeSortButton.frame = CGRectMake(76.0, 12.0, 64.0, 72.0 - 2 * 12.0);
//    timeSortButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [timeSortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [timeSortButton setTitle:@"时间" forState:UIControlStateNormal];
//    [timeSortButton addTarget:self action:@selector(didSortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    timeSortButton.tag = 1001;
//    [self.headerView addSubview:timeSortButton];
//    
//    UIButton *priceSortButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    priceSortButton.backgroundColor = [UIColor clearColor];
//    priceSortButton.frame = CGRectMake(76.0 + 64.0 + 16.0, 12.0, 64.0, 72.0 - 2 * 12.0);
//    priceSortButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [priceSortButton setTitle:@"总价" forState:UIControlStateNormal];
//    [priceSortButton setTitleColor:COLOR(134.0, 157.0, 157.0, 1.0) forState:UIControlStateNormal];
//    [priceSortButton addTarget:self action:@selector(didSortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    priceSortButton.tag = 1002;
//    [self.headerView addSubview:priceSortButton];
    
    self.takeoutTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT - kPadNaviHeight) style:UITableViewStylePlain];
    self.takeoutTableView.backgroundColor = [UIColor clearColor];
    self.takeoutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.takeoutTableView.dataSource = self;
    self.takeoutTableView.delegate = self;
    self.takeoutTableView.showsVerticalScrollIndicator = NO;
    self.takeoutTableView.showsHorizontalScrollIndicator = NO;
    self.takeoutTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.takeoutTableView.hidden = YES;
    [self.view addSubview:self.takeoutTableView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    self.takeoutTableView.tableHeaderView = headerView;
    [self.takeoutTableView registerNib:[UINib nibWithNibName:@"HomeCurrentPosTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeCurrentPosTableViewCell"];
    
    self.tableCollectionView = [[PadRestaurantCollectionView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadRestaurantSideViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight) collectionViewLayout:layout];
    self.tableCollectionView.backgroundColor = [UIColor clearColor];
    self.tableCollectionView.dataSource = self;
    self.tableCollectionView.delegate = self;
    self.tableCollectionView.isItemCanMove = NO;
    self.tableCollectionView.alwaysBounceVertical = YES;
    self.tableCollectionView.showsVerticalScrollIndicator = NO;
    self.tableCollectionView.showsHorizontalScrollIndicator = NO;
    [self.tableCollectionView registerClass:[PadRestaurantCollectionCell class] forCellWithReuseIdentifier:PadRestaurantCollectionCellIdentifier];
    [self.view addSubview:self.tableCollectionView];
}

- (void)initRightSide
{
    self.rightView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kPadRestaurantSideViewWidth, kPadNaviHeight + 18.0, kPadRestaurantSideViewWidth - 16.0, IC_SCREEN_HEIGHT - kPadNaviHeight - 18.0 - 16.0)];
    self.rightView.backgroundColor = [UIColor clearColor];
    self.rightView.image = [[UIImage imageNamed:@"pad_restaurant_table_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    self.rightView.userInteractionEnabled = YES;
    [self.view addSubview:self.rightView];
    
    NSArray *segmentedItems = [NSArray arrayWithObjects:LS(@"PadCurrentCustomer"), LS(@"PadReservationCustomer"), nil];
    BNSegmentedControl *segmentedControl = [[BNSegmentedControl alloc] initWithItems:segmentedItems];
    CGFloat itemWidth = floor((kPadRestaurantSideViewWidth - 16.0 - 16.0 * 2)/segmentedItems.count);
    segmentedControl.frame = CGRectMake(16.0, 12.0 + 1.0, itemWidth * segmentedItems.count, kPadRestaurantSegmentItemHeight);
    segmentedControl.leftImageItems = [NSArray arrayWithObjects:
                                       [[UIImage imageNamed:@"pad_segmented_left_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)],
                                       [[UIImage imageNamed:@"pad_segmented_left_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)], nil];
    segmentedControl.rightImageItems = [NSArray arrayWithObjects:
                                        [[UIImage imageNamed:@"pad_segmented_right_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)],
                                        [[UIImage imageNamed:@"pad_segmented_right_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)], nil];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.normalFontColor = COLOR(90.0, 211.0, 213.0, 1.0);
    segmentedControl.selectFontColor = [UIColor whiteColor];
    segmentedControl.textFont = [UIFont systemFontOfSize:13.0];
    segmentedControl.delegate = self;
    [self.rightView addSubview:segmentedControl];
    
    self.segmentedControl = segmentedControl;
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 12.0 + kPadRestaurantSegmentItemHeight + 12.0, kPadRestaurantSideViewWidth - 16.0, 1.0)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
    [self.rightView addSubview:lineImageView];
    
    CGFloat originY = 12.0 + kPadRestaurantSegmentItemHeight + 12.0 + 1.0;
    self.posOperateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, originY, self.rightView.frame.size.width, self.rightView.frame.size.height - originY - kPadConfirmButtonHeight) style:UITableViewStylePlain];
    self.posOperateTableView.backgroundColor = [UIColor clearColor];
    self.posOperateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.posOperateTableView.dataSource = self;
    self.posOperateTableView.delegate = self;
    self.posOperateTableView.showsVerticalScrollIndicator = NO;
    self.posOperateTableView.showsHorizontalScrollIndicator = NO;
    self.posOperateTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.rightView addSubview:self.posOperateTableView];
    
    self.reservationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, originY, self.rightView.frame.size.width, self.rightView.frame.size.height - originY - kPadConfirmButtonHeight) style:UITableViewStylePlain];
    self.reservationTableView.backgroundColor = [UIColor clearColor];
    self.reservationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.reservationTableView.dataSource = self;
    self.reservationTableView.delegate = self;
    self.reservationTableView.showsVerticalScrollIndicator = NO;
    self.reservationTableView.showsHorizontalScrollIndicator = NO;
    self.reservationTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.reservationTableView.hidden = YES;
    [self.rightView addSubview:self.reservationTableView];
    
    self.billingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.billingButton.frame = CGRectMake(0.0, self.rightView.frame.size.height - kPadConfirmButtonHeight, self.rightView.frame.size.width, kPadConfirmButtonHeight);
    self.billingButton.backgroundColor = [UIColor clearColor];
    [self.billingButton setBackgroundImage:[[UIImage imageNamed:@"pad_restaurant_order_button_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)] forState:UIControlStateNormal];
    [self.billingButton setBackgroundImage:[[UIImage imageNamed:@"pad_restaurant_order_button_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)] forState:UIControlStateHighlighted];
    [self.billingButton addTarget:self action:@selector(didBillingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:self.billingButton];
    
    UIImage *addImage = [UIImage imageNamed:@"pad_restaurant_add_bill_n"];
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.rightView.frame.size.width/2.0 - addImage.size.width - 4.0, (kPadConfirmButtonHeight - addImage.size.height)/2.0, addImage.size.width, addImage.size.height)];
    addImageView.backgroundColor = [UIColor clearColor];
    addImageView.image = addImage;
    addImageView.tag = 101;
    [self.billingButton addSubview:addImageView];
    
    UILabel *billingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.rightView.frame.size.width/2.0, 0.0, self.rightView.frame.size.width/2.0, kPadConfirmButtonHeight)];
    billingLabel.backgroundColor = [UIColor clearColor];
    billingLabel.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
    billingLabel.textAlignment = NSTextAlignmentLeft;
    billingLabel.font = [UIFont boldSystemFontOfSize:17.0];
    billingLabel.text = LS(@"PadRestaurantBilling");
    billingLabel.tag = 102;
    [self.billingButton addSubview:billingLabel];
}

- (void)initNavi
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
    
    UIImageView *leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(kPadNaviHeight - 0.5, 0.0, 0.5, kPadRestaurantFloorCellHeight)];
    leftLine.backgroundColor = [UIColor clearColor];
    leftLine.image = [UIImage imageNamed:@"pad_restaurant_floor_left_line"];
    [self.naviBar addSubview:leftLine];
    
    self.floorTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.floorTableView.backgroundColor = [UIColor clearColor];
    self.floorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.floorTableView.delegate = self;
    self.floorTableView.dataSource = self;
    self.floorTableView.showsVerticalScrollIndicator = NO;
    self.floorTableView.showsHorizontalScrollIndicator = NO;
    self.floorTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.floorTableView.frame = CGRectMake(kPadNaviHeight, 0.0, IC_SCREEN_WIDTH - 2 * kPadNaviHeight, kPadNaviHeight);
    [self.naviBar addSubview:self.floorTableView];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(IC_SCREEN_WIDTH - kPadNaviHeight, 0.0, kPadNaviHeight, kPadNaviHeight);
    self.editButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.editButton setTitle:LS(@"PadRestaurantEdit") forState:UIControlStateNormal];
    [self.editButton setTitleColor:COLOR(169.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(didEditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:self.editButton];
    
    [self refreshRestaurantFloorAndTable];
}

//- (void)didSortButtonClick:(id)sender
//{
//    UIButton *button = (id)sender;
//    if (button.tag == 1001)
//    {
//        if (self.sortType == kPadTakeoutSortByTime)
//        {
//            return;
//        }
//        
//        self.sortType = kPadTakeoutSortByTime;
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        UIButton *priceSortButton = (UIButton *)[self.headerView viewWithTag:1002];
//        [priceSortButton setTitleColor:COLOR(134.0, 157.0, 157.0, 1.0) forState:UIControlStateNormal];
//    }
//    else if (button.tag == 1002)
//    {
//        if (self.sortType == kPadTakeoutSortByPrice)
//        {
//            return;
//        }
//        
//        self.sortType = kPadTakeoutSortByPrice;
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        UIButton *timeSortButton = (UIButton *)[self.headerView viewWithTag:1001];
//        [timeSortButton setTitleColor:COLOR(134.0, 157.0, 157.0, 1.0) forState:UIControlStateNormal];
//    }
//    
//    UIImageView *background = (UIImageView *)[self.headerView viewWithTag:1000];
//    background.frame = CGRectMake(button.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height);
//    [self fetchTakeoutPosOperates];
//    [self.takeoutTableView reloadData];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Required Methods

- (void)setSelectedFloor:(CDRestaurantFloor *)selectedFloor
{
    if (_selectedFloor && _selectedFloor.floorID.integerValue == selectedFloor.floorID.integerValue)
    {
        return;
    }
    _selectedFloor = selectedFloor;
    
    if (_selectedFloor == nil)
    {
        self.rightView.hidden = YES;
        self.editButton.hidden = NO;
        self.tableCollectionView.hidden = YES;
//        self.headerView.hidden = NO;
        self.takeoutTableView.hidden = NO;
        
        [self fetchTakeoutPosOperates];
        [self.takeoutTableView reloadData];
    }
    else
    {
//        self.headerView.hidden = YES;
        self.takeoutTableView.hidden = YES;
        self.rightView.hidden = NO;
        self.editButton.hidden = NO;
        self.tableCollectionView.hidden = NO;
        
        [self reloadFloorTables];
    }
}

- (void)reloadFloorTables
{
    if ( self.selectedFloor )
    {
        self.restaurantTables = [[BSCoreDataManager currentManager] fetchRestaurantTableWithFloor:self.selectedFloor];
    }
    
    [self.tableCollectionView reloadData];
}

#pragma mark -
#pragma mark Required Methods

- (void)fetchTakeoutPosOperates
{
    if (self.sortType == kPadTakeoutSortByTime)
    {
        self.takeouts = [[BSCoreDataManager currentManager] fetchTakeoutPosOperates:@"operate_date"];
    }
    else if (self.sortType == kPadTakeoutSortByPrice)
    {
        self.takeouts = [[BSCoreDataManager currentManager] fetchTakeoutPosOperates:@"amount"];
    }
}

- (void)refreshRestaurantFloorAndTable
{
    NSInteger floorCount = self.restaurantFloors.count + ([PersonalProfile currentProfile].isTakeout.boolValue ? 1 : 0);
    if (floorCount * kPadRestaurantFloorCellWidth <= IC_SCREEN_WIDTH - 2 * kPadNaviHeight)
    {
        self.floorTableView.scrollEnabled = NO;
    }
    else
    {
        self.floorTableView.scrollEnabled = YES;
    }
    
    [self refreshBillingButton];
    [self.floorTableView reloadData];
    [self.tableCollectionView reloadData];
}

- (void)refreshBillingButton
{
    UIImageView *addImageView = (UIImageView *)[self.billingButton viewWithTag:101];
    UILabel *billingLabel = (UILabel *)[self.billingButton viewWithTag:102];
    
    if (self.selectedTable /* && self.selectedTable.tableState.integerValue == kPadRestaurantTableStateIdle */ && (self.segmentedIndex == 0 || (self.segmentedIndex == 1 && self.selectedCustomerIndex >= 0)))
    {
        addImageView.image = [UIImage imageNamed:@"pad_restaurant_add_bill_h"];
        billingLabel.textColor = [UIColor whiteColor];
        [self.billingButton setBackgroundImage:[[UIImage imageNamed:@"pad_restaurant_order_button_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)] forState:UIControlStateNormal];
        [self.billingButton setBackgroundImage:[[UIImage imageNamed:@"pad_restaurant_order_button_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)] forState:UIControlStateHighlighted];
    }
    else
    {
        addImageView.image = [UIImage imageNamed:@"pad_restaurant_add_bill_n"];
        billingLabel.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
        [self.billingButton setBackgroundImage:[[UIImage imageNamed:@"pad_restaurant_order_button_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)] forState:UIControlStateNormal];
        [self.billingButton setBackgroundImage:[[UIImage imageNamed:@"pad_restaurant_order_button_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)] forState:UIControlStateHighlighted];
    }
}

- (void)didMenuButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBackPadSideBar)])
    {
        [self.delegate didBackPadSideBar];
    }
}

- (void)didEditButtonClick:(id)sender
{
    PadRestaurantEditViewController *editViewController = [[PadRestaurantEditViewController alloc] initWithNibName:@"PadRestaurantEditViewController" bundle:nil];
    [self.navigationController pushViewController:editViewController animated:NO];
}

- (void)didBillingButtonClick:(id)sender
{
    if (!self.selectedTable /* || self.selectedTable.tableState.integerValue == kPadRestaurantTableStateUsing || self.selectedTable.tableState.integerValue == kPadRestaurantTableStateBook || self.selectedTable.usingQty.integerValue != 0 */)
    {
        return;
    }
    
    if (self.segmentedIndex == 0)
    {
        self.inputType = kPadTextInputRestaurant;
        PadTextInputViewController *viewController = [[PadTextInputViewController alloc] initWithType:kPadTextInputRestaurant];
        viewController.delegate = self;
        viewController.maskView = self.maskView;
        CBRotateNavigationController *navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        navi.navigationBarHidden = YES;
        navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
    else if (self.segmentedIndex == 1)
    {
        if (self.selectedCustomerIndex >= 0)
        {
            self.inputType = kPadTextInputBookedRestaurant;
            PadTextInputViewController *viewController = [[PadTextInputViewController alloc] initWithType:kPadTextInputBookedRestaurant];
            viewController.delegate = self;
            viewController.maskView = self.maskView;
            CBRotateNavigationController *navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
            navi.navigationBarHidden = YES;
            navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
            self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
            self.maskView.navi.navigationBarHidden = YES;
            self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
            [self.maskView addSubview:self.maskView.navi.view];
            [self.maskView show];
        }
    }
}

- (void)didTextInputFinishedWithType:(kPadTextInputType)type inputText:(NSString *)inputText
{
    [[CBLoadingView shareLoadingView] show];
    
    BSCreateRestaurantOperateRequest* request = [[BSCreateRestaurantOperateRequest alloc] initWithTable:self.selectedTable personCount:[inputText integerValue] isBooked:(type == kPadTextInputBookedRestaurant) ? YES : NO];
    [request execute];
    
    [self.maskView hidden];
}

#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchStartInfoResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if (result == 0)
        {
            [self refreshRestaurantFloorAndTable];
        }
    }
    if ([notification.name isEqualToString:kFetchBookResponse] || [notification.name isEqualToString:kBSCreateBookResponse] || [notification.name isEqualToString:kBSEditBookResponse] || [notification.name isEqualToString:kBSDeleteBookResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.reservations = [[BSCoreDataManager currentManager] fetchTodayBooks];
            [self.reservationTableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kBSRestaurantRequestSuccess] || [notification.name isEqualToString:kFetchRestaurantTableResponse])
    {
        self.restaurantFloors = [[BSCoreDataManager currentManager] fetchAllRestaurantFloor];
        if ( self.selectedFloor )
        {
            self.restaurantTables = [[BSCoreDataManager currentManager] fetchRestaurantTableWithFloor:self.selectedFloor];
        }
        
        [self reloadFloorTables];
        [self refreshRestaurantFloorAndTable];
    }
    else if ([notification.name isEqualToString:kBSRestaurantRequestFailed])
    {
        ;
    }
    else if ([notification.name isEqualToString:kBSPadCashierSuccess])
    {
        self.selectedTable = nil;
        self.selectedCustomerIndex = -1;
        self.reservations = [[BSCoreDataManager currentManager] fetchTodayBooks];
        [self refreshRestaurantFloorAndTable];
    }
    else if ([notification.name isEqualToString:kBSPadAllotPerformance])
    {
        ;
    }
    else if ([notification.name isEqualToString:kBSPadGiveGiftCard])
    {
        ;
    }
    else if ([notification.name isEqualToString:kCreateRestaurantOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            BSCreateRestaurantOperateRequest* request = notification.object;
            
            if ( self.inputType == kPadTextInputRestaurant )
            {
                PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithRestaurant:self.selectedTable personCount:request.personCount occupyID:request.occupyID book:nil];
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if ( self.inputType == kPadTextInputBookedRestaurant )
            {
                CDBook *book = [self.reservations objectAtIndex:self.selectedCustomerIndex];
                PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithRestaurant:self.selectedTable personCount:request.personCount occupyID:request.occupyID book:book];
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            
            [self.segmentedControl setCurrentIndex:0];
            
            self.inputType = -1;
        }
        else
        {
            NSString *message = [notification.userInfo objectForKey:@"rm"];
            UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [view show];
        }
    }
}

#pragma mark -
#pragma mark BNSegmentedControlDelegate Methods

- (void)segmentedControl:(BNSegmentedControl *)segmentedControl didSelectedAtIndex:(NSInteger)selectedIndex
{
    self.segmentedIndex = selectedIndex;
    self.selectedCustomerIndex = -1;
    [self refreshBillingButton];
    if (self.segmentedIndex == 0)
    {
        self.posOperateTableView.hidden = NO;
        self.reservationTableView.hidden = YES;
        [self.posOperateTableView reloadData];
    }
    else if (self.segmentedIndex == 1)
    {
        self.posOperateTableView.hidden = YES;
        self.reservationTableView.hidden = NO;
        [self.reservationTableView reloadData];
    }
}


#pragma mark -
#pragma mark PadProjectViewControllerDelegate Methods

- (void)didPadProjectViewControllerMenuButtonPressed:(CDPosOperate*)operate
{
    self.projectOperate = operate;
    if (!self.selectedFloor)
    {
        [self.takeoutTableView reloadData];
    }
}


#pragma mark -
#pragma mark PadRestaurantCollectionViewDataSource Methods

- (NSInteger)collectionView:(PadRestaurantCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.restaurantTables.count;
}

- (UICollectionViewCell *)collectionView:(PadRestaurantCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PadRestaurantCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PadRestaurantCollectionCellIdentifier forIndexPath:indexPath];
    
    CDRestaurantTable *table = (CDRestaurantTable *)[self.restaurantTables objectAtIndex:indexPath.row];
    cell.titleLabel.text = table.tableName;
    cell.seatsLabel.text = [NSString stringWithFormat:@"%d/%d", table.usingQty.integerValue, table.tableSeats.integerValue];
    
    if (table.tableState.integerValue == kPadRestaurantTableStateIdle)
    {
        cell.seatsLabel.textColor = COLOR(179.0, 213.0, 219.0, 1.0);
        cell.ratioImageView.backgroundColor = COLOR(179.0, 213.0, 219.0, 1.0);
    }
    else
    {
        cell.seatsLabel.textColor = [UIColor whiteColor];
        cell.ratioImageView.backgroundColor = COLOR(84.0, 211.0, 214.0, 1.0);
    }
    
    if (table.usingQty.integerValue == 0)
    {
        cell.seatsLabel.textColor = COLOR(179.0, 213.0, 219.0, 1.0);
    }
    
    CGFloat origin = kPadRestaurantCollectionCellHeight;
    if ( table.tableSeats.floatValue != 0 )
    {
        origin = ((float)(table.tableSeats.floatValue - table.usingQty.floatValue)/table.tableSeats.floatValue) * kPadRestaurantCollectionCellHeight;
        if ( origin != kPadRestaurantCollectionCellHeight && origin > 83 )
        {
            origin = 83;
        }
    }
    
    cell.ratioImageView.frame = CGRectMake(0.0, origin, kPadRestaurantCollectionCellWidth, kPadRestaurantCollectionCellHeight - origin);
    if (self.selectedTable && self.selectedTable.tableID.integerValue == table.tableID.integerValue)
    {
        cell.selectedImageView.hidden = NO;
    }
    else
    {
        cell.selectedImageView.hidden = YES;
    }
    
    return cell;
}


#pragma mark -
#pragma mark PadProjectCollectionViewDelegate Methods

- (void)collectionView:(PadRestaurantCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    CDRestaurantTable *table = [self.restaurantTables objectAtIndex:indexPath.row];
    if (self.selectedTable && self.selectedTable.tableID.integerValue == table.tableID.integerValue)
    {
        self.selectedTable = nil;
    }
    else
    {
        self.selectedTable = table;
    }
    
    [self refreshBillingButton];
    [self.tableCollectionView reloadData];
}

- (NSIndexPath *)collectionView:(PadRestaurantCollectionView *)collectionView targetIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    return toIndexPath;
}

- (void)collectionView:(PadRestaurantCollectionView *)collectionView willMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    ;
}

- (void)collectionView:(PadRestaurantCollectionView *)collectionView didMoveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    ;
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.floorTableView)
    {
        if ([PersonalProfile currentProfile].isTakeout.boolValue)
        {
            return self.restaurantFloors.count + 1;
        }
        else
        {
            return self.restaurantFloors.count;
        }
    }
    else if (tableView == self.takeoutTableView)
    {
        return self.takeouts.count + 1;
    }
    else if (tableView == self.posOperateTableView)
    {
        return self.posOperates.count;
    }
    else if (tableView == self.reservationTableView)
    {
        return self.reservations.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.floorTableView)
    {
        return kPadRestaurantFloorCellWidth;
    }
    else if (tableView == self.takeoutTableView)
    {
        return kHomeAddPosOperateCellHeight;
    }
    else if (tableView == self.posOperateTableView)
    {
        return kPadPosOperateCellHeight;
    }
    else if (tableView == self.reservationTableView)
    {
        return kPadCustomerCellHeight;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.floorTableView)
    {
        static NSString *CellIdentifier = @"PadRestaurantFloorCellIdentifier";
        PadRestaurantFloorCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadRestaurantFloorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.leftLine.hidden = YES;
        if (indexPath.row == 0 && self.floorTableView.scrollEnabled == YES)
        {
            cell.leftLine.hidden = NO;
        }
        
        CDRestaurantFloor *floor = nil;
        if ([PersonalProfile currentProfile].isTakeout.boolValue)
        {
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = LS(@"PadRestaurantTakeout");
            }
            else
            {
                floor = [self.restaurantFloors objectAtIndex:indexPath.row - 1];
                cell.titleLabel.text = floor.floorName;
            }
        }
        else
        {
            floor = [self.restaurantFloors objectAtIndex:indexPath.row];
            cell.titleLabel.text = floor.floorName;
        }
        
        if ([PersonalProfile currentProfile].isTakeout.boolValue && indexPath.row == 0)
        {
            if (!self.selectedFloor)
            {
                cell.titleLabel.textColor = COLOR(90.0, 211.0, 213.0, 1.0);
                cell.background.image = [UIImage imageNamed:@"pad_restaurant_floor_h"];
            }
            else
            {
                cell.titleLabel.textColor = COLOR(170.0, 177.0, 177.0, 1.0);
                cell.background.image = [UIImage imageNamed:@"pad_restaurant_floor_n"];
            }
        }
        else
        {
            if (self.selectedFloor && self.selectedFloor.floorID.integerValue == floor.floorID.integerValue)
            {
                cell.titleLabel.textColor = COLOR(90.0, 211.0, 213.0, 1.0);
                cell.background.image = [UIImage imageNamed:@"pad_restaurant_floor_h"];
            }
            else
            {
                cell.titleLabel.textColor = COLOR(170.0, 177.0, 177.0, 1.0);
                cell.background.image = [UIImage imageNamed:@"pad_restaurant_floor_n"];
            }
        }
        
        return cell;
    }
    else if (tableView == self.takeoutTableView)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"HomeAddPosOperateCellIdentifier";
            HomeAddPosOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[HomeAddPosOperateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            return cell;
        }
        else
        {
            HomeCurrentPosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCurrentPosTableViewCell"];
            cell.delegate = self;
            
            CDPosOperate *posOperate = self.takeouts[indexPath.row - 1];
            [cell setPosOperate:posOperate indexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
            
            cell.isCurrentPos = (posOperate == self.projectOperate ? YES : NO);
            [cell.avatarImageView setImageWithName:[NSString stringWithFormat:@"%@_%@", posOperate.member.memberID, posOperate.member_name] tableName:@"born.member" filter:posOperate.member.memberID fieldName:@"image" writeDate:posOperate.operate_date placeholderString:(cell.isCurrentPos ? @"pad_avatar_currentPos" : @"pad_avatar_default") cacheDictionary:self.imageCacheDictionary];
            
            return cell;
        }
        
        return nil;
    }
    else if (tableView == self.posOperateTableView)
    {
        static NSString *CellIdentifier = @"PadPosOperateCellIdentifier";
        PadPosOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadPosOperateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CDPosOperate *posOperate = [self.posOperates objectAtIndex:indexPath.row];
        cell.titleLabel.text = posOperate.member.memberName;
        if (posOperate.member.isDefaultCustomer.boolValue)
        {
            cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadDefaultCustomer")];
            if (posOperate.book)
            {
                cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadBookedCustomer"), posOperate.book.booker_name];
            }
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *startDate = [dateFormatter dateFromString:posOperate.operate_date];
        dateFormatter.dateFormat = @"HH:mm";
        cell.timeLabel.text = [dateFormatter stringFromDate:startDate];
        cell.phoneLabel.text = posOperate.member.mobile;
        cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadTableCurrentNumber"), posOperate.restaurant_person_count];
        
        return cell;
    }
    else if (tableView == self.reservationTableView)
    {
        static NSString *CellIdentifier = @"PadReservationCellIdentifier";
        PadCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell isSelectImageViewSelected:NO];
        if (indexPath.row == self.selectedCustomerIndex)
        {
            [cell isSelectImageViewSelected:YES];
        }
        
        CDBook *book = [self.reservations objectAtIndex:indexPath.row];
        cell.titleLabel.text = book.booker_name;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *startDate = [dateFormatter dateFromString:book.start_date];
        dateFormatter.dateFormat = @"HH:mm";
        cell.timeLabel.text = [dateFormatter stringFromDate:startDate];
        cell.phoneLabel.text = book.telephone;
        cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadTableCurrentNumber"), @(2)];
        
        return cell;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.posOperateTableView)
    {
        return YES;
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.posOperateTableView)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.posOperateTableView)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            CDPosOperate *posOperate = (CDPosOperate *)[self.posOperates objectAtIndex:indexPath.row];
            if ( posOperate.occupy_restaurant_id )
            {
                BSDeleteRestaurantOperateRequest* request = [[BSDeleteRestaurantOperateRequest alloc] initWithOccupyID:posOperate.occupy_restaurant_id];
                [request execute];
            }
            
            NSArray* products = posOperate.products.array;
            
            for ( CDPosProduct* product in products )
            {
                CDBook* book = product.book;
                if ( book )
                {
                    book.isUsed = @(FALSE);
                    BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
                    if ( [book.is_reservation_bill boolValue] )
                    {
                        request.type = HandleBookType_delete;
                    }
                    else
                    {
                        request.type = HandleBookType_approved;
                    }
                    [request execute];
                }
            }
            
            if ( posOperate.book )
            {
                posOperate.book.isUsed = @(FALSE);
                
                BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:posOperate.book];
                if ( [posOperate.book.is_reservation_bill boolValue] )
                {
                    request.type = HandleBookType_delete;
                }
                else
                {
                    request.type = HandleBookType_approved;
                }
                [request execute];
            }
            
            [[BSCoreDataManager currentManager] deleteObject:posOperate];
            self.posOperates = [[BSCoreDataManager currentManager] fetchLocalPosOperates:@"operate_id"];
            [self.posOperateTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLocalPosOperateNotification object:nil userInfo:@{@"count":@(self.posOperates.count)}];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.floorTableView)
    {
        if ([PersonalProfile currentProfile].isTakeout.boolValue)
        {
            CDRestaurantFloor *floor = nil;
            if (indexPath.row != 0)
            {
                floor = [self.restaurantFloors objectAtIndex:indexPath.row - 1];
            }
            
            if (self.selectedFloor.floorID.integerValue == floor.floorID.integerValue)
            {
                return;
            }
            self.selectedFloor = floor;
            self.selectedTable = nil;
            [self refreshRestaurantFloorAndTable];
        }
        else
        {
            CDRestaurantFloor *floor = [self.restaurantFloors objectAtIndex:indexPath.row];
            if (self.selectedFloor.floorID.integerValue == floor.floorID.integerValue)
            {
                return;
            }
            self.selectedFloor = floor;
            self.selectedTable = nil;
            [self refreshRestaurantFloorAndTable];
        }
    }
    else if (tableView == self.takeoutTableView)
    {
        if (indexPath.row == 0)
        {
            PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithTakeoutWithHandNo:@""];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else if (tableView == self.posOperateTableView)
    {
        CDPosOperate *posOperate = [self.posOperates objectAtIndex:indexPath.row];
        PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithPosOperate:posOperate];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (tableView == self.reservationTableView)
    {
        if (self.selectedCustomerIndex == indexPath.row)
        {
            self.selectedCustomerIndex = -1;
        }
        else
        {
            self.selectedCustomerIndex = indexPath.row;
        }
        [self refreshBillingButton];
        [self.reservationTableView reloadData];
    }
}


#pragma mark -
#pragma mark HomeCurrentPosTableViewCellDelegate Methods

- (void)didHomeCurrentPosTableViewCellDeleteButtonPresssed:(HomeCurrentPosTableViewCell*)cell
{
    [[BSCoreDataManager currentManager] deleteObject:cell.posOperate];
    [[BSCoreDataManager currentManager] save:nil];
    
    [self fetchTakeoutPosOperates];
    NSIndexPath *indexPath = [self.takeoutTableView indexPathForCell:cell];
    [self.takeoutTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    for (HomeCurrentPosTableViewCell *cell in [self.takeoutTableView visibleCells])
    {
        if ([cell isKindOfClass:[HomeCurrentPosTableViewCell class]])
        {
            NSIndexPath *indexPath = [self.takeoutTableView indexPathForCell:cell];
            cell.numberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
        }
    }
}

- (void)didHomeCurrentPosTableViewCellPresssed:(HomeCurrentPosTableViewCell*)cell
{
    PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithPosOperate:cell.posOperate];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark PadNumberKeyboardDelegate Methods

- (void)didPadNumberKeyboardDonePressed:(UITextField *)textField
{
    if ( self.inputType == kPadTextInputRestaurant || self.inputType == kPadTextInputBookedRestaurant )
    {
        [self didTextInputFinishedWithType:self.inputType inputText:textField.text];
    }
    else
    {
        [self didTextFieldEditDone:textField];
    }
}

- (void)didTextFieldEditDone:(UITextField *)textField
{
    if ( self.inputType == kPadTextInputRestaurant || self.inputType == kPadTextInputBookedRestaurant )
    {
        [self didTextInputFinishedWithType:self.inputType inputText:textField.text];
    }
    else
    {
        UIViewController *viewController = [self.navigationController.viewControllers lastObject];
        if ([viewController isKindOfClass:[PadProjectViewController class]])
        {
            PadProjectViewController *projectViewController = (PadProjectViewController *)viewController;
            [projectViewController didTextFieldEditDone:textField];
        }
    }
}

@end
