//
//  BSDataManager.h
//  Boss
//
//  Created by jimmy on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSDataManager : NSObject

+ (NSString*)getTodaySring;
+ (void)getTodayString:(NSString**)start end:(NSString**)end;
+ (void)getWeekString:(NSString**)start end:(NSString**)end;
+ (void)getMonthString:(NSString**)start end:(NSString**)end;
+ (void)getMonthString:(NSString*)month start:(NSString**)start end:(NSString**)end;
+ (void)getTwoYearString:(NSString**)start end:(NSString**)end;

@end
