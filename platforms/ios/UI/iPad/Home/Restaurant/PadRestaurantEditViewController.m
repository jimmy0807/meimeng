//
//  PadRestaurantEditViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadRestaurantEditViewController.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "BSRestaurantRequest.h"
#import "UIViewController+MMDrawerController.h"
#import "BSHandleRestaurantFloorRequest.h"
#import "BSHandleRestaurantTableRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"

#define PadRestaurantCollectionCellIdentifier          @"PadRestaurantCollectionCellIdentifier"
#define PadRestaurantCollectionHeaderIdentifier        @"PadRestaurantCollectionHeaderIdentifier"

#define kPadRestaurantSideViewWidth         300.0
#define kPadRestaurantSegmentItemHeight     29.0

@interface PadRestaurantEditViewController ()<PadTableNameCellDelegate,PadRestaurantFloorCellDelegate>
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UITableView *floorTableView;
@property (nonatomic, strong) PadRestaurantCollectionView *tableCollectionView;
@property (nonatomic, strong) UITableView *editTableView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) NSMutableArray *restaurantFloors;
@property (nonatomic, strong) NSMutableArray *restaurantTables;
@property (nonatomic, strong) CDRestaurantFloor *selectedFloor;
@property (nonatomic, strong) CDRestaurantTable *selectedTable;

@property (nonatomic, strong)NSMutableSet* modifyTableSet;
@property (nonatomic, strong)NSMutableSet* modifyFloorSet;
@property (nonatomic, strong)NSMutableDictionary* createdFloorTableParams;
@property (nonatomic, strong)NSMutableSet* changedSequenceFloorSet;

@end


@implementation PadRestaurantEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSRestaurantRequestSuccess];
    [self registerNofitificationForMainThread:kBSRestaurantRequestFailed];
    
    self.restaurantFloors = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllRestaurantFloor]];
    if (self.restaurantFloors.count > 0)
    {
        self.selectedFloor = [self.restaurantFloors objectAtIndex:0];
    }
    
    self.modifyTableSet = [NSMutableSet set];
    self.modifyFloorSet = [NSMutableSet set];
    self.changedSequenceFloorSet = [NSMutableSet set];
    
    [self initView];
    
    [self registerNofitificationForMainThread:kCreateRestaurantTableResponse];
    [self registerNofitificationForMainThread:kWriteRestaurantTableResponse];
    [self registerNofitificationForMainThread:kDeleteRestaurantTableResponse];
    [self registerNofitificationForMainThread:kBSRestaurantRequestSuccess];
}

- (void)initView
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kPadRestaurantSideViewWidth, 0.0, kPadRestaurantSideViewWidth, IC_SCREEN_HEIGHT)];
    rightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kPadRestaurantSideViewWidth - 1.0, 0.0, 1.0, IC_SCREEN_HEIGHT)];
    lineImageView.backgroundColor = COLOR(216.0, 230.0, 230.0, 1.0);
    [self.view addSubview:lineImageView];
    
    [self initLeftSide];
    [self initRightSide];
    [self initNavi];
}

- (void)initLeftSide
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(kPadRestaurantCollectionCellWidth, kPadRestaurantCollectionCellHeight)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(18.0, 16.0, 16.0, 16.0);
    layout.minimumLineSpacing = 16.0;
    layout.minimumInteritemSpacing = 0.0;
    
    self.tableCollectionView = [[PadRestaurantCollectionView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadRestaurantSideViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight) collectionViewLayout:layout];
    self.tableCollectionView.backgroundColor = [UIColor clearColor];
    self.tableCollectionView.dataSource = self;
    self.tableCollectionView.delegate = self;
    self.tableCollectionView.isItemCanMove = YES;
    self.tableCollectionView.alwaysBounceVertical = YES;
    self.tableCollectionView.showsVerticalScrollIndicator = NO;
    self.tableCollectionView.showsHorizontalScrollIndicator = NO;
    [self.tableCollectionView registerClass:[PadRestaurantCollectionCell class] forCellWithReuseIdentifier:PadRestaurantCollectionCellIdentifier];
    [self.view addSubview:self.tableCollectionView];
}

- (void)initRightSide
{
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kPadRestaurantSideViewWidth, kPadNaviHeight, kPadRestaurantSideViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight)];
    self.rightView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.rightView];
    
    self.editTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadRestaurantSideViewWidth, self.rightView.frame.size.height - 24.0 - 12.0 - kPadConfirmButtonHeight) style:UITableViewStylePlain];
    self.editTableView.backgroundColor = [UIColor clearColor];
    self.editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.editTableView.dataSource = self;
    self.editTableView.delegate = self;
    self.editTableView.showsVerticalScrollIndicator = NO;
    self.editTableView.showsHorizontalScrollIndicator = NO;
    self.editTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.rightView addSubview:self.editTableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.rightView.frame.size.height - 24.0 - kPadConfirmButtonHeight - 12.0, self.rightView.frame.size.width, 12.0 + kPadConfirmButtonHeight + 24.0)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.rightView addSubview:bottomView];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(24.0, 12.0, self.rightView.frame.size.width - 2 * 24.0, kPadConfirmButtonHeight);
    self.deleteButton.backgroundColor = [UIColor clearColor];
    self.deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self.deleteButton setTitle:LS(@"Delete") forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:COLOR(255.0, 110.0, 100.0, 1.0) forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[[UIImage imageNamed:@"pad_table_delete"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[[UIImage imageNamed:@"pad_table_delete"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(didDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.deleteButton];
}

- (void)initNavi
{
    self.naviBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kPadNaviHeight + 3.0)];
    self.naviBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pad_navi_background"]];
    [self.view addSubview:self.naviBar];
    
    self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.minusButton.frame = CGRectMake(0.0, 0.0, kPadRestaurantFloorCellWidth, kPadRestaurantFloorCellHeight);
    self.minusButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.minusButton setTitle:@"－" forState:UIControlStateNormal];
    [self.minusButton setBackgroundImage:[UIImage imageNamed:@"pad_restaurant_floor_n"] forState:UIControlStateNormal];
    [self.minusButton setBackgroundImage:[UIImage imageNamed:@"pad_restaurant_floor_n"] forState:UIControlStateHighlighted];
    [self.minusButton setTitleColor:COLOR(170.0, 177.0, 177.0, 1.0) forState:UIControlStateNormal];
    [self.minusButton addTarget:self action:@selector(didMinusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:self.minusButton];
    
    self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.plusButton.frame = CGRectMake(kPadRestaurantFloorCellWidth, 0.0, kPadRestaurantFloorCellWidth, kPadRestaurantFloorCellHeight);
    self.plusButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.plusButton setTitle:@"＋" forState:UIControlStateNormal];
    [self.plusButton setBackgroundImage:[UIImage imageNamed:@"pad_restaurant_floor_n"] forState:UIControlStateNormal];
    [self.plusButton setBackgroundImage:[UIImage imageNamed:@"pad_restaurant_floor_n"] forState:UIControlStateHighlighted];
    [self.plusButton setTitleColor:COLOR(170.0, 177.0, 177.0, 1.0) forState:UIControlStateNormal];
    [self.plusButton addTarget:self action:@selector(didPlusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.floorTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.floorTableView.backgroundColor = [UIColor clearColor];
    self.floorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.floorTableView.delegate = self;
    self.floorTableView.dataSource = self;
    self.floorTableView.showsVerticalScrollIndicator = NO;
    self.floorTableView.showsHorizontalScrollIndicator = NO;
    self.floorTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.floorTableView.frame = CGRectMake(kPadRestaurantFloorCellWidth, 0.0, IC_SCREEN_WIDTH - 2 * kPadNaviHeight - 2 * kPadRestaurantFloorCellWidth, kPadNaviHeight);
    [self.naviBar addSubview:self.floorTableView];
    [self.naviBar addSubview:self.plusButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(IC_SCREEN_WIDTH - 2 * kPadNaviHeight, 0.0, kPadNaviHeight, kPadNaviHeight);
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [cancelButton setTitle:LS(@"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR(169.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(didCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:cancelButton];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(IC_SCREEN_WIDTH - kPadNaviHeight, 0.0, kPadNaviHeight, kPadNaviHeight);
    finishButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [finishButton setTitle:LS(@"PadFinishButton") forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateHighlighted];
    [finishButton addTarget:self action:@selector(didFinishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:finishButton];
    
    [self refreshContentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Required Methods

- (void)reloadFloor
{
    NSArray *mutableArray = [[BSCoreDataManager currentManager] fetchRestaurantTableWithFloor:self.selectedFloor];
    
    NSInteger maxSequence = 1;
    if (mutableArray.count != 0)
    {
        CDRestaurantTable *lastTable = [mutableArray lastObject];
        maxSequence = MAX(mutableArray.count, lastTable.tableSequence.integerValue);
    }
#if 0
    NSInteger screens = ceilf((float)maxSequence/25.0);
    self.restaurantTables = [NSMutableArray array];
    for (int i = 0; i < screens * 25; i++)
    {
        [self.restaurantTables addObject:@""];
    }
    
    for (CDRestaurantTable *table in mutableArray)
    {
        NSInteger sequence = table.tableSequence.integerValue - 1;
        while ([[self.restaurantTables objectAtIndex:sequence] isKindOfClass:[CDRestaurantTable class]])
        {
            sequence++;
        }
        [self.restaurantTables replaceObjectAtIndex:sequence withObject:table];
    }
#else
    self.restaurantTables = [NSMutableArray arrayWithArray:mutableArray];
    [self.restaurantTables addObject:[NSString stringWithFormat:@"%d",(maxSequence + 1)]];
#endif
    [self.tableCollectionView reloadData];
}

- (void)setSelectedFloor:(CDRestaurantFloor *)selectedFloor
{
    _selectedFloor = selectedFloor;
    
    [self reloadFloor];
}

#pragma mark -
#pragma mark Required Methods

- (void)refreshContentView
{
    if (self.restaurantFloors.count * kPadRestaurantFloorCellWidth < IC_SCREEN_WIDTH - 2 * kPadNaviHeight - 2 * kPadRestaurantFloorCellWidth)
    {
        self.floorTableView.scrollEnabled = NO;
        self.plusButton.frame = CGRectMake(self.floorTableView.frame.origin.x + (self.restaurantFloors.count) * kPadRestaurantFloorCellWidth, 0.0, kPadRestaurantFloorCellWidth, kPadRestaurantFloorCellHeight);
        //self.floorTableView.frame = CGRectMake(kPadRestaurantFloorCellWidth, 0.0, (self.restaurantFloors.count) * kPadRestaurantFloorCellWidth, kPadNaviHeight);
    }
    else
    {
        self.floorTableView.scrollEnabled = YES;
        self.plusButton.frame = CGRectMake(self.floorTableView.frame.origin.x + self.floorTableView.frame.size.width, 0.0, kPadRestaurantFloorCellWidth, kPadRestaurantFloorCellHeight);
        //self.floorTableView.frame = CGRectMake(kPadRestaurantFloorCellWidth, 0.0, IC_SCREEN_WIDTH - 2 * kPadNaviHeight - 2 * kPadRestaurantFloorCellWidth, kPadNaviHeight);
    }
    
    
    self.rightView.hidden = YES;
    if (self.selectedFloor && self.selectedTable)
    {
        self.rightView.hidden = NO;
    }
    [self.editTableView reloadData];
    [self.floorTableView reloadData];
    [self.tableCollectionView reloadData];
}

- (void)refreshDeleteButton
{
    UILabel *deleteLabel = (UILabel *)[self.deleteButton viewWithTag:101];
    if (self.selectedTable)
    {
        deleteLabel.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateNormal];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateHighlighted];
    }
    else
    {
        deleteLabel.textColor = [UIColor whiteColor];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateHighlighted];
    }
}

- (void)didMinusButtonClick:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定要删除该楼层吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 102;
    alert.delegate = self;
    [alert show];
}

- (void)didPlusButtonClick:(id)sender
{
#if 1
    CDRestaurantFloor* lastFloor = [self.restaurantFloors lastObject];
    CDRestaurantFloor* floor = [[BSCoreDataManager currentManager] insertEntity:@"CDRestaurantFloor"];
    floor.floorSequence = @([lastFloor.floorSequence integerValue] + 1);
    floor.isActive = @(TRUE);
    [self.modifyFloorSet addObject:floor];
    
    self.restaurantFloors = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllRestaurantFloor]];
    [self reloadFloor];
    [self refreshContentView];
#else
    CDRestaurantFloor* lastFloor = [self.restaurantFloors lastObject];
    CDRestaurantFloor* floor = [[BSCoreDataManager currentManager] insertEntity:@"CDRestaurantFloor"];
    floor.floorSequence = @([lastFloor.floorSequence integerValue] + 1);
    floor.isActive = @(TRUE);
    [self.modifyFloorSet addObject:floor];
    self.restaurantFloors = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllRestaurantFloor]];
    if (self.restaurantFloors.count > 0)
    {
        self.selectedFloor = [self.restaurantFloors objectAtIndex:0];
    }
    [self.floorTableView reloadData];
    
    self.selectedTable = nil;
    [self reloadFloor];
#endif
}

- (void)didCancelButtonClick:(id)sender
{
    [[BSCoreDataManager currentManager] rollback];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didFinishButtonClick:(id)sender
{
    if ( self.selectedTable )
    {
        PadTableNameCell* cell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ( ![self.selectedTable.tableName isEqualToString:cell.nameTextField.text] )
        {
            self.selectedTable.tableName = cell.nameTextField.text;
            
            PadRestaurantCollectionCell *tableCell = (PadRestaurantCollectionCell*)[self.tableCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.restaurantTables indexOfObject:self.selectedTable] inSection:0]];
            tableCell.titleLabel.text = cell.nameTextField.text;
            
            [self.modifyTableSet addObject:self.selectedTable];
        }
    }
    
    NSMutableArray* createdTableArray = [NSMutableArray array];
    
    NSMutableSet* willRemovedSet = [NSMutableSet set];
    
    for ( CDRestaurantTable* table in self.modifyTableSet )
    {
        if ( [table.tableID integerValue] == 0 )
        {
            if ( [table.floor.floorID integerValue] == 0 )
            {
                [createdTableArray addObject:table];
            }
            else
            {
                BSHandleRestaurantTableRequest* request = [[BSHandleRestaurantTableRequest alloc] initWithTable:table];
                request.type = HandleTableType_create;
                [request execute];
                
                if ( table.tableName.length == 0 )
                {
                    [willRemovedSet addObject:table];
                }
            }
        }
        else if ( ![table.isActive boolValue] )
        {
            BSHandleRestaurantTableRequest* request = [[BSHandleRestaurantTableRequest alloc] initWithTable:table];
            request.type = HandleTableType_delete;
            [request execute];
        }
        else
        {
            BSHandleRestaurantTableRequest* request = [[BSHandleRestaurantTableRequest alloc] initWithTable:table];
            request.type = HandleTableType_write;
            [request execute];
        }
    }
    
    for ( CDRestaurantFloor* floor in self.modifyFloorSet )
    {
        if ( [floor.floorID integerValue] == 0 )
        {
            NSMutableArray* tempArray = [NSMutableArray array];
            
            for ( int i = 0; i < createdTableArray.count; i ++ )
            {
                CDRestaurantTable* table = createdTableArray[i];
                if ( table.floor == floor )
                {
                    [tempArray addObject:table];
                    [createdTableArray removeObject:table];
                    i--;
                }
            }
            
            BSHandleRestaurantFloorRequest* request = [[BSHandleRestaurantFloorRequest alloc] initWithFloor:floor];
            request.type = HandleFloorType_create;
            request.createdTableArray = tempArray;
            [request execute];
            
            if ( floor.floorName.length == 0 )
            {
                [willRemovedSet addObject:floor];
            }
        }
        else if ( ![floor.isActive boolValue] )
        {
            BSHandleRestaurantFloorRequest* request = [[BSHandleRestaurantFloorRequest alloc] initWithFloor:floor];
            request.type = HandleFloorType_delete;
            [request execute];
        }
        else
        {
            BSHandleRestaurantFloorRequest* request = [[BSHandleRestaurantFloorRequest alloc] initWithFloor:floor];
            request.type = HandleFloorType_write;
            [request execute];
        }
    }
    
    for ( CDRestaurantFloor* floor in self.changedSequenceFloorSet )
    {
        NSArray* tables = [[BSCoreDataManager currentManager] fetchRestaurantTableWithFloor:floor];
        [tables enumerateObjectsUsingBlock:^(CDRestaurantTable *table, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if ( [table isKindOfClass:[CDRestaurantTable class]] )
            {
                table.tableSequence = @(idx);
                BSHandleRestaurantTableRequest* request = [[BSHandleRestaurantTableRequest alloc] initWithTable:table];
                request.type = HandleTableType_write;
                [request execute];
            }
        }];
    }
    
    [[BSCoreDataManager currentManager] deleteObjects:willRemovedSet.allObjects];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didDeleteButtonClick:(id)sender
{
    if ( [self.selectedTable.tableID integerValue] == 0 )
    {
        [[BSCoreDataManager currentManager] deleteObject:self.selectedTable];
        self.selectedTable = nil;
        [self reloadFloor];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定要删除该桌子吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 101;
        alert.delegate = self;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 )
    {
        if ( alertView.tag == 101 )
        {
            self.selectedTable.isActive = @(FALSE);
            [self.modifyTableSet addObject:self.selectedTable];
            self.selectedTable = nil;
            [self reloadFloor];
        }
        else if ( alertView.tag == 102 )
        {
            self.selectedFloor.isActive = @(FALSE);
            [self.modifyFloorSet addObject:self.selectedFloor];
            
            self.restaurantFloors = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllRestaurantFloor]];
            if (self.restaurantFloors.count > 0)
            {
                self.selectedFloor = [self.restaurantFloors objectAtIndex:0];
            }
            else
            {
                self.selectedFloor = nil;
            }
            
            [self.floorTableView reloadData];
            
            self.selectedTable = nil;
            [self reloadFloor];
            [self refreshContentView];
        }
    }
}

#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSRestaurantRequestSuccess])
    {
        self.restaurantFloors = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllRestaurantFloor]];
        [self refreshContentView];
    }
    else if ([notification.name isEqualToString:kBSRestaurantRequestFailed])
    {
        ;
    }
}


#pragma mark -
#pragma mark PadRestaurantCollectionViewDataSource Methods

- (NSInteger)collectionView:(PadRestaurantCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.selectedFloor)
    {
        return self.restaurantTables.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(PadRestaurantCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PadRestaurantCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PadRestaurantCollectionCellIdentifier forIndexPath:indexPath];
    
    CDRestaurantTable *table = (CDRestaurantTable *)[self.restaurantTables objectAtIndex:indexPath.row];
    if ([table isKindOfClass:[NSString class]])
    {
        [cell setState:kPadRestaurantTableNone];
        
        return cell;
    }
    
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
    
    if (table.usingQty.integerValue == 0 )
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
    if ( self.selectedTable && self.selectedTable == table )
    {
        cell.selectedImageView.hidden = NO;
        [cell setState:kPadRestaurantTableSelected];
    }
    else
    {
        cell.selectedImageView.hidden = YES;
        [cell setState:kPadRestaurantTableNormal];
    }
    
    return cell;
}


#pragma mark -
#pragma mark PadProjectCollectionViewDelegate Methods

- (void)collectionView:(PadRestaurantCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    CDRestaurantTable *table = (CDRestaurantTable *)[self.restaurantTables objectAtIndex:indexPath.row];
    if ([table isKindOfClass:[NSString class]])
    {
        [self addRestaurantDesk];
        return;
    }
    
    if ( self.selectedTable )
    {
        PadTableNameCell* cell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.nameTextField resignFirstResponder];
        if ( ![self.selectedTable.tableName isEqualToString:cell.nameTextField.text] )
        {
            self.selectedTable.tableName = cell.nameTextField.text;
            
            PadRestaurantCollectionCell *tableCell = (PadRestaurantCollectionCell*)[self.tableCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.restaurantTables indexOfObject:self.selectedTable] inSection:0]];
            tableCell.titleLabel.text = cell.nameTextField.text;
            
            [self.modifyTableSet addObject:self.selectedTable];
        }
    }
    
    if ( self.selectedTable && self.selectedTable == table )
    {
        self.selectedTable = nil;
    }
    else
    {
        self.selectedTable = table;
    }
    
    [self refreshContentView];
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
    NSObject *object = [self.restaurantTables objectAtIndex:fromIndexPath.row];
    [self.restaurantTables removeObjectAtIndex:fromIndexPath.row];
    [self.restaurantTables insertObject:object atIndex:toIndexPath.row];
    
    [self.changedSequenceFloorSet addObject:self.selectedFloor];
}

- (void)addRestaurantDesk
{
    if ( self.selectedTable )
    {
        PadTableNameCell* cell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.nameTextField resignFirstResponder];
        if ( ![self.selectedTable.tableName isEqualToString:cell.nameTextField.text] )
        {
            self.selectedTable.tableName = cell.nameTextField.text;
            
            PadRestaurantCollectionCell *tableCell = (PadRestaurantCollectionCell*)[self.tableCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.restaurantTables indexOfObject:self.selectedTable] inSection:0]];
            tableCell.titleLabel.text = cell.nameTextField.text;
            
            [self.modifyTableSet addObject:self.selectedTable];
        }
    }
    
    NSInteger maxSequence = [[self.restaurantTables lastObject] integerValue];
    CDRestaurantTable* table = [[BSCoreDataManager currentManager] insertEntity:@"CDRestaurantTable"];
    table.tableSequence = @(maxSequence + 1);
    table.isActive = @(TRUE);
    table.floor = self.selectedFloor;
    
    [self.restaurantTables removeLastObject];
    [self.restaurantTables addObject:table];
    [self.restaurantTables addObject:[NSString stringWithFormat:@"%d",(maxSequence + 1)]];
    
    self.selectedTable = table;
    
    [self.tableCollectionView reloadData];
    [self refreshContentView];
    
    [self.modifyTableSet addObject:self.selectedTable];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.floorTableView)
    {
        return self.restaurantFloors.count;
    }
    else if (tableView == self.editTableView)
    {
        if (self.selectedFloor && self.selectedTable)
        {
            return 2;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.floorTableView)
    {
        return kPadRestaurantFloorCellWidth;
    }
    else if (tableView == self.editTableView)
    {
        return kPadTableNameCellHeight;
    }
    
    return 0;
}

//-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.floorTableView)
//    {
//        return YES;
//    }
//    
//    return NO;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.floorTableView)
//    {
//        return YES;
//    }
//    
//    return NO;
//}
//
//-(void) tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
//{
//    
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.floorTableView)
    {
        static NSString *CellIdentifier = @"PadRestaurantFloorCellIdentifier";
        PadRestaurantFloorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadRestaurantFloorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        CDRestaurantFloor *floor = [self.restaurantFloors objectAtIndex:indexPath.row];
        
        if ( floor == self.selectedFloor )
        {
            cell.titleLabel.enabled = YES;
        }
        else
        {
            cell.titleLabel.enabled = NO;
        }
        
        if ( self.selectedFloor == floor )
        {
            cell.titleLabel.textColor = COLOR(90.0, 211.0, 213.0, 1.0);
            cell.background.image = [UIImage imageNamed:@"pad_restaurant_floor_h"];
        }
        else
        {
            cell.titleLabel.textColor = COLOR(170.0, 177.0, 177.0, 1.0);
            cell.background.image = [UIImage imageNamed:@"pad_restaurant_floor_n"];
        }
        cell.titleLabel.text = floor.floorName;
        
        return cell;
    }
    else if (tableView == self.editTableView)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"PadTableNameCellIdentifier";
            PadTableNameCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadTableNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            cell.titleLabel.text = LS(@"PadTableNameTitle");
            cell.nameTextField.text = self.selectedTable.tableName;
            
            return cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"PadTableSeatCellIdentifier";
            PadTableSeatCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadTableSeatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            cell.titleLabel.text = LS(@"PadTableNumberTitle");
            cell.numberTextField.text = [NSString stringWithFormat:@"%d", self.selectedTable.tableSeats.integerValue];
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.floorTableView)
    {
        CDRestaurantFloor *floor = [self.restaurantFloors objectAtIndex:indexPath.row];
        if ( self.selectedFloor == floor )
        {
            return ;
        }
        else
        {
            PadRestaurantFloorCell* cell = [self.floorTableView cellForRowAtIndexPath:indexPath];
            [cell.titleLabel resignFirstResponder];
        }
        self.selectedFloor = floor;
        self.selectedTable = nil;
        [self refreshContentView];
    }
}


#pragma mark -
#pragma mark PadTableSeatCellDelegate Methods

- (void)didTableSeatsMinus
{
    if (self.selectedTable.tableSeats.integerValue > 1)
    {
        self.selectedTable.tableSeats = [NSNumber numberWithInteger:self.selectedTable.tableSeats.integerValue - 1];
        
        PadTableSeatCell *cell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.numberTextField.text = [NSString stringWithFormat:@"%d", self.selectedTable.tableSeats.integerValue];
        
        UIImageView* v ;
        [v sd_setImageWithURL:nil placeholderImage:nil];
        
        PadRestaurantCollectionCell *tableCell = (PadRestaurantCollectionCell*)[self.tableCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.restaurantTables indexOfObject:self.selectedTable] inSection:0]];
        tableCell.seatsLabel.text = [NSString stringWithFormat:@"%d/%d", self.selectedTable.usingQty.integerValue, self.selectedTable.tableSeats.integerValue];
        
        [self.modifyTableSet addObject:self.selectedTable];
    }
}

- (void)didTableSeatsPlus
{
    self.selectedTable.tableSeats = [NSNumber numberWithInteger:self.selectedTable.tableSeats.integerValue + 1];
    
    PadTableSeatCell *cell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.numberTextField.text = [NSString stringWithFormat:@"%d", self.selectedTable.tableSeats.integerValue];
    
    PadRestaurantCollectionCell *tableCell = (PadRestaurantCollectionCell*)[self.tableCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.restaurantTables indexOfObject:self.selectedTable] inSection:0]];
    tableCell.seatsLabel.text = [NSString stringWithFormat:@"%d/%d", self.selectedTable.usingQty.integerValue, self.selectedTable.tableSeats.integerValue];
    
    [self.modifyTableSet addObject:self.selectedTable];
}

- (void)didTableSeatsCountChanged:(NSInteger)count
{
    if ( count > 0 )
    {
        self.selectedTable.tableSeats = @(count);
        
        PadTableSeatCell *cell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.numberTextField.text = [NSString stringWithFormat:@"%d", self.selectedTable.tableSeats.integerValue];
        
        PadRestaurantCollectionCell *tableCell = (PadRestaurantCollectionCell*)[self.tableCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.restaurantTables indexOfObject:self.selectedTable] inSection:0]];
        tableCell.seatsLabel.text = [NSString stringWithFormat:@"%d/%d", self.selectedTable.usingQty.integerValue, self.selectedTable.tableSeats.integerValue];
        
        [self.modifyTableSet addObject:self.selectedTable];
    }
}

- (void)didTableNameChanged:(NSString*)name
{
    if ( self.selectedTable == nil || [self.selectedTable.tableName isEqualToString:name] )
        return;
    
    self.selectedTable.tableName = name;
    
    PadRestaurantCollectionCell *tableCell = (PadRestaurantCollectionCell*)[self.tableCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.restaurantTables indexOfObject:self.selectedTable] inSection:0]];
    tableCell.titleLabel.text = name;
    
    [self.modifyTableSet addObject:self.selectedTable];
}

- (void)didFloorNameChanged:(NSString*)name
{
    if ( name.length == 0 || [self.selectedFloor.floorName isEqualToString:name ] )
        return;
    
    self.selectedFloor.floorName = name;
    
    [self.modifyFloorSet addObject:self.selectedFloor];
}

@end
