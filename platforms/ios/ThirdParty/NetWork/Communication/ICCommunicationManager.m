//
//  ICCommunicationManager.m
//  BetSize
//
//  Created by jimmy on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICCommunicationManager.h"

//#import "ICTcpAuthResponseProcessor.h"
static ICCommunicationManager* currentManager;

@implementation ICCommunicationManager
@synthesize status = _status;
@synthesize isFriendListFetched;
@synthesize isFirstLaunched;

+(ICCommunicationManager*)currentManager
{
    if (currentManager == nil) 
    {
        currentManager = [[ICCommunicationManager alloc]init];
    }
    
    return currentManager;
}

-(id)init
{
    self = [super init];
    if (self) 
    {
        hostReachability = [[Reachability reachabilityForInternetConnection] retain];
        
        [hostReachability startNotifier];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        
        self.isFirstLaunched = TRUE;
    }
    return self;
}

-(BOOL)connectToServer
{
    if ( !cmSocket )
    {
        cmSocket = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *err = nil;
        if ( ![cmSocket connectToHost:SERVER_ADD onPort:LONG_CONNECTION_PORT error:&err] )
        {
            NSLog(@"socket init error : %@",err);
            return false;
        }
        
        if (_status != ICCommunicationStatusConnecting) 
        {
            _status = ICCommunicationStatusConnecting;
            [[NSNotificationCenter defaultCenter] postNotificationName: kICCommunicationManagerStatusChanged object: self userInfo: [NSDictionary dictionaryWithObject: @"connected" forKey: @"status"]];
        }
        
        if (!processingChain) {
            processingChain = [[self generateDefaultProcessingChain] retain];
        }
        if ( !opq )
        {
            opq = [[NSOperationQueue alloc]init];
        }
        // [opq setSuspended: YES];
    }
    else
    {
        return FALSE;
    }
    
    return TRUE;
}

-(NSArray*)generateDefaultProcessingChain
{
    NSMutableArray* chain = [NSMutableArray array];
    //ICResponseProcessor* processor = nil;
    
    //processor = [[[ICTcpAuthResponseProcessor alloc]init] autorelease] ;
    //[chain addObject: processor];
    
    return chain;
}

- (void)sendTCpRequest:(id)params messageType:(NSInteger)type
{
    if ( ![cmSocket isConnected] )
    {
        //do something
    }
    
    ICPacket *packet = [[[ICPacket alloc] init] autorelease];
    packet.nMessageType = type;
    packet.dictMessage = params;
    //[self addPacketToSendingQueue];
    [self sendPacket:packet];
}

-(BOOL)sendPacket:(ICPacket*)packet
{
    if (!packet) 
    {
        return NO;
    }
    
    NSData* data = [NSData jsonDataWithObject: packet.dictMessage];
    short type = htons(packet.nMessageType);
    UInt32 len = htonl([data length]);
    char* p = (char*)&type;
    NSMutableData* dataToSend = [NSMutableData dataWithBytes:p length:2];
    p = (char*)&len;
    [dataToSend appendBytes:p length:4];
    [dataToSend appendData: data];
    // [dataToSend appendBytes:@"\r\n" length:sizeof(@"\r\n")];
    [cmSocket writeData:dataToSend withTimeout:-1 tag:0];
    
    return YES;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"%s %d", __FUNCTION__, __LINE__);
    if (_status != ICCommunicationStatusConnecting) 
    {
        _status = ICCommunicationStatusConnecting;
        [[NSNotificationCenter defaultCenter] postNotificationName: kICCommunicationManagerStatusChanged object: self userInfo: [NSDictionary dictionaryWithObject: @"connected" forKey: @"status"]];
    }
    
    [cmSocket readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"%s %d, tag = %ld", __FUNCTION__, __LINE__, tag);
    
    [cmSocket readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"==== onSocket:didReadData ====== , length = %d",[data length]);
    NSInteger RecvLen =  [data length];
    char *buf = (char*)[data bytes];
    while (RecvLen > 0)
    {
        short nMessageType = *(short*)buf;
        int packetLen = ntohl(*(int*)(buf + 2));
        RecvLen = RecvLen - packetLen - 6;
        ICPacket* packet = [[[ICPacket alloc] init] autorelease];
        packet.nMessageType = ntohs(nMessageType);
        
        NSData* dictData = [NSData dataWithBytes:(buf+6) length:packetLen];
        packet.dictMessage = [NSDictionary dictionaryWithJSONData: dictData];
        buf = buf + packetLen + 6;
        NSString* str = [NSString stringWithUTF8String: [dictData bytes]];
        NSLog(@"%@",str);
        BOOL processed = NO;
        // Responsibility Chain
        for (ICResponseProcessor* rspProcessor in processingChain) 
        {
            if ([rspProcessor process: packet invoker: self]) 
            {
                processed = YES;
                break;
            }
        }
        // Unknown message, skip it
        if (!processed)
        {
            NSLog(@"unknow message id: %d", packet.nMessageType);
            //   NSLog(@"Skip %d bytes", packetLength);
        }
    }    
    [cmSocket readDataWithTimeout: -1 tag: 0];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"==== onSocketDidDisconnect ======");

    _status = ICCommunicationStatusDisconnected;

    SAFE_RELEASE(cmSocket);
    if ( hostReachability.currentReachabilityStatus != NotReachable2 )
    {
        //[(AppDelegate*)[UIApplication sharedApplication].delegate retryConnect];
    }
}

- (void)disconnect
{
    /*
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ( version >= 4.2 )
    {
        if ( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined )
        {
            [[ICLocationManger currentManager] stop];
        }
    }*/
    [cmSocket setDelegate:nil];
    [cmSocket disconnect];
    SAFE_RELEASE(cmSocket);
    _status = ICCommunicationStatusDisconnected; 
}

- (BOOL)isConnected
{
    if ( cmSocket && _status == ICCommunicationStatusConnected)
    {
        return [cmSocket isConnected];
    }
    
    return FALSE;
}

- (BOOL) isNetworkReachability
{
    return hostReachability.currentReachabilityStatus;
}

- (void) reachabilityChanged: (NSNotification* )note
{
#if 1
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    if (curReach.currentReachabilityStatus != NotReachable2)
    {
         if (_status != ICCommunicationStatusConnected) 
         {
             _status = ICCommunicationStatusConnected;
             [[NSNotificationCenter defaultCenter] postNotificationName: kICCommunicationManagerStatusChanged object: self userInfo: [NSDictionary dictionaryWithObject: @"connected" forKey: @"status"]];
         }
        NSLog(@"====reachabilityChanged  Reachable=====");
    }
    else
    {
        _status = ICCommunicationStatusDisconnected;
        [[NSNotificationCenter defaultCenter] postNotificationName: kICCommunicationManagerStatusChanged object: self userInfo: [NSDictionary dictionaryWithObject: @"disconnected" forKey: @"status"]];
        NSLog(@"====reachabilityChanged  NotReachable=====");
    }
#endif
}

@end
