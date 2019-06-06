//
//  NSDate+Formatter.m
//  Boss
//
//  Created by lining on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

+ (NSDate *)dateFromString:(NSString *)dateString
{
    return [self dateFromString:dateString formatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = formatter;
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

+ (int)minuteTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int minute = (int)value /60%60;
    int hour = (int)value / 3600;
    return minute + hour * 60;
}

- (NSString *)dateString
{
    return [self dateStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)dateStringWithFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = formatter;
    NSString *dateString = [dateFormat stringFromDate:self];
    return dateString;
}

#pragma mark - year、month、day & hour、minute、second
- (NSInteger)year
{
    NSInteger year;
    [self getYear:&year month:nil day:nil];
    return year;
}

- (NSInteger)month
{
    NSInteger month;
    [self getYear:nil month:&month day:nil];
    return month;
}

- (NSInteger)day
{
    NSInteger day;
    [self getYear:nil month:nil day:&day];
    return day;
}

- (NSInteger)hour
{
    NSInteger hour;
    [self getHour:&hour minute:nil second:nil];
    return hour;
}

- (NSInteger)minute
{
    NSInteger minute;
    [self getHour:nil minute:&minute second:nil];
    return minute;
}

- (NSInteger)second
{
    NSInteger second;
    [self getHour:nil minute:nil second:&second];
    return second;
}

- (void)getYear:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day
{
    [self getYear:year month:month day:day hour:nil minute:nil second:nil];
}

- (void)getHour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second
{
    [self getYear:nil month:nil day:nil hour:hour minute:minute second:second];
}

- (void)getYear:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day hour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    
    if (year) {
        *year = components.year;
    }
    
    if (month) {
        *month = components.month;
    }
    
    if (day) {
        *day = components.day;
    }
    
    if (hour) {
        *hour = components.hour;
    }
    
    if (minute) {
        *minute = components.minute;
    }
    
    if (second) {
        *second = components.second;
    }

}

#pragma mark - month

- (NSInteger)monthDaysLen
{
    return [self monthDaysLenFromDate:self];
}

- (NSInteger)monthDaysLenFromDate:(NSDate *)date
{
    NSInteger monthDayLen;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    monthDayLen = range.length;
    return monthDayLen;
}

- (NSInteger)monthFirstWeekDay
{
    return [self monthFirstWeekDayFromDate:self];
}

- (NSInteger)monthFirstWeekDayFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compontents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    compontents.day = 1;
    NSDate *firstDate = [calendar dateFromComponents:compontents];
    return [self weekDayFromDate:firstDate];
}

#pragma mark - week 

- (NSInteger)weekDay
{
    return [self weekDayFromDate:self];
}

- (NSInteger)weekDayFromDate:(NSDate *)date
{
    NSInteger weekDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekCompontents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    weekDay = weekCompontents.weekday - 1;
    if (weekDay == 0) {
        weekDay = 7;
    }
    return weekDay;
}







@end
