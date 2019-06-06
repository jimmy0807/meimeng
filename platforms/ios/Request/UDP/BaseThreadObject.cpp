#include <iostream>
#include <errno.h>
#include "BaseThreadObject.h"

#ifdef WIN32
DWORD WINAPI baseThreadObjectThreadFunc(LPVOID param);
#else
void* baseThreadObjectThreadFunc(void*);
#endif

BaseThreadObject::BaseThreadObject(void* userData)
: _thread(NULL)
, isDetached(false)
, _state(BaseThreadObjectStateInvalid)
, _userData(userData)
, needJoin(false)
, _callback(NULL)
{
#ifndef WIN32 
    pthread_cond_init(&_finishCond, NULL);
    pthread_mutex_init(&_condMutex,  NULL);
#endif
}

BaseThreadObject::~BaseThreadObject()
{
#ifndef WIN32 
    pthread_cond_destroy(&_finishCond);
    pthread_mutex_destroy(&_condMutex);
#endif
}

bool BaseThreadObject::start()
{
    if (_thread) 
    {
        return true;
    }

    needJoin = false;
    _state = BaseThreadObjectStateRunning;
    if (_callback) 
    {
        _callback->onStateChanged(_state, isDetached, _userData);
    }
#ifdef WIN32
	_thread = CreateThread(NULL, 0, baseThreadObjectThreadFunc, this, 0, NULL);
#else
    pthread_create(&_thread, NULL, &baseThreadObjectThreadFunc, this);
//    struct sched_param sp;
//    int policy = SCHED_RR;
//    pthread_getschedparam(_thread, &policy, &sp);
//    sp.sched_priority = sched_get_priority_max(SCHED_RR);
//    pthread_setschedparam(_thread, SCHED_RR, &sp);
#endif
    return true;
}

bool BaseThreadObject::wait(int millisecond, bool cancelOnTimeout)
{
    if (!isDetached && _thread) 
    {
#ifdef WIN32
		DWORD e = WaitForSingleObject(_thread, millisecond);
		if (e == WAIT_OBJECT_0)
		{
			CloseHandle(_thread);
			_thread = NULL;
		}
#else
        struct timespec to;
        to.tv_sec = time(NULL) + millisecond / 1000; 
        to.tv_nsec = (millisecond % 1000) * 1000; 
        pthread_mutex_lock(&_condMutex);
        int e = pthread_cond_timedwait(&_finishCond, &_condMutex, &to);
        pthread_mutex_unlock(&_condMutex);
		if (e == 0) 
		{
			pthread_join(_thread, NULL);
			_thread = NULL;
			return true;
		}
#endif
        else if (cancelOnTimeout)
        {
            this->cancel();
            return true;
        }
        return false;
    }    
    return false;
}

void BaseThreadObject::cancel()
{
	if (_thread)
	{
#ifdef WIN32
		TerminateThread(_thread, 0);
		CloseHandle(_thread);
#elif defined(ANDROID)
        pthread_kill(_thread, 0);
#else
		pthread_cancel(_thread);
#endif
		_thread = NULL;
	}
}


void BaseThreadObject::readyToWait()
{
    needJoin = true;
}

void BaseThreadObject::detach()
{
	if (_thread)
	{
#ifdef WIN32
		CloseHandle(_thread);
#else
		pthread_detach(_thread);
#endif
		_thread = NULL;
	}
    isDetached = true;
}

bool BaseThreadObject::getIsDetached()
{
    return isDetached || _thread == NULL;
}

#ifdef WIN32
DWORD WINAPI baseThreadObjectThreadFunc(LPVOID param)
#else
void* baseThreadObjectThreadFunc(void* param)
#endif
{
    BaseThreadObject* thread = static_cast<BaseThreadObject*>(param);
    thread->run();
    if (thread->isDetached) 
    {
        delete thread;
    }
    else 
    {
        if (!thread->needJoin)
        {
            thread->detach();          
        }
        thread->_state = BaseThreadObjectStateStopped;  
        if (thread->_callback) 
        {
            thread->_callback->onStateChanged(thread->_state, thread->isDetached, thread->_userData);
        }
#ifndef WIN32
        pthread_mutex_lock(&thread->_condMutex);
        pthread_cond_broadcast(&thread->_finishCond);
        pthread_mutex_unlock(&thread->_condMutex);  
#endif
    }
    return 0;
}

void BaseThreadObject::testCancel()
{
#if !defined(WIN32) && !defined(ANDROID)    
    pthread_testcancel();
#endif
}
