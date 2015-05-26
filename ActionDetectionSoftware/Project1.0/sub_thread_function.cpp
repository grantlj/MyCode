#include"sub_thread_function.h"



extern Words_SVM MyWord_SVM;
extern AllResult MyAllResult;
extern FeatrueVector ThreadFeatureVector;
extern SubThread MyThread_Words_SVM;
extern PeopleDector MyPeopleDector;
extern SubThread MyThread_PeopleDetector;

//！！！---线程处理函数1.word svm
DWORD WINAPI ThreadProcess_Words_SVM(LPVOID lpParam)
{
	while (true)
	{
		if (MyThread_Words_SVM.get_isNeedHandle())
		{
			cout << "Thread 'SVM WORDS' Handle Start" << endl;
			MyThread_Words_SVM.set_isSubThreadBuzy(true);
			

			MyThread_Words_SVM.enter_CriticalSection();
			MyWord_SVM.bow_svm(ThreadFeatureVector, MyAllResult);
			MyThread_Words_SVM.leave_CriticalSection();

			MyThread_Words_SVM.set_isNeedHandle(false);
			MyThread_Words_SVM.set_isSubThreadBuzy(false);


		}
		else
		{
			Sleep(5);
		}
	}
}


//！！！---线程处理函数PeopleDector
DWORD WINAPI ThreadProcess_PeopleDetector(LPVOID lpParam)
{
	while (true)
	{
		if (MyThread_PeopleDetector.get_isNeedHandle())
		{
			cout << "Thread 'PeopleDetector' Handle Start" << endl;
			MyThread_PeopleDetector.set_isSubThreadBuzy(true);

			MyThread_PeopleDetector.enter_CriticalSection();
			MyPeopleDector.people_detect(MyAllResult);
			MyThread_PeopleDetector.leave_CriticalSection();

			MyThread_PeopleDetector.set_isNeedHandle(false);
			MyThread_PeopleDetector.set_isSubThreadBuzy(false);

		}
		else
		{
			Sleep(100);
		}
	}
	}
	