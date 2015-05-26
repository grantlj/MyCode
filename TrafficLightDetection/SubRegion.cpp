#include"SubRegion.h"

extern int indexAll;

string num2string(unsigned int i)
{
	//iΪ��λ��
	String res = "00";
	int shi = i / 10;
	int ge = i % 10;
	res[0] = shi + 48;
	res[1] = ge + 48;
	return res;
}


SubRegion::SubRegion()
{
	Tag = "blank";
}

SubRegion::SubRegion(Rect BoundingBoxPara, string TagPara, unsigned int AreaPara, Mat & SupBinaryImage, Mat &SupColorImage)
{

	
	
	unsigned int Rows = SupBinaryImage.rows;
	unsigned int Cols = SupBinaryImage.cols;

	unsigned int Rx = BoundingBoxPara.x;
	unsigned int Ry = BoundingBoxPara.y;
	unsigned int Rheight = BoundingBoxPara.height;
	unsigned int Rwidth = BoundingBoxPara.width;
	Tag = TagPara;
	Shape = "unknown";
	BoundingBox = BoundingBoxPara;

	

	BinaryImage = Mat(Rheight, Rwidth, CV_8UC1);
	ColorImage = Mat(Rheight, Rwidth, CV_8UC3);

	for (unsigned int r = Ry; r < Ry + Rheight; r++)
	for (unsigned int c = Rx; c < Rx + Rwidth; c++)
	{
		BinaryImage.at<uchar>(r - Ry, c - Rx) = SupBinaryImage.at<uchar>(r, c);
		ColorImage.at<Vec3b>(r - Ry, c - Rx)[0] = SupColorImage.at<Vec3b>(r, c)[0];
		ColorImage.at<Vec3b>(r - Ry, c - Rx)[1] = SupColorImage.at<Vec3b>(r, c)[1];
		ColorImage.at<Vec3b>(r - Ry, c - Rx)[2] = SupColorImage.at<Vec3b>(r, c)[2];
	}

	//��������

	Moments Moment = moments(BinaryImage, true);

	Centroid = Point2f(Moment.m10 / Moment.m00 + Rx, Moment.m01 / Moment.m00 + Ry);

	

	//test get expand images

	unsigned int ExpandRate = 5;

	int ExRx = Rx - ExpandRate * (Rwidth);
	int ExRy = Ry - ExpandRate * (Rheight);
	int ExRwidth = (2 * ExpandRate + 1) * Rwidth;
	int ExRheight = (2 * ExpandRate + 1) * Rheight;


	//check variable index
	if (ExRx < 0) ExRx = 0;
	if (ExRy < 0) ExRy = 0;
	if (ExRx + ExRwidth >= Cols) ExRwidth = Cols - ExRx - 1;
	if (ExRy + ExRheight >= Rows) ExRheight = Rows - ExRy - 1;

	ExpandBoundingBox = Rect(ExRx, ExRy, ExRwidth, ExRheight);
	ExpandCentroid = Point2f(Moment.m10 / Moment.m00 + ExpandRate * (Rwidth), Moment.m01 / Moment.m00 + ExpandRate * (Rheight));

	ExpandBinaryImage = Mat(ExRheight, ExRwidth, CV_8UC1);
	ExpandColorImage = Mat(ExRheight, ExRwidth, CV_8UC3);

	for (unsigned int r = ExRy; r < ExRy + ExRheight; r++)
	for (unsigned int c = ExRx; c < ExRx + ExRwidth; c++)
	{
		ExpandBinaryImage.at<uchar>(r - ExRy, c - ExRx) = SupBinaryImage.at<uchar>(r, c);
		ExpandColorImage.at<Vec3b>(r - ExRy, c - ExRx)[0] = SupColorImage.at<Vec3b>(r, c)[0];
		ExpandColorImage.at<Vec3b>(r - ExRy, c - ExRx)[1] = SupColorImage.at<Vec3b>(r, c)[1];
		ExpandColorImage.at<Vec3b>(r - ExRy, c - ExRx)[2] = SupColorImage.at<Vec3b>(r, c)[2];
	}
	
	findSquareArea(85);

}


void SubRegion::findSquareArea(uchar GrayThreshhold)
{
	//�����뷨��
	//����Ѱ�ҵ�������ڵ�contour

	isSquare = false;
	cvtColor(ExpandColorImage, ExpandGrayImage, CV_BGR2GRAY);
	NomalizeMat(ExpandGrayImage);
	unsigned int Rows = ExpandGrayImage.rows;
	unsigned int Cols = ExpandGrayImage.cols;
	
	
	
	for (int r = 0; r < Rows; r++)
	{
		uchar * ptr = ExpandGrayImage.ptr<uchar>(r);
		for (int c = 0; c < Cols; c++)
		{
			uchar val = ptr[c];
			if (val < GrayThreshhold)
				ptr[c] = 255;
			else
				ptr[c] = 0;
		}
	}
	
	//����ExpandGrayImage �Ȳ�ȫ��  �ڸ�ʴ  ������

	my_dilate_erode(true, 1, MORPH_ELLIPSE, ExpandGrayImage);
	imFillHoles(ExpandGrayImage);
	my_dilate_erode(false, 2, MORPH_ELLIPSE, ExpandGrayImage);
	my_dilate_erode(true, 1, MORPH_ELLIPSE, ExpandGrayImage);

	
	//debug
	//Mat ExpandTestColor;
	//cvtColor(ExpandGrayImage, ExpandTestColor, CV_GRAY2BGR);
	//circle(ExpandTestColor, ExpandCentroid, 2, Scalar(0, 0, 255));
	
	//���ȼ��
	vector<vector<Point>> contours;
	Mat toFindContours = ExpandGrayImage.clone();
	findContours(toFindContours, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);

	//����ǲ���
	for (unsigned int i = 0; i < contours.size(); i++)
	{
		//approxPolyDP(contours[i], approxCurve, 0.5, true);

		//����Ƿ������ ������ĳ��ͨ����
		if (pointPolygonTest(contours[i], ExpandCentroid, false) >= 0)
		{
			//��ȡ��ͨ��
			Mat TargetRegion = ExpandGrayImage.clone();
			for (int r = 0; r < Rows; r++)
			{
				uchar * ptr = TargetRegion.ptr<uchar>(r);
				for (int c = 0; c < Cols; c++)
				{
					Point2f NowPoint = Point(c, r);
					if (pointPolygonTest(contours[i], NowPoint, false) < 0)
						ptr[c] = 0;
				}
			}

			
			
			//��ȡ���˿� ������ǲ����ı���
			vector<vector<Point>> SubContours;
			//vector<Point> TrafficLight;

			//!!!!!!!!!!!!!!!!!!!!!!!!����TargetRegion ��Ҫ�����㷨
			//my_dilate_erode(false, 2, MORPH_RECT, TargetRegion);
			//my_dilate_erode(true, 2, MORPH_RECT, TargetRegion);
			Mat  ColorTest;
			cvtColor(TargetRegion, ColorTest, CV_GRAY2BGR);
			findContours(TargetRegion, SubContours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
			
			approxPolyDP(SubContours[0], TrafficLight, 20, true);
			if (TrafficLight.size() == 4 && isContourConvex(TrafficLight))
			{
				//�Ǹ�����
				isSquare = true;

			}
			break;
			

		}
	}

	//����������ȫͼ
	for (int i = 0; i < TrafficLight.size(); i++)
	{
		TrafficLight[i].x = TrafficLight[i].x + ExpandBoundingBox.x;
		TrafficLight[i].y = TrafficLight[i].y + ExpandBoundingBox.y;
	}

}


void SubRegion::imFillHoles(Mat &Image)
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


void SubRegion::my_dilate_erode(bool isdilate, unsigned int  dilation_size, int Type_MORPH, Mat & BinaryImage)
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

void SubRegion::NomalizeMat(Mat & Matrix)
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


SubRegion::~SubRegion()
{
}