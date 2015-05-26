#include"other.h"
#include"aux_fun.h"

#include<iostream>
#include<fstream>
#include<string>
#include<cv.h>
#include<cxcore.h>

using std::cin;
using std::cout;
using std::endl;
using std::string;
using std::ifstream;


AllResult::AllResult()
{
	ActionMessage = "start";
	Fps = 0;
	LoopEndTime = 1000;
	LoopStartTime = 0;
	PointNum = 4;
	CatchFrame[0] = cvPoint(50, 50); CatchFramePoint[0] = &CatchFrame[0];
	CatchFrame[1] = cvPoint(100, 50); CatchFramePoint[1] = &CatchFrame[1];
	CatchFrame[2] = cvPoint(100, 100); CatchFramePoint[2] = &CatchFrame[2];
	CatchFrame[3] = cvPoint(50, 100); CatchFramePoint[3] = &CatchFrame[3];	
	ProgramCounter = 0;
	//普通字体
	ActionMessageFont = new CvFont;
	cvInitFont(ActionMessageFont, CV_FONT_HERSHEY_SIMPLEX, 1, 1);
	//fps的字体
	FpsFont = new CvFont;
	cvInitFont(FpsFont, CV_FONT_HERSHEY_SIMPLEX, 0.5, 0.5);


}

void AllResult::process_vedio_frame(IplImage * Image)
{
	//程序计数器自加
	ProgramCounter++;
	

	cvPutText(Image, ActionMessage.data(), cvPoint(0, 20), ActionMessageFont, CV_RGB(0, 0, 0));
	cvPutText(Image, (num2str(Fps)+"fps").data(), cvPoint(20, 40), FpsFont, CV_RGB(255, 0, 0)); //打印FPS值
	cvPolyLine(Image, CatchFramePoint, &PointNum, 1, 1, CV_RGB(255, 255, 255));
	
	
}

void AllResult::set_CatchFrame_Points(CvPoint Point, unsigned int width, unsigned int height)
{
	CatchFrame[0].x = Point.x; 
	CatchFrame[0].y = Point.y;
	CatchFrame[1].x = Point.x + width;
	CatchFrame[1].y = Point.y;
	CatchFrame[2].x = Point.x + width;
	CatchFrame[2].y = Point.y + height;
	CatchFrame[3].x = Point.x;
	CatchFrame[3].y = Point.y + height;
}


int AllResult::calculate_need_wait(unsigned int MinWaitTime)
{
	
	unsigned int ThisLoopTime = clock() - LoopStartTime;
	int ThisLoopNeedWaitTime = MinWaitTime - ThisLoopTime;
	if (ThisLoopNeedWaitTime <= 0)
		ThisLoopNeedWaitTime = 1;
	return ThisLoopNeedWaitTime;
}


AllResult::~AllResult()
{
	delete ActionMessageFont;
	delete FpsFont;
}





Parameter::Parameter(const char * ParameterFile)
{
	ifstream FileInStream;
	FileInStream.open(ParameterFile);
	char * buffer = new char[300];
	FileInStream.getline(buffer, 300);
	FileInStream >> SlidingWindowLength >> SlideDistance >> MinimumLoopTime;
	FileInStream.close();
}







