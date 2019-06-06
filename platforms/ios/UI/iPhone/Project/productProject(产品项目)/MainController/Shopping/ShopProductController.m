//
//  shopController.m
//  Boss
//
//  Created by jiangfei on 16/6/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ShopProductController.h"
#import "ProductTypeColletionCell.h"
#import "ProductTypeOneColumnCollectionCell.h"
#import "ProductTypeFlowLayout.h"
#import "ProductTypeCollectionHeadView.h"
#import "MJRefresh.h"
#import "UIBarButtonItem+JFExtension.h"
#import "UIView+SnapShot.h"

@interface ShopProductController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
/** collectionView*/
@property (nonatomic,weak)UICollectionView *collectionView;
/** 布局数组*/
@property (nonatomic,strong)NSMutableArray *layoutArray;
/** 当前布局*/
@property (nonatomic,strong)ProductTypeFlowLayout *layout;
/** 重用标识数组*/
@property (nonatomic,strong)NSMutableArray *reuseIdArray;
/** 当前的重用标识 */
@property (nonatomic,copy)NSString *cellId;
/** collection显示的数据*/
@property (nonatomic,strong)NSMutableArray *collectionArray;
/** collection当前显示的View*/
@property (nonatomic,strong)NSMutableArray *currentArray;
/** collectionView头部控件*/
@property (nonatomic,weak)ProductTypeCollectionHeadView *collctionHeadView;
/**  一页显示的数据*/
@property (nonatomic,assign)NSUInteger pageCount;

/** 记录collectionView 上一次滚动的点*/
@property (nonatomic,assign)CGPoint prePoint;
/** 记录collectionView停止拖拽时候的点*/
@property (nonatomic,assign)CGPoint stopPoint;
/** 判断当前滚动的方向*/
@property (nonatomic,assign)BOOL scrollUp;
@end

@implementation ShopProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stopPoint = CGPointMake(0, MAXFLOAT);
    self.pageCount = 20;
    [self collectionView];
    //设置导航栏
    [self setUpNavi];
    //添加刷新控件
    [self addRefrshView];
    

}
#pragma mark - 设置导航栏
-(void)setUpNavi
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithNormalImageName:@"navi_back_n.png" andHightImageName:@"navi_back_h.png" target:self action:@selector(back:)];
    if (self.type == ShopControllerType_Buy) {
        self.title = @"商品";
    }
    else if (self.type == ShopControllerType_Point)
    {
        self.title = @"积分";
    }
}
-(void)back:(UIBarButtonItem*)item
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 添加刷新控件
-(void)addRefrshView
{
    //头部
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.mj_h = 10;
    header.backgroundColor = [UIColor whiteColor];
    header.ignoredScrollViewContentInsetTop = 0;
    self.collectionView.mj_header = header;
    //底部刷新控件
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
#pragma mark 加载更多数据
-(void)loadMoreData
{
    //判断数据库中的数据是否为空
    if (self.collectionArray.count==0) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    //判断当前显示的数据与数据库中数据的差值
    if (self.currentArray.count +self.pageCount < self.collectionArray.count) {
        NSArray *arr = [self.collectionArray subarrayWithRange:NSMakeRange(self.currentArray.count, self.pageCount)];
        [self.currentArray addObjectsFromArray:arr];
    }else if(self.currentArray.count<self.collectionArray.count){
        self.currentArray = self.collectionArray;
    }else{
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    });
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView setContentOffset:CGPointMake(0, 60) animated:YES];
}
#pragma mark 加载新的数据
-(void)loadNewData
{
    
    
////    self.currentArray = nil;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.collectionView.mj_header endRefreshing];
//        
//        CGPoint point = CGPointMake(0, 60);
//        
//        [self.collectionView setContentOffset:point animated:YES];
//        
//        [self.collectionView reloadData];
//    });
}

#pragma collectionView的delegate和datasource方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.currentArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   ProductTypeColletionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellId forIndexPath:indexPath];
    cell.object = self.currentArray[indexPath.row];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    ProductTypeCollectionHeadView *reuserView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductTypeCollectionHeadView" forIndexPath:indexPath];
    self.collctionHeadView = reuserView;
//    reuserView.reuseBlock = ^(NSInteger tag){
//        //改变cell的标识付来便于获取不同的cell
//        self.cellId = self.reuseIdArray[tag];
//        CGFloat margin = 15;
//        CGFloat itemW = (IC_SCREEN_WIDTH - 3*margin)/2;
//        CGFloat itemH = itemW + 36;
//        CGSize size1 = CGSizeMake(itemW, itemH);
//        CGSize size2 = CGSizeMake(IC_SCREEN_WIDTH - 30, 100);
//        if (tag == 0){
//            self.layout.size = size1;
//        }else{
//            self.layout.size = size2;
//        }
//        [self.collectionView reloadData];
//    };
//    
    return reuserView;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == ShopControllerType_Buy) {
        
        ProductTypeColletionCell *cell = (ProductTypeColletionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        CGRect rect = [self.view convertRect:cell.bounds fromView:cell];
        UIView *snapshot = [self snapshotAtIndexPath:indexPath];
        snapshot.frame = rect;
        [self.view addSubview:snapshot];
        [UIView animateWithDuration:0.4 animations:^{
            snapshot.frame = CGRectMake(20, self.view.frame.size.height - 20, 20.0, 20.0);
        } completion:^(BOOL finished) {
            [snapshot removeFromSuperview];
        }];
    }
    else if (self.type == ShopControllerType_Point)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([_delegate respondsToSelector:@selector(didSelectedProjectItem:)]) {
        CDProjectItem *item = self.currentArray[indexPath.row];
        [_delegate didSelectedProjectItem:item];
    }
}

#pragma mark - snap view
- (UIView *)snapshotAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTypeColletionCell *cell = (ProductTypeColletionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
    cell.highlighted = NO;
    
    UIView *snapshot = [cell snapshot];
    snapshot.frame = cell.frame;
    snapshot.alpha = 1.0;
    snapshot.layer.shadowRadius = 4.0;
    snapshot.layer.shadowOpacity = 0.0;
    snapshot.layer.shadowOffset = CGSizeZero;
    snapshot.layer.shadowPath = [[UIBezierPath bezierPathWithRect:snapshot.layer.bounds] CGPath];
    
    return snapshot;
}

#pragma mark - 初始化(view)
#pragma mark 初始化collectionView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        CGRect rect = CGRectMake(0, 0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
        //默认是显示正方形的cell
        self.layout = self.layoutArray[0];
        self.cellId = self.reuseIdArray[0];
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:self.layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView = collectionView;
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册正方形的cell
        [_collectionView registerNib:[UINib nibWithNibName:@"ProductTypeColletionCell" bundle:nil] forCellWithReuseIdentifier:[self.reuseIdArray firstObject]];
        //注册长方形的cell
        [_collectionView registerNib:[UINib nibWithNibName:@"ProductTypeOneColumnCollectionCell" bundle:nil] forCellWithReuseIdentifier:[self.reuseIdArray lastObject]];
        //注册headView
        [_collectionView registerClass:[ProductTypeCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductTypeCollectionHeadView"];
    }
    return _collectionView;
}
#pragma mark - 初始化(数据)
#pragma mark 重用标识数组
-(NSMutableArray *)reuseIdArray
{
    if (!_reuseIdArray) {
        _reuseIdArray = [NSMutableArray array];
        [_reuseIdArray addObjectsFromArray:@[@"productTypeCell",@"otherColletiionCell"]];
    }
    return _reuseIdArray;
}
#pragma mark 初始化collectionView要显示的数据
-(NSMutableArray *)collectionArray{
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray array];
        [_collectionArray addObjectsFromArray:[[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:@[@(kPadBornCategoryProduct), @(kPadBornCategoryProject)] categoryIds:nil existItemIds:nil keyword:nil priceAscending:YES]];
      
    }
    return _collectionArray;
}
#pragma mark - 初始化布局数组
-(NSMutableArray *)layoutArray
{
    if (!_layoutArray) {
        _layoutArray = [NSMutableArray array];
        //一行展示两个cell
        ProductTypeFlowLayout *layout0 = [[ProductTypeFlowLayout alloc]init];
        //一行展示一个cell
        ProductTypeFlowLayout *layout1 = [[ProductTypeFlowLayout alloc]init];
        [_layoutArray addObjectsFromArray:@[layout0,layout1]];
        
        
    }
    return _layoutArray;
}
#pragma mark - 初始化当前布局
-(ProductTypeFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[ProductTypeFlowLayout alloc]init];
    }
    return _layout;
}
#pragma mark 初始化当前collectionView要显示的数据
-(NSMutableArray *)currentArray{
    if (!_currentArray) {
        _currentArray = [NSMutableArray array];
        
        if(self.collectionArray.count<self.pageCount) {
            _currentArray = self.collectionArray;
        }else{
            if (self.collectionArray.count>0) {
                NSArray *arr = [self.collectionArray subarrayWithRange:NSMakeRange(0, self.pageCount)];
                [_currentArray  addObjectsFromArray:arr];
            }
        }
    }
    return _currentArray;
}

#pragma mark - scrollView的代理方法
#pragma mark 滚动过程中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint currentPoint = scrollView.contentOffset;
    CGFloat maxMargin = -20;
    CGFloat headH = 60;
    //判断是否往上面滚。
    self.scrollUp = (self.prePoint.y < currentPoint.y);
    
    if (self.scrollUp) {//上弹得过程
        if (currentPoint.y < headH && self.stopPoint.y < maxMargin) {//到达了最低点
            [self headViewDataSetWithImageName:@"BornDownRefreshImage" loadingShow:YES titleName:@"正在为您刷新..."];
        }else{//没有到达最低点
            [self headViewDataSetWithImageName:@"BornDownRefreshImage" loadingShow:NO titleName:@"继续下拉刷新..."];
        }
    }else{//下拉的过程
        if (currentPoint.y< maxMargin) {//从collectionViewde的(0,0)下拉的距离超过20，切换图片，提示松手加载
            [self headViewDataSetWithImageName:@"BornCategoryUpRefreshImage" loadingShow:NO titleName:@"松开立即刷新..."];
        }else{//从60 - 0 下拉的过程
            [self headViewDataSetWithImageName:@"BornDownRefreshImage" loadingShow:NO titleName:@"继续下拉刷新..."];
        }
    }
    self.prePoint = currentPoint;
}
#pragma mark 结束拖拽
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.stopPoint = scrollView.contentOffset;
    CGFloat y = 60;
    CGPoint zeroPoint = CGPointMake(0, 0);
    CGPoint maxPoint = CGPointMake(0, y);
    if (scrollView.contentOffset.y <y && scrollView.contentOffset.y>0) {
        if (self.scrollUp) {//往上滚
            if (scrollView.contentOffset.y > y/3) {
                [self.collectionView setContentOffset:maxPoint animated:YES];
            }else{
                [self.collectionView setContentOffset:zeroPoint animated:YES];
            }
            
        }else{//往下滚
            if (scrollView.contentOffset.y>y/3*2) {
                [self.collectionView setContentOffset:maxPoint animated:YES];
            }else{
                [self.collectionView setContentOffset:zeroPoint animated:YES];
            }
            
        }
    }
    if (scrollView.contentOffset.y < -70) {
//        self.collctionHeadView.loadingShow = YES;
    }
    
}
#pragma mark 设置headView的数据
-(void)headViewDataSetWithImageName:(NSString*)imageName loadingShow:(BOOL)loadingShow titleName:(NSString*)titleName{
    //切换图片
//    [UIView animateWithDuration:0.1 animations:^{
//        if (imageName.length>0) {
//            self.collctionHeadView.imageName = [UIImage imageNamed:imageName];
//        }
//        self.collctionHeadView.titleName = titleName;
//        self.collctionHeadView.loadingShow = loadingShow;
//    }];
}

@end
