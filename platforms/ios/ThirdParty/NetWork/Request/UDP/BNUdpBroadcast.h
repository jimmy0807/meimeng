//
//  BNUdpBroadCast.h
//  WeiReport
//
//  Created by jimmy on 14-8-15.
//
//

#ifndef __WeiReport__BNUdpBroadCast__
#define __WeiReport__BNUdpBroadCast__

class BNUdpBroadcast
{
public:
    static void sendBroadcast(const char* josnString, const char* ipAddress = "234.5.6.7", int port = 7788);
};

#endif /* defined(__WeiReport__BNUdpBroadCast__) */
