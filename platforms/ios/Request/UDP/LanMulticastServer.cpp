#include "LanMulticastServer.h"
#include "LanControlServerCallback.h"

#include <iostream>
#include <string>
#include <sys/select.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <sys/ioctl.h>
#include <unistd.h>
#define closesocket close
#define Sleep(ms) usleep((ms * 1000))

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

LanMulticastServer::LanMulticastServer(const char* ip, short port)
: BaseThreadObject(NULL)
, _port(port)
, socketFD(-1)
{
	_ip = strdup(ip);
}

LanMulticastServer::~LanMulticastServer()
{
	free(_ip);
	delete []buffer;
}

bool LanMulticastServer::start()
{
	u_char loop = 0;
    u_int yes=1;   
    int ret = 0;
    struct sockaddr_in local_addr;  
    struct ip_mreq mreq;  
    if (socketFD > 0) 
    {
        return true;
    }
    buffer = new char[1024];
    if ((socketFD = socket(AF_INET,SOCK_DGRAM,0)) < 0)   
    {
        LanLog("Failed to create socket\n");
        goto failed;
    }
    if (setsockopt(socketFD,SOL_SOCKET,SO_REUSEADDR,(const char *)&yes,sizeof(yes)) < 0)     
    {   
		LanLog("Reusing ADDR failed\n");
        goto failed;  
    }  
    memset(&local_addr, 0, sizeof(local_addr)); 
    local_addr.sin_port = htons(_port);
    local_addr.sin_family = AF_INET;  
    setsockopt(socketFD, IPPROTO_IP, IP_MULTICAST_LOOP,(const char *) &loop, sizeof(loop)); 
  
    local_addr.sin_addr.s_addr = inet_addr(_ip);
    
    bzero(&mreq, sizeof(struct ip_mreq));
    mreq.imr_multiaddr.s_addr = inet_addr(_ip);    
    mreq.imr_interface.s_addr = INADDR_ANY;   
    ret = setsockopt(socketFD, IPPROTO_IP, IP_ADD_MEMBERSHIP, (char *)&mreq, sizeof(mreq));   
    if (ret < 0) 
    {
        goto failed;
    }
    if (bind(socketFD, (struct sockaddr*)&local_addr, sizeof(struct sockaddr_in)) < 0) 
    {
		LanLog("Failed to bind adress\n");
        goto failed;
    } 

    goOn = true;
    
    run();
    
    return true;

failed:
    if (socketFD > 0) 
    {
		closesocket(socketFD);
        socketFD = -1;
    }
	delete []buffer;
    buffer = NULL;
    return false;
}

void LanMulticastServer::stop()
{
	if (goOn && !this->isDetached) 
    {
        this->readyToWait();
        goOn = false;
        this->wait();
    }
    if (socketFD > 0) 
    {
        closesocket(socketFD);
        socketFD = -1;
    }  
    delete []buffer;
    buffer = NULL;
}

void LanMulticastServer::run()
{
	fd_set rfds;
    struct timeval tv;
    struct sockaddr_in remote_addr;   
    memset(&remote_addr, 0, sizeof(remote_addr));    
    remote_addr.sin_family = AF_INET;    
    remote_addr.sin_addr.s_addr = inet_addr(_ip);;    
    remote_addr.sin_port = htons(_port);  

    int retval = 0;
    int nBytes = 0;
    while (goOn) 
    {
        FD_ZERO(&rfds);
        FD_SET(socketFD, &rfds);
        tv.tv_sec = 1;
        tv.tv_usec = 0;
        retval = select(socketFD + 1, &rfds, NULL, NULL, &tv);
        if (retval < 0)
        {
            goOn = false;
            break;
        }
        else if (retval) 
        {
            socklen_t len = sizeof(remote_addr);
			usedBufferSize = 0;
            while (goOn)
            {
                nBytes = 0;
                memset(buffer, 0x00, 1024);
                ioctl(socketFD, FIONREAD, (u_long *)&nBytes);
                if (nBytes == 0) 
                {
                    break;
                }
                usedBufferSize = 0;
                nBytes = recvfrom(socketFD, buffer + usedBufferSize, nBytes, 0, (struct sockaddr *)&remote_addr, &len);
                usedBufferSize += nBytes;
				//char* _ip = inet_ntoa(remote_addr.sin_addr);
				//tryParseData(buffer, usedBufferSize, std::string(_ip));
                LanControlServerCallback c = LanControlServerCallback();
                c.onReceivePadOrder(buffer);
            }
        }
        else 
        {
            //cout << "no data in 1 s" << endl;
        }
    }
    if (goOn) 
    {
        this->detach();
    }
}
