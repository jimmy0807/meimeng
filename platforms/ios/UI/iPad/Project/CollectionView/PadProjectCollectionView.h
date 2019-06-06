//
//  PadProjectCollectionView.h
//  Boss
//
//  Created by XiaXianBing on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PadProjectCollectionCell.h"

@class PadProjectCollectionView;
@protocol PadProjectCollectionViewDelegate <NSObject, UICollectionViewDelegate>

@optional

- (NSIndexPath *)collectionView:(PadProjectCollectionView *)collectionView targetIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(PadProjectCollectionView *)collectionView willMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(PadProjectCollectionView *)collectionView didMoveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end


@protocol PadProjectCollectionViewDataSource <NSObject, UICollectionViewDataSource>

@end

@interface PadProjectCollectionView : UICollectionView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isProjectCanMove;
@property (nonatomic, strong) NSIndexPath *movingIndexPath;
@property (nonatomic, strong) NSIndexPath *initialIndexPathForMoving;
@property (nonatomic, assign) id<PadProjectCollectionViewDelegate> delegate;
@property (nonatomic, assign) id<PadProjectCollectionViewDataSource> dataSource;

- (BOOL)isMovingIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathAdaptedItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)snapshotAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)snapshotForMovingItem;

@end
