#ifndef SUB_REGION_H_
#define SUB_REGION_H_

#include<string>
#include<vector>

#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>



using namespace cv;
using std::string;
using std::vector;




class SubRegion
{
public:
	string Tag;
	string Shape;

	Rect BoundingBox;
	Point2f Centroid;//在整幅图像的位置

	Mat BinaryImage;
	Mat ColorImage;
	
	//test expand sub-region
	Rect ExpandBoundingBox;
	Point2f ExpandCentroid;//在Expand图中的位置
	Mat ExpandBinaryImage;
	Mat ExpandColorImage;
	Mat ExpandGrayImage;
	vector<Point> approxCurve;
	bool isSquare;

	vector<Point> TrafficLight;

public:
	SubRegion();
	SubRegion(Rect BoundingBoxPara, string TagPara,unsigned int AreaPara,Mat & SupBinaryImage,Mat &SupColorImage);
	void findSquareArea(uchar GrayThreshhold);
	~SubRegion();

private:
	
	void imFillHoles(Mat &Image);
	void my_dilate_erode(bool isdilate, unsigned int  dilation_size, int Type_MORPH, Mat & BinaryImage);
	void NomalizeMat(Mat & Matrix);
};





#endif