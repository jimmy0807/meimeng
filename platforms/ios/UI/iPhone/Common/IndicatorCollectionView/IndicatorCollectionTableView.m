//
//  IndicatorCollectionTableView.m
//  Boss
//
//  Created by lining on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#define kTopScrollViewHeigth 46
#define kDefaultCount 3
#define kMinMargin 20
#define kScrollViewBgColor  COLOR(11, 169, 250, 1)


#import "IndicatorCollectionTableView.h"
#import "IndicatorCollectionViewCell.h"



@interface IndicatorCollectionTableView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger currentIdx;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (strong, nonatomic) NSMutableArray *topItems;
@property (strong, nonatomic) NSMutableArray *titleWidths;
@property (strong, nonatomic) UIView *lineView;
@end

@implementation IndicatorCollectionTableView

+ (instancetype)createView
{
    return [[self alloc] init];
}

+ (instancetype)createViewFromNib
{
    IndicatorCollectionTableView *indicatorView =  [[[NSBundle mainBundle] loadNibNamed:@"IndicatorCollectionTableView" owner:self options:nil] objectAtIndex:0];
    indicatorView.isLoadFromNib = true;
    return indicatorView;
}

- (instancetype)initWithTitles:(NSArray *)titles
{
    self = [super init];
    if (self) {
        self.titles = titles;
        self.topScollHeight = kTopScrollViewHeigth;
        self.count = titles.count;
        self.topStartOffset = -1;
        self.topItemMargin = -1;
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self ) {
        self.topScollHeight = kTopScrollViewHeigth;
        self.count = -1;
        self.topStartOffset = -1;
        self.topItemMargin = -1;
        
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = kScrollViewBgColor;
    self.scrollView.showsHorizontalScrollIndicator = false;
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.equalTo(@(self.topScollHeight));
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.showsVerticalScrollIndicator = false;
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = true;
//    [self.collectionView registerNib:[UINib nibWithNibName:@"IndicatorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IndicatorCollectionViewCell"];
    [self.collectionView registerClass:[IndicatorCollectionViewCell class] forCellWithReuseIdentifier:@"IndicatorCollectionViewCell"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
    }];
}


- (void) reloadSubViews
{
    self.count = self.titles.count;
    self.topItems = [NSMutableArray array];
    self.titleWidths = [NSMutableArray array];
    
    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView).with.insets(UIEdgeInsetsZero);
        make.height.equalTo(self.scrollView);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:self.lineView];
    
    
    CGFloat titleWidth = 0;
    for (NSString *title in self.titles) {
        CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:16.0] constrainedToSize:CGSizeMake(IC_SCREEN_WIDTH, 44)];
        titleWidth += ceil(size.width);
        [self.titleWidths addObject:@(size.width)];
    }
    
    
    if (self.topItemMargin >= 0) {
        if (self.topStartOffset < 0) {
            self.topStartOffset = self.topItemMargin;
        }
    }
    else
    {
        if (self.count < 0) {
            self.count = kDefaultCount;
        }
        
        if (self.topStartOffset < 0)
        {
            self.topItemMargin = 1.0 * (IC_SCREEN_WIDTH - titleWidth)/(self.count + 1);
            self.topStartOffset = self.topItemMargin;
        }
        else
        {
            self.topItemMargin = 1.0 * (IC_SCREEN_WIDTH - titleWidth - 2*self.topStartOffset)/(self.count - 1);
        }
    }

    if (self.topStartOffset < kMinMargin) {
        self.topStartOffset = kMinMargin;
    }
    
    
    if (self.topItemMargin < kMinMargin) {
        self.topItemMargin = kMinMargin;
    }
    
    //设置contentEdgeInsets 防止btn的title字符串太多导致btn太小不好点击。
    CGFloat contentEdge = roundf(self.topItemMargin / 3.0f);
    NSLog(@"%.2f",contentEdge);
    UIView *lastView = nil;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
       // 设置contentEdgeInsets 防止btn的title字符串太多导致btn太小不好点击
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, contentEdge,0, contentEdge);
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
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        //        btn.titleLabel.textColor = [UIColor whiteColor];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(containerView);
            if (lastView) {
                make.leading.mas_equalTo(lastView.mas_trailing).with.offset(self.topItemMargin - 2*contentEdge);
            }
            else
            {
                make.leading.mas_equalTo(containerView.mas_leading).with.offset(self.topStartOffset - contentEdge);
            }
        }];
        
        if (i == 0) {
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn.mas_centerX);
                make.width.equalTo(self.titleWidths[i]);
                make.height.equalTo(@2);
                make.bottom.equalTo(containerView).with.offset(-5);
            }];
        }
        lastView = btn;
        
    }
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(lastView).with.offset(self.topStartOffset - contentEdge);
    }];

}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)indicateViewToIndex:(NSInteger)idx
{
    UIButton *preBtn = self.topItems[currentIdx];
    preBtn.alpha = 0.6;
    
    UIButton *btn = self.topItems[idx];
    btn.alpha = 1;
    currentIdx = idx;
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX);
        make.width.equalTo(self.titleWidths[idx]);
        make.height.equalTo(@2);
        make.bottom.equalTo(self.lineView.superview).with.offset(-5);
    }];
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.lineView.superview layoutIfNeeded];
    }];
    
    float scrollMaxMoveX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (scrollMaxMoveX < 0) {
        scrollMaxMoveX = 0;
    }
    float collectionViewMaxOffsetX = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
    
    float radio = scrollMaxMoveX / collectionViewMaxOffsetX;
    float scrollX = radio * idx * self.collectionView.frame.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedIndicatorView:atIndex:)]) {
        [self.delegate didSelectedIndicatorView:self atIndex:idx];
    }
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width * idx, 0) animated:YES];
}

- (void)didTopBtnPressed:(UIButton *)btn
{
    NSInteger idx = btn.tag - 101;
    
    [self indicateViewToIndex:idx];
    
//    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width * idx, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
    
    [self indicateViewToIndex:index];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    IndicatorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndicatorCollectionViewCell" forIndexPath:indexPath];
    
    id<IndicatorCollectionViewProtocol>indicatorView = self.indicatorViews[row];
    if ([indicatorView respondsToSelector:@selector(reloadView)]) {
        [indicatorView reloadView];
    }
    cell.indicatorView = (UIView *)indicatorView;
    [cell.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    return cell;

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

@end
