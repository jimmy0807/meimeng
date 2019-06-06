//
//  PadRestaurantCollectionView.h
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PadRestaurantCollectionCell.h"

@class PadRestaurantCollectionView;
@protocol PadRestaurantCollectionViewDelegate <NSObject, UICollectionViewDelegate>

@optional
- (NSIndexPath *)collectionView:(PadRestaurantCollectionView *)collectionView targetIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(PadRestaurantCollectionView *)collectionView willMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(PadRestaurantCollectionView *)collectionView didMoveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end

@protocol PadRestaurantCollectionViewDataSource <NSObject, UICollectionViewDataSource>

@end

@interface PadRestaurantCollectionView : UICollectionView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isItemCanMove;
@property (nonatomic, strong) NSIndexPath *movingIndexPath;
@property (nonatomic, strong) NSIndexPath *initialIndexPathForMoving;
@property (nonatomic, assign) id<PadRestaurantCollectionViewDelegate> delegate;
@property (nonatomic, assign) id<PadRestaurantCollectionViewDataSource> dataSource;

- (BOOL)isMovingIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathAdaptedItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)snapshotAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)snapshotForMovingItem;

@end
