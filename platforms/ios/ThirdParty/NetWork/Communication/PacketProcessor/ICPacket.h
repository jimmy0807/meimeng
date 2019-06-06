//
//  ICPacket.h
//  BetSize
//
//  Created by jimmy on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPacket : NSObject
{
    NSInteger nMessageType;
    NSDictionary* dictMessage;
}

@property(nonatomic, retain) NSDictionary* dictMessage;
@property(nonatomic, assign) NSInteger nMessageType;
 
@end
