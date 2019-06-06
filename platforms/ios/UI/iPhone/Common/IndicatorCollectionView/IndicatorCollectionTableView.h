//
//  IndicatorCollectionTableView.h
//  Boss
//
//  Created by lining on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndicatorCollectionViewProtocol.h"

@class IndicatorCollectionTableView;
@protocol IndicatorCollectionViewDelegate <NSObject>
@optional
- (void)didSelectedIndicatorView:(IndicatorCollectionTableView *)indicatorView atIndex:(NSInteger)index;

@end



@interface IndicatorCollectionTableView : UIView
+ (instancetype) createViewFromNib;
+ (instancetype) createView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) BOOL isLoadFromNib;

@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray <id<IndicatorCollectionViewProtocol>>*indicatorViews;
@property (weak, nonatomic) id<IndicatorCollectionViewDelegate>delegate;

@property (assign, nonatomic) CGFloat topScollHeight;
@property (assign, nonatomic) CGFloat topItemMargin;
@property (assign, nonatomic) CGFloat topStartOffset;


- (instancetype) initWithTitles:(NSArray *)titles;
- (void) reloadSubViews;
- (void) reloadData;

- (void)indicateViewToIndex:(NSInteger)idx;

@end
