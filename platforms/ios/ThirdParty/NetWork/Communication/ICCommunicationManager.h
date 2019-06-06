//
//  ICCommunicationManager.h
//  BetSize
//
//  Created by jimmy on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "ICResponseProcessor.h"
#import "ICPacket.h"
#import "Reachability.h"
#import "ICRequestDef.h"
#import "NSData+JSON.h"
#import "NSDictionary+JSON.h"

#define kICCommunicationManagerStatusChanged @"ICCommunicationManagerStatusChanged"

typedef enum 
{
    ICCommunicationStatusDisconnected,
    ICCommunicationStatusConnecting,
    ICCommunicationStatusConnected,
} ICCommunicationStatus;

@interface ICCommunicationManager : NSObject
{
    AsyncSocket *cmSocket;
    NSArray *processingChain;
    NSOperationQueue* opq;
    ICCommunicationStatus _status;
    Reachability* hostReachability;
    BOOL isFriendListFetched;
    BOOL isFirstLaunched;
}

@property(nonatomic) ICCommunicationStatus status;
@property(nonatomic) BOOL isFriendListFetched;
@property(nonatomic) BOOL isFirstLaunched;

+(ICCommunicationManager*)currentManager;

- (BOOL)isConnected;
- (void)disconnect;
-(BOOL)connectToServer;
-(BOOL)sendPacket:(ICPacket*)packet;
-(void)sendTCpRequest:(id)params messageType:(NSInteger)type;
- (BOOL) isNetworkReachability;

@end
