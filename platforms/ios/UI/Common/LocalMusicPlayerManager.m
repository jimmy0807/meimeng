//
//  LocalMusicPlayerManager.m
//  test
//
//  Created by test on 15/1/5.
//
//

#import "LocalMusicPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

static LocalMusicPlayerManager* s_sharedManager = nil;

@interface LocalMusicPlayerManager()<AVAudioPlayerDelegate>
@property(nonatomic, strong)AVAudioPlayer* player;
@end

@implementation LocalMusicPlayerManager

+ (LocalMusicPlayerManager*)sharedManager
{
    @synchronized(s_sharedManager)
    {
        if (s_sharedManager == nil)
        {
            s_sharedManager = [[LocalMusicPlayerManager alloc] init];
        }
    }
    
    return s_sharedManager;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(sessionCategory),
                                &sessionCategory);
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                 sizeof (audioRouteOverride),
                                 &audioRouteOverride);
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }
    return self;
}

- (BOOL)playMusic:(NSURL*)url
{
    if ( [self isPlaying:url] )
    {
        [self.player stop];
        return FALSE;
    }
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    if ( self.player == nil )
    {
        if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 )
        {
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url fileTypeHint:AVFileTypeMPEGLayer3 error:nil];
        }
    }
    
    if ( self.player == nil )
    {
        BOOL isMp3Net = [@"mp3" isEqualToString:[url.absoluteString pathExtension]];
        self.player = isMp3Net ? [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil]: [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfURL:url] error:nil];
    }
    
    if ( self.player == nil )
    {
        self.player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfURL:url] error:nil];
    }
    
    self.player.delegate = self;
    [self.player play];
    [self handleNotification:YES];
    
    return TRUE;
}

- (void)stopMusic
{
    [self.player stop];
    self.player = nil;
}

- (BOOL)isPlaying:(NSURL*)url
{
    if ( [self.player.url.absoluteString isEqualToString:url.absoluteString] )
    {
        return self.player.playing;
    }
    
    return FALSE;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self handleNotification:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocalMusicPlayFinished object:self userInfo:nil];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self handleNotification:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocalMusicPlayFinished object:self userInfo:nil];
}

#pragma mark - 监听听筒or扬声器
- (void) handleNotification:(BOOL)state
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    if(state)//添加监听
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                  object:nil];
    }
    else//移除监听
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

@end
