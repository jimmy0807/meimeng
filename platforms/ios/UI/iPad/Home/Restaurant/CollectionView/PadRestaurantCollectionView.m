//
//  PadRestaurantCollectionView.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadRestaurantCollectionView.h"
#import "UIView+SnapShot.h"

@interface UIGestureRecognizer (SAUtilities)

- (void)cancelTouch;

@end

@implementation UIGestureRecognizer (SAUtilities)

- (void)cancelTouch
{
    self.enabled = NO;
    self.enabled = YES;
}

@end

@interface PadRestaurantCollectionView ()

@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, strong) UIView *snapshot;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, assign) NSInteger autoScrollDistance;
@property (nonatomic, assign) NSInteger autoScrollThreshold;

@end


@implementation PadRestaurantCollectionView

@dynamic delegate;
@dynamic dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self prepareGestureRecognizer];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        [self prepareGestureRecognizer];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self prepareGestureRecognizer];
}

- (void)prepareGestureRecognizer
{
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressGestureRecognizer:)];
    self.longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.longPressGestureRecognizer];
}


#pragma mark -
#pragma mark UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = YES;
    if ([gestureRecognizer isEqual:self.longPressGestureRecognizer])
    {
        shouldBegin = self.isItemCanMove;
        if (self.isItemCanMove)
        {
            CGPoint touch = [gestureRecognizer locationInView:self];
            NSIndexPath *indexPath = [self indexPathForItemAtPoint:touch];
            shouldBegin = [self isValidIndexPath:indexPath];
        }
    }
    
    return shouldBegin;
}

- (void)didLongPressGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint touch = [gestureRecognizer locationInView:self];
            [self prepareForMovingItemAtTouchPoint:touch];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint touch = [gestureRecognizer locationInView:self];
            [self moveSnapshotToLocation:touch];
            [self maybeAutoScroll];
            
            if (![self isAutoScrolling])
            {
                [self moveItemToLocation:touch];
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            [self finishMovingItem];
        }
            break;
            
        default:
            [self cancelMovingIfNeeded];
            break;
    }
}

- (void)cancelMovingIfNeeded
{
    if (self.movingIndexPath != nil)
    {
        [self stopAutoScrolling];
        [self resetSnapshot];
        [self resetMovingItem];
    }
}

- (void)resetSnapshot
{
    [self.snapshot removeFromSuperview];
    self.snapshot = nil;
}

- (void)resetMovingItem
{
    NSIndexPath *indexPath = [self.movingIndexPath copy];
    
    self.movingIndexPath = nil;
    self.initialIndexPathForMoving = nil;
    PadRestaurantCollectionCell *cell = (PadRestaurantCollectionCell *)[self cellForItemAtIndexPath:indexPath];
    cell.alpha = 1.0;
}

- (void)prepareForMovingItemAtTouchPoint:(CGPoint)point
{
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    self.initialIndexPathForMoving = indexPath;
    self.movingIndexPath = indexPath;
    
    self.snapshot = [self snapshotForMovingItem];
    [self addSubview:self.snapshot];
    
    self.touchOffset = CGPointMake(self.snapshot.center.x - point.x, self.snapshot.center.y - point.y);
    [self prepareAutoScrollForSnapshot];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:willMoveItemAtIndexPath:)])
    {
        [self.delegate collectionView:self willMoveItemAtIndexPath:self.movingIndexPath];
    }
}

- (void)finishMovingItem
{
    [self stopAutoScrolling];
    PadRestaurantCollectionCell *cell = (PadRestaurantCollectionCell *)[self cellForItemAtIndexPath:self.movingIndexPath];
    CGRect finalRect = cell.frame;
    if (CGRectEqualToRect(finalRect, CGRectZero))
    {
        return ;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.snapshot.frame = finalRect;
    } completion:^(BOOL finished) {
        if ([self.initialIndexPathForMoving compare:self.movingIndexPath] != NSOrderedSame && [self.delegate respondsToSelector:@selector(collectionView:didMoveItemFromIndexPath:toIndexPath:)])
        {
            [self.delegate collectionView:self didMoveItemFromIndexPath:self.initialIndexPathForMoving toIndexPath:self.movingIndexPath];
        }
        [self resetSnapshot];
        [self resetMovingItem];
    }];
}

- (void)moveItemToLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:location];
    PadRestaurantCollectionCell *cell = (PadRestaurantCollectionCell *)[self cellForItemAtIndexPath:self.movingIndexPath];
    cell.alpha = 0.0;
    
    if (![self canMoveToIndexPath:indexPath])
    {
        return;
    }
    
    [self performBatchUpdates:^{
        [self moveItemAtIndexPath:self.movingIndexPath toIndexPath:indexPath];
        self.movingIndexPath = indexPath;
    }completion:^(BOOL finished) {
        ;
    }];
}

- (BOOL)canMoveToIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:self.movingIndexPath] == NSOrderedSame)
    {
        return NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:targetIndexPath:toIndexPath:)])
    {
        NSIndexPath *destIndexPath = [self.delegate collectionView:self targetIndexPath:self.movingIndexPath toIndexPath:indexPath];
        
        return ([indexPath compare:destIndexPath] == NSOrderedSame);
    }
    
    return YES;
}


#pragma mark -
#pragma mark IndexPath Utilities

- (BOOL)isMovingIndexPath:(NSIndexPath *)indexPath
{
    return ([indexPath compare:self.movingIndexPath] == NSOrderedSame);
}

- (BOOL)isValidIndexPath:(NSIndexPath *)indexPath
{
    PadRestaurantCollectionCell *cell = (PadRestaurantCollectionCell *)[self cellForItemAtIndexPath:indexPath];
    return (indexPath != nil && indexPath.section != NSNotFound && indexPath.row != NSNotFound && (cell.state != kPadRestaurantTableNone));
}

- (NSIndexPath *)indexPathAdaptedItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.movingIndexPath == nil)
    {
        return indexPath;
    }
    
    CGFloat adaptedItem = NSNotFound;
    NSInteger movingItemOffset = 1;
    if ([indexPath compare:self.movingIndexPath] == NSOrderedSame)
    {
        indexPath = self.initialIndexPathForMoving;
    }
    else if (self.movingIndexPath.section == self.initialIndexPathForMoving.section)
    {
        if (indexPath.item >= self.initialIndexPathForMoving.item && indexPath.item < self.movingIndexPath.item)
        {
            adaptedItem = indexPath.item + movingItemOffset;
        }
        else if (indexPath.item <= self.initialIndexPathForMoving.item && indexPath.item > self.movingIndexPath.item)
        {
            adaptedItem = indexPath.item - movingItemOffset;
        }
    }
    else if (self.movingIndexPath.section != self.initialIndexPathForMoving.section)
    {
        if (indexPath.section == self.initialIndexPathForMoving.section && indexPath.item >= self.initialIndexPathForMoving.item)
        {
            adaptedItem = indexPath.item + movingItemOffset;
        }
        else if (indexPath.section == self.movingIndexPath.section && indexPath.item > self.movingIndexPath.item)
        {
            adaptedItem = indexPath.item - movingItemOffset;
        }
    }
    
    if (adaptedItem != NSNotFound)
    {
        indexPath = [NSIndexPath indexPathForItem:adaptedItem inSection:indexPath.section];
    }
    
    return indexPath;
}


#pragma mark -
#pragma mark Snapshot Methods

- (UIView *)snapshotAtIndexPath:(NSIndexPath *)indexPath
{
    PadRestaurantCollectionCell *cell = (PadRestaurantCollectionCell *)[self cellForItemAtIndexPath:indexPath];
    
    UIView *snapshot = [cell snapshot];
    snapshot.frame = cell.frame;
    snapshot.alpha = 1.0;
    snapshot.layer.shadowRadius = 4.0;
    snapshot.layer.shadowOpacity = 0.0;
    snapshot.layer.shadowOffset = CGSizeZero;
    snapshot.layer.shadowPath = [[UIBezierPath bezierPathWithRect:snapshot.layer.bounds] CGPath];
    
    return snapshot;
}

- (UIView *)snapshotForMovingItem
{
    PadRestaurantCollectionCell *cell = (PadRestaurantCollectionCell *)[self cellForItemAtIndexPath:self.movingIndexPath];
    
    UIView *snapshot = [cell snapshot];
    snapshot.frame = cell.frame;
    snapshot.alpha = 1.0;
    snapshot.layer.shadowRadius = 4.0;
    snapshot.layer.shadowOpacity = 0.36;
    snapshot.layer.shadowOffset = CGSizeZero;
    snapshot.layer.shadowPath = [[UIBezierPath bezierPathWithRect:snapshot.layer.bounds] CGPath];
    
    return snapshot;
}

- (void)moveSnapshotToLocation:(CGPoint)point
{
    self.snapshot.center = CGPointMake(point.x + self.touchOffset.x, point.y + self.touchOffset.y);
}


#pragma mark -
#pragma mark AutoScrolling Methods

- (void)prepareAutoScrollForSnapshot
{
    self.autoScrollThreshold = CGRectGetHeight(self.snapshot.frame) * 0.6;
    self.autoScrollDistance = 0;
}

- (void)maybeAutoScroll
{
    [self determineAutoScrollDistanceForSnapshot];
    if (self.autoScrollDistance == 0)
    {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
    else if (self.autoScrollTimer == nil)
    {
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(autoScrollTimerFired:) userInfo:nil repeats:YES];
    }
}

- (void)determineAutoScrollDistanceForSnapshot
{
    self.autoScrollDistance = 0.0;
    if ([self canScroll] && CGRectIntersectsRect(self.snapshot.frame, self.bounds))
    {
        CGPoint touch = [self.longPressGestureRecognizer locationInView:self];
        touch.y += self.touchOffset.y;
        
        CGFloat distanceToTopEdge = touch.y - CGRectGetMinY(self.bounds);
        CGFloat distanceToBottomEdge = CGRectGetMaxY(self.bounds) - touch.y;
        
        if (distanceToTopEdge < self.autoScrollThreshold)
        {
            self.autoScrollDistance = [self autoScrollDistanceForProximityToEdge:distanceToTopEdge] * -1;
        }
        else if (distanceToBottomEdge < self.autoScrollThreshold)
        {
            self.autoScrollDistance = [self autoScrollDistanceForProximityToEdge:distanceToBottomEdge];
        }
    }
}

- (CGFloat)autoScrollDistanceForProximityToEdge:(CGFloat)proximity
{
    return ceilf((self.autoScrollThreshold - proximity) / 5.0);
}

- (void)autoScrollTimerFired:(NSTimer *)timer
{
    [self legalizeAutoScrollDistance];
    
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y += self.autoScrollDistance;
    self.contentOffset = contentOffset;
    
    CGRect rect = self.snapshot.frame;
    rect.origin.y += self.autoScrollDistance;
    self.snapshot.frame = rect;
    
    CGPoint touch = [self.longPressGestureRecognizer locationInView:self];
    [self moveItemToLocation:touch];
}

- (void)legalizeAutoScrollDistance
{
    CGFloat minmumLegalDistance = self.contentOffset.y * (-1.0);
    CGFloat maxmumLegalDistance = self.contentSize.height - (CGRectGetHeight(self.frame) + self.contentOffset.y);
    self.autoScrollDistance = MAX(self.autoScrollDistance, minmumLegalDistance);
    self.autoScrollDistance = MIN(self.autoScrollDistance, maxmumLegalDistance);
}

- (void)stopAutoScrolling
{
    self.autoScrollDistance = 0.0;
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

- (BOOL)isAutoScrolling
{
    return (self.autoScrollDistance != 0);
}

- (BOOL)canScroll
{
    return (CGRectGetHeight(self.frame) < self.contentSize.height);
}

-(void)dealloc
{
    ;
}

@end
