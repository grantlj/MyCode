#include<iostream>
#include<string>
#include<vector>

#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>

#include"ImageSet.h"
#include"SubRegion.h"

using namespace cv;
using std::string;
using std::vector;
using std::endl;
using std::cout;

int indexAll = 0;

int main()
{
	if (true)
	{
		string FileName = "demo.jpg"; //"E:/DIP/tl/4.jpg";
		Mat Frame=imread(FileName);
		ImageSet * is = new ImageSet(Frame);
		ImageSet * NowSet = new ImageSet(Frame);
		imshow("Traffic Light Detection", NowSet->HandledImage);
		

		imwrite("TrafficLightDetection.jpg", NowSet->HandledImage);
		delete NowSet;
		waitKey(0);
	}
	else
	{
		VideoCapture Camera = VideoCapture(0);
		Mat Frame;
		namedWindow("Traffic Light Detection");
		while (true)
		{
			Camera >> Frame;

			ImageSet * NowSet = new ImageSet(Frame);

			imshow("Traffic Light Detection", NowSet->HandledImage);
			delete NowSet;
			waitKey(10);
		}
	}
  	


	
	
	

	
	return 0;
}