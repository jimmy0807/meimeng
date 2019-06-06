//
//  PadBookVerticalHourView.h
//  Boss
//
//  Created by jimmy on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadBookVerticalHourViewDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView PadBookVerticalHourView:(UIView*)PadBookVerticalHourView;
@end

@interface PadBookVerticalHourView : UIView

@property(nonatomic, weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic, weak)id<PadBookVerticalHourViewDelegate> delegate;

- (void)updateCurrentTime:(BOOL)isToday;

@end
