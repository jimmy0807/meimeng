//
//  PadBookMonthView.m
//  Boss
//
//  Created by lining on 15/12/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadBookMonthView.h"
#import "MonthCollectionViewCell.h"
#import "UIView+Frame.h"
#import "NSDate+Formatter.h"

#define TitleLabelHeight   44
#define YearInterval 100


@interface DateItem : NSObject
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, assign) NSInteger monthDayLen;
@property(nonatomic, assign) NSInteger monthFirstWeekDay;

@end

@implementation DateItem

@end



@interface PadBookMonthView ()
{
    NSIndexPath *currentIndexPath;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) int firstWeekDay;
@property (assign, nonatomic) int monthDay;
@property (strong, nonatomic) NSMutableArray *dateItems;
@end

@implementation PadBookMonthView

- (instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.date = date;
        [self initTitleLabels];
       
//        [self initWithItemDates];
        
        [self performSelectorInBackground:@selector(initWithItemDates) withObject:self];
        
        [self initCollectionView];
        
        [self registerNofitificationForMainThread:kMonthViewInitializeDone];
        
    }
    return self;
}

- (void)reloadViewWithDate:(NSDate *)date
{
    [self reloadViewWithDate:date animated:NO];
}

- (void)reloadViewWithDate:(NSDate *)date animated:(BOOL) animated
{
    self.date = date;
    //    [self.collectionView reloadData];
    NSDate *nowDate = [NSDate date];
    int nowYear = nowDate.year;
    NSInteger section = (self.date.year - (nowYear - YearInterval)) * 12 + date.month;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section - 1];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    NSLog(@"date: ",[self.date dateString]);
    

//    self.firstWeekDay = [date monthFirstWeekDay];
//    self.monthDay = [date monthDaysLen];
}


- (void)initWithItemDates
{
    self.dateItems = [NSMutableArray array];
    NSDate *nowDate = [NSDate date];
    int nowYear = nowDate.year;
    for (int year = nowYear - YearInterval; year <= nowYear + YearInterval; year++) {
        for (int month = 1; month <= 12; month++) {
//            NSDate *date = [NSDate dateFromString:[NSString stringWithFormat:]];
            NSDate *date = [NSDate dateFromString:[NSString stringWithFormat:@"%04d-%02d",year,month] formatter:@"yyyy-MM"];

            DateItem *item = [[DateItem alloc] init];
            item.date = date;
            item.monthFirstWeekDay = [date monthFirstWeekDay];
            item.monthDayLen = [date monthDaysLen];
            
            [self.dateItems addObject:item];
        }
    }
//    [self performSelectorOnMainThread:@selector(postNotification) withObject:nil waitUntilDone:true];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMonthViewInitializeDone object:nil];
}

//- (void) postNotification
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kMonthViewInitializeDone object:nil];
//}

- (void) initTitleLabels
{
    NSArray *weeks = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    CGFloat width = self.width / weeks.count;
    for (int i = 0; i < weeks.count; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i* width, 0, width - 15, TitleLabelHeight)];
        
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = weeks[i];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TitleLabelHeight, self.width, 1)];
    lineView.backgroundColor = COLOR(242, 239, 239, 1);
    [self addSubview:lineView];
   
}

- (void) initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setItemSize:CGSizeMake(kCell_Width, kCell_Height)];
    [layout setHeaderReferenceSize:CGSizeMake(kCell_Width, 1)];
    [layout setMinimumInteritemSpacing:1.5];
    [layout setMinimumLineSpacing:1];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TitleLabelHeight + 1, self.width, self.height - TitleLabelHeight -1) collectionViewLayout:layout];
    
    self.collectionView.backgroundColor = COLOR(242, 239, 239, 1);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MonthCollectionViewCell class] forCellWithReuseIdentifier:@"MonthCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadReusableView"];
    [self addSubview:self.collectionView];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kMonthViewInitializeDone])
    {
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    DateItem *item = [self.dateItems objectAtIndex:section];
    float row = (item.monthFirstWeekDay + item.monthDayLen - 1)/7.0;
    int ceilRow = ceil(row);
    if (section + 1 < self.dateItems.count) {
        DateItem *nextItem = [self.dateItems objectAtIndex:section + 1];
        if (nextItem.monthFirstWeekDay == 1 && (ceilRow - row) == 0) {
            return (ceilRow + 1) *7;
        }
    }
    
   return ceilRow * 7;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dateItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MonthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MonthCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    
    DateItem *item = [self.dateItems objectAtIndex:section];
    if (indexPath.row + 1>= item.monthFirstWeekDay && indexPath.row + 1 < item.monthFirstWeekDay + item.monthDayLen) {
//        
//        cell.dayLabel.text = [NSString stringWithFormat:@"%d",indexPath.row - self.firstWeekDay + 2];
        cell.monthLabel.text = @"";
        if (indexPath.row + 1 == item.monthFirstWeekDay) {
            cell.monthLabel.text = [NSString stringWithFormat:@"%02d月",item.date.month];
        }
        int day = indexPath.row - item.monthFirstWeekDay + 2;
        cell.dateString = [NSString stringWithFormat:@"%04d-%02d-%02d",item.date.year, item.date.month,day];
    }
    else
    {
        cell.dateString = nil;
    }
//    cell.dayLabel.backgroundColor = [UIColor redColor];
//     NSLog(@"row: %d day:%@",indexPath.row,cell.dayLabel.text);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@",kind);
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadReusableView" forIndexPath:indexPath];

    return headView;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MonthCollectionViewCell *cell = (MonthCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.dateString) {
        
        NSDate *date = [NSDate dateFromString:cell.dateString formatter:@"yyyy-MM-dd"];
        NSLog(@"%d : %@",indexPath.row,date);
        if ([self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
            [self.delegate didSelectedDate:date];
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    offset.y = offset.y + self.collectionView.height/2.0;
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:offset];
    if (indexPath.section == currentIndexPath.section) {
        return;
    }
    else
    {
        currentIndexPath = indexPath;
        if ([self.delegate respondsToSelector:@selector(didScrollToDate:)]) {
            DateItem *item = [self.dateItems objectAtIndex:indexPath.section];
            [self.delegate didScrollToDate:item.date];
        }
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
