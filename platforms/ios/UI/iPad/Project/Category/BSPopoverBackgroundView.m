//
//  BSPopoverBackgroundView.m
//  Boss
//
//  Created by XiaXianBing on 15/11/27.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSPopoverBackgroundView.h"

@interface BSPopoverBackgroundView()

@end


@implementation BSPopoverBackgroundView

@synthesize arrowOffset = _arrowOffset;
@synthesize arrowDirection = _arrowDirection;


+ (CGFloat)arrowBase
{
    return 0.0;
}

+ (CGFloat)arrowHeight
{
    return 0.0;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.shadowOpacity = 0.0f;
}


#pragma mark -
#pragma mark init methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.arrowDirection = UIPopoverArrowDirectionAny;
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-IC_SCREEN_WIDTH, -IC_SCREEN_HEIGHT, 2 * IC_SCREEN_WIDTH, 2 * IC_SCREEN_HEIGHT)];
        backgroundImageView.backgroundColor = [UIColor blackColor];
        backgroundImageView.alpha = 0.5;
        [self addSubview:backgroundImageView];
        
        UIImage *topImage = [UIImage imageNamed:@"top_arrow"];
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - topImage.size.width)/2.0, - topImage.size.height, topImage.size.width, topImage.size.height)];
        topImageView.backgroundColor = [UIColor clearColor];
        topImageView.image = topImage;
        [self addSubview:topImageView];
    }
    
    return self;
}

@end
