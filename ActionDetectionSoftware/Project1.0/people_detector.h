#ifndef PEOPLE_DETECTOR_H_
#define PEOPLE_DETECTOR_H_

#include"other.h"

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
//#include <opencv2/gpu/gpu.hpp>
#include <highgui.h>
#include <cxcore.h>
#include <cv.h>

#include<vector>

using std::vector;
using cv::HOGDescriptor;
using cv::Rect;
using cv::Mat;

class PeopleDector
{
	HOGDescriptor DefaultHog;
	vector<Rect> Found, FoundRect;
	IplImage * Image;
public:
	PeopleDector();
	~PeopleDector();
	void people_detect(AllResult & MyResult);
	void prepare_Image(IplImage * Copy);
private:

};



#endif