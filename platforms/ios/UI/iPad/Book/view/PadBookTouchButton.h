//
//  PadBookTouchButton.h
//  Boss
//
//  Created by jimmy on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PadBookTouchButton;

@protocol PadBookTouchButtonDelegate <NSObject>
- (void)beginTouchAtPoint:(CGPoint)point btn:(PadBookTouchButton*)btn;
- (void)moveToPoint:(CGPoint)point btn:(PadBookTouchButton*)btn;
- (void)endTouchAtPoint:(CGPoint)point btn:(PadBookTouchButton*)btn;
@end

@interface PadBookTouchButton : UIButton
{
    BOOL isMoved;
}

@property(nonatomic, assign)id<PadBookTouchButtonDelegate> delegate;
@property(nonatomic, assign) bool isSelected;

@end
