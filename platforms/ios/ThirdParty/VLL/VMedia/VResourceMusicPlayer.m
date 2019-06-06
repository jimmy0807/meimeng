//
//  VResourceMusicPlayer.m
//  BetSize
//
//  Created by Vincent on 1/17/13.
//
//

#import "VResourceMusicPlayer.h"

static VResourceMusicPlayer* s_sharedPlayer;

@interface VResourceMusicPlayer ()
@property(nonatomic, retain) AVAudioPlayer* backgroundPlayer;
@property(nonatomic, retain) AVAudioPlayer* musicPlayer;
@property(nonatomic, retain) NSTimer* fadeOutTimer;
@property(nonatomic, copy) MusicFadeOutCompleteBlock completeBlock;
@end

@implementation VResourceMusicPlayer
@synthesize backgroundMediaFileName = _backgroundMediaFileName;
@synthesize completeBlock = _completeBlock;

+ (VResourceMusicPlayer*)sharedPlayer
{
    @synchronized(s_sharedPlayer)
    {
        if (s_sharedPlayer == nil)
        {
            s_sharedPlayer = [[VResourceMusicPlayer alloc] init];
        }
        return s_sharedPlayer;
    }
}

- (void)dealloc
{
    [_backgroundMediaFileName release];
    self.backgroundPlayer = nil;
    self.completeBlock = nil;
    self.musicPlayer = nil;
    [super dealloc];
}

- (void)playBackgroundMusic: (NSString*)mediaFileName
{
    [self stopBackground];
    NSString* filePath = [[NSBundle mainBundle] pathForResource: mediaFileName ofType: @""];
    self.backgroundPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: filePath] error: nil] autorelease];
    _backgroundMediaFileName = [filePath copy];
    self.backgroundPlayer.numberOfLoops = -1;
    [self.backgroundPlayer play];
}

- (void)playBackgroundMusic:(NSString *)mediaFileName fadeOutFormer: (BOOL)fadeOutFormer
{
    if (fadeOutFormer)
    {
        [self stopBackgroundWithFadeOutWithCompleteBlock: ^()
         {
             [self playBackgroundMusic: mediaFileName];
         }
         ];
    }
    else
    {
        [self playBackgroundMusic: mediaFileName];
    }
}

- (void)stopBackground
{
    [self.backgroundPlayer stop];
    self.backgroundPlayer = nil;
    [_backgroundMediaFileName release];
    _backgroundMediaFileName = nil;
}

- (void)stopMusic
{
    [self.musicPlayer stop];
    self.musicPlayer = nil;
}

- (void)stopBackgroundWithFadeOutWithCompleteBlock: (MusicFadeOutCompleteBlock)completeBlock;
{
    self.completeBlock = completeBlock;
    self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(didFadeOutTimer) userInfo: nil repeats: YES];
}

- (void)didFadeOutTimer
{
    BOOL stop = NO;
    if (self.backgroundPlayer.volume - 0.1 > 0)
    {
        self.backgroundPlayer.volume -= 0.1;
        if (self.backgroundPlayer.volume == 0)
        {
            stop = YES;
        }
    }
    else
    {
        stop = YES;
    }
    if (stop)
    {
        [self.fadeOutTimer invalidate];
        self.fadeOutTimer = nil;
        [self stopBackground];
        if (self.completeBlock)
        {
            self.completeBlock();
        }
    }
}

- (void)playMusic: (NSString*)mediaFileName
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource: mediaFileName ofType: @""];
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: filePath] error: nil];
    player.delegate = self;
    [player play];
}

- (void)playInterrupBackgroundMusic:(NSString*)mediaFileName needResume:(BOOL)flag
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource: mediaFileName ofType: @""];
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: filePath] error: nil];
    player.delegate = self;
    
    //[self.backgroundPlayer pause];
    
    isNeedResume = flag;
    
    [self.musicPlayer stop];
    self.musicPlayer = player;
    
    [player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ( isNeedResume )
    {
        self.musicPlayer = nil;
        //[self.backgroundPlayer play];
    }

    [player autorelease];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if ( isNeedResume )
    {
        self.musicPlayer = nil;
        [self.backgroundPlayer play];
    }

    [player autorelease];
}

@end
