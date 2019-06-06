//
//  HomeBannerTableViewCell.m
//  Boss
//
//  Created by jimmy on 15/7/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeBannerTableViewCell.h"
#import "VLabel.h"
#import "BSFetchStoreListRequest.h"
#import "CBPageCotrol.h"
#import "HomeCountData.h"
#import "UIButton+WebCache.h"

@class SAImageManager;

@interface HomeBannerTableViewCell () <VLabelDelegate, UIScrollViewDelegate>
@property(nonatomic, strong)UILabel* storeLabel;
@property(nonatomic, strong)VLabel* changeStoreLabel;
@property(nonatomic, strong)NSMutableArray* advertisementViewArray;
@property(nonatomic, strong)UIScrollView* pageScrollView;
@property(nonatomic, strong)UILabel* leftViewTitle;
@property(nonatomic, strong)UILabel* leftViewValue;
@property(nonatomic, strong)UILabel* rightViewTitle;
@property(nonatomic, strong)UILabel* rightViewValue;
@property(nonatomic, strong)CDStore* store;
@property(nonatomic, strong)CBPageCotrol *pageControl;
@property(nonatomic, strong)NSArray* advertisementArray;
@property(nonatomic, strong)NSTimer* sliderShowTimer;
@end

@implementation HomeBannerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    float ratio = IC_SCREEN_WIDTH / 320;
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_Banner_BG.png"]];
    
    self.storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 29 * ratio)];
    self.storeLabel.font = [UIFont systemFontOfSize:14];
    self.storeLabel.textColor = COLOR(76, 76, 76, 1);
    [self.contentView addSubview:self.storeLabel];
    
    CGRect frame = CGRectMake(0, 0, 100, 20);
    self.changeStoreLabel = [[VLabel alloc] initWithFrame:frame];
    self.changeStoreLabel.font = [UIFont systemFontOfSize:13];
    self.changeStoreLabel.textColor = COLOR(84, 197, 255, 1);
    self.changeStoreLabel.text = @"更改";
    self.changeStoreLabel.textAlignment = NSTextAlignmentCenter;
    self.changeStoreLabel.delegate = self;
    CGSize size = [self.changeStoreLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByCharWrapping];
    frame.size.width = size.width;
    frame.size.height = size.height;
    frame.origin.y = ( 28 * ratio - size.height ) / 2;
    self.changeStoreLabel.frame = frame;
    [self.contentView addSubview:self.changeStoreLabel];
    
//    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.storeLabel.frame.size.height, IC_SCREEN_WIDTH, 69 * ratio)];
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 69 * ratio)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.contentView addSubview:scrollView];
    self.pageScrollView = scrollView;
    
    [self initDataView];
    [self reloadScrollView];
    
    [self registerNofitificationForMainThread:kBSFetchStoreListResponse];
    [self registerNofitificationForMainThread:kFetchHomeAdvertisementResponse];
    [self registerNofitificationForMainThread:kFetchHomeCountDataResponse];
    [self registerNofitificationForMainThread:kFetchHomeTodayIncomeDetailResponse];
    [self registerNofitificationForMainThread:kFetchHomePassengerFlowDetailResponse];
    [self registerNofitificationForMainThread:kFetchHomeMyTodayIncomeDetailResponse];
    
    return self;
}

- (void)reloadScrollView
{
    [self reloadPageView];
    self.pageScrollView.contentSize = CGSizeMake(self.pageScrollView.frame.size.width * (1 + self.advertisementArray.count), self.pageScrollView.frame.size.height);
    for (UIView* v in self.advertisementViewArray )
    {
        [v removeFromSuperview];
    }
    self.advertisementViewArray = [NSMutableArray array];
    [self.advertisementArray enumerateObjectsUsingBlock:^(CDAdvertisement* ad, NSUInteger index, BOOL *stop)
    {
        UIButton* v = [UIButton buttonWithType:UIButtonTypeCustom];
        [v addTarget:self action:@selector(didAdvertisementPressed:) forControlEvents:UIControlEventTouchUpInside];
        v.tag = 888 + index;
        v.frame = CGRectMake((index+1)*self.pageScrollView.frame.size.width, 0, self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height);
        [self.pageScrollView addSubview:v];
        [self.advertisementViewArray addObject:v];
        
        CDAdvertisementItem * item = self.advertisementArray[index];
//        //workaround
//        if (item.imageName != nil)
//        {
//            [SAImageManager sharedManager].retryTimesParams[item.imageName] = @(0);
//            
//            [v setImageWithName:item.imageName tableName:@"born.carousel.item" filter:item.itemID fieldName:@"image" writeDate:item.writeDate placeholderImage:nil cacheDictionary:nil];
//        }
        [v sd_setBackgroundImageWithURL:[NSURL URLWithString:item.imageUrl] forState:UIControlStateNormal];
        v.adjustsImageWhenHighlighted = NO;
    }];

#if 0
    if ( [self.advertisement.interval integerValue] > 0 )
    {
        self.sliderShowTimer = [NSTimer scheduledTimerWithTimeInterval:[self.advertisement.interval integerValue] target:self selector:@selector(onSliderShowChanged:) userInfo:nil repeats:YES];
    }
#endif
}

- (void)onSliderShowChanged:(NSTimer*)timer
{
    
}

- (void)didAdvertisementPressed:(UIButton*)sender
{
    NSInteger index = sender.tag - 888;
    CDAdvertisementItem* item = self.advertisementArray[index];
    if ( item.linkUrl.length > 0 )
    {
        [self.delegate didAdvertisementButtonPressed:self linkUrl:item.linkUrl];
    }
}

- (void)reloadPageView
{
    self.advertisementArray = [[BSCoreDataManager currentManager] fetchItems:@"CDAdvertisementItem"];
    [self.pageControl reloadViewsWithPageCount:(1 + self.advertisementArray.count)];
}

- (void)initDataView
{
    self.advertisementArray = [[BSCoreDataManager currentManager] fetchItems:@"CDAdvertisementItem"];
    
    float ratio = IC_SCREEN_WIDTH / 320;
    
    UIImageView* dateBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_Banner_DataBG"]];
    dateBg.frame = self.pageScrollView.bounds;
    [self.pageScrollView addSubview:dateBg];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, self.pageScrollView.frame.size.width/2, self.pageScrollView.frame.size.height);
    [leftButton addTarget:self action:@selector(didLeftButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [leftButton addTarget:self action:@selector(didLeftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.pageScrollView.frame.size.width/2, 0, self.pageScrollView.frame.size.width/2, self.pageScrollView.frame.size.height);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13 * ratio];
    [rightButton addTarget:self action:@selector(didRightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pageScrollView addSubview:leftButton];
    [self.pageScrollView addSubview:rightButton];
    
    self.leftViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * ratio, leftButton.frame.size.width, 20)];
    self.leftViewTitle.textColor = COLOR(166, 166, 166, 1);
    self.leftViewTitle.font = [UIFont systemFontOfSize:13 * ratio];
    self.leftViewTitle.textAlignment = NSTextAlignmentCenter;
    [leftButton addSubview:self.leftViewTitle];
    
    self.leftViewValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 37 * ratio, leftButton.frame.size.width, 20)];
    self.leftViewValue.textColor = COLOR(67, 67, 67, 1);
    self.leftViewValue.font = [UIFont systemFontOfSize:17 * ratio];
    self.leftViewValue.textAlignment = NSTextAlignmentCenter;
    [leftButton addSubview:self.leftViewValue];
    
    self.rightViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * ratio, rightButton.frame.size.width, 20)];
    self.rightViewTitle.textColor = COLOR(166, 166, 166, 1);
    self.rightViewTitle.font = [UIFont systemFontOfSize:13 * ratio];
    self.rightViewTitle.textAlignment = NSTextAlignmentCenter;
    [rightButton addSubview:self.rightViewTitle];
    
    self.rightViewValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 37 * ratio, rightButton.frame.size.width, 20)];
    self.rightViewValue.textColor = COLOR(67, 67, 67, 1);
    self.rightViewValue.font = [UIFont systemFontOfSize:17 * ratio];
    self.rightViewValue.textAlignment = NSTextAlignmentCenter;
    [rightButton addSubview:self.rightViewValue];
    
    self.pageControl = [[CBPageCotrol alloc] initWithFrame:CGRectMake(0, self.pageScrollView.frame.size.height + self.pageScrollView.frame.origin.y, IC_SCREEN_WIDTH, 23 * ratio) withImg:[UIImage imageNamed:@"login_page_dot_n.png"] highlightImg:[UIImage imageNamed:@"login_page_dot_h.png"] numberOfPages:self.advertisementArray.count + 1];
    [self addSubview:self.pageControl];
}

- (void)reloadDataView
{
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( profile.roleOption == RoleOption_boss || profile.roleOption == RoleOption_shopManager )
    {
        self.leftViewTitle.text = @"今日总收入";
        self.rightViewTitle.text = @"今日客流量";
        self.leftViewValue.text = [NSString stringWithFormat:@"%@%.02f",@"￥",[[[HomeCountData currentData] getTodayIncome] floatValue]];
        self.rightViewValue.text = [[HomeCountData currentData] getPassengerFlow];
    }
    else
    {
        self.leftViewTitle.text = @"本月提成";
        self.rightViewTitle.text = @"今日预约";
        self.leftViewValue.text = [NSString stringWithFormat:@"%@%@",@"￥",[[HomeCountData currentData] getMyTodayIncome]];
        self.rightViewValue.text = [[HomeCountData currentData] getMyAppointmentCount];
    }
}

- (void)didLeftButtonPressed:(id)sender
{
    //self.leftViewValue.textColor = COLOR(67, 67, 67, 1);
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( profile.roleOption == RoleOption_boss || profile.roleOption == RoleOption_shopManager )
    {
        [self.delegate didTodayIncomeButtonPressed:self];
    }
    else
    {
        [self.delegate didMyTodayInComeButtonPressed:self];
    }
}

- (void)didLeftButtonTouchDown:(id)sender
{
    //self.leftViewValue.textColor = [UIColor blueColor];
}

- (void)didRightButtonPressed:(id)sender
{
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( profile.roleOption == RoleOption_boss || profile.roleOption == RoleOption_shopManager )
    {
        [self.delegate didPassengerFlowButtonPressed:self];
    }
    else
    {
        [self.delegate didMyTodayAppointmentButtonPressed:self];
    }
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ( [notification.name isEqualToString:kBSFetchStoreListResponse] )
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            [self setCurrentStoreName];
        }
    }
    else if ( [notification.name isEqualToString:kFetchHomeAdvertisementResponse] )
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            [self reloadScrollView];
        }
    }
    else if ( [notification.name isEqualToString:kFetchHomeCountDataResponse] || [notification.name isEqualToString:kFetchHomeTodayIncomeDetailResponse] || [notification.name isEqualToString:kFetchHomePassengerFlowDetailResponse] || [notification.name isEqualToString:kFetchHomeMyTodayIncomeDetailResponse] )
    {
        [self reloadDataView];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)vLabel:(VLabel *)vLabel touchesWtihTag:(NSInteger)tag
{
    [self.delegate didSettingStoreButtonPressed:self store:self.store];
}

- (void)reloadData
{
    [self setCurrentStoreName];
    [self reloadDataView];
    [self reloadScrollView];
}

- (void)setCurrentStoreName
{
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    
    self.store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:storeID forKey:@"storeID"];
    self.storeLabel.text = ( self.store.storeName.length > 0 ) ? [NSString stringWithFormat:@"当前门店:%@",self.store.storeName] : @"";
    self.changeStoreLabel.hidden = ( self.storeLabel.text.length == 0 || profile.shopIds.count < 2) ? YES : NO;
    
    CGSize size = [self.storeLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat totalLength = size.width + (self.changeStoreLabel.hidden ? 0 : self.changeStoreLabel.frame.size.width) + 6;
    CGRect frame = self.storeLabel.frame;
    frame.origin.x = (IC_SCREEN_WIDTH - totalLength)/2;
    frame.size.width = size.width;
    self.storeLabel.frame = frame;
    
    frame = self.changeStoreLabel.frame;
    frame.origin.x = self.storeLabel.frame.origin.x + self.storeLabel.frame.size.width + 6;
    self.changeStoreLabel.frame = frame;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x/IC_SCREEN_WIDTH;
    self.pageControl.currentPage = current;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int current = ceil((scrollView.contentOffset.x - IC_SCREEN_WIDTH/2.0)/IC_SCREEN_WIDTH);
    self.pageControl.currentPage = current;
}

@end
