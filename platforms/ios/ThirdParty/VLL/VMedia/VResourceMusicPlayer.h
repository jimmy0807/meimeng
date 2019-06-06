//
//  VResourceMusicPlayer.h
//  BetSize
//
//  Created by Vincent on 1/17/13.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^MusicFadeOutCompleteBlock)();

@interface VResourceMusicPlayer : NSObject<AVAudioPlayerDelegate>
{
    BOOL isNeedResume;
}

- (void)playBackgroundMusic: (NSString*)mediaFileName;
- (void)playBackgroundMusic:(NSString *)mediaFileName fadeOutFormer: (BOOL)fadeOutFormer;
- (void)stopBackground;
- (void)stopMusic;
- (void)stopBackgroundWithFadeOutWithCompleteBlock: (MusicFadeOutCompleteBlock)completeBlock;
- (void)playMusic: (NSString*)mediaFileName;
- (void)playInterrupBackgroundMusic:(NSString*)mediaFileName needResume:(BOOL)flag;
+ (VResourceMusicPlayer*)sharedPlayer;

@property(nonatomic, copy, readonly) NSString* backgroundMediaFileName;
@end
