#ifndef THREAD_H_
#define THREAD_H_




#include<iostream>
#include<Windows.h>
#include<cv.h>
#include<cxcore.h>



class SubThread
{
	CRITICAL_SECTION g_cs;
	bool isSubThreadBuzy; //���߳��Ƿ�æ���
	bool isNeedHandle;    //�Ƿ���������Ҫ������
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