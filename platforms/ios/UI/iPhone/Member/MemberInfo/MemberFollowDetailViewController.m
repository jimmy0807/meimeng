//
//  MemberFollowDetailViewController.m
//  Boss
//
//  Created by lining on 16/5/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFollowDetailViewController.h"
#import "MemberRecordCollectionViewCell.h"
#import "MemberFollowInfoDataSource.h"
#import "MemberFollowProductDataSource.h"
#import "MemberFollowContentDataSource.h"

#import "BSFetchMemberFollowProductRequest.h"
#import "BSFetchMemberFollowContentRequest.h"

#import "MemberFollowAddContentViewController.h"


#define TOP_TITLE_INFO      @"分析详情"
#define TOP_TITLE_PRODUCT   @"院余项目"
#define TOP_TITLE_CONTENT   @"跟进内容"

@interface MemberFollowDetailViewController ()<MemberRecordDataSourceProtocol,CollectionViewCellDelegate>
{
    NSInteger currentIdx;
    NSInteger requestCount;
}
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableArray *topItems;
@property (nonatomic, strong) NSArray *topTitles;
@property (nonatomic, strong) NSMutableDictionary *dataSourceDict;
@end

@implementation MemberFollowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"跟进表详情";
    
    self.topTitles = @[TOP_TITLE_INFO,TOP_TITLE_PRODUCT,TOP_TITLE_CONTENT];
    [self initDataSource];
    [self initScrollView];
    [self initCollectionView];
    
    [self registerNofitificationForMainThread:kBSFetchMemberFollowProductResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberFollowContentResponse];
    [self registerNofitificationForMainThread:kBSUpdateMemberFollowResponse];
    [self sendRequest];
}

#pragma mark - send request
- (void)sendRequest
{
    requestCount = 0;
    BSFetchMemberFollowProductRequest *productRequest = [[BSFetchMemberFollowProductRequest alloc] init];
    productRequest.follow = self.follow;
    [productRequest execute];
    requestCount++;
    
    BSFetchMemberFollowContentRequest *contentRequest = [[BSFetchMemberFollowContentRequest alloc] init];
    contentRequest.follow = self.follow;
    [contentRequest execute];
    requestCount ++;
    
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSUpdateMemberFollowResponse]) {
        [self.collectionView reloadData];
        BSFetchMemberFollowContentRequest *contentRequest = [[BSFetchMemberFollowContentRequest alloc] init];
        contentRequest.follow = self.follow;
        [contentRequest execute];
        requestCount ++;
    }
    else
    {
        requestCount--;
        if (requestCount == 0) {
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - init DataSource
- (void)initDataSource
{
    self.dataSourceDict = [NSMutableDictionary dictionary];
     for (NSString *title in self.topTitles)
     {
         CollectionTableDataSource *dataSource;
         if ([title isEqualToString:TOP_TITLE_INFO]) {
             dataSource = [[MemberFollowInfoDataSource alloc] init];
             
         }
         else if ([title isEqualToString:TOP_TITLE_PRODUCT])
         {
             dataSource = [[MemberFollowProductDataSource alloc] init];
         }
         else if ([title isEqualToString:TOP_TITLE_CONTENT])
         {
             dataSource = [[MemberFollowContentDataSource alloc] init];
         }
         dataSource.tag = title;
         dataSource.delegate = self;
         [self.dataSourceDict setObject:dataSource forKey:title];
     }
}




#pragma mark - init scrollView
- (void) initScrollView
{
    self.topItems = [NSMutableArray array];
    self.scrollView.showsHorizontalScrollIndicator = false;
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:containerView];
    self.scrollView.backgroundColor = AppThemeColor;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView).with.insets(UIEdgeInsetsZero);
        make.height.equalTo(self.scrollView);
    }];
    
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:self.indicatorView];
    
    CGFloat titleWidth = 0;
    for (NSString *title in self.topTitles) {
        CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:16.0] constrainedToSize:CGSizeMake(IC_SCREEN_WIDTH, 44)];
        titleWidth += size.width;
    }
    
    CGFloat offset = 1.0 * (IC_SCREEN_WIDTH - titleWidth)/(self.topTitles.count + 1);
    
    UIView *lastView = nil;
    for (int i = 0; i < self.topTitles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 101 + i;
        [btn addTarget:self action:@selector(didTopBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

        if (currentIdx == i) {
            btn.alpha = 1;
        }
        else
        {
            btn.alpha = 0.6;
        }
        
        [self.topItems addObject:btn];
        [containerView addSubview:btn];
        [btn setTitle:self.topTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//        btn.backgroundColor = [UIColor redColor];
        
        //        btn.titleLabel.textColor = [UIColor whiteColor];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(containerView);
            if (lastView) {
                make.leading.mas_equalTo(lastView.mas_trailing).with.offset(offset);

            }
            else
            {
                make.leading.mas_equalTo(containerView.mas_leading).with.offset(offset);
            }
        }];
        
        if (i == 0) {
            [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(btn).offset(0);
                
                make.width.equalTo(btn);
                make.height.equalTo(@2);
                make.bottom.equalTo(containerView).with.offset(-5);
            }];
        }
        
        lastView = btn;
    }
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(lastView).with.offset(offset);
    }];
}

- (void)didTopBtnPressed:(UIButton *)btn
{
    NSInteger idx = btn.tag - 101;
    
    [self indicateViewToIndex:idx];
    
    [self.collectionView setContentOffset:CGPointMake(self.view.frame.size.width * idx, 0) animated:YES];
}


- (void)indicateViewToIndex:(NSInteger)idx
{
    UIButton *preBtn = self.topItems[currentIdx];
    preBtn.alpha = 0.6;
    
    UIButton *btn = self.topItems[idx];
    btn.alpha = 1;
    currentIdx = idx;
    
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(btn);
        make.width.equalTo(btn);
        make.height.equalTo(@2);
        make.bottom.equalTo(self.indicatorView.superview).with.offset(-5);
    }];
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.indicatorView.superview layoutIfNeeded];
    }];
    
    float scrollMaxMoveX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (scrollMaxMoveX < 0) {
        scrollMaxMoveX = 0;
    }
    float collectionViewMaxOffsetX = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
    
    float radio = scrollMaxMoveX / collectionViewMaxOffsetX;
    float scrollX = radio * idx * self.collectionView.frame.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
}


#pragma mark - collection view
- (void) initCollectionView
{
    self.collectionView.pagingEnabled = true;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MemberRecordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MemberRecordCollectionViewCell"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
    
    [self indicateViewToIndex:index];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    MemberRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberRecordCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    NSString *title = self.topTitles[row];
    cell.noRecordView.hidden = true;
    cell.addBtnHidden = true;
    if ([title isEqualToString:TOP_TITLE_INFO]) {
        MemberFollowInfoDataSource *dataSource = [self.dataSourceDict objectForKey:title];
        dataSource.follow = self.follow;
        cell.tableView.dataSource = dataSource;
        cell.tableView.delegate = dataSource;
        [cell.tableView reloadData];
    }
    else if ([title isEqualToString:TOP_TITLE_PRODUCT])
    {
        MemberFollowProductDataSource *dataSource = [self.dataSourceDict objectForKey:title];
        
        dataSource.mainProducts = [self fetchFollowMainProductes:true];
        dataSource.otherProducts = [self fetchFollowMainProductes:false];
        cell.tableView.dataSource = dataSource;
        cell.tableView.delegate = dataSource;
        [cell.tableView reloadData];
    }
    else if ([title isEqualToString:TOP_TITLE_CONTENT])
    {
        cell.addBtnHidden = false;
        
        MemberFollowContentDataSource *dataSource = [self.dataSourceDict objectForKey:title];
        dataSource.followContents = [[BSCoreDataManager currentManager] fetchMemberFollowContentsWithFollow:self.follow];
        cell.tableView.dataSource = dataSource;
        cell.tableView.delegate = dataSource;
        [cell.tableView reloadData];
    }
    
    NSLog(@"%@",title);
    return cell;
}

- (NSArray *)fetchFollowMainProductes:(BOOL)main
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"follow_id = %@ && is_main_product = %d",self.follow.follow_id,main];
    
    //    CDMemberFollowProduct
    NSArray *followProducts = [[BSCoreDataManager currentManager] fetchItems:@"CDMemberFollowProduct" sortedByKey:@"line_id" ascending:YES predicate:predicate];
    return followProducts;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - MemberRecordDataSourceProtocol
- (void)didItemSelectedwithType:(NSString *)type atIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:TOP_TITLE_CONTENT]) {
        NSArray *followContents = [[BSCoreDataManager currentManager] fetchMemberFollowContentsWithFollow:self.follow];
        CDMemberFollowContent *followContent = [followContents objectAtIndex:indexPath.section];
        
        MemberFollowAddContentViewController *addContentVC = [[MemberFollowAddContentViewController alloc] init];
        addContentVC.followContent = followContent;
        addContentVC.follow = self.follow;
        [self.navigationController pushViewController:addContentVC animated:YES];
    }
}

#pragma mark - CollectionViewCellDelegate
- (void)didAddBtnPressedOfCell:(MemberRecordCollectionViewCell *)cell
{

    MemberFollowAddContentViewController *addContentVC = [[MemberFollowAddContentViewController alloc] init];
    addContentVC.follow = self.follow;
    [self.navigationController pushViewController:addContentVC animated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
