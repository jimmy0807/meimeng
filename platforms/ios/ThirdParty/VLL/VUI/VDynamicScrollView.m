//
//  VDynamicScrollView.m
//  WeiViewIphone
//
//  Created by vincent on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VDynamicScrollView.h"
#import "VArrayDictionary.h"

@implementation VDynamicScrollDequeueView

- (id)initWithFrame:(CGRect)frame identifier:(NSString *)identifier
{
    self = [super initWithFrame: frame];
    if (self)
    {
        self.identifier = identifier;
    }
    return self;
}

- (void)dealloc
{
    self.identifier = nil;
    [super dealloc];
}

@end

@interface VDynamicScrollView ()
@property(nonatomic, retain) VArrayDictionary* arrayDicationary;
@end

@implementation VDynamicScrollView
@synthesize delegate = _elDelegate;
@synthesize currentIndex;
@synthesize pageNumber;
@synthesize centerView;
@synthesize leftView;
@synthesize rightView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super setDelegate: self];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.arrayDicationary = [[[VArrayDictionary alloc] init] autorelease];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)reloadLeftView
{
    if (currentIndex == 0) 
    {
        return;
    }
    if (rightView) 
    {
        [self removeChildView: rightView];
    }
    rightView = centerView;
    centerView = leftView;
    NSInteger loadIndex = currentIndex - 2;
    if (loadIndex < 0) 
    {
        leftView = nil;
    }
    else
    {
        leftView = [[self loadViewWithIndex: loadIndex] retain];
        leftView.center = CGPointMake((loadIndex + 0.5)* self.frame.size.width, self.frame.size.height/2); 
        [self addSubview: leftView];
    }
}

-(void)reloadRightView
{
    if (currentIndex == pageNumber - 1) 
    {
        return;
    }
    if (leftView) 
    {
        [self removeChildView: leftView];
    }
    leftView = centerView;
    centerView = rightView;
    NSInteger loadIndex = currentIndex + 2;
    if (loadIndex >= pageNumber) 
    {
        rightView = nil;
    }
    else
    {
        rightView = [[self loadViewWithIndex: loadIndex] retain];
        rightView.center = CGPointMake((loadIndex + 0.5)* self.frame.size.width, self.frame.size.height/2); 
        [self addSubview: rightView];
    }
}

-(void)reloadAllViews:(NSInteger)index
{
    if (leftView) 
    {
        [self removeChildView: leftView];
        leftView = nil;
    }
    if (rightView) 
    {
        [self removeChildView: rightView];
        rightView = nil;
    }
    if (centerView) 
    {
        [self removeChildView: centerView];
        centerView = nil;   
    }
    NSInteger leftIndex = index - 1;
    if (leftIndex >= 0) 
    {
        leftView = [[self loadViewWithIndex: leftIndex] retain];
        leftView.center = CGPointMake((leftIndex + 0.5)* self.frame.size.width, self.frame.size.height/2);
    }
    centerView = [[self loadViewWithIndex: index] retain];
    centerView.center = CGPointMake((index + 0.5)* self.frame.size.width, self.frame.size.height/2);
    NSInteger rightIndex = index + 1;
    if (rightIndex < pageNumber) 
    {
        rightView = [[self loadViewWithIndex: rightIndex] retain];
        rightView.center = CGPointMake((rightIndex + 0.5)* self.frame.size.width, self.frame.size.height/2);
    }
    [self addSubview: leftView];
    [self addSubview: centerView];
    [self addSubview: rightView];
}

-(void)reloadViews:(NSInteger)index
{
    if (index < 0 || index >= pageNumber) {
        return;
    }
    if (index - currentIndex > 1 || index - currentIndex < -1 || index - currentIndex == 0) {
        [self reloadAllViews: index];
    } else if (currentIndex - index == 1 ) {
        [self reloadLeftView];
    } else {
        [self reloadRightView];
    }
    currentIndex = index;
}

-(void)reloadData
{
    pageNumber = [self.delegate vDynamicScrollViewNumberOfPage: self];
    if (pageNumber == 0) {
        return;
    }
    if (currentIndex >= pageNumber) 
    {
        currentIndex = pageNumber - 1;
    }
    self.contentSize = CGSizeMake(self.frame.size.width * pageNumber, self.frame.size.height);
    if (self.contentOffset.x != currentIndex * self.frame.size.width) 
    {
        NSLog(@"currentIndex = %d", currentIndex);
        [self setContentOffset:CGPointMake(currentIndex * self.frame.size.width, 0)];
    }
    [self reloadAllViews: currentIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float width = scrollView.frame.size.width;
    float offset = scrollView.contentOffset.x;
    NSInteger index;
    if ( offset > lastOffset )
    {
        index = offset / width;
    }
    else
    {
        index = ceil(offset / width);
    }
    
    if (index >= pageNumber)
    {
        return;
    }
    /*
    if (currentIndex > scrollView.contentOffset.x) 
    {
        index = ceil((offset + scrollView.frame.size.width/2) / width);
    }*/
    if (currentIndex != index && index < pageNumber) 
    {
        NSLog(@"currentIndex: %d, index: %d", currentIndex, index);
        [self reloadViews: index];
        if ([self.delegate respondsToSelector: @selector(vDynamicScrollViewDidScrollToIndex:index:)]) 
        {
            [self.delegate vDynamicScrollViewDidScrollToIndex: self index: index];
        }
    }

    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) 
    {
        [self.delegate scrollViewDidScroll: self];
    }
    currentIndex = index;
    lastOffset = scrollView.contentOffset.x;
}

- (BOOL)respondsToSelector:(SEL)selector 
{
    if ([super respondsToSelector: selector]) 
    {
        return  YES;
    } 
    if ([self.delegate respondsToSelector: selector]) 
    {
        return  YES;
    }
    return NO;
}

- (void)setCurrentIndex:(NSInteger)index
{
    [self setCurrentIndex:index scroll:NO];
}

- (void)setCurrentIndex:(NSInteger)index scroll: (BOOL)scroll
{
    //currentIndex = index;
    if (scroll) 
    {
       
         [self setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:YES];
    }
    else
    {
        [self setContentOffset: CGPointMake(index * self.frame.size.width, 0)];
    }
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.delegate respondsToSelector: aSelector]) 
    {
        return self.delegate;
    }
    return nil;
}

- (void)dealloc
{
    [centerView release];
    [leftView release];
    [rightView release];
    self.arrayDicationary = nil;
    [super dealloc];
}

- (VDynamicScrollDequeueView*)dequeueViewWithIdentifier: (NSString*)identifier
{
    return [self.arrayDicationary popObjectForKey: identifier];
}

- (UIView*)loadViewWithIndex: (NSInteger)index
{
    if ([self.delegate respondsToSelector: @selector(vDynamicScrollView: dequeueViewForIndex:)])
    {
        VDynamicScrollDequeueView* view = [self.delegate vDynamicScrollView: self dequeueViewForIndex:index];
        return view;
    }
    else if ([self.delegate respondsToSelector: @selector(vDynamicScrollView:viewForIndex:)])
    {
        UIView* view = [self.delegate vDynamicScrollView: self viewForIndex: index];
        return view;
    }
    return nil;
}
-(void)reloadViewAtIndex:(NSInteger)index
{
    [self loadViewWithIndex:index];
}

- (void)removeChildView: (UIView*)view
{
    [view removeFromSuperview];
    if ([view isKindOfClass: [VDynamicScrollDequeueView class]])
    {
        VDynamicScrollDequeueView* dequeueView = (VDynamicScrollDequeueView*)view;
        [self.arrayDicationary addObject: dequeueView forKey: dequeueView.identifier];
    }
    [view release];
}
@end
