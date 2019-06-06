//
//  MonthCollectionViewCell.m
//  Boss
//
//  Created by lining on 15/12/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "MonthCollectionViewCell.h"
#import "UIView+Frame.h"
#import "NSDate+Formatter.h"
#define kMarginSize 10

@implementation MonthCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self = [MonthCollectionViewCell loadFromNib];
        self.backgroundColor = [UIColor whiteColor];
        
        self.width = kCell_Width;
        self.height = kCell_Height;
        
        self.bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.dayBg = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 10 - 20), 10, 20, 20)];
        self.dayBg.image = [UIImage imageNamed:@"month_today_bg.png"];
        [self addSubview:self.dayBg];
        
        self.dayLabel = [[UILabel alloc] initWithFrame:self.dayBg.frame];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont systemFontOfSize:15];
        self.dayLabel.textColor = [UIColor grayColor];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dayLabel];
        
        self.countBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.countBg.image = [UIImage imageNamed:@"month_count_bg_gray.png"];
        [self addSubview:self.countBg];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 34, 20)];
        self.countLabel.backgroundColor = [UIColor clearColor];
//        self.countLabel.font = [UIFont systemFontOfSize:13];
        self.countLabel.font = [UIFont boldSystemFontOfSize:13];
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.countLabel];
        
        self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.height - 20)/2.0, self.width, 20)];
        self.monthLabel.backgroundColor = [UIColor clearColor];
        self.monthLabel.font = [UIFont boldSystemFontOfSize:15];
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        self.monthLabel.textColor = COLOR(78, 212, 212,1);
        [self addSubview:self.monthLabel];

        
//        self.backgroundColor = COLOR(242, 239, 239, 1);
    }
    return self;
}


- (void)setDateString:(NSString *)dateString
{
    _dateString = dateString;
    self.countBg.hidden = true;
    self.dayBg.hidden = true;
    
    if (dateString == nil) {
        self.countLabel.text = @"";
        self.dayLabel.text = @"";
        self.monthLabel.text = @"";
        return;
    }
    NSDate *currentDate = [NSDate date];
    currentDate = [NSDate dateFromString:[currentDate dateStringWithFormatter:@"yyyy-MM-dd"] formatter:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateFromString:dateString formatter:@"yyyy-MM-dd"];
    
    NSArray *books = [[BSCoreDataManager currentManager] fetchBooksWithDay:dateString];

    self.dayLabel.text = [NSString stringWithFormat:@"%d",date.day];
    self.dayLabel.textColor = [UIColor grayColor];
    
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:currentDate];
    if (timeInterval == 0) {
        self.dayBg.hidden = false;
        self.dayLabel.textColor = [UIColor whiteColor];
    }
    
    if (books.count > 0) {
        self.countBg.hidden = false;
        if (timeInterval < 0) {
            self.countBg.image = [UIImage imageNamed:@"month_count_bg_gray.png"];
        }
        else
        {
            self.countBg.image = [UIImage imageNamed:@"month_count_bg_orange.png"];
        }
        self.countLabel.text = [NSString stringWithFormat:@"%d",books.count];
    }

}

@end
