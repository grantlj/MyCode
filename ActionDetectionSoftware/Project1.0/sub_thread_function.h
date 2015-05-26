#ifndef SUB_THREAD_FUNCTION_H_
#define SUB_THREAD_FUNCTION_H_

#include"thread.h"
#include"words_svm.h"
#include"feature.h"
#include"other.h"
#include"people_detector.h"

#include<iostream>
#include<Windows.h>



//´¦Àíº¯Êý
DWORD WINAPI ThreadProcess_Words_SVM(LPVOID lpParam);
DWORD WINAPI ThreadProcess_PeopleDetector(LPVOID lpParam);








#endif