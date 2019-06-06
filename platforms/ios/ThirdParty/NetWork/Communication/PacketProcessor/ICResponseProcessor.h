//
//  ICResponseProcessor.h
//  BetSize
//
//  Created by jimmy on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICPacket.h"

@interface ICResponseProcessor : NSObject

-(BOOL)process:(ICPacket*)packet invoker: (id<NSObject>) invoker;

@end
