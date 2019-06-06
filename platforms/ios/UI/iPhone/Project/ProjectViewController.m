//
//  ProjectViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ProjectViewController.h"
#import "SAImage.h"
#import "VFileImage.h"
#import "VDownloader.h"
#import "VDownloadingCenter.h"
#import "UIImage+Resizable.h"
#import "BSCoreDataManager.h"
#import "NSObject+MainThreadNotification.h"
#import "BSProjectRequest.h"

#import "BSItemCell.h"
#import "CBLoadingView.h"
#import "BSSelectItemCell.h"
#import "ProjectTypeViewController.h"
#import "ProjectCreateViewController.h"
#import "ProductDetailViewController.h"


#define kProjectFilterBarHeight         44.0
#define kProjectSearchBarHeight         44.0
#define kProjectSegmentContentHeight    46.0
#define kProjectSegmentItemHeight       29.0
#define kProjectCategoryWidth           (120.0 * DEVICE_RATIO)
#define kProjectCategoryHeight          260.0
#define kProjectSubCategoryWidth        (200.0 * DEVICE_RATIO)
#define kProjectCategoryCellHeight      42.0
#define kProjectSubCategoryCellHeight   42.0

#define kSearchKeywordTextFieldTag      100
#define kPanDianAmountTextFieldTag      200

@interface ProjectViewController ()

@property (nonatomic, assign) kProjectViewType viewType;
@property (nonatomic, assign) kPadBornCategoryType projectType;
@property (nonatomic, assign) kPadBornCategoryType type;
@property (nonatomic, strong) NSArray *itemIds;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, assign) id<ProjectItemPanDianDelegate> delegate;

@property (nonatomic, strong) NSArray *segmentedItems;
@property (nonatomic, assign) BOOL isPriceSortASC;
@property (nonatomic, assign) BOOL isSelectCategory;

@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSArray *templateArray;
@property (nonatomic, strong) CDProjectCategory *currentCategory;
@property (nonatomic, strong) NSArray *subCategoryArray;
@property (nonatomic, assign) NSInteger categorySelectedIndex;
@property (nonatomic, assign) NSInteger subCategorySelectedIndex;
@property (nonatomic, assign) NSInteger otherCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;


@property (nonatomic, strong) UIImageView *filterBar;
@property (nonatomic, strong) UIButton *searchBar;
@property (nonatomic, strong) UITableView *projectTableView;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) UITableView *subCategoryTableView;

@end


@implementation ProjectViewController

- (id)initWithViewType:(kProjectViewType)viewType existItemIds:(NSArray *)itemIds
{
    self = [super initWithNibName:NIBCT(@"ProjectViewController") bundle:nil];
    if (self != nil)
    {
        self.viewType = viewType;
        self.itemIds = itemIds;
        if (itemIds == nil)
        {
            self.itemIds = [NSArray array];
        }
        
        [self initType];
    }
    
    return self;
}

- (id)initWithViewType:(kProjectViewType)viewType projectType:(kPadBornCategoryType)projectType existItemIds:(NSArray *)itemIds
{
    self = [super initWithNibName:NIBCT(@"ProjectViewController") bundle:nil];
    if (self != nil)
    {
        self.viewType = viewType;
        self.itemIds = itemIds;
        self.projectType = projectType;
        if (itemIds == nil)
        {
            self.itemIds = [NSArray array];
        }
        
        [self initType];
    }
    
    return self;
}

- (id)initWithParams:(NSDictionary *)params delegate:(id<ProjectItemPanDianDelegate>)delegate
{
    self = [super initWithNibName:NIBCT(@"ProjectViewController") bundle:nil];
    if (self != nil)
    {
        self.params = [NSMutableDictionary dictionaryWithDictionary:params];
        self.delegate = delegate;
        self.viewType = kProjectSelectPanDianItem;
        self.itemIds = params.allKeys;
        
        [self initType];
    }
    
    return self;
}

- (void)initType
{
    self.keyword = @"";
    self.otherCount = 0;
    self.totalCount = 0;
    self.isPriceSortASC = NO;
    self.isSelectCategory = NO;
    self.type = kPadBornCategoryProduct;
    self.categoryArray = [[NSArray alloc] init];
    self.templateArray = [[NSArray alloc] init];
    self.cachePicParams = [[NSMutableDictionary alloc] init];
    
    self.types = [NSArray arrayWithObjects:
                  [NSNumber numberWithInteger:kPadBornCategoryProduct],
                  [NSNumber numberWithInteger:kPadBornCategoryProject],
                  [NSNumber numberWithInteger:kPadBornCategoryCourses],
                  [NSNumber numberWithInteger:kPadBornCategoryPackage], nil];
    
    if (self.viewType == kProjectViewEdit)
    {
        self.title = LS(@"ProjectNaviTitle");
    }
    else if (self.viewType == kProjectSelectConsumable)
    {
        self.title = LS(@"SelectConsumable");
        self.types = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kPadBornCategoryProduct], nil];
    }
    else if (self.viewType == kProjectSelectSubItem)
    {
        self.title = LS(@"SelectSubItem");
        if (self.projectType == kPadBornCategoryCourses)
        {
            self.types = [NSArray arrayWithObjects:
                          [NSNumber numberWithInteger:kPadBornCategoryProduct],
                          [NSNumber numberWithInteger:kPadBornCategoryProject], nil];
        }
        else if (self.projectType == kPadBornCategoryPackage)
        {
            self.types = [NSArray arrayWithObjects:
                          [NSNumber numberWithInteger:kPadBornCategoryProduct],
                          [NSNumber numberWithInteger:kPadBornCategoryProject],
                          [NSNumber numberWithInteger:kPadBornCategoryCourses], nil];
        }
    }
    else if (self.viewType == kProjectSelectSameItem)
    {
        self.title = LS(@"SelectSameItem");
        self.type = kPadBornCategoryProject;
        self.types = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kPadBornCategoryProject], nil];
    }
    else if (self.viewType == kProjectSelectCardItem)
    {
        self.title = LS(@"CardItem");
        self.type = kPadBornCategoryProject;
        self.types = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kPadBornCategoryProject], nil];
    }
    else if (self.viewType == kProjectSelectPurchase)
    {
        self.title = LS(@"ProjectSelectPurchaseTitle");
        self.types = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kPadBornCategoryProduct], nil];
    }
    else if (self.viewType == kProjectSelectCardBuyItem)
    {
        self.title = LS(@"ProjectSelectCardBuyItem");
    }
    else if (self.viewType == kProjectSelectPanDianItem)
    {
        self.title = LS(@"ProjectSelectPanDianItem");
    }
    
    NSMutableArray *items = [NSMutableArray array];
    if (self.types.count > 1)
    {
        for (int i = 0; i < self.types.count; i++)
        {
            int typeInt = [[self.types objectAtIndex:i] integerValue];
            NSString *typestr = [NSString stringWithFormat:@"BornCategory%d", typeInt];
            [items insertObject:LS(typestr) atIndex:items.count];
        }
    }
    self.segmentedItems = [NSArray arrayWithArray:items];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.templateArray = [NSArray array];
    self.templateArray = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:nil categoryIds:nil keyword:self.keyword priceAscending:self.isPriceSortASC];
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self registerNofitificationForMainThread:kBSProjectRequestSuccess];
    [self registerNofitificationForMainThread:kBSProjectRequestFailed];
    [self registerNofitificationForMainThread:kBSProjectItemEditFinish];
    [self registerNofitificationForMainThread:kBSProjectTemplateEditFinish];
    
    [self initView];
    [self initData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Init Methods

- (void)initView
{
    self.filterBar = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kProjectFilterBarHeight)];
    self.filterBar.image = [UIImage imageNamed:@"project_filter_bar_bg"];
    self.filterBar.userInteractionEnabled = YES;
    [self.view addSubview:self.filterBar];
    
    UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    typeButton.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH/2.0, self.filterBar.frame.size.height);
    typeButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [typeButton setTitle:LS(@"ProjectCategory") forState:UIControlStateNormal];
    [typeButton setTitleColor:COLOR(137.0, 142.0, 145.0, 1.0) forState:UIControlStateNormal];
    [typeButton setImage:[UIImage imageNamed:@"filter_arrow_down"] forState:UIControlStateNormal];
    [typeButton setImage:[UIImage imageNamed:@"filter_arrow_down"] forState:UIControlStateHighlighted];
    [typeButton setImageEdgeInsets:UIEdgeInsetsMake(2.0, 72.0, 0.0, 0.0)];
    [typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -36.0, 0.0, 0.0)];
    [typeButton addTarget:self action:@selector(didTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    typeButton.tag = 101;
    [self.filterBar addSubview:typeButton];
    
    UIButton *priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priceButton.frame = CGRectMake(self.filterBar.frame.size.width/2.0, 0.0, self.filterBar.frame.size.width/2.0, self.filterBar.frame.size.height);
    priceButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [priceButton setTitle:LS(@"ProjectSortByPrice") forState:UIControlStateNormal];
    [priceButton setTitleColor:COLOR(137.0, 142.0, 145.0, 1.0) forState:UIControlStateNormal];
    [priceButton setImage:[UIImage imageNamed:@"filter_arrow_down"] forState:UIControlStateNormal];
    [priceButton setImage:[UIImage imageNamed:@"filter_arrow_down"] forState:UIControlStateHighlighted];
    [priceButton setImageEdgeInsets:UIEdgeInsetsMake(2.0, 72.0, 0.0, 0.0)];
    [priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -36.0, 0.0, 0.0)];
    [priceButton addTarget:self action:@selector(didPriceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    priceButton.tag = 102;
    [self.filterBar addSubview:priceButton];
    
    UIImage *searchImage = [[UIImage imageNamed:@"project_search_bg"] imageResizableWithCapInsets:UIEdgeInsetsMake(24.0, 64.0, 24.0, 64.0)];
    self.searchBar = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBar.frame = CGRectMake(0.0, self.filterBar.frame.size.height, IC_SCREEN_WIDTH, kProjectSearchBarHeight);
    [self.searchBar setBackgroundImage:searchImage forState:UIControlStateNormal];
    [self.searchBar setBackgroundImage:searchImage forState:UIControlStateHighlighted];
    [self.searchBar addTarget:self action:@selector(didSearchBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBar];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(36.0, (self.searchBar.frame.size.height - 24.0)/2.0, self.searchBar.frame.size.width - 36.0 - 12.0, 24.0)];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.placeholder = LS(@"SearchPlaceholder");
    searchField.font = [UIFont systemFontOfSize:14.0];
    searchField.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.tag = kSearchKeywordTextFieldTag;
    searchField.delegate = self;
    [self.searchBar addSubview:searchField];
    
    self.projectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, self.filterBar.frame.size.height + self.searchBar.frame.size.height, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT - self.filterBar.frame.size.height - self.searchBar.frame.size.height) style:UITableViewStylePlain];
    self.projectTableView.backgroundColor = [UIColor clearColor];
    self.projectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.projectTableView.delegate = self;
    self.projectTableView.dataSource = self;
    self.projectTableView.showsVerticalScrollIndicator = NO;
    self.projectTableView.showsHorizontalScrollIndicator = NO;
    self.projectTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.projectTableView];
    
    self.filterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.filterBar.frame.origin.y + self.filterBar.frame.size.height, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT - self.filterBar.frame.size.height)];
    
    self.filterView.backgroundColor = [UIColor clearColor];
    self.filterView.hidden = YES;
    self.filterView.clipsToBounds = YES;
    [self.view addSubview:self.filterView];
    UIButton *contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contentButton.frame = self.filterView.bounds;
    contentButton.backgroundColor = [UIColor blackColor];
    [contentButton addTarget:self action:@selector(didFilterViewContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    contentButton.alpha = 0.0;
    contentButton.tag = 101;
    [self.filterView addSubview:contentButton];
    
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, -kProjectCategoryHeight, IC_SCREEN_WIDTH, kProjectCategoryHeight)];
    contentView.image = [UIImage imageNamed:@"project_category_bg"];
    contentView.userInteractionEnabled = YES;
    contentView.tag = 102;
    [self.filterView addSubview:contentView];
    
    CGFloat height = 0.0;
    if (self.types.count == 1)
    {
        contentView.image = [UIImage imageNamed:@"project_category_bg_single"];
    }
    else
    {
        BNSegmentedControl *segmentedControl = [[BNSegmentedControl alloc] initWithItems:self.segmentedItems];
        CGFloat itemWidth = floor((IC_SCREEN_WIDTH - 12.0 * 2 * DEVICE_RATIO)/self.segmentedItems.count);
        segmentedControl.frame = CGRectMake((IC_SCREEN_WIDTH - itemWidth * self.segmentedItems.count)/2.0,  (kProjectSegmentContentHeight - kProjectSegmentItemHeight)/2.0, itemWidth * self.segmentedItems.count, kProjectSegmentItemHeight);
        segmentedControl.leftImageItems = [NSArray arrayWithObjects:
                                           [[UIImage imageNamed:@"segmented_left_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)],
                                           [[UIImage imageNamed:@"segmented_left_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)], nil];
        segmentedControl.centerImageItems = [NSArray arrayWithObjects:
                                             [[UIImage imageNamed:@"segmented_middle_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)],
                                             [[UIImage imageNamed:@"segmented_middle_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)], nil];
        segmentedControl.rightImageItems = [NSArray arrayWithObjects:
                                            [[UIImage imageNamed:@"segmented_right_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)],
                                            [[UIImage imageNamed:@"segmented_right_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)], nil];
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.normalFontColor = COLOR(11.0, 169.0, 250.0, 1.0);
        segmentedControl.selectFontColor = [UIColor whiteColor];
        segmentedControl.textFont = [UIFont systemFontOfSize:14.0];
        segmentedControl.delegate = self;
        [contentView addSubview:segmentedControl];
        
        height = kProjectSegmentContentHeight;
    }
    
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, height, kProjectCategoryWidth, contentView.frame.size.height - height) style:UITableViewStylePlain];
    self.categoryTableView.backgroundColor = [UIColor clearColor];
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.showsVerticalScrollIndicator = NO;
    self.categoryTableView.showsHorizontalScrollIndicator = NO;
    [contentView addSubview:self.categoryTableView];
    
    self.subCategoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(kProjectCategoryWidth, height, kProjectSubCategoryWidth, contentView.frame.size.height - height) style:UITableViewStylePlain];
    self.subCategoryTableView.backgroundColor = [UIColor clearColor];
    self.subCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subCategoryTableView.delegate = self;
    self.subCategoryTableView.dataSource = self;
    self.subCategoryTableView.showsVerticalScrollIndicator = NO;
    self.subCategoryTableView.showsHorizontalScrollIndicator = NO;
    [contentView addSubview:self.subCategoryTableView];
}

- (void)initData
{
   [self initCategory];
  [self initProjectItem];
    
    NSArray *templates = [[BSCoreDataManager currentManager] fetchAllProjectTemplate];
    NSArray *items = [[BSCoreDataManager currentManager] fetchAllProjectItem];
    if (templates.count != 0 && items.count != 0)
    {
        if (self.viewType != kProjectViewEdit)
        {
            return ;
        }
    }
    
    if (templates.count == 0 || items.count == 0)
    {
        [[CBLoadingView shareLoadingView] show];
    }
    [[BSProjectRequest sharedInstance] startProjectRequest];
}

- (void)initCurrentCategory:(CDProjectCategory *)category
{
    self.currentCategory = category;
    NSArray *subCategories = self.currentCategory.subCategory.array;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemCount != %@", [NSNumber numberWithInteger:0]];
    self.subCategoryArray = [subCategories filteredArrayUsingPredicate:predicate];
    NSLog(@"subCategoryArray.count==%zd",self.subCategoryArray.count);
}

- (void)initCategory
{
    //count = 728  CDProjectItem
    NSArray *allItems = [[BSCoreDataManager currentManager] fetchAllProjectItem];
//    NSLog(@"allItems.count=====%zd,%@",allItems.count,[[allItems firstObject] class]);
    //count = 77 CDProjectCategory
    NSArray *categorys = [[BSCoreDataManager currentManager] fetchAllProjectCategory];
   // NSLog(@"categorys.count=====%zd,%@",categorys.count,[[categorys firstObject] class]);
    if (allItems.count == 0)
    {
        for (int i = 0; i < categorys.count; i++)
        {
            CDProjectCategory *category = [categorys objectAtIndex:i];
            category.itemCount = [NSNumber numberWithInteger:0];
        }
        [[BSCoreDataManager currentManager] save:nil];
        
        self.otherCount = 0;
        self.totalCount = 0;
        self.categoryArray = [[BSCoreDataManager currentManager] fetchTopProjectCategory];
        [self.categoryTableView reloadData];
        [self.subCategoryTableView reloadData];
        
        return ;
    }
    
    NSArray *types = [NSArray array];
    if (self.type == kPadBornCategoryAll)
    {
        types = [NSArray arrayWithArray:self.types];
    }
    else
    {
        types = [NSArray arrayWithObject:[NSNumber numberWithInteger:self.type]];
    }
    
    for (int i = 0; i < categorys.count; i++)
    {
        CDProjectCategory *category = [categorys objectAtIndex:i];
        //????
        NSArray *categoryIds = [self subCategoryIds:category];
        
        if (self.viewType == kProjectViewEdit)
        {
            NSArray *items = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:types categoryIds:categoryIds keyword:nil priceAscending:NO];
            category.itemCount = [NSNumber numberWithInteger:items.count];
        }
        else
        {
            NSArray *items = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:self.viewType bornCategorys:types categoryIds:categoryIds existItemIds:self.itemIds keyword:nil priceAscending:NO];
            category.itemCount = [NSNumber numberWithInteger:items.count];
        }
    }
    [[BSCoreDataManager currentManager] save:nil];
    
    if (self.viewType == kProjectViewEdit)
    {//产品项目
        NSLog(@"firstObject----%@",[types firstObject]);
        NSArray *otherItems = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:types categoryIds:@[[NSNumber numberWithInteger:0]] keyword:nil priceAscending:NO];
        NSLog(@"otherItems.count==%d",otherItems.count);
        self.otherCount = otherItems.count;
        NSArray *totalItems = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:types categoryIds:nil keyword:nil priceAscending:NO];
        self.totalCount = totalItems.count;
 }
    else
    {
        NSArray *otherItems = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:self.viewType bornCategorys:types categoryIds:@[[NSNumber numberWithInteger:0]] existItemIds:self.itemIds keyword:nil priceAscending:NO];
        self.otherCount = otherItems.count;
        NSArray *totalItems = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:self.viewType bornCategorys:types categoryIds:nil existItemIds:self.itemIds keyword:nil priceAscending:NO];
    self.totalCount = totalItems.count;
    }
    
    self.categorySelectedIndex = 0;
    self.subCategorySelectedIndex = 0;
    self.categoryArray = [[BSCoreDataManager currentManager] fetchTopProjectCategory];
    if (self.categoryArray.count != 0)
    {
        CDProjectCategory *category = [self.categoryArray objectAtIndex:self.categorySelectedIndex];
        [self initCurrentCategory:category];
    }
    
    [self.categoryTableView reloadData];
    [self.subCategoryTableView reloadData];
}

- (void)initProjectItem
{
    NSArray *types = [NSArray array];
    if (self.type == kPadBornCategoryAll)
    {
        types = [NSArray arrayWithArray:self.types];
    }
    else
    {
        types = [NSArray arrayWithObject:[NSNumber numberWithInteger:self.type]];
    }
    
    NSArray *categoryIds = [NSArray array];
    if (self.categorySelectedIndex == self.categoryArray.count)
    {
        categoryIds = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0], nil];
    }
    else if (self.categorySelectedIndex == self.categoryArray.count + 1)
    {
        categoryIds = nil;
    }
    else
    {
        if (self.currentCategory.parentID.integerValue == 0)
        {
            if (self.subCategorySelectedIndex == 0)
            {
                categoryIds = [self subCategoryIds:self.currentCategory];
            }
            else
            {
                CDProjectCategory *subCategory = [self.subCategoryArray objectAtIndex:self.subCategorySelectedIndex - 1];
                categoryIds = [self subCategoryIds:subCategory];
            }
        }
        else
        {
            if (self.subCategorySelectedIndex == 0 || self.subCategorySelectedIndex == 1)
            {
                categoryIds = [self subCategoryIds:self.currentCategory];
            }
            else
            {
                CDProjectCategory *subCategory = [self.subCategoryArray objectAtIndex:self.subCategorySelectedIndex - 2];
                categoryIds = [self subCategoryIds:subCategory];
            }
        }
    }
    
    if (self.viewType == kProjectViewEdit)
    {
        self.templateArray = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:types categoryIds:categoryIds keyword:self.keyword priceAscending:self.isPriceSortASC];
     
    }
    else
    {
        self.templateArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:self.viewType bornCategorys:types categoryIds:categoryIds existItemIds:self.itemIds keyword:self.keyword priceAscending:self.isPriceSortASC];

    }
    
    [self.projectTableView reloadData];
}

- (NSArray *)subCategoryIds:(CDProjectCategory *)category
{
    NSMutableArray *ids = [NSMutableArray array];
    [ids addObject:category.categoryID];
    for (int i = 0; i < category.subCategory.count; i++)
    {
        CDProjectCategory *subCategory = [category.subCategory objectAtIndex:i];
        NSArray *subIds = [self subCategoryIds:subCategory];
        [ids addObjectsFromArray:subIds];
    }
    
    return  [NSArray arrayWithArray:ids];
}


#pragma mark -
#pragma mark Required Methods

- (void)didRightBarButtonItemClick:(id)sender
{
    ProjectTypeViewController *viewController = [[ProjectTypeViewController alloc] initWithParentViewController:self];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark 点击了分类按钮
- (void)didTypeButtonClick:(id)sender
{
    if (self.isSelectCategory)
    {

        [self hideFilterView];
    }
    else
    {

        [self showFilterView];
    }
}

- (void)didFilterViewContentButtonClick:(id)sender
{
    if (self.isSelectCategory)
    {
        
        [self hideFilterView];
    }
    else
    {
        
        [self showFilterView];
    }
}

- (void)showFilterView
{
    NSLog(@"showFilterView");
    UIButton *typeButton = (UIButton *)[self.filterBar viewWithTag:101];
    [typeButton setTitleColor:COLOR(11.0, 169.0, 250.0, 1.0) forState:UIControlStateNormal];
    [typeButton setImage:[UIImage imageNamed:@"filter_arrow_up"] forState:UIControlStateNormal];
    [typeButton setImage:[UIImage imageNamed:@"filter_arrow_up"] forState:UIControlStateHighlighted];
    
    UITextField *textField = (UITextField *)[self.searchBar viewWithTag:101];
    if (textField.isFirstResponder)
    {
        [UIView animateWithDuration:0.32 animations:^{
            [textField endEditing:YES];
        } completion:^(BOOL finished) {
            self.filterView.hidden = NO;
            [UIView animateWithDuration:0.32 animations:^{
                UIButton *contentButton = (UIButton *)[self.filterView viewWithTag:101];
                UIImageView *contentView = (UIImageView *)[self.filterView viewWithTag:102];
                contentButton.alpha = 0.5;
                contentView.frame = CGRectMake(0.0, 0.0, contentView.frame.size.width, contentView.frame.size.height);
            } completion:^(BOOL finished) {
                self.isSelectCategory = YES;
            }];
        }];
    }
    else
    {
        self.filterView.hidden = NO;
        [UIView animateWithDuration:0.32 animations:^{
            UIButton *contentButton = (UIButton *)[self.filterView viewWithTag:101];
            UIImageView *contentView = (UIImageView *)[self.filterView viewWithTag:102];
            contentButton.alpha = 0.5;
            contentView.frame = CGRectMake(0.0, 0.0, contentView.frame.size.width, contentView.frame.size.height);
        } completion:^(BOOL finished) {
            self.isSelectCategory = YES;
        }];
    }
}

- (void)hideFilterView
{
    NSLog(@"hideFilterView");
    UIButton *typeButton = (UIButton *)[self.filterBar viewWithTag:101];
    [typeButton setTitleColor:COLOR(137.0, 142.0, 145.0, 1.0) forState:UIControlStateNormal];
    [typeButton setImage:[UIImage imageNamed:@"filter_arrow_down"] forState:UIControlStateNormal];
    [typeButton setImage:[UIImage imageNamed:@"filter_arrow_down"] forState:UIControlStateHighlighted];
    
    UITextField *searchField = (UITextField *)[self.searchBar viewWithTag:1001];
    if ([searchField isFirstResponder])
    {
        [UIView animateWithDuration:0.36 animations:^{
            UIButton *contentButton = (UIButton *)[self.filterView viewWithTag:101];
            UIImageView *contentView = (UIImageView *)[self.filterView viewWithTag:102];
            contentButton.alpha = 0.0;
            contentView.frame = CGRectMake(0.0, -contentView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
        } completion:^(BOOL finished) {
            self.isSelectCategory = NO;
            self.filterView.hidden = YES;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.36 animations:^{
            UIButton *contentButton = (UIButton *)[self.filterView viewWithTag:101];
            UIImageView *contentView = (UIImageView *)[self.filterView viewWithTag:102];
            contentButton.alpha = 0.0;
            contentView.frame = CGRectMake(0.0, -contentView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
        } completion:^(BOOL finished) {
            self.isSelectCategory = NO;
            self.filterView.hidden = YES;
        }];
    }
}

- (void)didPriceButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (self.isPriceSortASC)
    {
        self.isPriceSortASC = NO;
        [button setTitleColor:COLOR(137.0, 142.0, 145.0, 1.0) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"filter_arrow_down"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"filter_arrow_down"] forState:UIControlStateHighlighted];
    }
    else
    {
        self.isPriceSortASC = YES;
        [button setTitleColor:COLOR(11.0, 169.0, 250.0, 1.0) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"filter_arrow_up"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"filter_arrow_up"] forState:UIControlStateHighlighted];
    }
    
    UITextField *textField = (UITextField *)[self.searchBar viewWithTag:101];
    if (textField.isFirstResponder)
    {
        [UIView animateWithDuration:0.32 animations:^{
            [textField endEditing:YES];
        } completion:^(BOOL finished) {
            [self initProjectItem];
        }];
    }
    else
    {
        [self initProjectItem];
    }
}

- (void)didSearchBarClick:(id)sender
{
    UITextField *textField = (UITextField *)[self.searchBar viewWithTag:101];
    [textField becomeFirstResponder];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSProjectRequestSuccess])
    {
        [[CBLoadingView shareLoadingView] hide];
        
        [self initCategory];
        [self initProjectItem];
    }
    else if ([notification.name isEqualToString:kBSProjectRequestFailed])
    {
        [[CBLoadingView shareLoadingView] hide];
    }
    else if ([notification.name isEqualToString:kBSProjectItemEditFinish] || [notification.name isEqualToString:kBSProjectTemplateEditFinish])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [[BSProjectRequest sharedInstance] startProjectRequest];
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.projectTableView)
    {
        return self.templateArray.count;
    }
    else if (tableView == self.categoryTableView)
    {
        return self.categoryArray.count + 2;
    }
    else if (tableView == self.subCategoryTableView)
    {
        if (self.categorySelectedIndex < self.categoryArray.count)
        {
            if (self.currentCategory.parentID.integerValue == 0)
            {
                return self.subCategoryArray.count + 1;
            }
            else
            {
                return self.subCategoryArray.count + 2;
            }
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.projectTableView)
    {
        return kBSItemCellHeight;
    }
    else if (tableView == self.categoryTableView)
    {
        return kProjectCategoryCellHeight;
    }
    else if (tableView == self.subCategoryTableView)
    {
        return kProjectSubCategoryCellHeight;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (tableView == self.projectTableView)
    {
        if (self.viewType == kProjectSelectPanDianItem)
        {
            static NSString *CellIdentifier = @"BSSelectItemCellIdentifier";
            BSSelectItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BSSelectItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            CDProjectItem *item = [self.templateArray objectAtIndex:indexPath.row];
            [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
            cell.titleLabel.text = item.itemName;
    
            NSString *categorystr = [NSString stringWithFormat:@"BornCategory%d", item.bornCategory.integerValue];
            cell.detailLabel.text = [NSString stringWithFormat:LS(@"ProjectItemDetail"), item.totalPrice.doubleValue, item.uomName, LS(categorystr), LS(item.type)];
            
            cell.valueTextField.tag = kPanDianAmountTextFieldTag + indexPath.row;
            cell.valueTextField.delegate = self;
            NSNumber *amount = [self.params objectForKey:item.itemID];
            if (amount)
            {
                cell.selectImageView.image = [UIImage imageNamed:@"login_remeberPw_h"];
                cell.valueTextField.text = [NSString stringWithFormat:@"%d", amount.integerValue];
                cell.valueTextField.hidden = NO;
            }
            else
            {
                cell.selectImageView.image = [UIImage imageNamed:@"login_remeberPw_n"];
                cell.valueTextField.text = @"";
                cell.valueTextField.hidden = YES;
            }
            
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"BSItemCellIdentifier";
            BSItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BSItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            if (self.viewType == kProjectViewEdit)
            {
                CDProjectTemplate *template = [self.templateArray objectAtIndex:indexPath.row];
                [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:template.imageUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
                cell.titleLabel.text = template.templateName;
                NSString *categorystr = [NSString stringWithFormat:@"BornCategory%d", template.bornCategory.integerValue];
                cell.detailLabel.text = [NSString stringWithFormat:LS(@"ProjectItemDetail"), template.listPrice.doubleValue, template.uomName, LS(categorystr), LS(template.type)];
            }
            else
            {
                CDProjectItem *item = [self.templateArray objectAtIndex:indexPath.row];
                [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
                cell.titleLabel.text = item.itemName;
                NSString *categorystr = [NSString stringWithFormat:@"BornCategory%d", item.bornCategory.integerValue];
                cell.detailLabel.text = [NSString stringWithFormat:LS(@"ProjectItemDetail"), item.totalPrice.doubleValue, item.uomName, LS(categorystr), LS(item.type)];
            }
            
            return cell;
        }
    }
    else if (tableView == self.categoryTableView)
    {
        static NSString *CellIdentifier = @"CategoryTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0, kProjectCategoryWidth - 12.0 - 12.0 - 20.0, kProjectCategoryCellHeight)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:14.0];
            titleLabel.textColor = COLOR(96.0, 99.0, 102.0, 1.0);
            titleLabel.tag = 101;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kProjectCategoryWidth - 32.0 - 12.0, 0.0, 32.0, kProjectCategoryCellHeight)];
            numberLabel.backgroundColor = [UIColor clearColor];
            numberLabel.textAlignment = NSTextAlignmentRight;
            numberLabel.font = [UIFont systemFontOfSize:12.0];
            numberLabel.textColor = COLOR(137.0, 142.0, 145.0, 1.0);
            numberLabel.tag = 102;
            [cell.contentView addSubview:numberLabel];
        }
        
        UIImage *normalImage = [[UIImage imageNamed:@"project_category_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 44.0, 12.0, 44.0)];
        UIImage *selectedImage = [[UIImage imageNamed:@"project_category_cell_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 44.0, 12.0, 44.0)];
        if (indexPath.row == self.categorySelectedIndex)
        {
            cell.backgroundView = [[UIImageView alloc] initWithImage:selectedImage];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:normalImage];
        }
        else
        {
            cell.backgroundView = [[UIImageView alloc] initWithImage:normalImage];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedImage];
        }
        
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel *numberLabel = (UILabel *)[cell.contentView viewWithTag:102];
        
        if (indexPath.row == self.categoryArray.count)
        {
            titleLabel.text = LS(@"Other");
            numberLabel.text = [NSString stringWithFormat:@"%d", self.otherCount];
            
        }
        else if (indexPath.row == self.categoryArray.count + 1)
        {
            titleLabel.text = LS(@"Total");
            
            numberLabel.text = [NSString stringWithFormat:@"%d", self.totalCount];
        }
        else
        {
            CDProjectCategory *category = [self.categoryArray objectAtIndex:indexPath.row];
            titleLabel.text = category.categoryName;
            numberLabel.text = [NSString stringWithFormat:@"%d", category.itemCount.integerValue];
        }
        return cell;
    }
    else if (tableView == self.subCategoryTableView)
    {
        static NSString *CellIdentifier = @"SubCategoryTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0, kProjectSubCategoryWidth - 12.0 - 14.0 - 24.0, kProjectSubCategoryCellHeight)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:14.0];
            titleLabel.textColor = COLOR(96.0, 99.0, 102.0, 1.0);
            titleLabel.tag = 101;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kProjectSubCategoryWidth - 32.0 - 14.0, 0.0, 32.0, kProjectSubCategoryCellHeight)];
            numberLabel.backgroundColor = [UIColor clearColor];
            numberLabel.textAlignment = NSTextAlignmentRight;
            numberLabel.font = [UIFont systemFontOfSize:12.0];
            numberLabel.textColor = COLOR(137.0, 142.0, 145.0, 1.0);
            numberLabel.tag = 102;
            [cell.contentView addSubview:numberLabel];
        }
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel *numberLabel = (UILabel *)[cell.contentView viewWithTag:102];
        
        UIImage *normalImage = [[UIImage imageNamed:@"project_sub_category_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 44.0, 12.0, 44.0)];
        UIImage *selectedImage = [[UIImage imageNamed:@"project_sub_category_cell_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 44.0, 12.0, 44.0)];
        if (indexPath.row == self.subCategorySelectedIndex)
        {
            cell.backgroundView = [[UIImageView alloc] initWithImage:selectedImage];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:normalImage];
            titleLabel.textColor = COLOR(11.0, 169.0, 250.0, 1.0);
            numberLabel.textColor = COLOR(11.0, 169.0, 250.0, 1.0);
        }
        else
        {
            cell.backgroundView = [[UIImageView alloc] initWithImage:normalImage];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedImage];
            titleLabel.textColor = COLOR(96.0, 99.0, 102.0, 1.0);
            numberLabel.textColor = COLOR(137.0, 142.0, 145.0, 1.0);
        }
        
        if (self.currentCategory.parentID.integerValue == 0)
        {
            if (indexPath.row == 0)
            {
                titleLabel.text = LS(@"Total");
                numberLabel.text = [NSString stringWithFormat:@"%d", self.currentCategory.itemCount.integerValue];
            }
            else
            {
                CDProjectCategory *subCategory = [self.subCategoryArray objectAtIndex:indexPath.row - 1];
                titleLabel.text = subCategory.categoryName;
                numberLabel.text = [NSString stringWithFormat:@"%d", subCategory.itemCount.integerValue];
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                titleLabel.text = LS(@"GoBack");
                numberLabel.text = @"";
            }
            else if (indexPath.row == 1)
            {
                titleLabel.text = LS(@"Total");
                numberLabel.text = [NSString stringWithFormat:@"%d", self.currentCategory.itemCount.integerValue];
            }
            else
            {
                CDProjectCategory *subCategory = [self.subCategoryArray objectAtIndex:indexPath.row - 2];
                titleLabel.text = subCategory.categoryName;
                numberLabel.text = [NSString stringWithFormat:@"%d", subCategory.itemCount.integerValue];
            }
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.projectTableView)
    {
        if (self.viewType == kProjectViewEdit)
        {
            CDProjectTemplate *template = [self.templateArray objectAtIndex:indexPath.row];
            ProjectCreateViewController *viewController = [[ProjectCreateViewController alloc] initWithEditType:kProjectTemplateEdit projectTemplate:template];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            CDProjectItem *item = [self.templateArray objectAtIndex:indexPath.row];
            if (self.viewType == kProjectSelectConsumable)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSConsumableItemSelectFinish object:item userInfo:nil];
            }
            else if (self.viewType == kProjectSelectSubItem)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSSubItemSelectFinish object:item userInfo:nil];
            }
            else if (self.viewType == kProjectSelectSameItem)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSSameItemSelectFinish object:item userInfo:nil];
            }
            else if (self.viewType == kProjectSelectCardItem)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSCardItemSelectFinish object:item userInfo:nil];
            }
            else if (self.viewType == kProjectSelectPurchase)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSPurchaseItemSelectFinish object:item userInfo:nil];
            }
            else if (self.viewType == kProjectSelectCardBuyItem)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSCardBuyItemSelectFinish object:item userInfo:nil];
            }
            else if (self.viewType == kProjectSelectPanDianItem)
            {
                NSNumber *amount = [self.params objectForKey:item.itemID];
                if (amount)
                {
                    [self.params removeObjectForKey:item.itemID];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeletePanDianWithProjectItem:)])
                    {
                        [self.delegate didDeletePanDianWithProjectItem:item];
                    }
                }
                else
                {
                    [self.params setObject:[NSNumber numberWithInteger:0] forKey:item.itemID];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didAddPanDianWithProjectItem:)])
                    {
                        [self.delegate didAddPanDianWithProjectItem:item];
                    }
                }
                [self.projectTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                return ;
            }
            
            if (self.viewType != kProjectSelectPurchase)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else if (tableView == self.categoryTableView && indexPath.row != self.categorySelectedIndex)
    {
        self.categorySelectedIndex = indexPath.row;
        self.subCategorySelectedIndex = 0;
        if (self.categorySelectedIndex < self.categoryArray.count)
        {
            CDProjectCategory *category = [self.categoryArray objectAtIndex:self.categorySelectedIndex];
            [self initCurrentCategory:category];
        }
        [self.categoryTableView reloadData];
        [self.subCategoryTableView reloadData];
        [self initProjectItem];
        
        if (self.categorySelectedIndex >= self.categoryArray.count || self.subCategoryArray.count == 0)
        {
            [self hideFilterView];
        }
    }
    else if (tableView == self.subCategoryTableView)
    {
        if (self.currentCategory.parentID.integerValue == 0)
        {
            if (indexPath.row != 0)
            {
                CDProjectCategory *subCategory = [self.subCategoryArray objectAtIndex:indexPath.row - 1];
                if (subCategory.subCategory.count != 0)
                {
                    [self initCurrentCategory:subCategory];
                    
                    self.subCategorySelectedIndex = 1;
                    [self.subCategoryTableView reloadData];
                    [self initProjectItem];
                    
                    return ;
                }
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                NSInteger index = [self.currentCategory.parent.subCategory indexOfObject:self.currentCategory];
                [self initCurrentCategory:self.currentCategory.parent];
                if (self.currentCategory.parentID.integerValue == 0)
                {
                    self.subCategorySelectedIndex = index + 1;
                }
                else
                {
                    self.subCategorySelectedIndex = index + 2;
                }
                [self.subCategoryTableView reloadData];
                [self initProjectItem];
                
                return ;
            }
            else if (indexPath.row > 1)
            {
                CDProjectCategory *subCategory = [self.subCategoryArray objectAtIndex:indexPath.row - 2];
                if (subCategory.subCategory.count != 0)
                {
                    [self initCurrentCategory:subCategory];
                    self.subCategorySelectedIndex = 1;
                    [self.subCategoryTableView reloadData];
                    [self initProjectItem];
                    
                    return ;
                }
            }
        }
        
        self.subCategorySelectedIndex = indexPath.row;
        [self.subCategoryTableView reloadData];
        [self initProjectItem];
        [self hideFilterView];
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UITextField *textField = (UITextField *)[self.searchBar viewWithTag:101];
    if (textField.isFirstResponder)
    {
        [textField endEditing:YES];
    }
}


#pragma mark -
#pragma mark BNSegmentedControlDelegate Methods

- (void)segmentedControl:(BNSegmentedControl *)segmentedControl didSelectedAtIndex:(NSInteger)selectedIndex
{
    self.type = selectedIndex + 1;
    
    [self initCategory];
    [self initProjectItem];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == kSearchKeywordTextFieldTag)
    {
        return YES;
    }
    
    BOOL isNum = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < string.length)
    {
        NSString *substring = [string substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [substring rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0)
        {
            isNum = NO;
            break;
        }
        i++;
    }
    
    return isNum;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == kSearchKeywordTextFieldTag)
    {
        if (![self.keyword isEqualToString:textField.text])
        {
            self.keyword = textField.text;
            [self initProjectItem];
        }
    }
    else if (textField.tag >= kPanDianAmountTextFieldTag)
    {
        NSInteger index = textField.tag - kPanDianAmountTextFieldTag;
        CDProjectItem *item = [self.templateArray objectAtIndex:index];
        NSNumber *amount = [self.params objectForKey:item.itemID];
        if (amount && amount.integerValue != textField.text.integerValue)
        {
            [self.params setObject:[NSNumber numberWithInteger:textField.text.integerValue] forKey:item.itemID];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didEditPanDianWithProjectItem:withAmount:)])
            {
                [self.delegate didEditPanDianWithProjectItem:item withAmount:textField.text.integerValue];
            }
        }
        [self.projectTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
