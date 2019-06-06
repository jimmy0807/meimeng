//
//  MemberFilterView.h
//  Boss
//
//  Created by lining on 16/5/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterItemView.h"
#import "FilterDefine.h"


@protocol FilterViewDelegate <NSObject>
@optional
- (void)didFilterItemViewPressed:(FilterItemView *)itemView;
- (void)didCancelFilterItemSelected:(FilterItemView *)itemView;
@end

@interface FilterView : UIView
//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *filterTitles;
@property (nonatomic, strong) id<FilterViewDelegate>delegate;
//@property (nonatomic, strong) UIView *filterView;

@end
