//
//  VAudioPlayer.h
//  Spark
//
//  Created by Vincent on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface VAudioPlayer : AVAudioPlayer<AVAudioPlayerDelegate>
{
    id<AVAudioPlayerDelegate> _delegate;
    BOOL changeWithProximity;
    BOOL isAddedObserver;
}

@property(assign) id<AVAudioPlayerDelegate> delegate;
@property(nonatomic, assign) BOOL changeWithProximity;
@end
