//
//  LocalMusicPlayerManager.h
//  test
//
//  Created by test on 15/1/5.
//
//

#import <Foundation/Foundation.h>

#define kLocalMusicPlayFinished @"kLocalMusicPlayFinished"

@interface LocalMusicPlayerManager : NSObject

+ (LocalMusicPlayerManager*)sharedManager;
- (BOOL)playMusic:(NSURL*)url;
- (void)stopMusic;
- (BOOL)isPlaying:(NSURL*)url;

@end
