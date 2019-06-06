//
//  BSDataManager.m
//  Boss
//
//  Created by jimmy on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSDataManager.h"
#import "NSDate+Formatter.h"

@implementation BSDataManager

+ (NSString*)getTodaySring
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];
    
    return today;
}

+ (void)getTodayString:(NSString**)start end:(NSString**)end
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];
    
    *start = [NSString stringWithFormat:@"%@ 00:00:00",today];
    *end = [NSString stringWithFormat:@"%@ 23:59:59",today];
}

+ (void)getWeekString:(NSString**)start end:(NSString**)end
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";

    *start = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-518400]];
    *end = [NSString stringWithFormat:@"%@ 23:59:59",[dateFormat stringFromDate:[NSDate date]]];
}

+ (void)getMonthString:(NSString**)start end:(NSString**)end
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM";

    NSString* month = [dateFormat stringFromDate:[NSDate date]];
    NSInteger day = [[NSDate date] monthDaysLen];
    
    *start = [NSString stringWithFormat:@"%@-01 00:00:00",month];
    *end = [NSString stringWithFormat:@"%@-%02d 23:59:59",month,day];
}

+ (void)getMonthString:(NSString*)month start:(NSString**)start end:(NSString**)end
{
    *start = [NSString stringWithFormat:@"%@-01 00:00:00",month];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM";
    NSDate* date = [dateFormat dateFromString:month];
    NSInteger day = [date monthDaysLen];
    
    *end = [NSString stringWithFormat:@"%@-%02d 23:59:59",month,day];
}

+ (void)getTwoYearString:(NSString**)start end:(NSString**)end
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    NSString* thisYear = [dateFormat stringFromDate:[calendar dateFromComponents:components]];
    components.year = components.year - 1;
    NSString* lastYear = [dateFormat stringFromDate:[calendar dateFromComponents:components]];
    *start = [NSString stringWithFormat:@"%@-01-01 00:00:00",lastYear];
    *end = [NSString stringWithFormat:@"%@-12-31 23:59:59",thisYear];
}
@end
