//
//  PadBookTouchButton.m
//  Boss
//
//  Created by jimmy on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadBookTouchButton.h"

@implementation PadBookTouchButton

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    NSLog(@"%s: %@",__FUNCTION__,NSStringFromCGPoint(point));
    [self.delegate beginTouchAtPoint:point btn:self];
    isMoved = NO;
    
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isMoved = TRUE;
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    NSLog(@"%s: %@",__FUNCTION__,NSStringFromCGPoint(point));
    [self.delegate moveToPoint:point btn:self];
    
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    CGPoint point = [[touches anyObject] locationInView:self.superview];
     NSLog(@"%s: %@",__FUNCTION__,NSStringFromCGPoint(point));
    
    [self.delegate endTouchAtPoint:point btn:self];
    
    if ( !isMoved )
    {
        [super touchesEnded:touches withEvent:event];
    }
    else
    {
        self.highlighted = NO;
    }
    
    isMoved = FALSE;
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [super touchesCancelled:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self.superview];
     NSLog(@"%s: %@",__FUNCTION__,NSStringFromCGPoint(point));
    [self.delegate endTouchAtPoint:point btn:self];

    self.highlighted = NO;
    isMoved = FALSE;

}





@end
