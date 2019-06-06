//
//  HomeHeadTabView.h
//  Boss
//
//  Created by jimmy on 15/10/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum HomeHeadTabViewTab
{
    HomeHeadTabView_Local,
    HomeHeadTabView_Guadan,
    HomeHeadTabView_History,
    HomeHeadTabView_MemberCard
}HomeHeadTabViewTab;

typedef enum HomeHeadTabViewLocalSortType
{
    HomeHeadTabViewLocalSortType_Time,
    HomeHeadTabViewLocalSortType_Price
}HomeHeadTabViewLocalSortType;

typedef enum HomeHeadTabViewHistoryType
{
    HomeHeadTabViewHistoryType_Day,
    HomeHeadTabViewHistoryType_Week,
    HomeHeadTabViewHistoryType_Month
}HomeHeadTabViewHistoryType;

typedef enum HomeHeadTabViewHistoryMonthType
{
    HomeHeadTabViewHistoryMonthType_Year,
    HomeHeadTabViewHistoryMonthType_Month
}HomeHeadTabViewHistoryMonthType;

@protocol HomeHeadTabViewDelegate <NSObject>
- (void)didHomeHeadTabViewAddPosOperateButtonPressed:(CGFloat)posY;
- (void)didCreateYimeiNewMemberButtonPressed;
- (void)didHomeHeadTabViewTimeFilterButtonPressed;
- (void)didHomeHeadTabViewPriceFilterButtonPressed;
- (void)didHomeHeadTabViewCurrentPosButtonPressed;
- (void)didHomeHeadTabViewGuadanPosButtonPressed;
- (void)didHomeHeadTabViewHistoryPosButtonPressed;
- (void)didHomeHeadTabViewMemberCardButtonPressed;
- (void)didHomeHeadTabViewTodayFilterButtonPressed;
- (void)didHomeHeadTabViewWeekFilterButtonPressed;
- (void)didHomeHeadTabViewMonthFilterButtonPressed;
- (void)didHomeHeadTabViewMonthBackButtonPressed;
- (void)didHomeHeadTableViewRefreshBtnPressed;
- (void)didHomeHeadTableViewShowDoneBtnPressed;
- (void)didHomeHeadTabViewWillSearchYimeiContent:(NSString*)content;
@end

@interface HomeHeadTabView : UIView

@property(nonatomic, weak)id<HomeHeadTabViewDelegate> delegate;
@property(nonatomic)HomeHeadTabViewTab currentHeadTab;
@property(nonatomic)HomeHeadTabViewLocalSortType localSortType;
@property(nonatomic)HomeHeadTabViewHistoryType historyType;
@property(nonatomic)HomeHeadTabViewHistoryMonthType historyMonthType;

@property(nonatomic)BOOL isShouyintai;

@property(nonatomic, strong)NSString* selectedMonthYearString;
@property(nonatomic, strong)NSNumber* selectedMonthStoreID;

@property(nonatomic, weak)IBOutlet UILabel* currentPosLabel;
@property(nonatomic, weak)IBOutlet UIButton* createPosButton;

- (void)showHistoryMonthBackView:(NSString*)title;
- (void)doAnimationFromHistoryToLocal;

- (void)setYimeiTitleLabelText:(NSString*)text;

@property(nonatomic, weak)IBOutlet UIView* yimeiBackgroundView;
@property(nonatomic, strong)NSNumber* currentWorkID;

@property(nonatomic)BOOL isDoneSelected;

- (void)reloadCreateButton;

@end
