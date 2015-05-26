#include"thread.h"

using std::cout;
using std::endl;



SubThread::SubThread(LPTHREAD_START_ROUTINE ThreadProcess)
{
	isSubThreadBuzy = false; //���߳��Ƿ�æ���
	isNeedHandle = false;    //�Ƿ���������Ҫ������

	CreateThread(
		NULL,              // default security attributes
		0,                 // use default stack size  
		ThreadProcess,        // thread function 
		NULL,             // argument to thread function 
		0,                 // use default creation flags 
		NULL);

	InitializeCriticalSection(&g_cs);
}


//set
void SubThread::set_isSubThreadBuzy(bool in)
{ 
	EnterCriticalSection(&g_cs);
	isSubThreadBuzy = in; 
	LeaveCriticalSection(&g_cs);
}
void SubThread::set_isNeedHandle(bool in)
{ 
	EnterCriticalSection(&g_cs);
	isNeedHandle = in; 
	LeaveCriticalSection(&g_cs);
}


SubThread::~SubThread()
{
	isSubThreadBuzy = false; //���߳��Ƿ�æ���
	isNeedHandle = false;    //�Ƿ���������Ҫ������
}










