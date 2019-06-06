//
//  SignDrawingNameView.m
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import "SignDrawingNameView.h"

@implementation DrawLine

@end

@implementation SignDrawingNameView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.nowDrawPointArray = [NSMutableArray array];
    self.finishlineArray = [NSMutableArray array];
    drawedCount = 0;
    
    self.size = 5;
    self.m_color = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.nowDrawPointArray = [NSMutableArray array];
        self.finishlineArray = [NSMutableArray array];
        drawedCount = 0;
        
        self.size = 5;
        self.m_color = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if ( self.savedImage )
    {
        [self.savedImage drawInRect:rect];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    if( [self.nowDrawPointArray count] >= 1 )
    {
        [self firstDraw:context];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( [self.delegate respondsToSelector:@selector(beginToDraw)] )
    {
        [self.delegate beginToDraw];
    }
    
    if ( [event allTouches].count > 1 )
        return;
    
    [self.nowDrawPointArray removeAllObjects];
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self.nowDrawPointArray addObject:[NSValue valueWithCGPoint:point]];
    drawedCount = 0;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( [event allTouches].count > 1 )
        return;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self.nowDrawPointArray addObject:[NSValue valueWithCGPoint:point]];
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( [event allTouches].count > 1 )
        return;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self.nowDrawPointArray addObject:[NSValue valueWithCGPoint:point]];
    
    DrawLine *TempLine = [[DrawLine alloc] init];
    TempLine.pointsArray = [NSArray arrayWithArray:self.nowDrawPointArray];
    TempLine.m_Color = self.m_color;
    TempLine.lineWidth = self.size;
    [self.finishlineArray addObject:TempLine];
    
    [self setNeedsDisplay];
    
    [self convertViewToImage];
    
    if ( [self.delegate respondsToSelector:@selector(endDraw)] )
    {
        [self.delegate endDraw];
    }
}

#pragma mark -
#pragma mark DrawLine Methods
-(void)firstDraw:(CGContextRef)Context
{
    CGContextSetStrokeColorWithColor(Context,self.m_color.CGColor);
    CGContextSetLineWidth(Context,self.size);
    if ( self.nowDrawPointArray.count == 1 )
    {
        CGPoint point1 = [[self.nowDrawPointArray objectAtIndex:0] CGPointValue];
        CGContextMoveToPoint(Context, point1.x,point1.y);
        CGContextAddLineToPoint(Context,point1.x,point1.y);
        CGContextStrokePath(Context);
        return;
    }
    
    for(int i = 0;i<[self.nowDrawPointArray count]-1;i++)
    {
        if ( i ==0)
        {
            if ( self.nowDrawPointArray.count == 1 )
            {
                CGPoint point1 = [[self.nowDrawPointArray objectAtIndex:i] CGPointValue];
                CGContextMoveToPoint(Context, point1.x,point1.y);
                CGContextAddLineToPoint(Context,point1.x,point1.y);
            }
            else
            {
                CGPoint point1 = [[self.nowDrawPointArray objectAtIndex:i] CGPointValue];
                CGPoint point2 = [[self.nowDrawPointArray objectAtIndex:i+1] CGPointValue];
                
                CGPoint middle;
                
                middle.x = point2.x - ( point2.x - point1.x ) / 2;
                middle.y = point2.y - ( point2.y - point1.y ) / 2;
                
                CGContextMoveToPoint(Context, point1.x,point1.y);
                CGContextAddLineToPoint(Context,middle.x,middle.y);
                
                lastDrawedPoint = middle;
            }
        }
        else
        {
            CGPoint point1 = [[self.nowDrawPointArray objectAtIndex:i] CGPointValue];
            CGPoint point2 = [[self.nowDrawPointArray objectAtIndex:i+1] CGPointValue];
            
            CGPoint middle;
            
            middle.x = point2.x - ( point2.x - point1.x ) / 2;
            middle.y = point2.y - ( point2.y - point1.y ) / 2;
            
            CGContextMoveToPoint(Context, lastDrawedPoint.x,lastDrawedPoint.y);
            CGContextAddQuadCurveToPoint(Context,point1.x,point1.y,middle.x,middle.y);
            
            lastDrawedPoint = middle;
        }
    }
    CGContextStrokePath(Context);
}

-(UIImage*)convertViewToImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    self.savedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return self.savedImage;
}

-(BOOL)clear
{
    [self.nowDrawPointArray removeAllObjects];
    [self.finishlineArray removeAllObjects];
    self.savedImage = nil;
    
    [self setNeedsDisplay];
    
    return TRUE;
}

@end
