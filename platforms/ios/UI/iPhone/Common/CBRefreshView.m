//
//  CBRefreshView.m
//  CardBag
//
//  Created by chen yan on 13-11-4.
//  Copyright (c) 2013骞�Everydaysale. All rights reserved.
//

#import "CBRefreshView.h"
#import <objc/runtime.h>

#define REFRESH_VIEW_HEIGHT         32.0
#define REFRESH_VIEW_ELEMENT        18.0
#define REFRESH_REGION_HEIGHT       32.0
#define FLIP_ANIMATION_DURATION     0.2

static const char *MRefreshDelegate = "refreshDelegate";
static const char *MInterceptor = "interceptor";
static const char *MCanRefresh = "canRefresh";
static const char *MCanLoadMore = "canLoadMore";

#pragma mark -
#pragma mark CBRefreshView implementation

@implementation CBRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, REFRESH_VIEW_HEIGHT - REFRESH_VIEW_ELEMENT, self.frame.size.width, REFRESH_VIEW_ELEMENT)];
		stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		stateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		stateLabel.textColor = COLOR(136.0, 132.0, 124.0, 1.0);
		stateLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		stateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		stateLabel.backgroundColor = [UIColor clearColor];
		stateLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:stateLabel];
		
		arrowLayer = [CALayer layer];
        arrowLayer.frame = CGRectMake(IC_SCREEN_WIDTH/2.0 - 48.0, REFRESH_VIEW_HEIGHT - REFRESH_VIEW_ELEMENT, REFRESH_VIEW_ELEMENT, REFRESH_VIEW_ELEMENT);
		arrowLayer.contentsGravity = kCAGravityResizeAspect;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
			arrowLayer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:arrowLayer];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(self.frame.size.width/2.0 - 48.0, REFRESH_VIEW_HEIGHT - REFRESH_VIEW_ELEMENT, REFRESH_VIEW_ELEMENT, REFRESH_VIEW_ELEMENT);
		[self addSubview:activityView];
    }
    
    return self;
}

- (void)setState:(CBPullingState)aState
{
	switch (aState)
    {
        case CBPullingStateNormal:
        {
            self.hidden = YES;
            
            if (self.state == CBPullingStateLoading)
            {
                UIScrollView *scrollView = (UIScrollView *)self.superview;
                
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				arrowLayer.transform = CATransform3DIdentity;
                if (self.status == CBRefreshStateRefresh)
                {
                    [scrollView setContentInset:UIEdgeInsetsZero];
                }
                if (self.status == CBRefreshStateLoadMore)
                {
                    [scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, REFRESH_VIEW_HEIGHT, 0.0)];
                }
				[CATransaction commit];
			}
            
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			arrowLayer.hidden = NO;
            [activityView stopAnimating];
			arrowLayer.transform = CATransform3DIdentity;
			[CATransaction commit];
            
            self.status = CBRefreshStateRefresh;
        }
            break;
            
        case CBPullingStatePullingDown:
        {
            self.hidden = NO;
            self.status = CBRefreshStateRefresh;
            
            stateLabel.frame = CGRectMake(10.0, 7.0, self.frame.size.width, 18.0);
            arrowLayer.frame = CGRectMake(self.frame.size.width/2.0 - 48.0, 7.0, 18.0, 18.0);
            activityView.frame = CGRectMake(self.frame.size.width/2.0 - 48.0, 7.0, 18.0, 18.0);
            
            if (self.state == CBPullingStateDownHitTheEnd)
            {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				arrowLayer.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            
            [CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            arrowLayer.hidden = NO;
            arrowLayer.contents = (id)[UIImage imageNamed:@"arrow_refresh"].CGImage;
            stateLabel.text = LS(@"PullDownToRefresh");
            arrowLayer.transform = CATransform3DIdentity;
            [activityView stopAnimating];
			[CATransaction commit];
        }
            break;
            
        case CBPullingStateDownHitTheEnd:
        {
            self.hidden = NO;
            self.status = CBRefreshStateRefresh;
            
            [CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            arrowLayer.hidden = NO;
            stateLabel.text = LS(@"ReleaseToRefresh");
            [activityView stopAnimating];
			arrowLayer.transform = CATransform3DMakeRotation((M_PI/180.0)*180.0, 0.0, 0.0, 1.0);
			[CATransaction commit];
        }
            break;
            
        case CBPullingStatePullingUp:
        {
            self.hidden = NO;
            self.status = CBRefreshStateLoadMore;
            
            stateLabel.frame = CGRectMake(10.0, 7.0, self.frame.size.width, 18.0);
            arrowLayer.frame = CGRectMake(self.frame.size.width/2.0 - 48.0, 7.0, 18.0, 18.0);
            activityView.frame = CGRectMake(self.frame.size.width/2.0 - 48.0, 7.0, 18.0, 18.0);
            
            if (self.state == CBPullingStateUpHitTheEnd)
            {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				arrowLayer.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            
            [CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            
//            arrowLayer.hidden = NO;
//            arrowLayer.contents = (id)[UIImage imageNamed:@"arrow_loadmore"].CGImage;
//            stateLabel.text = LS(@"PullUpToLoadMore");
//            arrowLayer.transform = CATransform3DIdentity;
//            [activityView stopAnimating];
            
            arrowLayer.hidden = YES;
            stateLabel.text = @"";
            [activityView stopAnimating];
            
			[CATransaction commit];
        }
            break;
            
        case CBPullingStateUpHitTheEnd:
        {
            self.hidden = NO;
            self.status = CBRefreshStateLoadMore;
            
            [CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            
//            arrowLayer.hidden = NO;
//            stateLabel.text = LS(@"ReleaseToRefresh");
//			arrowLayer.transform = CATransform3DMakeRotation((M_PI / 180.0)*180.0, 0.0, 0.0, 1.0);
//            [activityView stopAnimating];
            
            arrowLayer.hidden = YES;
            stateLabel.text = LS(@"IsLoading");
            [activityView startAnimating];
            
            [CATransaction commit];
        }
            break;
            
        case CBPullingStateLoading:
        {
            self.hidden = NO;
            
            UIScrollView *scrollView = (UIScrollView *)self.superview;
            UIEdgeInsets insets = scrollView.contentInset;
            
            if (self.status == CBRefreshStateRefresh)
            {
                if (scrollView.contentOffset.y < 0.0 && scrollView.contentOffset.y > -REFRESH_VIEW_HEIGHT)
                {
                    insets = UIEdgeInsetsMake(insets.top - scrollView.contentOffset.y, 0, insets.bottom, 0);
                    [scrollView setContentInset:insets];
                }
                else if (scrollView.contentOffset.y < - REFRESH_VIEW_HEIGHT)
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        UIEdgeInsets insets = scrollView.contentInset;
                        insets = UIEdgeInsetsMake(insets.top + REFRESH_VIEW_HEIGHT, 0, insets.bottom, 0);
                        [scrollView setContentInset:insets];
                    }];
                }
            }
            else if (self.status == CBRefreshStateLoadMore)
            {
                if (scrollView.contentOffset.y > 0.0 && scrollView.contentOffset.y < REFRESH_REGION_HEIGHT)
                {
                    insets = UIEdgeInsetsMake(insets.top, 0, REFRESH_VIEW_HEIGHT, 0);
                    [scrollView setContentInset:insets];
                    
                    
                }
                else if (scrollView.contentOffset.y > REFRESH_VIEW_HEIGHT)
                {
                    CGFloat insetsBottom;
                    if ( scrollView.frame.size.height > scrollView.contentSize.height )
                    {
                        insetsBottom = scrollView.frame.size.height - scrollView.contentSize.height + self.frame.size.height;
                    }
                    else
                    {
                        insetsBottom = REFRESH_VIEW_HEIGHT;
                    }
                    scrollView.contentInset = UIEdgeInsetsMake(insets.top, 0.0, insetsBottom, 0.0);
                }
            }
            
            [CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            arrowLayer.hidden = YES;
            stateLabel.text = LS(@"IsLoading");
            [activityView startAnimating];
			[CATransaction commit];
        }
            break;
            
        default:
            break;
	}
	
	_state = aState;
}

@end


#pragma mark -
#pragma mark UIScrollView (Private) implementation

@implementation UIScrollView (Private)
@dynamic interceptor;

- (void)setInterceptor:(Interceptor *)interceptor
{
    objc_setAssociatedObject(self, &MInterceptor, interceptor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (Interceptor *)interceptor
{
    return objc_getAssociatedObject(self, &MInterceptor);
}

- (void)refreshWithState:(CBRefreshState)state
{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(scrollView:withRefreshState:)])
    {
        [self.refreshDelegate scrollView:self withRefreshState:state];
    }
}

- (void)cleanCBrefreshView
{
    if (self.canLoadMore) {
        [self removeObserver:self forKeyPath:@"contentSize"];
    }
    
}

@end


#pragma mark -
#pragma mark Interceptor implementation

@implementation Interceptor
@synthesize receiver;
@synthesize scrollView;
@synthesize refreshView;
@synthesize loadmoreView;

//快速转发函数，在此实现函数拦截，实现自己功能后再转发给原代理
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSString *selectorName = NSStringFromSelector(aSelector);
    
    if ([selectorName isEqualToString:NSStringFromSelector(@selector(scrollViewDidScroll:))])
    {
        CGFloat offset = scrollView.contentOffset.y;
        if (offset < 0)
        {
            if (scrollView.canRefresh && refreshView.state == CBPullingStateNormal)
            {
                [refreshView setState:CBPullingStatePullingDown];
            }
        }
        
        if (offset < -REFRESH_REGION_HEIGHT && refreshView.state == CBPullingStatePullingDown)
        {
            [refreshView setState:CBPullingStateDownHitTheEnd];
        }
        else if (offset > -REFRESH_REGION_HEIGHT && offset < 0 && refreshView.state == CBPullingStateDownHitTheEnd)
        {
            [refreshView setState:CBPullingStatePullingDown];
        }
        
        offset = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        
        if (offset > 0 && scrollView.contentSize.height > scrollView.frame.size.height)
        {
            if (scrollView.canLoadMore && loadmoreView.state == CBPullingStateNormal)
            {
                [loadmoreView setState:CBPullingStatePullingUp];
                loadmoreView.hidden = NO;
                CGRect frame = CGRectMake(0.0, scrollView.contentSize.height, scrollView.frame.size.width, REFRESH_VIEW_HEIGHT);
                loadmoreView.frame = frame;
            }
        }
        
        if (offset > REFRESH_REGION_HEIGHT && loadmoreView.state == CBPullingStatePullingUp)
        {
            [loadmoreView setState:CBPullingStateUpHitTheEnd];
        }
        else if (offset > 0 && offset < REFRESH_REGION_HEIGHT && loadmoreView.state == CBPullingStateUpHitTheEnd)
        {
            [loadmoreView setState:CBPullingStatePullingUp];
        }
    }
    
    if ([selectorName isEqualToString:NSStringFromSelector(@selector(scrollViewDidEndDragging:willDecelerate:))])
    {
        CGFloat offset = scrollView.contentOffset.y;
        if (offset < -REFRESH_REGION_HEIGHT && refreshView.state == CBPullingStateDownHitTheEnd)
        {
            [refreshView setState:CBPullingStateLoading];
            [scrollView refreshWithState:CBRefreshStateRefresh];
        }
        
        offset = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        if (offset > REFRESH_REGION_HEIGHT && loadmoreView.state == CBPullingStateUpHitTheEnd)
        {
            [loadmoreView setState:CBPullingStateLoading];
            [scrollView refreshWithState:CBRefreshStateLoadMore];
        }
    }
    
    if ([selectorName isEqualToString:NSStringFromSelector(@selector(scrollViewDidEndDecelerating:))])
    {
        CGFloat offset = (scrollView.contentSize.height < scrollView.frame.size.height) ? 0 : (scrollView.contentSize.height - scrollView.frame.size.height);
        if (offset >= 0 && scrollView.contentOffset.y >= offset && (loadmoreView.state == CBPullingStatePullingUp || loadmoreView.state == CBPullingStateUpHitTheEnd))
        {
            [loadmoreView setState:CBPullingStateLoading];
            [scrollView refreshWithState:CBRefreshStateLoadMore];
        }
    }
    
    if ([receiver respondsToSelector:aSelector])
    {
        return receiver;
    }
    if ([scrollView respondsToSelector:aSelector])
    {
        return scrollView;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([receiver respondsToSelector:aSelector])
    {
        return YES;
    }
    
    if ([scrollView respondsToSelector:aSelector])
    {
        return YES;
    }
    
    return [super respondsToSelector:aSelector];
}

@end


#pragma mark -
#pragma mark UIScrollView (CBRefresh) implementation

@implementation UIScrollView (CBRefresh)

@dynamic canRefresh;
@dynamic canLoadMore;
@dynamic refreshDelegate;

//初始化拦截器
- (void)initInterceptor
{
    if (!self.interceptor)
    {
        self.interceptor = [[Interceptor alloc] init];
        self.interceptor.scrollView = self;
        
        if (self.delegate)
        {
            self.interceptor.receiver = self.delegate;
        }
        
        self.delegate = (id)self.interceptor;
    }
}

- (void)setCanRefresh:(BOOL)refresh
{
    if (refresh)
    {
        [self initInterceptor];
        if (!self.interceptor.refreshView)
        {
            CBRefreshView *refreshView = [[CBRefreshView alloc] initWithFrame:CGRectMake(0.0, -REFRESH_VIEW_HEIGHT, self.frame.size.width, REFRESH_VIEW_HEIGHT)];
            [self addSubview:refreshView];
            self.interceptor.refreshView = refreshView;
        }
        else
        {
            [self addSubview:self.interceptor.refreshView];
        }
    }
    else
    {
        if (self.interceptor.refreshView.superview)
        {
            [self.interceptor.refreshView removeFromSuperview];
        }
    }
    
    NSNumber *number = [NSNumber numberWithBool:refresh];
    objc_setAssociatedObject(self, &MCanRefresh, number, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)canRefresh
{
    id number = objc_getAssociatedObject(self, &MCanRefresh);
    
    return [number boolValue];
}

- (void)setCanLoadMore:(BOOL)loadmore
{
    if (loadmore)
    {
        [self initInterceptor];
        if (!self.interceptor.loadmoreView)
        {
            CBRefreshView *loadMoreView = [[CBRefreshView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height, self.frame.size.width, REFRESH_VIEW_HEIGHT)];
            UIEdgeInsets insets = self.contentInset;
            self.contentInset = UIEdgeInsetsMake(insets.top, 0.0, REFRESH_VIEW_HEIGHT, 0.0);
            [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addSubview:loadMoreView];
            
            self.interceptor.loadmoreView = loadMoreView;
        }
        else
        {
            [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addSubview:self.interceptor.loadmoreView];
        }
    }
    else
    {
        if (self.interceptor.loadmoreView.superview)
        {
            [self.interceptor.loadmoreView removeFromSuperview];
            [self removeObserver:self forKeyPath:@"contentSize"];
        }
    }
    
    NSNumber *number = [NSNumber numberWithBool:loadmore];
    objc_setAssociatedObject(self, &MCanLoadMore, number, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)canLoadMore
{
    NSNumber *number = objc_getAssociatedObject(self, &MCanLoadMore);
    
    return [number boolValue];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView  *scrollView = (UIScrollView *)self;
    CGFloat height = scrollView.contentSize.height < scrollView.frame.size.height ? scrollView.frame.size.height : scrollView.contentSize.height;
    self.interceptor.loadmoreView.frame = CGRectMake(0.0, height, self.frame.size.width, REFRESH_VIEW_HEIGHT);
}

- (void)setRefreshDelegate:(id<CBRefreshDelegate>)m_delegate
{
    objc_setAssociatedObject(self, &MRefreshDelegate, m_delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id)refreshDelegate
{
    return objc_getAssociatedObject(self, &MRefreshDelegate);
}

- (void)stopWithRefreshState:(CBRefreshState)state
{
    if (state == CBRefreshStateRefresh && self.interceptor.refreshView.state == CBPullingStateLoading)
    {
        [UIView animateWithDuration:0.4 animations:^{
            UIEdgeInsets insets = self.contentInset;
            insets = UIEdgeInsetsMake(0, 0, insets.bottom, 0);
            [self setContentInset:insets];
        }];
        
        [self.interceptor.refreshView setState:CBPullingStateNormal];
    }
    else if (state == CBRefreshStateLoadMore && self.interceptor.loadmoreView.state == CBPullingStateLoading)
    {
        [self.interceptor.loadmoreView setState:CBPullingStateNormal];
    }
    
    if(self.interceptor.loadmoreView)
    {
        [self.interceptor.loadmoreView setFrame:CGRectMake(0, (self.contentSize.height < self.frame.size.height) ? self.frame.size.height : self.contentSize.height, self.frame.size.width, REFRESH_VIEW_HEIGHT)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scView
{
    ;
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scView willDecelerate:(BOOL)decelerate
{
    ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    ;
}

@end
