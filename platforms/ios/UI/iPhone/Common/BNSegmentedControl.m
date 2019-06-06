//
//  BNSegmentedControl.m
//  WeiReport
//
//  Created by XiaXianBing on 14-7-21.
//
//

#import "BNSegmentedControl.h"
#import "UIImage+Resizable.h"

#define		DEFAULT_FONT_SIZE       14.0f
#define		DEFAULT_CORNER_RADIUS   0.0f
#define     DEFAULT_NORMAL_COLOR    [UIColor blackColor]
#define     DEFAULT_SELECT_COLOR    [UIColor whiteColor]

@implementation BNSegmentedControl

@synthesize delegate;
@synthesize items = _items;
@synthesize leftImageItems = _leftImageItems;
@synthesize centerImageItems = _centerImageItems;
@synthesize rightImageItems = _rightImageItems;


#pragma mark -
#pragma mark init methods

- (id)init
{
    self = [super init];
    if (self)
    {
        for (UIView *subView in [self subviews])
        {
            [subView removeFromSuperview];
        }
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        for (UIView *subView in [self subviews])
        {
            [subView removeFromSuperview];
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        for (UIView *subView in [self subviews])
        {
            [subView removeFromSuperview];
        }
    }
    
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
	if (self)
    {
		self.items = [NSMutableArray arrayWithArray:items];
        for (UIView *subView in [self subviews])
        {
            [subView removeFromSuperview];
        }
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect
{
	CGSize itemSize = CGSizeMake((rect.size.width/self.numberOfSegments), rect.size.height);
    for (int i = 0; i < self.numberOfSegments; i++)
    {
        NSString *string = (NSString *)[_items objectAtIndex:i];
        CGSize stringSize = [string sizeWithFont:_textFont];
        CGRect stringRect = CGRectMake(i * itemSize.width + (itemSize.width - stringSize.width) / 2, (itemSize.height - stringSize.height) / 2, stringSize.width, stringSize.height);
        
        NSInteger index = 0;
        UIColor *textColor = _normalFontColor;
        if (self.selectedSegmentIndex == i)
        {
            index = 1;
            textColor = _selectFontColor;
        }
        
        UIImage *segmentedImage;
        if (i == 0)
        {
            segmentedImage = (UIImage *)[_leftImageItems objectAtIndex:index];
        }
        else if (i == self.numberOfSegments - 1)
        {
            segmentedImage = (UIImage *)[_rightImageItems objectAtIndex:index];
        }
        else
        {
            segmentedImage = (UIImage *)[_centerImageItems objectAtIndex:index];
        }
        [segmentedImage drawInRect:CGRectMake(i * itemSize.width, 0.0, itemSize.width, itemSize.height)];
        [textColor setFill];
        [string drawInRect:stringRect withFont:_textFont];
    }
}

- (void)dealloc
{
    self.delegate = nil;
}


#pragma mark -
#pragma mark font && normalFontColor && selectedFontColor

- (UIFont *)textFont
{
	if (_textFont == nil)
    {
		self.textFont = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
	}
	return _textFont;
}

- (void)setFont:(UIFont *)aFont
{
	if (_textFont != aFont)
    {
        _textFont = aFont;
		[self setNeedsDisplay];
	}
}

- (UIColor *)normalFontColor
{
	if (_normalFontColor == nil)
    {
		self.normalFontColor = DEFAULT_NORMAL_COLOR;
	}
    
	return _normalFontColor;
}

- (void)setNormalFontColor:(UIColor *)aColor
{
	if (_normalFontColor != aColor)
    {
        _normalFontColor = aColor;
		[self setNeedsDisplay];
	}
}

- (UIColor *)selectFontColor
{
	if (_selectFontColor == nil)
    {
		self.selectFontColor = DEFAULT_SELECT_COLOR;
	}
    
	return _selectFontColor;
}

- (void)setSelectFontColor:(UIColor *)aColor
{
	if (_selectFontColor != aColor)
    {
        _selectFontColor = aColor;
		[self setNeedsDisplay];
	}
}


#pragma mark -
#pragma mark Override UISegmentedControl

- (NSUInteger)numberOfSegments
{
	if (!_items)
    {
		return [super numberOfSegments];
	}
    else
    {
		return _items.count;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSInteger itemIndex = floor(self.numberOfSegments * point.x / self.bounds.size.width);
    if (point.x < 0.0 || point.x > self.bounds.size.width)
    {
        return;
    }
    
    if (!self.momentary && itemIndex == self.selectedSegmentIndex)
    {
        return;
    }
    else
    {
        [self setSelectedSegmentIndex:itemIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didSelectedAtIndex:)])
        {
            [self.delegate segmentedControl:self didSelectedAtIndex:itemIndex];
        }
    }
    [self setNeedsDisplay];
}

- (void)setCurrentIndex:(NSInteger)index
{
    if ( index != self.selectedSegmentIndex )
    {
        [self setSelectedSegmentIndex:index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didSelectedAtIndex:)])
        {
            [self.delegate segmentedControl:self didSelectedAtIndex:index];
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    [_items replaceObjectAtIndex:segment withObject:title];
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment
{
    [_items replaceObjectAtIndex:segment withObject:image];
    [self setNeedsDisplay];
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    if (!segment || segment >= self.numberOfSegments)
    {
        return;
    }
    [super insertSegmentWithTitle:title atIndex:segment animated:animated];
    [_items insertObject:title atIndex:segment];
    [self setNeedsDisplay];
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    if (!segment || segment >= self.numberOfSegments)
    {
        return;
    }
    [super insertSegmentWithImage:image atIndex:segment animated:animated];
    [_items insertObject:image atIndex:segment];
    [self setNeedsDisplay];
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
    if (!segment || segment >= self.numberOfSegments)
    {
        return;
    }
    [_items removeObjectAtIndex:segment];
    [self setNeedsDisplay];
}

@end
