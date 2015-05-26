#include"people_detector.h"


PeopleDector::PeopleDector()
{
	DefaultHog.setSVMDetector(HOGDescriptor::getDefaultPeopleDetector());
}



void PeopleDector::people_detect(AllResult & MyResult)
{
	
	Mat Frame(Image, 0);
	DefaultHog.detectMultiScale(Frame, Found, 0, cv::Size(8, 8), cv::Size(32, 32), 1.05, 1);
	for (unsigned int i = 0; i < Found.size(); i++)
	{
		Rect r = Found[i];
		unsigned int j = 0;
		for (; j < Found.size(); j++){
			//如果是嵌套的就推出循环
			if (j != i && (r & Found[j]) == r)
				break;
		}
		if (j == Found.size()){
			FoundRect.push_back(r);
		}
	}

	if (FoundRect.size() >= 1)
	{
	Rect r = FoundRect[FoundRect.size()-1];
		r.x += cvRound(r.width*0.1);
		r.width = cvRound(r.width*0.8);
		r.y += cvRound(r.height*0.07);
		r.height = cvRound(r.height*0.8);
		MyResult.set_CatchFrame_Points(cvPoint(r.x, r.y), r.width, r.height);
	}



	
}

void PeopleDector::prepare_Image(IplImage * Copy)
{
	if (Image)
		cvReleaseImage(&Image);
	Image = cvCloneImage(Copy);
	
}


PeopleDector::~PeopleDector()
{
	if (!Image)
		cvReleaseImage(&Image);
	Found.clear();
	FoundRect.clear();
}
