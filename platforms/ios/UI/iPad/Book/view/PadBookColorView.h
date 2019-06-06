//
//  PadBookColorView.h
//  Boss
//
//  Created by lining on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DragDireciton) {
    DragDirecitonNone   = 0,
    DragDirecitonTop,           //= 1 << 0,
    DragDirecitonBottom,        //= 1 << 1,
    DragDirecitonLeft,          //= 1 << 2,
    DragDirecitonRight,         //= 1 << 3,
    DragDirecitonCenter,        //= 1 << 4,
};

#define VIEW_WIDTH  128
#define VIEW_HEIGHT 69
#define HEIGHT_PER  (VIEW_HEIGHT/60.0)
@class PadBookColorView;
@protocol PadBookViewDelegate<NSObject>
@optional
- (bool) intersectedOnBoundChanged:(PadBookColorView *)bookView;
- (bool) intersectedOnPositionMovedEnd:(PadBookColorView *)bookView;
- (void) onTouchMoved:(PadBookColorView *)bookView;
- (void) onDragEnd:(PadBookColorView *)bookView;
- (void) onPressed:(PadBookColorView *)bookView;
- (NSString *)changeTipsMessage:(PadBookColorView *)bookView;
@end

@interface PadBookColorView : UIControl

@property (Weak, nonatomic) id<PadBookViewDelegate>delegate;
@property (assign, nonatomic) NSInteger columnIdx;
@property (assign, nonatomic) NSInteger orignColumn;
@property(nonatomic, assign) DragDireciton direction;
@property (assign, nonatomic) bool showDragPoint;
@property(nonatomic, strong) CDBook *book;
@property(assign, nonatomic) bool dragNew;

- (instancetype) initWithCDBook:(CDBook *)book columnIdx:(NSInteger)columnIdx;

//- (instancetype) initWithCGPoint:(CGPoint) point columnIdx:(NSInteger)columnIdx;

- (void) reloadViewWithCDBook:(CDBook *)book;
//- (void) rollBack;//回到原来的位置

- (bool) intersectWithColorView:(PadBookColorView *)colorView;


- (void) touchBeganAtPoint:(CGPoint)point;
- (bool) touchMoveAtPoint:(CGPoint)point;
- (void) touchEndAtPoint:(CGPoint)point;

@end
