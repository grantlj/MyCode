#include"ImageSet.h"


Point2f calc_k_b(Point2f & p1, Point2f & p2);
bool judge_point_locate(Point2f &point, Point2f & kb);





ImageSet::ImageSet(Mat & SourceImage)
{
	
	//calculate parameter  x->a   y->b
	Point2f Red1 = Point2f(100, 255);
	Point2f Red2 = Point2f(200, 0);
	Point2f Green1 = Point2f(100, 255);
	Point2f Green2 = Point2f(20, 0);

	Point2f RedParameter_kb = calc_k_b(Red1, Red2);
	Point2f GreenParameter_kb = calc_k_b(Green1, Green2);



	//parameter
	uchar LightnessThreshold = 120;
	float SideRateThreshold = 1.5; 
	unsigned int  PointNumMinThreshold = 15;
	unsigned int PointNumMaxThreshold = 3000;


	
	//转换到LAB颜色空间
	cvtColor(SourceImage, LabImage, CV_BGR2Lab);

	unsigned int Rows = SourceImage.rows;
	unsigned int Cols = SourceImage.cols;
	unsigned int Width = Cols*SourceImage.channels();

	//分解到L、a、b三个通道
	LChannel = Mat(Rows, Cols, CV_8UC1);
	aChannel = Mat(Rows, Cols, CV_8UC1);
	bChannel = Mat(Rows, Cols, CV_8UC1);
	RedImage = Mat(Rows, Cols, CV_8UC1);
	GreenImage = Mat(Rows, Cols, CV_8UC1);

	for (unsigned int r = 0; r < Rows; r++)
	{
		uchar *PtrLab = LabImage.ptr<uchar>(r);
		uchar *PtrL = LChannel.ptr<uchar>(r);
		uchar *Ptra = aChannel.ptr<uchar>(r);
		uchar *Ptrb = bChannel.ptr<uchar>(r);
		uchar *PtrRed = RedImage.ptr<uchar>(r);
		uchar *PtrGreen = GreenImage.ptr<uchar>(r);
		for (unsigned int w = 0, c = 0; w < Width; w += 3, c++)
		{
			uchar aVal = PtrLab[w + 1];
			uchar bVal = PtrLab[w + 2];
			PtrL[c] = PtrLab[w];
			Ptra[c] = aVal;
			Ptrb[c] = bVal;
			
			//判断红色区域
			Point2f abVal = Point2f(float(aVal), float(bVal));
			if (judge_point_locate(abVal, RedParameter_kb))
				PtrRed[c] = 255;
			else
				PtrRed[c] = 0;
			
				
				
			//判断绿色区域
			if (judge_point_locate(abVal, GreenParameter_kb))
				PtrGreen[c] = 255;
			else
				PtrGreen[c] = 0;
		}

	}

	

	//亮度归一化
	NomalizeMat(LChannel);


	

	

	//首先处理红色
	my_dilate_erode(true, 3, MORPH_ELLIPSE, RedImage);
	imwrite("red_1.jpg", RedImage);
	imFillHoles(RedImage);
	imwrite("red_2.jpg", RedImage);
	my_dilate_erode(false, 6, MORPH_ELLIPSE, RedImage);
	imwrite("red_3.jpg", RedImage);
	my_dilate_erode(true, 3, MORPH_ELLIPSE, RedImage);
	imwrite("red_4.jpg", RedImage);
	

	addLightnessFactor(RedImage, LChannel, LightnessThreshold);

	//debug
	imwrite("red_L.jpg", RedImage);

	
	Mat CloneRedRegion;
	RedImage.copyTo(CloneRedRegion);
	vector<vector<Point>> RedContours;
	findContours(CloneRedRegion, RedContours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
	
	for (int c = 0; c < RedContours.size(); c++)
	{
		Rect Re = boundingRect(Mat(RedContours[c]));
		double Area;
		//判断是否生成子区域
		if (isCreateSubRegion(RedContours[c], Re,RedImage, Area, SideRateThreshold, PointNumMinThreshold, PointNumMaxThreshold))
		{
			SubRegion *NewSrp = new SubRegion(Re, "red", Area, RedImage, SourceImage);
			SubRegions.push_back(NewSrp);
			

		}
	}

	//然后首先处理绿色
	my_dilate_erode(true, 3, MORPH_ELLIPSE, GreenImage);
	imFillHoles(RedImage);
	my_dilate_erode(false, 6, MORPH_ELLIPSE, GreenImage);
	my_dilate_erode(true, 3, MORPH_ELLIPSE, GreenImage);
	addLightnessFactor(GreenImage, LChannel, LightnessThreshold);
	Mat CloneGreenRegion;
	GreenImage.copyTo(CloneGreenRegion);
	vector<vector<Point>> GreenContours;
	findContours(CloneGreenRegion, GreenContours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
	
	for (int c = 0; c < GreenContours.size(); c++)
	{
		Rect Re = boundingRect(Mat(GreenContours[c]));
		double Area;
		//判断是否生成子区域
		if (isCreateSubRegion(GreenContours[c], Re, GreenImage, Area, SideRateThreshold, PointNumMinThreshold, PointNumMaxThreshold))
		{
			SubRegion *NewSrp = new SubRegion(Re, "green", Area, GreenImage, SourceImage);
			SubRegions.push_back(NewSrp);
		}
	}

	
	//debug result
	SourceImage.copyTo(HandledImage);
	for (int i = 0; i < SubRegions.size(); i++)
	{
		if (SubRegions[i]->isSquare)
		{
			if (SubRegions[i]->Tag == "red")
			{
				polylines(HandledImage, SubRegions[i]->TrafficLight, true, Scalar(0, 0, 255), 3);
				putText(HandledImage, "Red", Point(int(SubRegions[i]->Centroid.x), int(SubRegions[i]->Centroid.y)), FONT_HERSHEY_PLAIN, 1, Scalar(0, 0, 255));
			}
			else if (SubRegions[i]->Tag == "green")
			{
				polylines(HandledImage, SubRegions[i]->TrafficLight, true, Scalar(0, 255, 0), 3);
				putText(HandledImage, "Green", Point(int(SubRegions[i]->Centroid.x), int(SubRegions[i]->Centroid.y)), FONT_HERSHEY_SIMPLEX, 1, Scalar(0, 255, 0));
			}
			
		}
	}
	

}


void ImageSet::imFillHoles(Mat &Image)
{
	// detect external contours
	vector<vector<Point>> contours;
	vector<Vec4i> hierarchy;
	findContours(Image, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);

	// fill external contours
	//
	if (!contours.empty() && !hierarchy.empty())
	{
		for (int idx = 0; idx < contours.size(); idx++)
		{
			drawContours(Image, contours, idx, Scalar::all(255), CV_FILLED, 8);
		}
	}
}


bool ImageSet::isCreateSubRegion(vector<Point> & contour,const Rect & Re, Mat & BinaryImage, double &Area, float SideRateThreshold, unsigned int PointNumMinThreshold, unsigned int PointNumMaxThreshold)
{
	Area = 0;
	unsigned int Rx = Re.x;
	unsigned int Ry = Re.y;
	unsigned int Rheight = Re.height;
	unsigned int Rwidth = Re.width;

	//判断长边比短边
	float SideRate;
	if (Rheight > Rwidth)
		SideRate = 1.0*Rheight / Rwidth;
	else
		SideRate = 1.0*Rwidth / Rheight;

	if (SideRate > SideRateThreshold)
	{
		return false;
	}
	else
	{
		//计算面积
		Area = contourArea(contour, false);
		if (Area<PointNumMinThreshold || Area>PointNumMaxThreshold)
			return false;
		else
			return true;
	}

	

}


void ImageSet::addLightnessFactor(Mat & BinaryImage, Mat &LChannel,uchar LightnessThreshold)
{
	unsigned int Rows = BinaryImage.rows;
	unsigned int Cols = BinaryImage.cols;
	for (unsigned int r = 0; r < Rows; r++)
	{
		uchar *PtrBI = BinaryImage.ptr<uchar>(r);
		uchar *PtrL = LChannel.ptr<uchar>(r);
		for (unsigned int c = 0; c < Cols; c++)
		if (PtrL[c] < LightnessThreshold)
			PtrBI[c] = 0;
	}
}


void ImageSet::NomalizeMat(Mat & Matrix)
{
	uchar MaxVal = 0;
	uchar MinVal = 255;
	unsigned int Rows = Matrix.rows;
	unsigned int Cols = Matrix.cols;
	for (unsigned int r = 0; r < Rows; r++)
	{
		uchar *PtrM = Matrix.ptr<uchar>(r);
		for (unsigned int c = 0; c < Cols; c++)
		{
			uchar Val = PtrM[c];
			if (Val < MinVal)
				MinVal = Val;
			if (Val>MaxVal)
				MaxVal = Val;
		}
	}
	uchar DiVal = MaxVal - MinVal;
	for (unsigned int r = 0; r < Rows; r++)
	{
		uchar *PtrM = Matrix.ptr<uchar>(r);
		for (unsigned int c = 0; c < Cols; c++)
		{
			PtrM[c] = uchar(255.0*(PtrM[c] - MinVal) / DiVal);	
		}
	}


}


//根据两点算斜率
Point2f calc_k_b(Point2f & p1, Point2f & p2)
{
	float k = (p1.y - p2.y) / (p1.x - p2.x);
	float a = p1.y - p1.x*k;
	return Point2f(k, a);
	
}


bool judge_point_locate(Point2f &point, Point2f & kb)
{
	if (point.y - kb.x*point.x > kb.y)
		return true;
	else
		return false;
}

void ImageSet::my_dilate_erode(bool isdilate, unsigned int  dilation_size, int Type_MORPH, Mat & BinaryImage)
{
	Mat element = getStructuringElement(Type_MORPH,
		Size(2 * dilation_size + 1, 2 * dilation_size + 1),
		Point(dilation_size, dilation_size));
	if (isdilate)
	{
		dilate(BinaryImage, BinaryImage, element);
	}
	else
	{
		erode(BinaryImage, BinaryImage, element);
	}

}

ImageSet::~ImageSet()
{

}