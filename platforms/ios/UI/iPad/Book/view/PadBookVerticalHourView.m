//
//  PadBookVerticalHourView.m
//  Boss
//
//  Created by jimmy on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadBookVerticalHourView.h"
#import "PadBookDefine.h"

#define kLableWidth     72
#define kLineX          80
#define kLineWidth      47


@interface PadBookVerticalHourView ()
@property(nonatomic, strong)UILabel* currentTimeLabel;
@property(nonatomic, strong)UIImageView* currentTimeLineImageView;
@end

@implementation PadBookVerticalHourView

- (void)awakeFromNib
{
    [super awakeFromNib];
    int startTime = START_HOUR;
    int endTime = END_HOUR;
    
    self.backgroundColor = [UIColor clearColor];
    self.scrollView.bounces = true;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, (endTime - startTime) * VIEW_HEIGHT + TOP_SPACE + BOTTOM_SPACE);
    
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 127, 1)];
    lineImageView.backgroundColor = GRAY_COLOR;
//    [self.scrollView addSubview:lineImageView];
    
    for ( int i = startTime; i <= endTime; i++ )
    {
        UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLineX,TOP_SPACE + VIEW_HEIGHT * ( i - startTime) - 1, kLineWidth, 1)];
        lineImageView.backgroundColor = GRAY_COLOR;
        [self.scrollView addSubview:lineImageView];
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , kLableWidth, 30)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = COLOR(143, 143, 143, 1);
        timeLabel.textAlignment = NSTextAlignmentRight;
        if ( i == 12 )
        {
           timeLabel.text = [NSString stringWithFormat:@"中午%d时",i];
        }
        else if ( i < 12 )
        {
            timeLabel.text = [NSString stringWithFormat:@"上午%d时",i];
        }
        else if ( i > 18 )
        {
            timeLabel.text = [NSString stringWithFormat:@"晚上%d时",i];
        }
        else
        {
            timeLabel.text = [NSString stringWithFormat:@"下午%d时",i];
        }
        timeLabel.center = CGPointMake(timeLabel.center.x, lineImageView.frame.origin.y);
        [self.scrollView addSubview:timeLabel];
    }
    
    self.currentTimeLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLineX, 0, 48, 1)];
    self.currentTimeLineImageView.backgroundColor = BLUE_COLOR;
    [self.scrollView addSubview:self.currentTimeLineImageView];
    
    self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , kLableWidth, 30)];
    self.currentTimeLabel.font = [UIFont systemFontOfSize:12];
    self.currentTimeLabel.textColor = BLUE_COLOR;
    self.currentTimeLabel.backgroundColor = [UIColor whiteColor];
    self.currentTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:self.currentTimeLabel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate scrollViewDidScroll:scrollView PadBookVerticalHourView:self];
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
        self.currentTimeLabel.hidden = YES;
    }
    else
    {
        self.currentTimeLineImageView.hidden = NO;
        self.currentTimeLabel.hidden = NO;
        
        offsetY = components.minute * HEIGHT_PER;
        positionY = TOP_SPACE + VIEW_HEIGHT * ( components.hour - START_HOUR) + offsetY - 1;
        
        CGRect frame = self.currentTimeLineImageView.frame;
        frame.origin.y = positionY;
        self.currentTimeLineImageView.frame = frame;
        
        frame = self.currentTimeLabel.frame;
        if ( offsetY <= 14 || offsetY >= ( VIEW_HEIGHT - 14 ) )
        {
            frame.size.height = 40;
        }
        else
        {
            frame.size.height = 17;
        }
        
        self.currentTimeLabel.frame = frame;
        self.currentTimeLabel.center = CGPointMake(self.currentTimeLabel.center.x, positionY);
        
        if ( components.hour == 12 )
        {
            self.currentTimeLabel.text = [NSString stringWithFormat:@"中午%d:%02d",components.hour,components.minute];
        }
        else if ( components.hour < 12 )
        {
            self.currentTimeLabel.text = [NSString stringWithFormat:@"上午%d:%02d",components.hour,components.minute];
        }
        else if ( components.hour > 18 )
        {
            self.currentTimeLabel.text = [NSString stringWithFormat:@"晚上%d:%02d",components.hour,components.minute];
        }
        else
        {
            self.currentTimeLabel.text = [NSString stringWithFormat:@"下午%d:%02d",components.hour,components.minute];
        }
    }
}

@end
