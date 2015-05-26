#ifndef VIDEO_WRITER_H_
#define VIDEO_WRITER_H_

#include<iostream>
#include<string>

#include<cv.h>
#include<cxcore.h>
#include<highgui.h>

using std::string;

class VideoWriter
{
public:
	CvVideoWriter * Writer;

public:
	VideoWriter(CvSize  VideoSize);
	VideoWriter::VideoWriter(CvSize  VideoSize, const char * FileName);
	~VideoWriter();


	//ÐÐÎª
	void write_frame(IplImage * Frame);

private:

};



#endif