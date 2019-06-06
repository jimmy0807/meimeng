//
//  PadBookMonthView.h
//  Boss
//
//  Created by lining on 15/12/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMonthViewInitializeDone @"kPadBookViewInitializeDone"

@protocol PadBookMonthViewDelegate <NSObject>
@optional
- (void)didSelectedDate:(NSDate *)date;
- (void)didScrollToDate:(NSDate *)date;
@end


@interface PadBookMonthView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, Weak) id<PadBookMonthViewDelegate>delegate;

- (instancetype) initWithFrame:(CGRect)frame date:(NSDate *)date;

- (void)reloadViewWithDate:(NSDate *)date;
- (void)reloadViewWithDate:(NSDate *)date animated:(BOOL) animated;
@end
