//
//  BNUdpBroadCast.cpp
//  WeiReport
//
//  Created by jimmy on 14-8-15.
//
//

#include "BNUdpBroadcast.h"

#include <iostream>
#include <string>
#ifdef WIN32
//#define _WINSOCKAPI_
#include <Winsock2.h>
#include <Ws2tcpip.h>
#include <io.h>
#include <sys/types.h>
#include <sys/stat.h>
#define lseek64 _lseeki64
#define close _close
#define read _read
#define write _write
#define strdup _strdup
#define socklen_t int
#define bzero ZeroMemory
#define ioctl ioctlsocket
#define sleep(sec) Sleep((sec) * 1000)
#else
#include <sys/select.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <sys/ioctl.h>
#include <unistd.h>
#define closesocket close
#define Sleep(ms) usleep((ms * 1000))
#endif

#ifdef __DARWIN_UNIX03
#define lseek64 lseek
#endif

#if defined(ANDROID) || defined(TARGET_OS_EMBEDDED) || defined(TARGET_OS_IPHONE) || defined(__arm__)
#define  LAN_MOBILE_DEVICE 1
#endif

#ifdef WIN32
#define IS_SOCKET_BUSY WSAGetLastError() == WSAEWOULDBLOCK
#else
#define IS_SOCKET_BUSY errno == EAGAIN
#endif

#ifdef ANDROID
#include <sys/stat.h>
#include <android/log.h>
#define LanLog(...) __android_log_print(ANDROID_LOG_INFO, "LanLog",__VA_ARGS__)
#elif defined(WIN32)
#include <tchar.h>
#include <windows.h>
#define LanLog(...) \
do {char __LanLogBuf[1024] = {0}; \
sprintf(__LanLogBuf, __VA_ARGS__); \
OutputDebugStringA(__LanLogBuf);}while(0);

#else
#include <stdio.h>
#define LanLog(...) printf(__VA_ARGS__);
#endif

#include <fcntl.h>
#include <errno.h>

typedef struct socket_io_t
{
	socket_io_t()
    :fd_socket(0)
    , fd_file(0)
    , sent(0)
    , hash("")
	{
        
	}
	int fd_socket;
	int fd_file;
	std::string hash;
	unsigned long long sent;
}socket_io_t;

void BNUdpBroadcast::sendBroadcast(const char* josnString, const char* ipAddress, int port)
{
    struct sockaddr_in local_addr;
	int socketFD;
    
    int yes = 1;
    int loop = 0;
   
    if ((socketFD = socket(AF_INET,SOCK_DGRAM,0)) < 0)
    {
        goto failed;
    }
    if (setsockopt(socketFD,SOL_SOCKET,SO_REUSEADDR,(char *)&yes,sizeof(yes)) < 0)
    {
        goto failed;
    }
    memset(&local_addr, 0, sizeof(local_addr));
    local_addr.sin_family = AF_INET;
    local_addr.sin_port = htons(port);
	setsockopt(socketFD, IPPROTO_IP, IP_MULTICAST_LOOP, (char *)&loop, sizeof(loop));
	local_addr.sin_addr.s_addr = inet_addr(ipAddress);
    
    if (sendto(socketFD, josnString, strlen(josnString), 0, (struct sockaddr *)&local_addr, (socklen_t)sizeof(local_addr)) < 0)
    {
        
    }
    
    closesocket(socketFD);
    
    return;
failed:
    if (socketFD > 0)
    {
        closesocket(socketFD);
        socketFD = -1;
    }
}
