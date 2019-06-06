//
//  PadBookSelectScrollView.m
//  Boss
//
//  Created by jimmy on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadBookSelectScrollView.h"
#import "PadBookTouchButton.h"
#import "PadBookColorView.h"
#import "UIView+Frame.h"
#import "NSDate+Formatter.h"
#import "PadBookPopoverDetailViewController.h"
#import "BSFetchBookRequest.h"
#import "BSHandleBookRequest.h"
#import "CBMessageView.h"
#import "PadBookDefine.h"
#import "PadBookPopoverDetailViewController.h"  
#import "PadMemberAndCardViewController.h"
#import "PadBookRightContainerViewController.h"
#import "MJRefresh.h"
#import "BSFetchBookRequest.h"

#define kBtnTag 1000


@interface PadBookSelectScrollView ()<PadBookTouchButtonDelegate,PadBookViewDelegate,UIPopoverControllerDelegate,PadBookPopoverControllerDelegate>
{
    CGPoint lastContentOffset;
    int direction;
    CGPoint start_point;
    CGPoint pre_point;
    NSInteger move_count;
    
    bool tap_new;
    bool drag_new;
    PadBookColorView *dragNewBookView;
    PadBookColorView *tapNewBookView;
    PadBookColorView *currentBookView;
    PadBookColorView *newBookView;
    
    CDBook *orginBook;
    
    NSInteger curretnYear,curretnMonth,curretnDay;
}


@property(nonatomic, strong) UIImageView* currentTimeLineImageView;
@property(nonatomic, strong) NSArray *technicianArray;
@property(nonatomic, strong) NSArray *tableArray;
@property(nonatomic, strong) NSMutableDictionary *viewDictionary;
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) UIPopoverController *popoverController;
@property(nonatomic, strong) PadBookRightContainerViewController* hVc;
@property(nonatomic, strong) UIImageView *headLineImageView;

@end

@implementation PadBookSelectScrollView
- (void)initWithTechnicianArray:(NSArray*)technicianArray day:(NSString *)day
{
    self.technicianArray = technicianArray;//CDStaff数组
    [self initWithColumnCount:self.technicianArray.count day:day];
}

- (void)initWithTableArray:(NSArray *)tableArray day:(NSString *)day
{
    self.tableArray = tableArray;
    [self initWithColumnCount:self.tableArray.count day:day];
}

- (void)initWithColumnCount:(NSInteger)count day:(NSString *)day;
{
    int startTime = START_HOUR;
    int endTime = END_HOUR;
    
    self.scrollView.bounces = true;
    
    self.viewDictionary = [NSMutableDictionary dictionary];
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.scrollEnabled = true;

    self.scrollView.canCancelContentTouches = NO;
    
    
//    self.technicianArray = technicianArray;
//    
    int numCount = count;
    CGFloat lineWidth =  self.scrollView.contentSize.width;
    
    if (self.scrollView.width - VIEW_WIDTH *count > 0)
    {
        int extraCount = ceil((self.scrollView.width - VIEW_WIDTH *numCount)/VIEW_WIDTH);
      
        numCount += extraCount;
        lineWidth = self.scrollView.width + 0.5;
    }
    
    for ( int i = startTime; i < endTime; i++ )
    {
        for ( int j = 0; j < numCount; j++ )
        {
            if (j < count)
            {
                PadBookTouchButton* btn = [PadBookTouchButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake( j * VIEW_WIDTH,TOP_SPACE + (i - startTime ) * VIEW_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT);
                btn.tag = kBtnTag * j + i - startTime;
                [btn addTarget:self action:@selector(didPadBookTouchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                btn.delegate = self;
                [self.scrollView addSubview:btn];

            }
            else if (j < numCount)
            {
                UIImageView * imgView = [[UIImageView alloc] init];
                imgView.frame = CGRectMake( j * VIEW_WIDTH, (i - startTime ) * VIEW_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT);
                [self.scrollView addSubview:imgView];
            }
            
            UIImageView* bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(j * VIEW_WIDTH,TOP_SPACE + (i - startTime ) * VIEW_HEIGHT + (VIEW_HEIGHT - 1), VIEW_WIDTH, 1)];
            bottomLine.backgroundColor = GRAY_COLOR;
            [self.scrollView addSubview:bottomLine];
            
            UIImageView* rightLine = [[UIImageView alloc] initWithFrame:CGRectMake(( j + 1 ) * VIEW_WIDTH - 1,TOP_SPACE + (i - startTime ) * VIEW_HEIGHT , 1, VIEW_HEIGHT)];
            rightLine.backgroundColor = GRAY_COLOR;
           
            if (startTime == i) {
                rightLine.frame = CGRectMake(( j + 1 ) * VIEW_WIDTH - 1, -1000 , 1,TOP_SPACE + 1000 + VIEW_HEIGHT);
            }
            else if (endTime - 1 == i)
            {
                rightLine.frame = CGRectMake(( j + 1 ) * VIEW_WIDTH - 1, (i - startTime ) * VIEW_HEIGHT , 1, VIEW_HEIGHT + 1000);
            }
            
            if (j == 0)
            {
                 bottomLine.frame = CGRectMake(- 1000,TOP_SPACE + (i - startTime ) * VIEW_HEIGHT + (VIEW_HEIGHT - 1), VIEW_WIDTH + 1000, 1);
            }
            
            if (j == numCount - 1)
            {
                bottomLine.frame = CGRectMake(j * VIEW_WIDTH,TOP_SPACE + (i - startTime ) * VIEW_HEIGHT + (VIEW_HEIGHT - 1), 1000 + VIEW_WIDTH, 1);
            }
            
            [self.scrollView addSubview:rightLine];
        }
    }
    
    self.currentTimeLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1000, 0,lineWidth + 2000, 1)];
    self.currentTimeLineImageView.backgroundColor = BLUE_COLOR;
    [self.scrollView addSubview:self.currentTimeLineImageView];
    
    self.headLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1000, TOP_SPACE - 1 ,2000 + lineWidth, 1)];
    self.headLineImageView.backgroundColor = GRAY_COLOR;
    [self.scrollView addSubview:self.headLineImageView];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1000, 1, self.scrollView.contentSize.height + TOP_SPACE + BOTTOM_SPACE + 2000)];
    leftImageView.backgroundColor = GRAY_COLOR;
    [self.scrollView addSubview:leftImageView];
    
    [self registerNofitificationForMainThread:kBSCreateBookResponse];
    [self registerNofitificationForMainThread:kBSEditBookResponse];
    [self registerNofitificationForMainThread:kBSDeleteBookResponse];
    
    
    [self registerNofitificationForMainThread:kMemberNavigationBackToBook];
    [self registerNofitificationForMainThread:kBookLookMemberDetail];
    
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        BSFetchBookRequest* request = [[BSFetchBookRequest alloc] init];
        request.sendRefresh = TRUE;
        [request execute];;
    }];
//    [self updateWithDay:day];
}

- (void)setContentSize:(CGSize)contentSize
{
    CGFloat lineWidth;
    if (contentSize.width < self.scrollView.width) {
        lineWidth = self.scrollView.width;
        contentSize.width = self.scrollView.width + 0.5;
    }
    else
    {
        lineWidth = contentSize.width;
    }
    
    self.currentTimeLineImageView.frame = CGRectMake(0, 0, lineWidth, 1);
    self.headLineImageView.width = lineWidth;
    self.scrollView.contentSize = contentSize;
    
}

- (void)updateCurrentTime:(BOOL)isToday
{
    CGFloat positionY = 0;
    CGFloat offsetY = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    if ( components.hour < START_HOUR || !isToday )
    {
        self.currentTimeLineImageView.hidden = YES;
    }
    else
    {
        self.currentTimeLineImageView.hidden = NO;
        
        offsetY = components.minute * HEIGHT_PER;
        positionY = TOP_SPACE + VIEW_HEIGHT * ( components.hour - START_HOUR) + offsetY - 1;
        
        CGRect frame = self.currentTimeLineImageView.frame;
        frame.origin.y = positionY;
        self.currentTimeLineImageView.frame = frame;
    }
    if (!self.currentTimeLineImageView.hidden) {
        CGPoint offset = self.scrollView.contentOffset;
        CGFloat offsetY = self.currentTimeLineImageView.y - self.scrollView.height/5.0;
        CGFloat maxOffsetY = self.scrollView.contentSize.height - self.scrollView.height;
        if (offsetY <= 0) {
            offsetY = 0;
        }
        if (offsetY >= maxOffsetY) {
            offsetY = maxOffsetY;
        }
        
        [self.scrollView setContentOffset:CGPointMake(offset.x,offsetY) animated:NO];
    }
}

- (void)updateDataWithBookArray:(NSArray*)bookArray
{
    
}


- (void)updateWithDay:(NSString *)day
{
    self.currentDate = [NSDate dateFromString:day formatter:@"yyyy-MM-dd"];
    
    curretnYear = self.currentDate.year;
    curretnMonth = self.currentDate.month;
    curretnDay = self.currentDate.day;
    NSInteger arrayCount;
    if ([PersonalProfile currentProfile].isTable.boolValue) {
        arrayCount = self.tableArray.count;
    }
    else
    {
        arrayCount = self.technicianArray.count;
    }
    
    for ( int column = 0; column < arrayCount; column++ )
    {
        NSArray *viewArray = self.viewDictionary[@(column)];
        for (PadBookColorView *view in viewArray) {
            [view removeFromSuperview];
        }
        viewArray = nil;
        [self.viewDictionary removeObjectForKey:@(column)];
        self.viewDictionary[@(column)] = nil;
    }
    
    NSLog(@"arrayCount = %d",arrayCount);//12
    for ( int column = 0; column < arrayCount; column++ )
    {
        NSMutableArray *viewArray = [self.viewDictionary objectForKey:@(column)];
        if (viewArray == nil) {
            viewArray = [NSMutableArray array];
            [self.viewDictionary setObject:viewArray forKey:@(column)];
        }
        NSArray *books;
        if ([PersonalProfile currentProfile].isTable.boolValue)
        {
            CDRestaurantTable *table = self.tableArray[column];
            books = [[BSCoreDataManager currentManager] fetchBooksWithTable:table day:day];
        }
        else
        {
            CDStaff *staff = self.technicianArray[column];
            books = [[BSCoreDataManager currentManager] fetchBooksWithTechnician:staff day:day];
        }
        [[BSCoreDataManager currentManager] save:nil];
        //已新建books不在这儿持久化
        for (CDBook *book in books) {
            //NSLog(@"book.people_num = %@",book.people_num);
            PadBookColorView *bookView = [[PadBookColorView alloc] initWithCDBook:book columnIdx:column];
            bookView.delegate = self;
            [self.scrollView addSubview:bookView];
            [viewArray addObject:bookView];
        }
        
    }
    
    [self.scrollView.mj_header endRefreshing];
}

- (BOOL)setInitBook:(CDBook*)book delay:(BOOL)isDelay
{
    if ( !book )
    {
        return FALSE;
    }
    
    NSInteger arrayCount = 0;
    if ([PersonalProfile currentProfile].isTable.boolValue) {
        arrayCount = self.tableArray.count;
    }
    else
    {
        arrayCount = self.technicianArray.count;
    }
    for ( int column = 0; column < self.technicianArray.count; column++ )
    {
        BOOL have = false;
        if ([PersonalProfile currentProfile].isTable.boolValue) {
            CDRestaurantTable *table= self.tableArray[column];
            if ( [table.tableID integerValue] == [book.table_id integerValue] )
            {
                have = true;
            }
        }
        else
        {
            CDStaff *technician = self.technicianArray[column];
            if ( [technician.staffID integerValue] == [book.technician_id integerValue] )
            {
                have = true;
            }
        }
        if (have)
        {
            NSMutableArray *viewArray = [self.viewDictionary objectForKey:@(column)];
            for ( PadBookColorView *bookView in viewArray )
            {
                if ( bookView.book == book )
                {
                    
                    bookView.showDragPoint = TRUE;
                    
                    CGFloat offsetX = 0;
                    CGFloat offsetY = 0;
                    
                    CGFloat topX = ( self.scrollView.frame.size.width - bookView.frame.size.width ) / 2;
                    CGFloat topY = ( self.scrollView.frame.size.height - bookView.frame.size.height ) / 2;
                    
                    if ( bookView.frame.origin.y <= topY )
                    {
                        
                    }
                    else
                    {
                        CGFloat moveY = bookView.frame.origin.y - topY;
                        if ( moveY >= self.scrollView.contentSize.height - self.scrollView.frame.size.height )
                        {
                            offsetY = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
                        }
                        else
                        {
                            offsetY = moveY;
                        }
                    }
                    
                    if ( bookView.frame.origin.x <= topX )
                    {
                        
                    }
                    else
                    {
                        CGFloat moveX = bookView.frame.origin.x - topX;
                        if ( moveX >= self.scrollView.contentSize.width - self.scrollView.frame.size.width )
                        {
                            offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
                        }
                        else
                        {
                            offsetX = moveX;
                        }
                    }

                    self.scrollView.contentOffset = CGPointMake(offsetX, offsetY);
                    
                    if ( isDelay )
                    {
                        [self performSelector:@selector(onPressed:) withObject:bookView afterDelay:2];
                    }
                    else
                    {
                        [self onPressed:bookView];
                    }
                    
                    return TRUE;
                }
            }
        }
    }
    
    return FALSE;
}

- (void)resetDirection:(int)scrollDirection
{
    lastContentOffset = self.scrollView.contentOffset;;
    direction = scrollDirection;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
    lastContentOffset = scrollView.contentOffset;
    direction = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( direction == 0 )
    {
        if ( fabs(scrollView.contentOffset.x - lastContentOffset.x) > fabs(scrollView.contentOffset.y - lastContentOffset.y) )
        {
            direction = 1;
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, lastContentOffset.y);
        }
        else
        {
            direction = -1;
            scrollView.contentOffset = CGPointMake(lastContentOffset.x, scrollView.contentOffset.y);
        }
    }
    else if ( direction > 0 )
    {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, lastContentOffset.y);
    }
    else
    {
        scrollView.contentOffset = CGPointMake(lastContentOffset.x, scrollView.contentOffset.y);
    }
    
    [self.delegate scrollViewDidScroll:scrollView PadBookSelectScrollView:self];
}


#pragma mark - View Dictionary
- (void) addBookView:(PadBookColorView *)bookView
{
    NSMutableArray *viewArray = self.viewDictionary[@(bookView.columnIdx)];
    if (viewArray == nil) {
        viewArray = [NSMutableArray array];
        self.viewDictionary[@(bookView.columnIdx)] = viewArray;
    }
    [viewArray addObject:bookView];
    [self.scrollView addSubview:bookView];
}


- (void) removeBookView:(PadBookColorView *)bookView
{
    NSMutableArray *orignArray = self.viewDictionary[@(bookView.orignColumn)];
    [orignArray removeObject:bookView];
    [bookView removeFromSuperview];
}
#pragma mark - show & hide popover 
- (void) showPopoverWithBookView:(PadBookColorView *)bookView
{
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        if ( ![PersonalProfile currentProfile].access_write_reservation && [bookView.book.book_id integerValue] > 0 && bookView.book.create_uid.integerValue > 0 && ![bookView.book.create_uid isEqualToNumber:[PersonalProfile currentProfile].userID] )
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您无权修改别人创建的预约单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
        
        WeakSelf;
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"PadBookRightBoard" bundle:nil];
        self.hVc = [tableViewStoryboard instantiateInitialViewController];
        self.hVc.book = bookView.book;
        self.hVc.didConfirmButtonPressed = ^(CDBook *book) {
            if (currentBookView == newBookView)
            {
                [weakSelf doneBtnPressedWithBook:book type:PadBookType_create];
            }
            else
            {
                [weakSelf doneBtnPressedWithBook:book type:PadBookType_edit];
            }
            weakSelf.hVc.view = nil;
            [weakSelf.hVc viewWillDisappear:NO];
        };
        
        self.hVc.didCancelButtonPressed = ^(CDBook *book) {
            [weakSelf cancelBtnPressed:book];
            [weakSelf.hVc viewWillDisappear:NO];
            [weakSelf.hVc.view removeFromSuperview];
            weakSelf.hVc.view = nil;
        };
        
        self.hVc.didDeleteButtonPressed = ^(CDBook *book) {
            [weakSelf deleteYimeiBtnPressed:book];
            [weakSelf.hVc viewWillDisappear:NO];
        };
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.hVc.view];
        return;
    }

    if (!self.popoverController)
    {
        PadBookPopoverDetailViewController *padBookPopoverVC = [[PadBookPopoverDetailViewController alloc] init];
        padBookPopoverVC.book = bookView.book;
        padBookPopoverVC.bookPhoneNumber = self.bookPhoneNumber;
        padBookPopoverVC.bookMember = self.bookMember;
        padBookPopoverVC.technicians = self.technicianArray;
        padBookPopoverVC.tables = self.tableArray;
        padBookPopoverVC.delegate = self;
        if (currentBookView == newBookView)
        {
            padBookPopoverVC.type = PadBookType_create;
        }
        else
        {
            padBookPopoverVC.type = PadBookType_edit;
        }
        
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:padBookPopoverVC];
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationVC];
//        self.popoverController.popoverContentSize = CGSizeMake(400, 500);
        self.popoverController.backgroundColor = [UIColor whiteColor];
        self.popoverController.passthroughViews = @[bookView];
        self.popoverController.delegate = self;
    }
   [self.popoverController presentPopoverFromRect:bookView.bounds inView:bookView permittedArrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight animated:TRUE];
    
//    PadBookPopoverDetailViewController *padBookPopoverVC = [[PadBookPopoverDetailViewController alloc] init];
//    padBookPopoverVC.book = bookView.book;
//    [self addSubview:padBookPopoverVC.view];
}

- (void)deleteYimeiBtnPressed:(CDBook *)book
{
    if ( [book.book_id integerValue] > 0 )
    {
        BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
        request.type = HandleBookType_delete;
        [request execute];
    }
    else
    {
        [self removeBookView:currentBookView];
        [self.hVc.view removeFromSuperview];
    }
    
    currentBookView.showDragPoint = false;

}

- (void) hidePopoverView:(BOOL)animation
{
    if (self.popoverController)
    {
        [self.popoverController dismissPopoverAnimated:animation];
        self.popoverController = nil;
    }
}

#pragma mark - 判断是否相交
- (bool) otherViewIntersectedWithBookView:(PadBookColorView *)bookView
{
    NSInteger arrayCount;
    if ([PersonalProfile currentProfile].isTable.boolValue) {
        arrayCount = self.tableArray.count;
    }
    else
    {
        arrayCount = self.technicianArray.count;
    }
    
    if (bookView.columnIdx >= arrayCount) {
        NSLog(@"超出技师的界限");
        return true;
    }
    NSArray *viewArray = self.viewDictionary[@(bookView.columnIdx)];
    for (PadBookColorView *view in viewArray) {
        if (bookView != view) {
            bool intersect = [bookView intersectWithColorView:view];
            if (intersect) {
                return intersect;
            }
        }
    }
    return false;
}

#pragma mark - PadBookViewDelegate

- (bool) intersectedOnBoundChanged:(PadBookColorView *)bookView
{
    return [self otherViewIntersectedWithBookView:bookView];
}

- (bool) intersectedOnPositionMovedEnd:(PadBookColorView *)bookView
{
    return [self otherViewIntersectedWithBookView:bookView];
}

- (void)onTouchMoved:(PadBookColorView *)bookView
{
    [self hidePopoverView:TRUE];
}

- (void) onDragEnd:(PadBookColorView *)bookView
{
    NSLog(@"onDragEnd");
    currentBookView = bookView;
    if ([PersonalProfile currentProfile].isTable.boolValue) {
        CDRestaurantTable *table = [self.tableArray objectAtIndex:bookView.columnIdx];
        bookView.book.table_id = table.tableID;
        bookView.book.table_name = table.tableName;
    }
    else
    {
        CDStaff *technician = [self.technicianArray objectAtIndex:bookView.columnIdx];
        bookView.book.technician_id = technician.staffID;
        bookView.book.technician_name = technician.name;
    }
    
    CDStaff *technician = [[BSCoreDataManager currentManager] findEntity:@"CDStaff" withValue:bookView.book.technician_id forKey:@"staffID"];
    if ( [technician.book_time integerValue] > 0 )
    {
        int duration = [NSDate minuteTimeDifferenceWithStartTime:bookView.book.start_date endTime:bookView.book.end_date];
        if (duration > [technician.book_time integerValue]) {
            if (start_point.y > pre_point.y) {
                bookView.book.start_date = [self dateFromY:start_point.y - [technician.book_time integerValue] * HEIGHT_PER];
                bookView.book.end_date = [self dateFromY:start_point.y];
            }
            else
            {
                bookView.book.start_date = [self dateFromY:start_point.y];
                bookView.book.end_date = [self dateFromY:start_point.y + [technician.book_time integerValue] * HEIGHT_PER];
            }
        }
        [currentBookView reloadViewWithCDBook:bookView.book];
    }
    
    if (bookView.showDragPoint) {
        
        [self showPopoverWithBookView:bookView];
    }
    else
    {
        NSLog(@"需要发送请求");
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"start_date"] = bookView.book.start_date;
        params[@"end_date"] = bookView.book.end_date;
        params[@"technician_id"] =bookView.book.technician_id;
        
        BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:bookView.book];
        request.params = params;
        request.type = HandleBookType_edit;
        [request execute];
    }
    if (bookView.orignColumn == bookView.columnIdx) {
        return;
    }
    [self removeBookView:bookView];

    [self addBookView:bookView];
//    [self.scrollView addSubview:bookView];
    
}


- (void) onPressed:(PadBookColorView *)bookView
{
    NSLog(@"onPressed");
    currentBookView = bookView;
    if (bookView.showDragPoint)
    {
        [self showPopoverWithBookView:bookView];
        [self initOrginBookWithBook:bookView.book];
    }
    else
    {
        if ([currentBookView isEqual:newBookView])
        {
            [self removeBookView:currentBookView];
            newBookView = nil;
        }
        [self hidePopoverView:TRUE];
    }
}

- (NSString *)changeTipsMessage:(PadBookColorView *)bookView
{
    NSString *message;
    if ([PersonalProfile currentProfile].isTable.boolValue) {
        CDRestaurantTable *orginTable = [self.tableArray objectAtIndex:bookView.orignColumn];
        CDRestaurantTable *table = [self.tableArray objectAtIndex:bookView.columnIdx];
        message = [NSString stringWithFormat:@"亲，你确定将你预约的桌子由%@改为%@吗？",orginTable.tableName,table.tableName];
    }
    else
    {
        CDStaff *orginTechnician = [self.technicianArray objectAtIndex:bookView.orignColumn];
        CDStaff *technician = [self.technicianArray objectAtIndex:bookView.columnIdx];
        message = [NSString stringWithFormat:@"亲，你确定将你预约的技师由%@改为%@吗？",orginTechnician.name,technician.name];
    }
    
    return message;
}
#pragma mark - PadBookTouchButtonDelegate
- (void)didPadBookTouchButtonPressed:(PadBookTouchButton*)btn
{
    int columnIdx = btn.tag / kBtnTag;

    NSLog(@"tap new");
    btn.isSelected = true;
    CDBook *book = [[BSCoreDataManager currentManager] insertEntity:@"CDBook"];
    book.start_date = [self dateFromY:btn.y];
    book.end_date = [self dateFromY:btn.bottom];
    book.name = @"新预约";
    if ([PersonalProfile currentProfile].isTable.boolValue) {
        CDRestaurantTable *table = [self.technicianArray objectAtIndex:columnIdx];
        book.table_id = table.tableID;
        book.table_name = table.tableName;
    }
    else
    {
        CDStaff *technician = [self.technicianArray objectAtIndex:columnIdx];
        book.technician_id = technician.staffID;
        book.technician_name = technician.name;
        if ( [technician.book_time integerValue] > 0 )
        {
            NSDate* date = [NSDate dateFromString:book.start_date];
            NSDate* endDate = [date dateByAddingTimeInterval:[technician.book_time integerValue] * 60];
            book.end_date = [endDate dateString];
        }
    }
    
    tapNewBookView = [[PadBookColorView alloc] initWithCDBook:book columnIdx:columnIdx];
    tapNewBookView.delegate = self;
    tapNewBookView.showDragPoint = true;
    //重叠不算相交
    if ([self otherViewIntersectedWithBookView:tapNewBookView])
    {
        [[BSCoreDataManager currentManager] deleteObject:book];
    }
    else
    {
        //9月份预约修改之前
        //[self addBookView:tapNewBookView];
        //[self showPopoverWithBookView:tapNewBookView];
        
        //9月份预约修改
        //NSLog(@"新建预约self.viewDictionary 当前点的是第%d列 %@",columnIdx,self.viewDictionary[@(columnIdx)]);
        //当前点击的是第几列 通过viewDictionary这个字典可以获得当前列里面的ColorView(也即预约View)，columnIdxArray可能为空
        NSMutableArray *columnIdxArray = self.viewDictionary[@(columnIdx)];
        //预约colorView的originY存入一个数组
        NSMutableArray *bookColorViewYarray = [NSMutableArray array];
        
        for (PadBookColorView *bookColorView in columnIdxArray) {
            [bookColorViewYarray addObject:[NSNumber numberWithFloat:bookColorView.y]];
        }
        NSLog(@"bookColorViewYarray=%@",bookColorViewYarray);
        
        NSNumber *btnY = [NSNumber numberWithFloat:btn.y];
        NSLog(@"点击按钮的btn=%@",btnY);
        BOOL containsRet = [bookColorViewYarray containsObject:btnY];
        NSLog(@"containsRet = %d",containsRet);
        
        //这里得加一个判断条件已经存在预约View的btn无法再添加 为了让一存在预约时不能重叠添加
        //这个view上已经添加了预约
        if (containsRet) {
            //那么怎么判断当前点击的按钮所在视图 已经有预约了？
            return;
        }else{
            //NSLog(@"新建预约btn.subviews %@",btn.tag);
            [self addBookView:tapNewBookView];
            [self showPopoverWithBookView:tapNewBookView];
            NSLog(@"新建预约 未点保存 蓝色View和右边填写信息View加入");
        }

    }
    newBookView = tapNewBookView;
    currentBookView = tapNewBookView;
}

- (void)beginTouchAtPoint:(CGPoint)point btn:(PadBookTouchButton*)btn
{
//    int j = btn.tag / kBtnTag;
//    int i = btn.tag%kBtnTag+8;
//    NSLog(@"%s( %d %d )",__FUNCTION__,j,i);
    
    start_point = point;
    pre_point = point;
    move_count = 0;
    
}

- (void)moveToPoint:(CGPoint)point btn:(PadBookTouchButton*)btn
{
    move_count ++;
   
    if (fabs(point.y - pre_point.y) < 0.01 || move_count <= 4 ) {
        pre_point = point;
        return;
    }
    
    int columnIdx = btn.tag / kBtnTag;
//    int i = btn.tag%kBtnTag+8;
//    NSLog(@"%s( %d %d )",__FUNCTION__,columnIdx,i);
    CGPoint move_point = point;
    if (dragNewBookView == nil) {
        CDBook *book = [[BSCoreDataManager currentManager] insertEntity:@"CDBook"];
        if (start_point.y > move_point.y) {
            book.start_date = [self dateFromY:move_point.y];
            book.end_date = [self dateFromY:start_point.y];
        }
        else
        {
            book.start_date = [self dateFromY:start_point.y];
            book.end_date = [self dateFromY:move_point.y];
        }
        
        book.name = @"新预约";
        dragNewBookView = [[PadBookColorView alloc] initWithCDBook:book columnIdx:columnIdx];
        dragNewBookView.dragNew = true;
        dragNewBookView.delegate = self;
        if (move_point.y - start_point.y > 0) {
            dragNewBookView.direction = DragDirecitonBottom;
            NSLog(@"________DragDirecitonBottom_________");
        }
        else
        {
            dragNewBookView.direction = DragDirecitonTop;
            NSLog(@"________DragDirecitonTop_________");
        }
        dragNewBookView.showDragPoint = true;
//        [self.scrollView addSubview:dragNewBookView];
        [dragNewBookView touchBeganAtPoint:start_point];
        [self addBookView:dragNewBookView];
    }
    
    newBookView = dragNewBookView;
    [dragNewBookView touchMoveAtPoint:move_point];
}

- (void)endTouchAtPoint:(CGPoint)point btn:(PadBookTouchButton*)btn
{
//    int j = btn.tag / kBtnTag;
//    int i = btn.tag%kBtnTag+8;
//    NSLog(@"%s( %d %d )",__FUNCTION__,j,i);
    if (dragNewBookView) {
        CGPoint end_point = point;
        
        [dragNewBookView touchEndAtPoint:end_point];
        dragNewBookView = nil;
    }
}


- (NSString *)dateFromY:(CGFloat)y
{
    y = y - TOP_SPACE;
    CGFloat totalMinute = y / HEIGHT_PER;
    NSInteger hour = START_HOUR + floor(totalMinute/60);
    NSInteger other_minute = totalMinute - (hour - START_HOUR) * 60;
    NSInteger minute = floor(other_minute);
    NSInteger second = (other_minute - minute) * 60;
    if (hour == START_HOUR - 1) {
        hour = START_HOUR;
        minute = 0;
        second = 0;
    }
    if (hour == END_HOUR) {
        hour = END_HOUR - 1;
        minute = 59;
        second = 59;
    }
    NSString *date = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",self.currentDate.year,self.currentDate.month,self.currentDate.day, hour,minute,second];
    NSLog(@"date: %@",date);
    return date;
}

#pragma mark - init orgin book
- (void) initOrginBookWithBook:(CDBook *)book
{
    orginBook = [[BSCoreDataManager currentManager] insertEntity:@"CDBook"];
    orginBook.booker_name = book.booker_name;
    orginBook.telephone = book.telephone;
    orginBook.start_date = book.start_date;
    orginBook.end_date = book.end_date;
    orginBook.technician_id = book.technician_id;
    orginBook.technician_name = book.technician_name;
    orginBook.table_id = book.table_id;
    orginBook.table_name = book.table_name;
    orginBook.people_num = book.people_num;
    orginBook.product_ids = book.product_ids;
    orginBook.product_name = book.product_name;
    orginBook.mark = book.mark;
    
}

#pragma mark - UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}



- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@" did dismiss");
}

#pragma mark - PadBookPopoverControllerDelegate
- (void) cancelBtnPressed:(CDBook *)book
{
    [[BSCoreDataManager currentManager] rollback];
    currentBookView.showDragPoint = false;
    if ([currentBookView isEqual:newBookView])
    {
        [self removeBookView:currentBookView];
    }
    else
    {
        [currentBookView reloadViewWithCDBook:book];
    }
    currentBookView = nil;
    [self hidePopoverView:TRUE];
}

- (void) deleteBtnPressed:(CDBook *)book
{
    BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
    request.type = HandleBookType_delete;
    [request execute];
    
    currentBookView.showDragPoint = false;
    
    [self hidePopoverView:TRUE];
}

- (void) doneBtnPressedWithBook:(CDBook *)book type:(PadBookType)type
{
    if ( ![PersonalProfile currentProfile].access_write_reservation && [book.book_id integerValue] > 0 && book.create_uid.integerValue > 0 && ![book.create_uid isEqualToNumber:[PersonalProfile currentProfile].userID] )
    {
        [self cancelBtnPressed:book];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您无权修改别人创建的预约单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    if ( [book.state isEqualToString:@"billed"] )
    {
        [self cancelBtnPressed:book];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已开单的预约,不能更改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSArray *intersectTechBooks = [[BSCoreDataManager currentManager] fetchIntersectTechBooksWithBook:book];
    if (intersectTechBooks.count > 0)
    {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[NSString stringWithFormat:@"在%@-%@这个时间段%@已经被其它客户预约了，亲请更改预约信息",book.start_date,book.end_date,book.technician_name]];
        [messageView show];
        
        return;
    }
    
    NSArray *intersectRoomBooks = [[BSCoreDataManager currentManager] fetchIntersectRoomBooksWithBook:book];
    if (intersectRoomBooks.count > 0)
    {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[NSString stringWithFormat:@"在%@-%@这个时间段%@已经被其它客户预约了，亲请更改预约信息",book.start_date,book.end_date,book.table_name]];
        [messageView show];
        
        return;
    }
    
    currentBookView.showDragPoint = false;
    
    BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([currentBookView isEqual:newBookView])
    {
        NSLog(@"新建");
        request.type = HandleBookType_create;
//        params[@"name"] = @"新预约";
        params[@"member_name"] = book.booker_name;
        params[@"telephone"] = book.telephone;
        params[@"start_date"] = book.start_date;
        params[@"end_date"] = book.end_date;
        params[@"technician_id"] = book.technician_id;
        params[@"table_id"] = book.table_id;
        NSArray* ids = [book.product_ids componentsSeparatedByString:@","];
        NSMutableArray* sendIds = [NSMutableArray array];
        for ( NSString* ID in ids )
        {
            [sendIds addObject:[NSNumber numberWithInteger:[ID integerValue]]];
        }
        params[@"product_ids"] = @[@[@6,@(FALSE),sendIds]];
        
        params[@"description"] = book.mark;
        params[@"active"] = [NSNumber numberWithBool:TRUE];
        params[@"state"] = @"approved";
        params[@"member_id"] = book.member_id;
        
        //9月预约 新增"推荐人"
        params[@"recommend_member_phone"] = book.recommend_member_phone;
    }
    else
    {
        NSLog(@"编辑");
        request.type = HandleBookType_edit;
        if (!([book.booker_name isEqualToString:orginBook.booker_name]))
        {
            params[@"member_name"] = book.booker_name;
            params[@"member_id"] = book.member_id;
        }
        
        if (!([book.telephone isEqualToString:orginBook.telephone]))
        {
            params[@"telephone"] = book.telephone;
        }
        
        if (!([book.start_date isEqualToString:orginBook.start_date]))
        {
            params[@"start_date"] = book.start_date;
        }
        
        if (!([book.end_date isEqualToString:orginBook.end_date]))
        {
            params[@"end_date"] = book.end_date;
        }
        
        if (!([book.technician_id integerValue] == [orginBook.technician_id integerValue]))
        {
            params[@"technician_id"] = book.technician_id;
        }
        
        if (book.table_id.integerValue != orginBook.book_id.integerValue)
        {
            params[@"table_id"] = book.table_id;
        }
        
        if ( ![book.product_ids isEqualToString:orginBook.product_ids] )
        {
            NSArray* ids = [book.product_ids componentsSeparatedByString:@","];
            NSMutableArray* sendIds = [NSMutableArray array];
            for ( NSString* ID in ids )
            {
                [sendIds addObject:[NSNumber numberWithInteger:[ID integerValue]]];
            }
            params[@"product_ids"] = @[@[@6,@(FALSE),sendIds]];
        }
        
        if (!([book.mark isEqualToString:orginBook.mark]))
        {
            params[@"description"] = book.mark;
        }
        
        if ( [book.state isEqualToString:@"draft"] )
        {
            params[@"state"] = @"approved";
            book.state = @"approved";
        }
        
//        params[@"start_date"] = book.start_date;
//        params[@"end_date"] = book.end_date;
    }
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        params[@"is_partner"] = book.is_partner;
        params[@"is_anesthetic"] = book.is_anesthetic;
        params[@"is_checked"] = book.is_checked;
        if ( ![book.member_type isEqualToString:@"0"] )
        {
            params[@"member_type"] = book.member_type;
        }
        
        params[@"designers_id"] = book.designers_id;
        //params[@"employee_id"] = book.employee_id;
        params[@"designers_service_id"] = book.designers_service_id;
        params[@"director_employee_id"] = book.director_employee_id;
        params[@"doctor_id"] = book.doctor_id;
        
        //9月预约 新增"推荐人"
        params[@"recommend_member_phone"] = book.recommend_member_phone;
    }
    
    if (params.allKeys.count > 0)
    {
        request.params = params; 
        [request execute];
    }
    
    [[BSCoreDataManager currentManager] deleteObject:orginBook];
    [self hidePopoverView:TRUE];
    [currentBookView reloadViewWithCDBook:book];
    newBookView = nil;
    currentBookView = nil;
}



#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    
    if ([notification.name isEqualToString:kBookLookMemberDetail]) {
        [self hidePopoverView:NO];
        return;
    }
    
    if ([notification.name isEqualToString:kMemberNavigationBackToBook]) {
        CDMember *member = (CDMember *)notification.object;
        currentBookView.book.telephone = member.mobile;
        currentBookView.book.book_id = member.memberID;
        currentBookView.book.booker_name = member.memberName;
        [self showPopoverWithBookView:currentBookView];
        return;
    }
    
    NSDictionary *retDict = notification.userInfo;
    NSInteger ret = [[retDict stringValueForKey:@"rc"] integerValue];
    NSString *msg = [retDict stringValueForKey:@"rm"];
    if ([notification.name isEqualToString:kBSCreateBookResponse])
    {
        if (ret == 0)
        {
            NSLog(@"预约创建成功");
            NSDate *startDate = [NSDate dateFromString:currentBookView.book.start_date];
            if (!((startDate.year == curretnYear) && (startDate.month == curretnMonth) && (startDate.day == curretnDay)))
            {
                [self removeBookView:currentBookView];
            }
            else
            {
                [currentBookView reloadViewWithCDBook:currentBookView.book];
            }
        }
        else
        {
            [self removeBookView:currentBookView];
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:msg];
            [messageView show];
        }

    }
    else if ([notification.name isEqualToString:kBSEditBookResponse])
    {
        if (ret == 0) {
            NSLog(@"预约编辑成功");
        }
        else
        {
//            [currentBookView rollBack];
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:msg];
            [messageView show];
        }
        
        [[BSCoreDataManager currentManager] deleteObject:orginBook];
        [[BSCoreDataManager currentManager] save:nil];
        
        NSDate *startDate = [NSDate dateFromString:currentBookView.book.start_date];
        if (!((startDate.year == curretnYear) && (startDate.month == curretnMonth) && (startDate.day == curretnDay)))
        {
            [self removeBookView:currentBookView];
        }
        else
        {
            [currentBookView reloadViewWithCDBook:currentBookView.book];
        }
    }
    else if ([notification.name isEqualToString:kBSDeleteBookResponse])
    {
        if (ret == 0) {
            NSLog(@"删除成功");
            [self removeBookView:currentBookView];
            [self.hVc.view removeFromSuperview];
            self.hVc.view = nil;
        }
        else
        {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:msg];
            [messageView show];
        }
    }
}

#pragma mark - request & params

- (void)createBookRquest
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)editBookRequestWithParams:(NSMutableDictionary *)params
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)deleteBookRequest
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
