#ifndef OTHER_H_
#define OTHER_H_


#include<iostream>
#include<string>
#include<cv.h>
#include<cxcore.h>
#include<ctime>

using std::cin;
using std::cout;
using std::endl;
using std::string;
using std::clock;

class Parameter
{
	unsigned int SlidingWindowLength;
	unsigned int SlideDistance;
	unsigned int MinimumLoopTime;

public:
	Parameter(const char * ParameterFile);
	Parameter(){ SlidingWindowLength = 25; SlideDistance = 8; MinimumLoopTime = 50; }
	~Parameter(){}
	unsigned int get_SlidingWindowLength() const { return SlidingWindowLength; }
	unsigned int get_SlideDistance() const { return SlideDistance; }
	unsigned int get_MinimumLoopTime() const { return MinimumLoopTime; }


private:

};




class AllResult
{
	string ActionMessage;
	
	CvPoint CatchFrame[4];
	int PointNum;
	CvFont * ActionMessageFont;
	CvFont * FpsFont;
	CvPoint *CatchFramePoint[4];
	unsigned long long ProgramCounter;
	unsigned short Fps;
	unsigned long long LoopStartTime;
	unsigned long long LoopEndTime;

	//运行控制成员函数
		

public:
	AllResult();
	~AllResult();
	void process_vedio_frame(IplImage * Image);
	void set_Fps(unsigned short Fps) { this->Fps = Fps; }
	void set_ActionMessage(string str){ ActionMessage = str; }
	void set_LoopStartTime(){ LoopStartTime = clock(); }
	void set_LoopEndTime(){ LoopEndTime = clock(); calculate_fps(); }
	

	
	unsigned long long get_ProgramCounter() const{ return ProgramCounter; }
	void set_CatchFrame_Points(CvPoint Point, unsigned int width, unsigned int height);//接口
	
	//运行控制
	int calculate_need_wait(unsigned int MinWaitTime);
private:
	void calculate_fps(){ if( ProgramCounter%5==0 ) Fps = short(1000.0 / (LoopEndTime - LoopStartTime)); }
};






#endif