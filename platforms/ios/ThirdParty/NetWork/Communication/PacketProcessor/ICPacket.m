//
//  ICPacket.m
//  BetSize
//
//  Created by jimmy on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICPacket.h"

@implementation ICPacket
@synthesize dictMessage;
@synthesize nMessageType;

-(void)dealloc
{
    [dictMessage release];
    [super dealloc];
}

@end
