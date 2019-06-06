 //
//  MemberRecordViewController.m
//  Boss
//
//  Created by lining on 16/3/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberRecordViewController.h"
#import "MemberRecordCollectionViewCell.h"
#import "MonthCollectionViewCell.h"

#import "MemberCardConsumeDataSource.h"
#import "MemberCardOperateDataSource.h"
#import "MemberCardArrearDataSource.h"
#import "MemberCardAmountDataSource.h"
#import "MemberCardPointDataSource.h"
#import "MemberChangeShopDataSource.h"
#import "MemberHuliDataSource.h"

#import "CBLoadingView.h"
#import "BSFetchCardPointsRequest.h"
#import "BSFetchCardConsumeRequest.h"
#import "BSFetchCardOperateRequest.h"
#import "BSFetchCardAmountsRequest.h"
#import "BSFetchMemberCardArrearsRequest.h"
#import "BSFetchChangeShopRecordRequest.h"
#import "BSFetchFeedbacksRequest.h"

#import "MemberRecordDetailViewController.h"
#import "MemberOperateDetailViewController.h"

typedef enum kRecordType
{
    kRecordType_caozuo,
    kRecordType_zhuandian,
    kRecordType_fankui,
    kRecordType_duihuan,
    kRecordType_sum
}kRecordType;

@interface MemberRecordViewController ()<MemberRecordDataSourceProtocol>
{
    NSInteger currentIdx;
}
//@property(nonatomic, strong) RecordCollectionViewDataSource *collecitonViewDataSource;

@property (nonatomic, strong) NSArray *topTitles;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSLayoutConstraint *indicatorLeading;
@property (nonatomic, strong) NSMutableArray *topItems;
@property (nonatomic, strong) NSMutableDictionary *dataSourceDict;
@property (nonatomic, assign) NSInteger requestCount;
@end

@implementation MemberRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *aa = [NSString stringWithFormat:@"%@",nil];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = @"记录";
    
    if (self.type == RecordType_Card) {
//        self.topTitles = @[RECORD_TYPE_CONSUME,RECORD_TYPE_OPERATE,RECORD_TYPE_AMOUNT,RECORD_TYPE_ARREAR,RECORD_TYPE_POINT,RECORD_TYPE_QIANDAO];
        
//        self.topTitles = @[RECORD_TYPE_CONSUME,RECORD_TYPE_OPERATE,RECORD_TYPE_ARREAR,RECORD_TYPE_QIANDAO]; //签到暂时去掉
        
        self.topTitles = @[RECORD_TYPE_CONSUME,RECORD_TYPE_OPERATE,RECORD_TYPE_ARREAR,RECORD_TYPE_AMOUNT,RECORD_TYPE_POINT];
    }
    else
    {
        self.topTitles = @[RECORD_TYPE_OPERATE,RECORD_TYPE_ZHUANDIAN,RECORD_TYPE_POINT];//RECORD_TYPE_HULI去掉
    }

//    self.topTitles = @[@"操作履历",@"余额变更",@"欠款还款",@"消费明细"];
    
    currentIdx = 0;
    
    [self initDataSource];
    
    [self initScrollView];
    
    [self initCollectionView];
    
//    self.collectionView.scrollEnabled = false;
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardPointResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardConsumeResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardOperateResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardAmountResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardArrearsResponse];
    
    [self registerNofitificationForMainThread:kBSFetchMemberChangeShopResponse];
    [self registerNofitificationForMainThread:kBSFetchFeedbackResponse];
    
    [self sendRequest];
}

#pragma mark - base request
- (void)sendRequest
{
    if (self.type == RecordType_Card) {
        [self sendCardRecordRequest];
    }
    else
    {
        [self sendMemberRecordRequest];
    }
}

- (void)sendCardRecordRequest
{
    if (self.card == nil) {
        return;
    }
    /*积分*/
    BSFetchCardPointsRequest *pointRequest = [[BSFetchCardPointsRequest alloc] initWithCardID:self.card.cardID];
    [pointRequest execute];
    self.requestCount ++;
    
    /*金额变动明细*/
    BSFetchCardAmountsRequest *amountRequest = [[BSFetchCardAmountsRequest alloc] initWithCardID:self.card.cardID];
    [amountRequest execute];
    self.requestCount ++;
    
    /*操作明细*/
    BSFetchCardOperateRequest *operateRequest = [[BSFetchCardOperateRequest alloc] initWithCardID:self.card.cardID];
    [operateRequest execute];
    self.requestCount++;
    
    /*消费明细*/
    BSFetchCardConsumeRequest *consumeRequest = [[BSFetchCardConsumeRequest alloc] initWithCardID:self.card.cardID];
    [consumeRequest execute];
    self.requestCount ++;
    
    /*欠款还款明细*/
    BSFetchMemberCardArrearsRequest *arrearRequest = [[BSFetchMemberCardArrearsRequest alloc] initWithMemberCardID:self.card.cardID];
    [arrearRequest execute];
    self.requestCount++;
    
    [[CBLoadingView shareLoadingView] show];
}

- (void)sendMemberRecordRequest
{
    if (self.member == nil) {
        return;
    }
    /*积分*/
    BSFetchCardPointsRequest *pointRequest = [[BSFetchCardPointsRequest alloc] initWithMemberID:self.member.memberID];
    [pointRequest execute];
    self.requestCount ++;

    /*操作明细*/
    BSFetchCardOperateRequest *operateRequest = [[BSFetchCardOperateRequest alloc] initWithMemberID:self.member.memberID];
    [operateRequest execute];
    self.requestCount++;
    
//    /*护理明细*/
//    BSFetchFeedbacksRequest *feedbackRequest = [[BSFetchFeedbacksRequest alloc] initWithMember:self.member];
//    [feedbackRequest execute];
//    self.requestCount ++;
    
    /*转店履历*/
    BSFetchChangeShopRecordRequest *changeShopRequest = [[BSFetchChangeShopRecordRequest alloc] initWithMember:self.member];
    [changeShopRequest execute];
    self.requestCount ++;
    
    [[CBLoadingView shareLoadingView] show];
    
    
//    /*金额变动明细*/
//    BSFetchCardAmountsRequest *amountRequest = [[BSFetchCardAmountsRequest alloc] initWithMemberID:self.member.memberID];
//    [amountRequest execute];
//    self.requestCount ++;
    
//    /*消费明细*/
//    BSFetchCardConsumeRequest *consumeRequest = [[BSFetchCardConsumeRequest alloc] initWithMemberID:self.member.memberID];
//    [consumeRequest execute];
//    self.requestCount ++;
    
//    /*欠款还款明细*/
//    BSFetchMemberCardArrearsRequest *arrearRequest = [[BSFetchMemberCardArrearsRequest alloc] initWithMemberID:self.member.memberID];
//    [arrearRequest execute];
//    self.requestCount++;
//

}


#pragma mark - init DataSource
- (void)initDataSource
{
    self.dataSourceDict = [NSMutableDictionary dictionary];

    for (NSString *title in self.topTitles) {
        if ([title isEqualToString:RECORD_TYPE_CONSUME]) {
            MemberCardConsumeDataSource *dataSource = [[MemberCardConsumeDataSource alloc] init];
            dataSource.tag = title;
            [self.dataSourceDict setObject:dataSource forKey:title];
        }
        else if ([title isEqualToString:RECORD_TYPE_OPERATE])
        {
            MemberCardOperateDataSource *dataSource = [[MemberCardOperateDataSource alloc] init];
            dataSource.tag = title;
            [self.dataSourceDict setObject:dataSource forKey:title];

        }
        else if ([title isEqualToString:RECORD_TYPE_AMOUNT])
        {
            MemberCardAmountDataSource *dataSource = [[MemberCardAmountDataSource alloc] init];
            dataSource.tag = title;
            [self.dataSourceDict setObject:dataSource forKey:title];
        }
        else if ([title isEqualToString:RECORD_TYPE_ARREAR])
        {
            MemberCardArrearDataSource *dataSource = [[MemberCardArrearDataSource alloc] init];
            dataSource.tag = title;
            [self.dataSourceDict setObject:dataSource forKey:title];
        }
        else if ([title isEqualToString:RECORD_TYPE_POINT])
        {
            MemberCardPointDataSource *dataSource = [[MemberCardPointDataSource alloc] init];
            dataSource.tag = title;
            [self.dataSourceDict setObject:dataSource forKey:title];
        }
        else if ([title isEqualToString:RECORD_TYPE_ZHUANDIAN])
        {
            MemberChangeShopDataSource *dataSource = [[MemberChangeShopDataSource alloc] init];
            dataSource.tag = title;
            [self.dataSourceDict setObject:dataSource forKey:title];
        }
        else if ([title isEqualToString:RECORD_TYPE_HULI])
        {
            MemberHuliDataSource *dataSource = [[MemberHuliDataSource alloc] init];
            dataSource.tag = title;
            [self.dataSourceDict setObject:dataSource forKey:title];
        }
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
    
    
    UIView *lastView = nil;
    
    
    CGFloat itemMarign = 30;
    CGFloat startOffset = 20;
    if (self.topTitles.count <= 3) {
        CGFloat titleWidth = 0;
        for (NSString *title in self.topTitles) {
            CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:16.0] constrainedToSize:CGSizeMake(IC_SCREEN_WIDTH, 44)];
            titleWidth += ceil(size.width);
            
            
        }
        startOffset = 1.0*(IC_SCREEN_WIDTH - titleWidth)/(self.topTitles.count + 1);
        itemMarign = startOffset;
    }
    
    
    
    
    for (int i = 0; i < self.topTitles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 101 + i;
        [btn addTarget:self action:@selector(didTopBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        btn.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
//                                           saturation:( arc4random() % 128 / 256.0 ) + 0.5
//                                           brightness:( arc4random() % 128 / 256.0 ) + 0.5
//                                                alpha:1];
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
//        btn.titleLabel.textColor = [UIColor whiteColor];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(containerView);
            if (lastView) {
                make.leading.mas_equalTo(lastView.mas_trailing).with.offset(itemMarign);
            }
            else
            {
                make.leading.mas_equalTo(containerView.mas_leading).with.offset(startOffset);
            }
        }];
        
        if (i == 0) {
            [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(containerView).offset(startOffset);
                
                make.width.equalTo(btn);
                make.height.equalTo(@2);
                make.bottom.equalTo(containerView).with.offset(-5);
            }];
        }
        
        lastView = btn;
    }
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(lastView).with.offset(startOffset);
    }];
}


- (void)didTopBtnPressed:(UIButton *)btn
{
    NSInteger idx = btn.tag - 101;
    
    [self indicateViewToIndex:idx];
    
    [self.collectionView setContentOffset:CGPointMake(self.view.frame.size.width * idx, 0) animated:YES];
}


#pragma mark - collection view
- (void) initCollectionView
{
    self.collectionView.pagingEnabled = true;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MemberRecordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MemberRecordCollectionViewCell"];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    self.requestCount--;
    if (self.requestCount == 0) {
        [[CBLoadingView shareLoadingView] hide];
        [self.collectionView reloadData];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    
//    float scrollMaxMoveX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
//    float collectionViewMaxOffsetX = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
//    
//    float radio = scrollMaxMoveX / collectionViewMaxOffsetX;
//    float scrollX = radio * self.collectionView.contentOffset.x;
//    
//    [self.scrollView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
   
    [self indicateViewToIndex:index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MemberRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberRecordCollectionViewCell" forIndexPath:indexPath];
    NSString *title = self.topTitles[indexPath.row];
    NSLog(@"%@",title);
    if ([title isEqualToString:RECORD_TYPE_CONSUME]) {
        NSArray *consumes = nil;
        if (self.type == RecordType_Card) {
            consumes = self.card.counsumes.array;
            
        }
        else
        {
            consumes = self.member.consumes.array;
        }
        if (consumes.count == 0) {
            cell.noRecordView.hidden = false;
            cell.tableView.hidden = true;
        }
        else
        {
            cell.noRecordView.hidden = true;
            cell.tableView.hidden = false;
            
            MemberCardConsumeDataSource *dataSource = [self.dataSourceDict objectForKey:title];
            //        dataSource.idx = indexPath.row;
            dataSource.consumes = consumes;
            dataSource.delegate = self;
            cell.tableView.dataSource = dataSource;
            cell.tableView.delegate = dataSource;
            [cell.tableView reloadData];
        }
    }
    else if ([title isEqualToString:RECORD_TYPE_OPERATE]) {
        NSArray *operates;
        if (self.type == RecordType_Card) {
//            operates = self.card.operates.array;
            operates = [[BSCoreDataManager currentManager] fetchCardOperatesWithCardID:self.card.cardID];
        }
        else
        {
//            operates = self.member.posOperate.array;
            operates = [[BSCoreDataManager currentManager] fetchCardOperatesWithMemberID:self.member.memberID];
        }
        
        if (operates.count == 0) {
            cell.noRecordView.hidden = false;
            cell.tableView.hidden = true;
        }
        else
        {
            cell.noRecordView.hidden = true;
            cell.tableView.hidden = false;
            
            MemberCardOperateDataSource *dataSource = [self.dataSourceDict objectForKey:title];
            //        dataSource.idx = indexPath.row;
            dataSource.delegate = self;
            dataSource.operates = operates;
            
            cell.tableView.dataSource = dataSource;
            cell.tableView.delegate = dataSource;
            [cell.tableView reloadData];
        }
    }
    else if ([title isEqualToString:RECORD_TYPE_AMOUNT]) {
        NSArray *amounts;
        if (self.type == RecordType_Card) {
            amounts = self.card.amounts.array;
            
        }
        else
        {
            amounts = self.member.amounts.array;
        }
        if (amounts.count == 0) {
            cell.noRecordView.hidden = false;
            cell.tableView.hidden = true;
        }
        else
        {
            cell.noRecordView.hidden = true;
            cell.tableView.hidden = false;
            
            MemberCardAmountDataSource *dataSource = [self.dataSourceDict objectForKey:title];
            //        dataSource.idx = indexPath.row;
            dataSource.amounts = amounts;
            dataSource.delegate = self;
            cell.tableView.dataSource = dataSource;
            cell.tableView.delegate = dataSource;
            [cell.tableView reloadData];
        }

    }
    else if ([title isEqualToString:RECORD_TYPE_ARREAR]) {
        NSArray *arrears;
        if (self.type == RecordType_Card) {
            arrears = self.card.arrears.array;
        }
        else
        {
            arrears = self.member.arrears.array;
        }
        if (arrears.count == 0) {
            cell.noRecordView.hidden = false;
            cell.tableView.hidden = true;
        }
        else
        {
            cell.noRecordView.hidden = true;
            cell.tableView.hidden = false;
            
            MemberCardArrearDataSource *dataSource = [self.dataSourceDict objectForKey:title];
            //        dataSource.idx = indexPath.row;
            dataSource.arrears = arrears;
            dataSource.delegate = self;
            cell.tableView.dataSource = dataSource;
            cell.tableView.delegate = dataSource;
            [cell.tableView reloadData];
        }
    }
    else if ([title isEqualToString:RECORD_TYPE_POINT]) {
        NSArray *points;
        if (self.type == RecordType_Card) {
            points = self.card.card_points.array;
        }
        else
        {
            points = self.member.points.array;
        }
        
        if (points.count == 0) {
            cell.noRecordView.hidden = false;
            cell.tableView.hidden = true;
        }
        else
        {
            cell.noRecordView.hidden = true;
            cell.tableView.hidden = false;
            
            MemberCardPointDataSource *dataSource = [self.dataSourceDict objectForKey:title];
            //        dataSource.idx = indexPath.row;
            dataSource.points = points;
            dataSource.delegate = self;
            cell.tableView.dataSource = dataSource;
            cell.tableView.delegate = dataSource;
            [cell.tableView reloadData];
        }
    }
    else if ([title isEqualToString:RECORD_TYPE_ZHUANDIAN])
    {
        NSArray *changeShops;
        if (self.type == RecordType_Member) {
            changeShops = self.member.changeShops.array;
        }
        if (changeShops.count == 0) {
            cell.noRecordView.hidden = false;
            cell.tableView.hidden = true;
        }
        else
        {
            cell.noRecordView.hidden = true;
            cell.tableView.hidden = false;
            
            MemberChangeShopDataSource *dataSource = [self.dataSourceDict objectForKey:title];
            //        dataSource.idx = indexPath.row;
            dataSource.changeShops = changeShops;
            dataSource.delegate = self;
            cell.tableView.dataSource = dataSource;
            cell.tableView.delegate = dataSource;
            [cell.tableView reloadData];
            
        }
        
    }
    else if ([title isEqualToString:RECORD_TYPE_HULI])
    {
        cell.noRecordView.hidden = false;
        cell.tableView.hidden = true;
        
    }
    return cell;
}


#pragma mark - MemberRecordDataSourceProtocol
- (void)didItemSelectedwithType:(NSString *)type atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray ;
    if ([type isEqualToString:RECORD_TYPE_CONSUME]) {
        
        MemberCardConsumeDataSource *dataSource = [self.dataSourceDict objectForKey:type];
        CDMemberCardConsume *consume = [dataSource.consumes objectAtIndex:indexPath.row];
        
//        [[{}],[{}]]
        sectionArray = @[@[@{@"收银单":consume.opreate_name},@{@"消耗数量":consume.consume_qty}],
                         @[@{@"单价":consume.price_unit},@{@"公开价":consume.price}],
                         @[@{@"疗程套餐名":consume.pack_product_line_name},@{@"卡扣":consume.qty},@{@"套餐内项目单价":consume.pack_price}]];

    }
    else if ([type isEqualToString:RECORD_TYPE_OPERATE])
    {
        MemberCardOperateDataSource *dataSource = [self.dataSourceDict objectForKey:type];
        CDPosOperate *operate = [dataSource.operates objectAtIndex:indexPath.row];
        
//        sectionArray = @[@[@{@"会员":operate.member_name},@{@"会员卡":operate.card_name},@{@"会员电话":operate.member_mobile},@{@"会员卡折扣方案":operate.memberCard.priceList.name},@{@"会员卡所属门店":operate.card_shop_name}],
//                         @[@{@"操作时间":operate.operate_date},@{@"操作卡的门店":operate.operate_shop_name}]
//                         ];
        MemberOperateDetailViewController *detailVC = [[MemberOperateDetailViewController alloc] init];
        detailVC.operate = operate;
        [self.navigationController pushViewController:detailVC animated:YES];
        
        return;
    }
    else if ([type isEqualToString:RECORD_TYPE_AMOUNT])
    {
        
        MemberCardAmountDataSource *dataSource = [self.dataSourceDict objectForKey:type];
        CDMemberCardAmount *amount = [dataSource.amounts objectAtIndex:indexPath.row];
        sectionArray = @[@[@{@"单据编号":amount.operate_name},@{@"类型":[[BSCoreDataManager currentManager] operateType:amount.type]},@{@"支付方式":amount.journal_name},@{@"金额":amount.amount},@{@"积分":amount.point},@{@"会员卡内金额变动":amount.card_amount}]
                         ];
    }
    
    else if ([type isEqualToString:RECORD_TYPE_ARREAR])
    {
        MemberCardArrearDataSource *dataSource = [self.dataSourceDict objectForKey:type];
        CDMemberCardArrears *arrear = [dataSource.arrears objectAtIndex:indexPath.row];
        
        NSString *type;
        
        if ([arrear.arrearsType isEqualToString:@"arrears"]) {
            type = @"充值欠款";
        }
        else if ([arrear.arrearsType isEqualToString:@"course_arrears"])
        {
            type = @"消费欠款";
        }
        
        sectionArray = @[@[@{@"收银单据":arrear.operateName},@{@"欠款标题":arrear.arrearsName},@{@"欠款金额":arrear.arrearsAmount},@{@"类型":type}],
                         @[@{@"已还金额":arrear.repaymentAmount},@{@"待还金额":arrear.unRepaymentAmount}],
                         ];
    }
    
    else if ([type isEqualToString:RECORD_TYPE_POINT])
    {
        MemberCardPointDataSource *dataSource = [self.dataSourceDict objectForKey:type];
        CDMemberCardPoint *point = [dataSource.points objectAtIndex:indexPath.row];
        sectionArray = @[@[@{@"卡编号":point.card_name},@{@"类型":[[BSCoreDataManager currentManager] operateType:point.type]},@{@"操作时间":point.create_date}],
                         @[@{@"变动前积分":point.point},@{@"变动后积分":point.exchange_point}]];
    }
    else if ([type isEqualToString:RECORD_TYPE_ZHUANDIAN])
    {
//        return;
        MemberChangeShopDataSource *dataSource = [self.dataSourceDict objectForKey:type];
        CDMemberChangeShop *changeShop = [dataSource.changeShops objectAtIndex:indexPath.row];
        sectionArray = @[@[@{@"会员":changeShop.member_name},@{@"会员卡":changeShop.card_name},@{@"原门店(会员)":changeShop.member_shop_name},@{@"原门店(卡)":changeShop.card_shop_name}],
//                         @[@{@"操作者":point.point},@{@"操作时间":point.exchange_point}],
                         @[@{@"新门店(会员)":changeShop.now_member_shop_name},@{@"新门店(卡)":changeShop.now_card_shop_name}]];
    }
    
    MemberRecordDetailViewController *detailVC = [[MemberRecordDetailViewController alloc] init];
    detailVC.sectionArray = sectionArray;
    detailVC.title = type;
    [self.navigationController pushViewController:detailVC animated:YES];
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


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}              

@end
