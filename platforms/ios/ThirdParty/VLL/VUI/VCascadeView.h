//
//  VCascadeView.h
//  Spark2
//
//  Created by Vincent on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VCascadeView;

@protocol VCascadeViewDelegate <NSObject>

@required
- (NSInteger)cascadeViewNumberOfColumn: (VCascadeView*)cascadeView;
- (NSInteger)cascadeView: (VCascadeView*)cascadeView numberOfRowInColumn: (NSInteger)column;
- (UIView*)cascadeView: (VCascadeView*)cascadeView viewForIndexPath: (NSIndexPath*)indexPath;
- (CGFloat)cascadeView: (VCascadeView*)cascadeView heightForIndexPath: (NSIndexPath*)indexPath;
- (void)cascadeView: (VCascadeView*)cascadeView  viewInCell:(UIView*)view viewForIndexPath: (NSIndexPath*)indexPath;
@optional
- (void)cascadeView: (VCascadeView*)cascadeView didContentSizeChanged: (CGFloat)height;
- (void)cascadeViewDidScrollToEnd: (VCascadeView*)cascadeView;
- (void)cascadeViewDidScroll:(VCascadeView *)cascadeView;
@end

@interface VCascadeView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat contentSizeHeight;
}


- (void)reloadData;
- (void)reloadCellAtIndexPath: (NSIndexPath*)indexPath;
- (void)reloadCellAtIndexPath: (NSIndexPath*)indexPath animation: (UITableViewRowAnimation)animation;
- (void)insertRowAtIndexPath: (NSIndexPath*)indexPath animated: (BOOL)animated;

- (void)insertNumberOfRowsAtTail: (NSInteger)number animation: (UITableViewRowAnimation)animation;
- (void)deleteRowAtTailWithAnimation: (UITableViewRowAnimation)animation;
@property(nonatomic, assign) id<VCascadeViewDelegate> delegate;
@property(nonatomic, retain) NSMutableArray* tableViews;
@property(nonatomic, assign, readonly) CGFloat contentSizeHeight;
@property(nonatomic, assign) UIEdgeInsets  contentInset;
@property(nonatomic, assign) CGPoint contentOffset;
//@property(nonatomic, assign) CGSize contentSize;
@property(nonatomic, assign) CGFloat contentSizeOffset;

- (void)setVCascadeViewSize: (CGFloat)height;

@end
