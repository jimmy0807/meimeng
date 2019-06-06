//
//  PadBookMainViewController.m
//  Boss
//
//  Created by jimmy on 15/11/27.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadBookMainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "PadBookSelectScrollView.h"
#import "PadBookTechnicianView.h"
#import "PadBookVerticalHourView.h"
#import "BSFetchBookRequest.h"
#import "BSFetchStaffRequest.h"
#import "CBLoadingView.h"
#import "NSDate+Formatter.h"
#import "PadBookColorView.h"
#import "PadBookMonthView.h"
#import "DrwableButton.h"
#import "PadBookFloorView.h"
#import "UIView+Frame.h"
#import "BSFetchRestaurantTableUseRequest.h"
#import "PadMemberAndCardViewController.h"
#import "PadBookPopoverDetailViewController.h"
#import "BSFetchBookScheduleLinesRequest.h"

typedef enum DateType
{
    DateType_Day,
    DateType_Month
}DateType;

@interface PadBookMainViewController ()<PadBookTechnicianViewDelegate, PadBookVerticalHourViewDelegate, PadBookSelectScrollViewDelegate,PadBookMonthViewDelegate,PadBookFloorViewDelegate>
{
    NSInteger requestCount;
    BOOL isNeedDelayToShow;
    
    
}
@property(nonatomic, weak)IBOutlet UIImageView* dateDayMonthImageView;
@property(nonatomic, weak)IBOutlet UILabel* headYearLabel;
@property(nonatomic, weak)IBOutlet UILabel* headDayMonthLabel;
@property (strong, nonatomic) IBOutlet UIView *vertionalSeperateLine;
@property(nonatomic, strong)PadBookSelectScrollView* selectDataScrollView;
@property(nonatomic, strong)PadBookTechnicianView* technicianScrollView;
@property(nonatomic, strong)PadBookVerticalHourView* timeScrollView;
@property(nonatomic, strong)PadBookMonthView *monthView;
@property(nonatomic, strong)NSString* todayString;
@property(nonatomic, strong)NSArray *technicianArray;   // 技师array
@property(nonatomic, strong)NSArray *floorArray;        //楼层array
@property(nonatomic, strong)NSArray *tableArray;        //桌子array
@property(nonatomic, strong)NSArray *bookArray;
@property(nonatomic, strong)NSDate *date;
@property(nonatomic, assign)DateType type;
@property(nonatomic, strong)CDRestaurantFloor *currentFloor;
@property(nonatomic, strong)DrwableButton *floorBtn;
@property(nonatomic, strong)PadBookFloorView *floorView;

@property (nonatomic, weak)IBOutlet UIButton* closeButton;
@end

@implementation PadBookMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.isCloseButton )
    {
        [self.closeButton setImage:[UIImage imageNamed:@"pad_navi_back_h"] forState:UIControlStateNormal];
        isNeedDelayToShow = TRUE;
    }
    
    [self forbidSwipGesture];

    [self sendRequest];
    
    [self initData];
    
    self.type = DateType_Day;

    self.date = [NSDate date];
    
    [self initScrollView];
    
    [self initWithMonthView];
    if ([PersonalProfile currentProfile].isTable.boolValue) {
        [self initFloorView];
    }
   
    
    
//    self.todayString = [NSString stringWithFormat:@"%@%@",self.headYearLabel.text,self.headDayMonthLabel.text];
    self.todayString = self.headDayMonthLabel.text;
    
    self.headYearLabel.hidden = true;
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kFetchBookResponse];
    [self registerNofitificationForMainThread:kMonthViewInitializeDone];
    
    [self registerNofitificationForMainThread:kBookLookMemberDetail];
    [self registerNofitificationForMainThread:kRefreshBookResponse];
    
    self.vertionalSeperateLine.hidden = true;
    
    [[[BSFetchBookScheduleLinesRequest alloc] init] execute];
}

- (void) sendRequest
{
    requestCount = 0;
    BSFetchBookRequest *request = [[BSFetchBookRequest alloc] init];
    [request execute];
    requestCount ++;
    
    if (![[PersonalProfile currentProfile].isTable boolValue]) {
        //[[[BSFetchStaffRequest alloc] init] execute];
        //requestCount ++;
    }
    
    
    requestCount ++; //之所以再加1 是因为有可能线程里初始化monthView的数据仍在初始化
    requestCount ++; //BSFetchBookScheduleLinesRequest;
    
    [[CBLoadingView shareLoadingView] show];
}

- (void) initData
{
//    self.tableArray = [[BSCoreDataManager currentManager] fetchAllRestaurantTable];
    if ([PersonalProfile currentProfile].isTable.boolValue) {
        self.floorArray = [[BSCoreDataManager currentManager] fetchAllRestaurantFloor];
        if (self.floorArray.count > 0) {
            self.currentFloor = self.floorArray[0];
        }
    }
    else
    {
        self.technicianArray = [[BSCoreDataManager currentManager] fetchBookStaffs];
    }
    
}

- (void)setCurrentFloor:(CDRestaurantFloor *)currentFloor
{
    _currentFloor = currentFloor;
//    self.tableArray = currentFloor.tables.allObjects;
    
    [self.floorBtn setTitle:currentFloor.floorName forState:UIControlStateNormal];
    
    self.tableArray = [[BSCoreDataManager currentManager] fetchRestaurantTableWithFloor:currentFloor];
    
    [self updateScroolView];
}

- (void) initFloorView
{
    self.floorBtn = [[DrwableButton alloc] initWithTitle:self.currentFloor.floorName font:[UIFont boldSystemFontOfSize:17] imageName:@"pad_book_arrow_down.png" selectedImageName:@"pad_book_arrow_up.png"];
    self.floorBtn.frame = CGRectMake(0, 78, 128, 72);
    [self.floorBtn setTitleColor:COLOR(96, 211, 212,1) forState:UIControlStateNormal];
    [self.floorBtn setTitleColor:COLOR(96, 211, 212,1) forState:UIControlStateSelected];
    [self.floorBtn addTarget:self action:@selector(floorBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.floorBtn];
    
    if ([[PersonalProfile currentProfile].isTable boolValue]) {
        self.floorBtn.hidden = false;
    }
    else
    {
        self.floorBtn.hidden = true;
    }
    
    //        [self initFloorView];
    
    self.floorView = [[PadBookFloorView alloc] initWithFrame:CGRectMake(0, 150, 128, 200) floors:self.floorArray];
    self.floorView.delegate = self;
    self.floorView.height = 0;
    [self.view addSubview:self.floorView];
}


- (void)initScrollView
{
    self.timeScrollView = [PadBookVerticalHourView loadFromNib];
    self.timeScrollView.frame = CGRectMake(0, 150, 128, 618);
    self.timeScrollView.delegate = self;
    [self.view addSubview:self.timeScrollView];
    
    [self updateScroolView];
}

- (void)updateScroolView
{
    [self.technicianScrollView removeFromSuperview];
    [self.selectDataScrollView removeFromSuperview];
    
    self.technicianScrollView = [PadBookTechnicianView loadFromNib];
    self.technicianScrollView.frame = CGRectMake(127, 78, 897, 72);
    self.technicianScrollView.delegate = self;
    if ([[PersonalProfile currentProfile].isTable boolValue]) {
        [self.technicianScrollView initWithTableArray:self.tableArray];
    }
    else
    {
        [self.technicianScrollView initWithTechnicianArray:self.technicianArray];
    }
    [self.view addSubview:self.technicianScrollView];
    
    [self.selectDataScrollView hidePopoverView:FALSE];
    self.selectDataScrollView = [PadBookSelectScrollView loadFromNib];
    
    self.selectDataScrollView.frame = CGRectMake(127, 150, 897, 618);
    [self.selectDataScrollView setContentSize:CGSizeMake(self.technicianScrollView.scrollView.contentSize.width, self.timeScrollView.scrollView.contentSize.height)];
    self.selectDataScrollView.bookMember = self.bookMember;
    self.selectDataScrollView.bookPhoneNumber = self.bookPhoneNumber;
    self.selectDataScrollView.delegate = self;
    if ([[PersonalProfile currentProfile].isTable boolValue]) {
        [self.selectDataScrollView initWithTableArray:self.tableArray day:[self.date dateStringWithFormatter:@"yyyy-MM-dd"]];
    }
    else
    {
        [self.selectDataScrollView initWithTechnicianArray:self.technicianArray day:[self.date dateStringWithFormatter:@"yyyy-MM-dd"]];
    }
    
    [self.view addSubview:self.selectDataScrollView];
    NSLog(@"self.date = %@",self.date);
    
    [self setDateWithDate:self.date];
    
    if ( [self.selectDataScrollView setInitBook:self.focusBook delay:isNeedDelayToShow] )
    {
        isNeedDelayToShow = FALSE;
        self.focusBook = nil;
    }
}

- (BOOL)isToday
{
    if ( self.todayString.length == 0)
    {
        return TRUE;
    }
    NSLog(@"self.todayString=%@\nself.headDayMonthLabel.text=%@",self.todayString,self.headDayMonthLabel.text);
//    return [self.todayString isEqualToString:[NSString stringWithFormat:@"%@%@",self.headYearLabel.text,self.headDayMonthLabel.text]];
    return [self.todayString isEqualToString:self.headDayMonthLabel.text];
}


- (void)setType:(DateType)type
{
    _type = type;
    if (type == DateType_Day) {
        self.headDayMonthLabel.font = [UIFont systemFontOfSize:20];
    }
    else if (type == DateType_Month)
    {
        self.headDayMonthLabel.font = [UIFont systemFontOfSize:24];
    }
}

- (void)floorBtnPressed:(DrwableButton *)btn
{
    btn.selected = !btn.selected;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.floorView.height = (self.floorView.height == 0?200:0);
    }];
    
}

#pragma mark - PadBookFloorViewDelegate
- (void)didSelectedFloor:(CDRestaurantFloor *)floor
{
    self.currentFloor = floor;
    [self floorBtnPressed:self.floorBtn];
}








#pragma mark - init month view
- (void) initWithMonthView
{
    self.monthView = [[PadBookMonthView alloc] initWithFrame:CGRectMake(0, 75, 1024, 768-75) date:self.date];
    self.monthView.delegate = self;
    self.monthView.hidden = true;
    [self.view addSubview:self.monthView];
}


 #pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBookLookMemberDetail]) {
        CDMember *member = (CDMember *)notification.object;
        PadMemberAndCardViewController *memberAndCardVC = [[PadMemberAndCardViewController alloc] initWithViewType:kPadMemberAndCardBook];
        memberAndCardVC.member = member;
        memberAndCardVC.rootNaviationVC = self.navigationController;
        [self.navigationController pushViewController:memberAndCardVC animated:YES];
    }
    else
    {
        requestCount --;
        if (requestCount <= 0)
        {
            [[CBLoadingView shareLoadingView] hide];
            [self initData];
            [self updateScroolView];
            self.focusBook = nil;
            requestCount = 100;
        }
        
        if ([notification.name isEqualToString:kRefreshBookResponse])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updateScroolView];
            });
            
            return;
        }
    }
    
}

#pragma mark - button  action
- (IBAction)didMenuButonPressed:(id)sender
{
    if ( self.isCloseButton )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

- (IBAction)didDateLeftButtonPressed:(id)sender
{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    if (self.type == DateType_Day) {
//        dateFormat.dateFormat = @"yyyy.MM.dd";
//    }
//    else
//    {
//        dateFormat.dateFormat = @"yyyy.MM";
//    }
//    NSDate* date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@%@",self.headYearLabel.text,self.headDayMonthLabel.text]];
    [[CBLoadingView shareLoadingView] show];
    NSString *formatter;
    if (self.type == DateType_Day) {
        formatter = @"yyyy年MM月dd日";
    }
    else
    {
        formatter = @"yyyy年MM月";
    }
    NSDate* date = [NSDate dateFromString:self.headDayMonthLabel.text formatter:formatter];
    if (self.type == DateType_Day) {
        self.date = [NSDate dateWithTimeInterval:-86400 sinceDate:date];
        date = self.date;
    }
    else
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        components.month = components.month - 1;
        if (components.month < 1) {
            components.month = 12;
            components.year = components.year - 1;
        }
        date = [calendar dateFromComponents:components];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setDateWithDate:date];
    });
}

- (IBAction)didDateRightButtonPressed:(id)sender
{
//    2012.09.11
    [[CBLoadingView shareLoadingView] show];
    NSString *formatter;
    if (self.type == DateType_Day) {
        formatter = @"yyyy年MM月dd日";
    }
    else
    {
        formatter = @"yyyy年MM月";
    }
    NSDate* date = [NSDate dateFromString:self.headDayMonthLabel.text formatter:formatter];
    
    if (self.type == DateType_Day) {
        date = [NSDate dateWithTimeInterval:86400 sinceDate:date];
        self.date = date;
    }
    else
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        components.month = components.month + 1;
        if (components.month > 12) {
            components.month = 1;
            components.year = components.year + 1;
        }
        date = [calendar dateFromComponents:components];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setDateWithDate:date];
    });
}

- (IBAction)didDateDayButtonPressed:(id)sender
{
    if (self.type == DateType_Day) {
        return;
    }
    self.dateDayMonthImageView.image = [UIImage imageNamed:@"Book_Day_Icon"];
    self.monthView.hidden = true;
    self.type = DateType_Day;
    [self setDateWithDate:self.date];
}

- (IBAction)didDateMonthButtonPressed:(id)sender
{
    if (self.type == DateType_Month) {
        return;
    }
    self.dateDayMonthImageView.image = [UIImage imageNamed:@"Book_Month_Icon"];
    self.type = DateType_Month;
    if (self.monthView) {
        [self.view bringSubviewToFront:self.monthView];
        self.monthView.hidden = false;
    }
    else
    {
        self.monthView = [[PadBookMonthView alloc] initWithFrame:CGRectMake(0, 75, 1024, 768-75) date:self.date];
        self.monthView.delegate = self;
        [self.view addSubview:self.monthView];
    }
    [self.monthView reloadViewWithDate:self.date];
    [self setDateWithDate:self.date];
}


- (void)setDateWithDate:(NSDate*)date
{
    if (date == nil) {
        return;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:(NSCalendarUnitDay |  NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    
//    self.headYearLabel.text = [NSString stringWithFormat:@"%d",components.year];
    if (self.type == DateType_Day) {
        self.headDayMonthLabel.text = [NSString stringWithFormat:@"%04d年%02d月%02d日",components.year,components.month,components.day];
        [self.technicianScrollView realoadTechnicianName:[NSString stringWithFormat:@"%04d-%02d-%02d",components.year,components.month,components.day]];
    }
    else
    {
        self.headDayMonthLabel.text = [NSString stringWithFormat:@"%04d年%02d月",components.year,components.month];
    }

    if (self.type == DateType_Month) {
        [self.monthView reloadViewWithDate:date animated:true];
    }
    else
    {
        //NSLog(@"%ld%ld%ld",components.year,components.month,components.day);
        
        [self.selectDataScrollView updateWithDay:[NSString stringWithFormat:@"%04d-%02d-%02d",components.year,components.month,components.day]];
        
        [self.timeScrollView updateCurrentTime:[self isToday]];
        
        [self.selectDataScrollView updateCurrentTime:[self isToday]];
    }
    [[CBLoadingView shareLoadingView] hide];
}


#pragma mark - PadBookMonthViewDelegate
- (void)didSelectedDate:(NSDate *)date
{
    self.date = date;
    [self didDateDayButtonPressed:nil];
}

- (void)didScrollToDate:(NSDate *)date
{
//    self.headYearLabel.text = [NSString stringWithFormat:@"%d",date.year];
//    self.headDayMonthLabel.text = [NSString stringWithFormat:@".%02d",date.month];
    if (self.monthView.hidden) {
        return;
    }
    self.headDayMonthLabel.text = [NSString stringWithFormat:@"%04d年%02d月",date.year,date.month];
}

#pragma mark - PadBookTechnicianViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView padBookTechnicianView:(UIView*)PadBookTechnicianView
{
    [self.selectDataScrollView resetDirection:1];
    self.selectDataScrollView.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.selectDataScrollView.scrollView.contentOffset.y);
}

#pragma mark - PadBookVerticalHourViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView PadBookVerticalHourView:(UIView*)PadBookVerticalHourView
{
    [self.selectDataScrollView resetDirection:-1];
    self.selectDataScrollView.scrollView.contentOffset = CGPointMake(self.selectDataScrollView.scrollView.contentOffset.x, scrollView.contentOffset.y);
    
}

#pragma mark - PadBookSelectScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView PadBookSelectScrollView:(UIView*)PadBookSelectScrollView
{
    if (scrollView.contentOffset.x > 0) {
        self.vertionalSeperateLine.hidden = false;
    }
    else
    {
        self.vertionalSeperateLine.hidden = true;
    }
    self.timeScrollView.scrollView.contentOffset = CGPointMake(self.timeScrollView.scrollView.contentOffset.x, scrollView.contentOffset.y);
    self.technicianScrollView.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.technicianScrollView.scrollView.contentOffset.y);
}

@end
