#ifndef LANMULTICASTSERVER_H
#define LANMULTICASTSERVER_H

#include "BaseThreadObject.h"

class LanMulticastServer : public BaseThreadObject
{
public:
	LanMulticastServer(const char* ip = "234.5.6.7", short port = 7788);
	~LanMulticastServer();
	bool start();
	void stop();
	void run();
protected:
	int socketFD;
	char* _ip;
    short _port;
	bool goOn;
	char* buffer;
    int usedBufferSize;
};


#endif