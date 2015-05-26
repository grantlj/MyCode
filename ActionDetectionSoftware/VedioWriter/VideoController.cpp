#include"VideoController.h"



#include<iostream>
#include<fstream>
#include<ctime>
#include<Windows.h>
using namespace std;


string num2str(int num);
string time2str();

VideoController::VideoController(const char * MapFileName,const char * FolderFileName)
{
	isNeedRecord = false;

	ifstream FileInStream;
	FileInStream.open(MapFileName);
	//循环读取
	while (true)
	{
		Map * NowMap = new Map;
		FileInStream >> NowMap->index;
		FileInStream >> NowMap->ActionName;
		if (FileInStream)
			MapVector.push_back(*NowMap);
		else
		{
			delete NowMap;
			break;
		}
	}
	FileInStream.close();

	FileInStream.open(FolderFileName);
	FileInStream >> OutFileFolder;
	FileInStream.close();

	//
	OutFileName = "No output to a file";
	Font = new CvFont;
	cvInitFont(Font, CV_FONT_HERSHEY_SIMPLEX, 0.5, 0.5);

}

void VideoController::create_new_VideoWriter(char KeyIndex, CvSize VideoSize, VideoWriter * &Writer)
{
	//没有按键
	if (KeyIndex == -1) return;
	delete Writer;
	bool HaveNoMap = true;
	for (unsigned int i = 0; i < MapVector.size(); i++)
	if (KeyIndex == MapVector[i].index)
	{
		isNeedRecord = true;
		HaveNoMap = false;
		OutFileName = MapVector[i].ActionName + time2str() + ".avi";

		Writer = new VideoWriter(VideoSize, ( OutFileFolder+OutFileName).data());
		break;			
	}
	if (HaveNoMap)
	{
		isNeedRecord = false;
		OutFileName = "No output to a file";
		Writer = nullptr;
	}
	
}

void VideoController::print_OutFileName(IplImage * Frame)
{
	cvPutText(Frame, OutFileName.data(), cvPoint(0, 20), Font, CV_RGB(255, 0, 0));
}


VideoController::~VideoController()
{
	int MapNum = (int)MapVector.size();
	MapVector.clear();
	//for (; MapNum > 0; MapNum--)
	//{
	//	delete &MapVector[MapNum - 1];
	//	MapVector.pop_back();
	//}
}




string num2str(int num)
{
	int t = num;
	//判断位数
	int wei;
	for (int i = 1;; i++)
	{
		if (num / (int)pow(10, i) == 0)
		{
			wei = i;
			break;
		}
	}

	char * str = new char[wei + 1];
	str[wei] = '\0';
	for (int i = wei - 1; i >= 0; i--)
	{
		str[i] = t % 10 + 48;
		t /= 10;
	}

	return str;
}


string time2str()
{
	string TimeString;
	SYSTEMTIME sys;
	GetLocalTime(&sys);
	

	TimeString = num2str(sys.wYear);
	if (sys.wMonth < 10)
		TimeString = TimeString + "0";
	TimeString = TimeString + num2str(sys.wMonth);

	if (sys.wDay < 10)
		TimeString = TimeString + "0";
	TimeString = TimeString + num2str(sys.wDay);


	if (sys.wHour < 10)
		TimeString = TimeString + "0";
	TimeString = TimeString + num2str(sys.wHour);

	if (sys.wMinute < 10)
		TimeString = TimeString + "0";
	TimeString = TimeString + num2str(sys.wMinute);

	if (sys.wSecond < 10)
		TimeString = TimeString + "0";
	TimeString = TimeString + num2str(sys.wSecond);


	return TimeString;

}
