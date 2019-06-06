//
//  VNaviBackButton.m
//  VLL (VinStudio Link Library)
//
//  Created by vincent on 4/29/11.
//  Copyright 2011 VinStudio. All rights reserved.
//

#import "VNaviBackButton.h"


@implementation VNaviBackButton
@synthesize delegate = _delegate;
@synthesize button;

- (id)initWithImage:(UIImage *)image
{
    button = [[VSoundButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    //button.soundFileName = @"dw2f_3.MP3";
    //[btn setImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState: UIControlStateNormal];
    self = [super initWithCustomView:button];
    if (self) 
    {
        [button addTarget:self action:@selector(didBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [button release];
        button = nil;
    }
    return self;
}

-(void)didBackButtonPressed: (id)sender
{
    if ([self.delegate respondsToSelector:@selector(navigationController)]) 
    {
        UINavigationController* naviCtl = [self.delegate performSelector:@selector(navigationController)];
        [naviCtl popViewControllerAnimated:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [button release];
    [super dealloc];
}

@end
