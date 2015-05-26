#ifndef IMAGE_SET_H_
#define IMAGE_SET_H_

#include<string>
#include<vector>

#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>

#include"SubRegion.h"

using namespace cv;
using std::string;
using std::vector;




class ImageSet
{
	//原始图像
	Mat SourceImage;
	Mat LabImage;
	Mat LChannel;
	Mat aChannel;
	Mat bChannel;

	//变换后的图像
	Mat RedImage;
	Mat GreenImage;

	vector<SubRegion *> SubRegions;




public:
	Mat HandledImage;
	ImageSet(Mat & SourceImage);
	~ImageSet();

private:
	void imFillHoles(Mat &Image);
	bool isCreateSubRegion(vector<Point> & contour,const Rect & Re, Mat & BinaryImage, double &Area, float SideRateThreshold, unsigned int PointNumThreshold, unsigned int PointNumMaxThreshold);
	void addLightnessFactor(Mat & BinaryImage, Mat &LChannel, uchar LightnessThreshold);
	void NomalizeMat(Mat & mat);
	void my_dilate_erode(bool isdilate, unsigned int  dilation_size, int Type_MORPH, Mat & BinaryImage);
};



#endif