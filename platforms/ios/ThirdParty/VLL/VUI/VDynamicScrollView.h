//
//  VDynamicScrollView.h
//  Yunio
//
//  Created by vincent on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDynamicScrollDequeueView : UIView
- (id)initWithFrame:(CGRect)frame identifier:(NSString *)identifier;
@property(nonatomic, copy)NSString* identifier;
@end

@class VDynamicScrollView;

@protocol VDynamicScrollViewDelegate <UIScrollViewDelegate>

- (NSInteger)vDynamicScrollViewNumberOfPage:(VDynamicScrollView*)vDynamicScrollView;
- (void)vDynamicScrollViewDidScrollToIndex: (VDynamicScrollView*)vDynamicScrollView index: (NSInteger)index;
@optional
- (VDynamicScrollDequeueView*)vDynamicScrollView:(VDynamicScrollView*)vDynamicScrollView dequeueViewForIndex:(NSInteger)index;
- (UIView*) vDynamicScrollView:(VDynamicScrollView*)vDynamicScrollView viewForIndex:(NSInteger)index;
@end


@interface VDynamicScrollView : UIScrollView<UIScrollViewDelegate> {
    UIView* centerView;
    UIView* rightView;
    UIView* leftView;
    id<VDynamicScrollViewDelegate> _elDelegate;
    NSInteger pageNumber;
    NSInteger currentIndex;
    CGFloat lastOffset;
}

@property(nonatomic, assign) id<VDynamicScrollViewDelegate> delegate;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, assign, readonly) NSInteger pageNumber;

@property(nonatomic, retain, readonly) UIView* centerView;
@property(nonatomic, retain, readonly) UIView* rightView;
@property(nonatomic, retain, readonly) UIView* leftView;
-(void)reloadData;
-(void)reloadViewAtIndex:(NSInteger)index;
- (void)setCurrentIndex:(NSInteger)index scroll: (BOOL)scroll;

- (VDynamicScrollDequeueView*)dequeueViewWithIdentifier: (NSString*)identifier;

@end
