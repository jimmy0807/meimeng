//
//  NSDate+Formatter.h
//  Boss
//
//  Created by lining on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatter)

+ (NSDate *) dateFromString:(NSString *)dateString;
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;
+ (int)minuteTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

- (NSString *)dateString;
- (NSString *)dateStringWithFormatter:(NSString *)formatter;
- (NSInteger) year;
- (NSInteger) month;
- (NSInteger) day;
- (NSInteger) hour;
- (NSInteger) minute;
- (NSInteger) second;


- (void)getYear:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day;
- (void)getHour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second;
- (void)getYear:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day hour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second;


- (NSInteger) monthDaysLen;
- (NSInteger) monthFirstWeekDay;

- (NSInteger) weekDay;

@end
