//
//  ICProgressView.m
//  BetSize
//
//  Created by jimmy on 12-10-27.
//
//

#import "ICProgressView.h"
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
								 float ovalHeight)
{
	float fw, fh;
	// If the width or height of the corner oval is zero, then it reduces to a right angle,
	// so instead of a rounded rectangle we have an ordinary one.
	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
	}
	
	//  Save the context's state so that the translate and scale can be undone with a call
	//  to CGContextRestoreGState.
	CGContextSaveGState(context);
	
	//  Translate the origin of the contex to the lower left corner of the rectangle.
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	
	//Normalize the scale of the context so that the width and height of the arcs are 1.0
	CGContextScaleCTM(context, ovalWidth, ovalHeight);
	
	// Calculate the width and height of the rectangle in the new coordinate system.
	fw = CGRectGetWidth(rect) / ovalWidth;
	fh = CGRectGetHeight(rect) / ovalHeight;
	
	// CGContextAddArcToPoint adds an arc of a circle to the context's path (creating the rounded
	// corners).  It also adds a line from the path's last point to the begining of the arc, making
	// the sides of the rectangle.
	CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
	
	// Close the path
	CGContextClosePath(context);
	
	// Restore the context's state. This removes the translation and scaling
	// but leaves the path, since the path is not part of the graphics state.
	CGContextRestoreGState(context);
}

static void fillRectWithLinearGradient(CGContextRef context, CGRect rect, CGFloat colors[], int numberOfColors, CGFloat locations[]) {
	CGContextSaveGState(context);
	
	if(!CGContextIsPathEmpty(context))
		CGContextClip(context);
	
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGPoint start = CGPointMake(0, 0);
	CGPoint end = CGPointMake(0, rect.size.height);
	
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, numberOfColors);
	CGContextDrawLinearGradient(context, gradient, end, start, 0);
	CGContextRestoreGState(context);
	
	CGColorSpaceRelease(space);
	CGGradientRelease(gradient);
}

@implementation ICProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setTintColorWithImage:(UIImage *)aIamge{
    [_tintColor release];
    _tintColor = [[UIColor colorWithPatternImage:aIamge] retain];
}
- (void) setBackGroundTintColor:(UIColor *)aColor{
    [_backgroundColor release];
    _backgroundColor = [aColor retain];
}
- (void) setBackGroundTintColorWithImage:(UIImage *)aIamge{
    [_backgroundColor release];
    _backgroundColor = [[UIColor colorWithPatternImage:aIamge] retain];
}

- (void)drawRect:(CGRect)rect
{
    if([self progressViewStyle] == UIProgressViewStyleDefault)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		//draw first white layer
		addRoundedRectToPath(ctx, rect, 4, 4);
		CGContextClip(ctx);
		
		CGContextSetRGBFillColor(ctx, 83.0/255.0,46.0/255.0, 96.0/255.0, 1);
		CGContextFillRect(ctx, rect);
		
		//draw lower gray line
		CGContextSetRGBStrokeColor(ctx, 83.0/255.0,46.0/255.0, 96.0/255.0, 1);
		CGContextSetLineWidth(ctx, 2);
		CGContextMoveToPoint(ctx, 2.2, rect.size.height);
		CGContextAddLineToPoint(ctx, rect.size.width - 2.2, rect.size.height);
		CGContextStrokePath(ctx);
		
		//fill upperhalf with light grey
		CGRect upperhalf = rect;
		upperhalf.size.height /= 1.75;
		upperhalf.origin.y = 0;
		
		CGContextSetRGBFillColor(ctx, 83.0/255.0,46.0/255.0, 96.0/255.0, 1);
		CGContextFillRect(ctx, upperhalf);
		
		//fill a part of the upper half with a somewhat darker grey
		CGRect upperhalfTop = upperhalf;
		upperhalfTop.size.height /= 2.7;
		CGContextSetRGBFillColor(ctx, 83.0/255.0,46.0/255.0, 96.0/255.0, 1);
		CGContextFillRect(ctx, upperhalfTop);
		
		//fill the progress part with our tintcolor
		//if(_tintColor == nil)
		//	_tintColor = [UIColor colorWithRed: 43.0/255.0 green: 134.0/255.0 blue: 225.0/255.0 alpha: 1];
		
		CGRect progressRect = rect;
		progressRect.size.width *= [self progress];
		
		addRoundedRectToPath(ctx, progressRect, 4, 4);
		CGContextClip(ctx);
		
		CGContextSetFillColorWithColor(ctx, [_tintColor CGColor]);
		CGContextFillRect(ctx, progressRect);
		
		progressRect.size.width -= 1.25;
		progressRect.origin.x += 0.625;
		progressRect.size.height -= 1.25;
		progressRect.origin.y += 0.625;
		
		addRoundedRectToPath(ctx, progressRect, 4, 4);
		CGContextClip(ctx);
		CGContextSetLineWidth(ctx, 1);
		CGContextSetRGBStrokeColor(ctx, 20.0/255.0, 20.0/255.0, 20.0/255.0, 0.6);
		CGContextStrokeRect(ctx, progressRect);
		/*
		//draw white linear gradient over upperhalf
		CGFloat colors[8] = {
			1, 1, 1, 0.45,
			1, 1, 1, 0.75
		};
		
		fillRectWithLinearGradient(ctx, upperhalf, colors, 2, nil);    */
         }
    else
    {
        [super drawRect: rect];
    }
}

- (void)dealloc
{
    [_tintColor release];
    [_backgroundColor release];
    [super dealloc];
}

@end
