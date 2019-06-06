//
//  BSPadDataRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSPadDataRequest : NSObject

+ (BSPadDataRequest *)sharedInstance;

- (void)startDataRequest;

@end
