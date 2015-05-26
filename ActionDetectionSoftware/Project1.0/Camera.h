#ifndef CAMERA_H_
#define CAMERA_H_

#include<iostream>
#include<string>

#include<cv.h>
#include<cxcore.h>
#include<highgui.h>


class Camera
{

	CvCapture * CameraCapture;
	IplImage * NowFrame;
public:
	Camera();
	Camera(int CameraIndex, double Magnification);
	Camera(const char * VideoFileName);
	~Camera();

	IplImage * updata_NowFrame();

	//get
	CvSize get_capture_size() const;
	IplImage * get_NowFrame() const;


	//ÐÐÎª
	char show_NowFrame(const char * WindowName,int WaitNms);
	
private:

};


#endif