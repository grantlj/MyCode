#ifndef THREAD_H_
#define THREAD_H_




#include<iostream>
#include<Windows.h>
#include<cv.h>
#include<cxcore.h>



class SubThread
{
	CRITICAL_SECTION g_cs;
	bool isSubThreadBuzy; //子线程是否繁忙标记
	bool isNeedHandle;    //是否有数据需要处理标记
public:
	SubThread(LPTHREAD_START_ROUTINE ThreadProcess);
	~SubThread();

	void enter_CriticalSection(){ EnterCriticalSection(&g_cs); }
	void leave_CriticalSection(){ LeaveCriticalSection(&g_cs); }
	//set
	void set_isSubThreadBuzy(bool in);
	void set_isNeedHandle(bool in);
	//get
	bool get_isSubThreadBuzy() const{ return isSubThreadBuzy; }
	bool get_isNeedHandle()const { return isNeedHandle; }

	
private:

};



#endif