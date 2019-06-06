//
//  VLabel.m
//  Spark
//
//  Created by jimmy on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VLabel.h"

@implementation VLabel
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setLineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail];
        //[self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [self setNumberOfLines:0];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setLineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail];
    //[self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:YES];
    [self setNumberOfLines:0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self setTextColor:[UIColor redColor]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [delegate vLabel:self touchesWtihTag:self.tag];
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGSize fontSize =[self.text sizeWithFont:self.font 
                                               forWidth:self.bounds.size.width
                                          lineBreakMode:NSLineBreakByTruncatingTail];
 
   // const float * colors = CGColorGetComponents([UIColor grayColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx,self.textColor.CGColor);
  //  CGContextSetRGBStrokeColor(ctx,100, 100, 100, 1.0f); // Format : RGBA

    CGContextSetLineWidth(ctx, 1.0f);
    NSLog(@"%f",fontSize.width);
    NSLog(@"%f",self.center.x);
    NSLog(@"%f",self.frame.origin.x);
    float fontLeft = 0;
    float fontRight = 0;
    
    if ( self.textAlignment == NSTextAlignmentLeft )
    {
        fontLeft = 0;
        fontRight = fontSize.width;
    }
    else if ( self.textAlignment == NSTextAlignmentRight )
    {
        fontLeft = self.frame.size.width - fontSize.width;
        fontRight = self.frame.size.width;
    }
    else
    {
        fontLeft = self.center.x - fontSize.width/2.0 - self.frame.origin.x;
        fontRight = self.center.x + fontSize.width/2.0 - self.frame.origin.x;
    }
    
    int div = self.showInMiddle ? 2 : 1;
    
    CGContextMoveToPoint(ctx, fontLeft, self.bounds.size.height/div);
    CGContextAddLineToPoint(ctx, fontRight, self.bounds.size.height/div);
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];   
}

- (void)dealloc
{
    [super dealloc];
}

@end
