//
//  VSliderView.m
//  PaintingTycoon
//
//  Created by Vincent on 12/25/12.
//  Copyright (c) 2012 InnovClub. All rights reserved.
//

#import "VSliderView.h"

@interface VSliderView()
@property(nonatomic, retain) UIImageView* leftForgroundImageView;
@property(nonatomic, retain) UIImageView* rightForgroundImageView;
@property(nonatomic, retain) UIButton* sliderButton;
@property(nonatomic, assign) CGSize borderSize;
//@property(nonatomic, retain) UIView* contentView;
@end

@implementation VSliderView
@synthesize currentLocation = _currentLocation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //self.contentView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        //self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        //self.contentView.backgroundColor = [UIColor clearColor];
        self.range = NSMakeRange(0, 10);
        self.backgroundImageView = [[[UIImageView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview: self.backgroundImageView];
        self.leftForgroundImageView = [[[UIImageView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width / 2, frame.size.height)] autorelease];
        self.leftForgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview: self.leftForgroundImageView];
        self.rightForgroundImageView = [[[UIImageView alloc] initWithFrame: CGRectMake(frame.size.width / 2, 0, frame.size.width / 2, frame.size.height)] autorelease];
        self.rightForgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview: self.rightForgroundImageView];
        self.sliderButton = [UIButton buttonWithType: UIButtonTypeCustom];
        self.sliderButton.adjustsImageWhenHighlighted = YES;
        self.sliderButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.sliderButton.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self addSubview: self.sliderButton];
        UIPanGestureRecognizer* pr = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(didGesture:)];
        [self.sliderButton addGestureRecognizer: pr];
        [pr release];
    }
    return self;
}

- (void)dealloc
{
    self.sliderButton = nil;
    self.backgroundImageView = nil;
    self.leftForgroundImageView = nil;
    self.rightForgroundImageView = nil;
    //self.contentView = nil;
    [super dealloc];
}

- (void)setCurrentLocation:(CGFloat)currentLocation
{
    if (currentLocation > self.range.length + self.range.location || currentLocation < self.range.location)
    {
        return;
    }
    _currentLocation = currentLocation;
    CGFloat ratio = (_currentLocation - self.range.location) * 1.0 / self.range.length;
    self.sliderButton.center = CGPointMake(self.borderSize.width + (self.frame.size.width - 2 * self.borderSize.width) * ratio, self.frame.size.height / 2);
    [self setNeedsLayout];
}

- (void)setLeftForgroundImage: (UIImage*)image
{
    self.leftForgroundImageView.image = image;
    [self setNeedsLayout];
}

- (void)setRightForgroundImage: (UIImage*)image
{
    self.rightForgroundImageView.image = image;
    [self setNeedsLayout];
}

- (void)didGesture: (UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.sliderButton.highlighted = YES;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        self.sliderButton.highlighted = NO;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint p = [gestureRecognizer locationInView: self];
        CGFloat location = self.range.location;
        if (p.x >= self.borderSize.width
            && p.x <= self.frame.size.width - self.borderSize.width)
        {
            self.sliderButton.center = CGPointMake(p.x, self.sliderButton.center.y);
            location += self.range.length * (p.x - self.borderSize.width) / (self.frame.size.width - 2 * self.borderSize.width);
        }
        else if (p.x > self.frame.size.width - self.borderSize.width)
        {
            location = self.range.location + self.range.length;
        }
        [self setCurrentLocation: location];
        if ([self.delegate respondsToSelector: @selector(sliderView:didSlide:)])
        {
            [self.delegate sliderView: self didSlide: location];
        }
    }
}

- (void)setSliderButtonImage: (UIImage*)image forState:(UIControlState)state
{
    CGPoint center = self.sliderButton.center;
    self.sliderButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.sliderButton.center = center;
    self.borderSize = CGSizeMake(self.sliderButton.frame.size.width  / 2, self.sliderButton.frame.size.height / 2)  ;
    [self.sliderButton setImage: image forState: state];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    self.backgroundImageView.frame = CGRectMake(self.borderSize.width / 2,
                                                (self.frame.size.height - self.backgroundImageView.image.size.height) / 2,
                                                self.frame.size.width - self.borderSize.width,
                                                self.backgroundImageView.image.size.height
                                                );
    CGFloat cap = self.backgroundImageView.image.leftCapWidth;
    CGFloat x = self.backgroundImageView.frame.origin.x + cap;
    self.leftForgroundImageView.frame = CGRectMake(x,
                                                   (self.frame.size.height - self.leftForgroundImageView.image.size.height) / 2,
                                                   self.sliderButton.center.x - x,
                                                   self.leftForgroundImageView.image.size.height
                                                   );
    CGFloat w = self.backgroundImageView.frame.size.width - 2 * cap - self.leftForgroundImageView.frame.size.width;
    self.rightForgroundImageView.frame = CGRectMake(self.sliderButton.center.x,
                                                    (self.frame.size.height - self.rightForgroundImageView.image.size.height) / 2,
                                                    w,
                                                    self.rightForgroundImageView.image.size.height
                                                    );
    
}


@end
