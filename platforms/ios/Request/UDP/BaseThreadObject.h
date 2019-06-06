#ifndef YUNIO_BaseThreadObject_h
#define YUNIO_BaseThreadObject_h
#ifdef WIN32
#include <windows.h>
#else
#include <pthread.h>
#endif

class BaseThreadObjectCallback;

typedef enum 
{
    BaseThreadObjectStateInvalid,
    BaseThreadObjectStateRunning,
    BaseThreadObjectStateStopped,
}BaseThreadObjectState;

class BaseThreadObject
{
public:
    BaseThreadObject(void* userData);
    virtual ~BaseThreadObject();
    virtual bool start();
    virtual void stop() = 0;
    virtual void detach();
    virtual bool wait(int millisecond = 2000, bool cancelOnTimeout = true);
    virtual void cancel();
    virtual void readyToWait();
    virtual void testCancel();
#ifdef WIN32
	friend DWORD  WINAPI baseThreadObjectThreadFunc(LPVOID param);
#else
    friend void* baseThreadObjectThreadFunc(void*);
#endif
    BaseThreadObjectState getState(){return _state;}
    void setCallback(BaseThreadObjectCallback* callback){_callback = callback;}
    void* _userData;   
    bool getIsDetached(void);
protected:
    virtual void run() = 0;

    bool    isDetached;
    bool    needJoin;
    BaseThreadObjectState _state;
    BaseThreadObjectCallback* _callback;


#ifdef WIN32
	HANDLE _thread;
#else
    pthread_t _thread;
    pthread_cond_t _finishCond;
    pthread_mutex_t _condMutex;
#endif
};

class BaseThreadObjectCallback
{
public:
    virtual ~BaseThreadObjectCallback(){};
    virtual void onStateChanged(BaseThreadObjectState state, bool isDetach, void* userData) = 0;
};

#endif
