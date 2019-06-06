//
//  VScrolledMenu.m
//  VLL (VinStudio Link Library)
//
//  Created by vincent on 5/13/11.
//  Copyright 2011 VStudio. All rights reserved.
//

#import "VScrolledMenu.h"
#import "VSoundButton.h"
@implementation VScrolledMenu
@synthesize delegate;
@synthesize itemButtonArray;
@synthesize animatedSelection;
@synthesize selectedIndex;
@synthesize animationViewType;
@synthesize notSelectedIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor clearColor];
        CGFloat height = self.frame.size.height;
        CGFloat width = self.frame.size.width;
        backGroundImageView = [[UIImageView alloc]init];
        backGroundImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:backGroundImageView];        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        selectedImageView = [[UIImageView alloc]init];
        selectedImageView.frame = CGRectMake(0, 0, width, height);  
        [_scrollView addSubview: selectedImageView];       
        itemButtonArray = [[NSMutableArray alloc]init];
        //UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        VSoundButton* btn = [[VSoundButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        btn.tag = 0;
        [btn addTarget: self action: @selector(itemSelected:) forControlEvents:UIControlEventTouchDown];
        
        [btn addTarget: self action: @selector(itemSelectedUp:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
        [itemButtonArray addObject:btn];
        [_scrollView addSubview:btn];
        [btn release];
        selectedImageView.hidden = YES;
        [self addSubview:_scrollView];
        self.autoresizesSubviews = YES;
        self.animationViewType = VScrolledMenuAnimationViewTypeFloating;
        
        notSelectedIndex = -1;
    }
    return self;
}

-(void)setAnimationViewType:(VScrolledMenuAnimationViewType)type
{
    animationViewType = type;
    if (animationViewType == VScrolledMenuAnimationViewTypeFloating) {
        [_scrollView bringSubviewToFront:selectedImageView];
    } else if (animationViewType == VScrolledMenuAnimationViewTypeMiddle)
    {
        [_scrollView sendSubviewToBack: selectedImageView];
    }
}

-(void)setSelectedImage:(UIImage*)image atY: (CGFloat)y
{
    [self setSelectedImage: image];
    CGRect rect = selectedImageView.frame;
    rect.origin.y = y;
    selectedImageView.frame = rect;
}

-(void)itemSelectedUp:(id)sender
{
    UIButton* btn = sender;
    btn.highlighted = NO;
}


-(void)itemSelected:(id)sender
{
    UIButton* btn = sender;
    if ( notSelectedIndex == btn.tag )
    {
        if (delegate) {
            if ([delegate respondsToSelector:@selector(vScrolledMenu: didSelectItem:)]) 
            {
                [delegate vScrolledMenu: self didSelectItem:btn.tag];
            }
        }
        
        return;
    }
    if (animationViewType == VScrolledMenuAnimationViewTypeFloating) {
        [_scrollView bringSubviewToFront:selectedImageView];
    } else if (animationViewType == VScrolledMenuAnimationViewTypeMiddle)
    {
        [_scrollView sendSubviewToBack: selectedImageView];
    }
    
    NSInteger lastIndex = selectedIndex;
    selectedIndex = btn.tag;

    UIButton* lastSelectedButton = [itemButtonArray objectAtIndex:lastIndex];
    //[lastSelectedButton setSelected: NO];
    lastSelectedButton.selected = NO;
    lastSelectedButton.highlighted = NO;
    UIButton* selectedButton = [itemButtonArray objectAtIndex:selectedIndex];
    //[selectedButton setSelected: YES];
    lastSelectedButton.highlighted = NO;
    selectedButton.selected = YES;
    selectedButton.highlighted = NO;

    if (animatedSelection) 
    {
        [UIView beginAnimations:nil context:[NSNumber numberWithInt:lastIndex]];
        [UIView setAnimationDuration: 0.3];
        [UIView setAnimationDelegate: self];
        //selectedImageView.frame = CGRectMake(selectedIndex * _scrollView.contentSize.width / itemButtonArray.count, selectedImageView.frame.origin.y, selectedImageView.frame.size.width, selectedImageView.frame.size.height);
        CGPoint point = selectedImageView.center;
        point.x = (selectedIndex + 0.5 )* _scrollView.contentSize.width / itemButtonArray.count;
        selectedImageView.center = point;
        [UIView commitAnimations];
    }
    if (delegate) {
        if ([delegate respondsToSelector:@selector(vScrolledMenu: didSelectItem:)]) 
        {
            [delegate vScrolledMenu: self didSelectItem:selectedIndex];
        }
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview: newSuperview];
    //[self setSelectedIndex: 0];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    NSNumber* num = (NSNumber*)context;
    NSInteger lastIndex = [num intValue];
    UIButton* btn = [itemButtonArray objectAtIndex:selectedIndex];
    [btn setSelected: YES];
    if (lastIndex != selectedIndex)
    {
        btn = [itemButtonArray objectAtIndex: lastIndex];
        [btn setSelected: NO];
    }

    // Swicth normal state and selected state
#if 0
    UIImage* imageNormal = [btn imageForState: UIControlStateNormal];
    UIImage* imageSelected = [btn imageForState: UIControlStateSelected];
    [btn setImage: imageNormal forState:UIControlStateSelected];
    [btn setImage: imageSelected forState:UIControlStateNormal];
    
    if (lastIndex != selectedIndex)
    {
        btn = [itemButtonArray objectAtIndex: lastIndex];
        imageNormal = [btn imageForState: UIControlStateNormal];
        imageSelected = [btn imageForState: UIControlStateSelected];
        [btn setImage: imageNormal forState:UIControlStateSelected];
        [btn setImage: imageSelected forState:UIControlStateNormal];        
    }
#endif
}

-(void)adjustButtons
{
    CGFloat width = _scrollView.contentSize.width / itemButtonArray.count;
    CGFloat height = _scrollView.contentSize.height;
    UIButton* btn = nil;
    for (int i = 0; i < itemButtonArray.count; ++i) 
    {
        btn = [itemButtonArray objectAtIndex: i];
        btn.frame = CGRectMake(i * width, 0, width, height);
    }
    //selectedImageView.center = btn.center;
}

-(void)setItemImage:(UIImage*) image atIndex:(NSInteger)index
{
    if (index < itemButtonArray.count) 
    {
        UIButton* button = [itemButtonArray objectAtIndex:index];
        [button setImage: image forState:UIControlStateNormal];

    }
}

-(void)setItemImageSelected:(UIImage*) image atIndex:(NSInteger)index
{
    if (index < itemButtonArray.count) 
    {
        UIButton* button = [itemButtonArray objectAtIndex:index];
        //[button setImage: image forState:UIControlStateDisabled];
        [button setImage: image forState:UIControlStateHighlighted];
        [button setImage: image forState:UIControlStateSelected];
    }
}

-(void)setItemText:(NSString*)text atIndex:(NSInteger)index
{
    if (index < itemButtonArray.count) 
    {
        UIButton* button = [itemButtonArray objectAtIndex:index];
        [button setTitle:text forState:UIControlStateNormal];
    }
}

-(void)setAnimatedSelection:(BOOL)animated
{
    for (UIButton* btn in itemButtonArray)
    {
        btn.adjustsImageWhenHighlighted = !animated;
        btn.adjustsImageWhenHighlighted = NO;
    }
    animatedSelection = animated;
    selectedImageView.hidden = !animatedSelection;
    if (selectedImageView.hidden == NO) {
        //UIButton* btn = [itemButtonArray objectAtIndex:selectedIndex];
        //CGPoint point = selectedImageView.center;
        //point.x = btn.center.x;
        //selectedImageView.center = point;
    }
}

-(void)setSelectedImage:(UIImage *)image
{
    selectedImageView.image = image;
    CGRect rect = selectedImageView.frame;
    rect.size = image.size;
    selectedImageView.frame = rect;
}

-(UIImage*)selectedImage
{
    return selectedImageView.image;
}

-(void)setBackGroundImage:(UIImage *)backGroundImage
{
    backGroundImageView.image = backGroundImage;
}

-(UIImage*)backGroundImage
{
    return backGroundImageView.image;
}

-(void)setContentSize: (CGSize)size
{
    _scrollView.contentSize = size;
    [self adjustButtons];
}

-(CGSize)contentSize
{
    return _scrollView.contentSize;
}

-(void)setBarHeight:(CGFloat) height
{
    for (UIButton* btn in itemButtonArray) {
        CGRect rect = btn.frame;
        rect.origin.y = self.frame.size.height - height;
        rect.size.height = height;
        btn.frame = rect;
    }
}

- (void)dealloc
{
    [_scrollView release];
    [backGroundImageView release];
    [selectedImageView release];
    [itemButtonArray release];
    [super dealloc];
}

-(void)setItemCount:(NSInteger)count
{
    NSInteger tabCount = itemButtonArray.count;
    if (tabCount == count) 
    {
        return;
    }
    if (tabCount < count) {
        for (int i = tabCount; i < count; ++i) 
        {
           // UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            VSoundButton* btn = [[VSoundButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            btn.tag = i;
            btn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
            [btn addTarget: self action: @selector(itemSelected:) forControlEvents:UIControlEventTouchDown];
            
            [btn addTarget: self action: @selector(itemSelectedUp:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor clearColor];
            btn.adjustsImageWhenHighlighted = NO;
            [itemButtonArray addObject:btn];
            [_scrollView addSubview:btn];
            [btn release];
        }
    } else
    {
        NSInteger diff = tabCount - count;
        for (int i = tabCount - diff; i < tabCount; i++) 
        {
            UIButton* btn = [itemButtonArray objectAtIndex:i];
            [btn removeFromSuperview];
            [itemButtonArray removeObject:btn];
        }
    }
    [self adjustButtons];
}

-(NSInteger)itemCount
{
    return itemButtonArray.count;
}

-(void)setSelectedIndex:(NSInteger)index
{
    NSInteger lastIndex = selectedIndex;
    UIButton* lastSelectedButton = [itemButtonArray objectAtIndex:lastIndex];
    //[lastSelectedButton setSelected: NO];
    lastSelectedButton.selected = NO;
    UIButton* selectedButton = [itemButtonArray objectAtIndex:index];
    //[selectedButton setSelected: YES];
    selectedButton.selected = YES;
    selectedIndex = index;
    if (animatedSelection) {
        [UIView beginAnimations:nil context: [NSNumber numberWithInt:lastIndex]];
        [UIView setAnimationDuration: 0.3];
        [UIView setAnimationDelegate: self];
        CGPoint point = selectedImageView.center;
        point.x = (selectedIndex + 0.5 )* _scrollView.contentSize.width / itemButtonArray.count;
        selectedImageView.center = point;
        [UIView commitAnimations];
    }
    
}

-(void)adjustAllTabsAccordingToImageSize
{
    CGFloat lastX = 0.0;
    for (UIButton* btn in  itemButtonArray) 
    {
        UIImage* image = [btn imageForState: UIControlStateNormal];
        btn.frame = CGRectMake(lastX, 0, image.size.width,  image.size.height);
        lastX += image.size.width;
    }
}

@end
