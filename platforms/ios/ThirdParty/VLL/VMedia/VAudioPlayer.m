//
//  VAudioPlayer.m
//  Spark
//
//  Created by Vincent on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VAudioPlayer.h"
#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIKit.h>

@interface VAudioPlayer ()
- (void)checkProximity: (BOOL) proximity;
- (void)audioRouteChanged: (UInt32) inDataSize inData: (const void * )inData;
@end

void audioSessionPropertyListener(
                                     void *                  inClientData,
                                     AudioSessionPropertyID	inID,
                                     UInt32                  inDataSize,
                                     const void *            inData)
{
    VAudioPlayer* player = (VAudioPlayer*)inClientData;
    [player audioRouteChanged: inDataSize inData: inData];
}



@implementation VAudioPlayer
@synthesize delegate = _delegate;
@synthesize changeWithProximity;

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError
{
    self = [super initWithContentsOfURL: url error: outError];
    if (self) 
    {
        super.delegate = self;
        self.changeWithProximity = NO;
        AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioSessionPropertyListener, self);
    }
    return self;
}

- (id)initWithData:(NSData *)data error:(NSError **)outError
{
    self = [super initWithData: data error: outError];
    if (self) 
    {
        super.delegate = self;
        self.changeWithProximity = NO;
        AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioSessionPropertyListener, self);
    }
    return self;
}

- (void)dealloc
{
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioSessionPropertyListener, self);
    [self checkProximity: NO];
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)selector 
{
    if ([super respondsToSelector: selector]) 
    {
        return  YES;
    } 
    
    if ([self.delegate respondsToSelector: selector]) 
    {
        return  YES;
    }
    return NO;
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.delegate respondsToSelector: aSelector]) 
    {
        return self.delegate;
    }
    return nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self checkProximity: NO];
    if ([self.delegate respondsToSelector: @selector(audioPlayerDidFinishPlaying: successfully:)]) 
    {
        [self.delegate audioPlayerDidFinishPlaying: player successfully: flag];
    }
}

- (BOOL)play
{
    [self decideAudioSession]; 
    [self checkProximity: changeWithProximity];
    return [super play];
}

- (void)stop
{
    [self checkProximity: NO];
    [super stop];
}

- (void)checkProximity: (BOOL) proximity
{
    if (proximity) 
    {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];  
        [[NSNotificationCenter defaultCenter] addObserver:self  
                                                 selector:@selector(sensorStateChange:)  
                                                     name:UIDeviceProximityStateDidChangeNotification 
                                                   object:nil]; 
        isAddedObserver = YES;
    }
    else 
    {
        if (isAddedObserver) 
        {
            [[NSNotificationCenter defaultCenter] removeObserver: self];
            isAddedObserver = NO;
            [[UIDevice currentDevice] setProximityMonitoringEnabled: NO]; 
        }
    }
}

-(void)sensorStateChange:(NSNotificationCenter *)notification 
{  
    [self decideAudioSession]; 
}  

- (void)decideAudioSession
{
    UInt32 propSize = sizeof(CFStringRef);
    CFStringRef cfs;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propSize, &cfs);
    
    NSString* propString = [NSString stringWithString:(NSString*)cfs];
    NSLog(@"propString = %@", propString);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;  
    if ([[UIDevice currentDevice] proximityState] == YES || !([propString isEqualToString:@"ReceiverAndMicrophone"] || [propString rangeOfString: @"Speaker"].location != NSNotFound )) 
    {  
        audioRouteOverride = kAudioSessionOverrideAudioRoute_None;  
    }  
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);  
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory); 
}

- (void)audioRouteChanged: (UInt32) inDataSize inData: (const void * )inData
{
    NSLog(@"audioRouteChanged...");
}

@end
