//
//  VSoundButton.m
//  mojito
//
//  Created by vincent on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VSoundButton.h"


@implementation VSoundButton
@synthesize soundFileName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [super addTarget: self action: @selector(didButtonPressed:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

-(void)didButtonPressed:(id)sender
{
    if (audioPlayer) 
    {
        [audioPlayer stop];
        SAFE_RELEASE(audioPlayer);
    }
    if (soundFileName) 
    {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],soundFileName]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
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
    [audioPlayer release];
    [soundFileName release];
    [super dealloc];
}

@end
