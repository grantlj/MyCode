#include"videoWriter.h"



VideoWriter::VideoWriter(CvSize  VideoSize)
{
	Writer = cvCreateVideoWriter("text.avi", CV_FOURCC('M', 'J', 'P', 'G'), 30, VideoSize);
}


VideoWriter::VideoWriter(CvSize  VideoSize, const char * FileName)
{
	Writer = cvCreateVideoWriter(FileName, CV_FOURCC('M', 'J', 'P', 'G'), 30, VideoSize);
}

void VideoWriter::write_frame(IplImage * Frame)
{
	cvWriteFrame(Writer, Frame);
}


VideoWriter::~VideoWriter()
{
	cvReleaseVideoWriter(&Writer);
}
