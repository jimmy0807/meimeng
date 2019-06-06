//
//  VSoundButton.h
//  mojito
//
//  Created by vincent on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VSoundButton : UIButton {
    NSString* soundFileName;
    AVAudioPlayer* audioPlayer;
}

@property(nonatomic, copy) NSString* soundFileName;
@end
