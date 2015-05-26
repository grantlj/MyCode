#include"Camera.h"


Camera::Camera()
{
	CameraCapture = cvCreateCameraCapture(CV_CAP_DSHOW);

}

Camera::Camera(int CameraIndex, double Magnification)
{
	CameraCapture = cvCreateCameraCapture(CV_CAP_DSHOW+ CameraIndex);
	cvSetCaptureProperty(CameraCapture, CV_CAP_PROP_FRAME_HEIGHT, (int)cvGetCaptureProperty(CameraCapture, CV_CAP_PROP_FRAME_HEIGHT)*Magnification);
	cvSetCaptureProperty(CameraCapture, CV_CAP_PROP_FRAME_WIDTH, (int)cvGetCaptureProperty(CameraCapture, CV_CAP_PROP_FRAME_WIDTH) *Magnification);
}

Camera::Camera(const char * VideoFileName)
{
	CameraCapture = cvCreateFileCapture(VideoFileName);
}


IplImage * Camera::updata_NowFrame()
{
	NowFrame = cvQueryFrame(CameraCapture);
	return NowFrame;
}

CvSize Camera::get_capture_size() const
{
	return cvSize(
		(int)cvGetCaptureProperty(CameraCapture, CV_CAP_PROP_FRAME_WIDTH),
		(int)cvGetCaptureProperty(CameraCapture, CV_CAP_PROP_FRAME_HEIGHT)
		);
}

IplImage * Camera::get_NowFrame() const
{
	return NowFrame;
}


//ÐÐÎª
char Camera::show_NowFrame(const char * WindowName,int WaitNms)
{
	cvShowImage(WindowName, NowFrame);
	char c = cvWaitKey(WaitNms);
	return c;
}


Camera::~Camera()
{
	cvReleaseCapture(&CameraCapture);
	//cvReleaseImage(&NowFrame);
}