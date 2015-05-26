#include"feature.h"



#include <vl/generic.h>
#include <vl/stringop.h>
#include <vl/pgm.h>
#include <vl/sift.h>
#include <vl/dsift.h>
#include<vl/hog.h>
#include <vl/getopt_long.h>

Feature::Feature(const IplImage * Image, MODE mod)
{
	//根据mod提取特征
	//初始化
	this->FeatureData = nullptr; 
	this->Length = this->Number = 0;
	//to do......

	//HOG
	IplImage * ImageGray = cvCreateImage(cvGetSize(Image), Image->depth, 1);
	cvCvtColor(Image, ImageGray, CV_BGR2GRAY);
	//读出图像信息
	float *ImageData = new float[ImageGray->height*ImageGray->width];
	unsigned char *Pixel;
	for (int i = 0; i<ImageGray->height; i++)
	{
		for (int j = 0; j<ImageGray->width; j++)
		{
			Pixel = (unsigned char*)(ImageGray->imageData + i*ImageGray->width + j);
			ImageData[i*ImageGray->width + j] = *(Pixel);
		}
	}
	//HOG参数配置
	vl_size numOrientations = 9;
	VlHog * hog = vl_hog_new(VlHogVariantUoctti, numOrientations, VL_FALSE);

	vl_size 	width = ImageGray->width;
	vl_size 	height = ImageGray->height;
	vl_size 	numChannels = 1;
	vl_size 	cellSize = 8;
	vl_hog_put_image(hog, ImageData, height, width, numChannels, cellSize);

	vl_size hogWidth = vl_hog_get_width(hog);
	vl_size hogHeight = vl_hog_get_height(hog);
	vl_size hogDimension = vl_hog_get_dimension(hog);
	//提取
	this->FeatureData = new float[hogWidth*hogHeight*hogDimension];
	vl_hog_extract(hog, this->FeatureData);
	this->Length = hogDimension;
	this->Number = hogWidth*hogHeight;

	cvReleaseImage(&ImageGray);
	delete [] ImageData;
	vl_hog_delete(hog);

}


Feature::Feature(const Feature & fea)
{
	this->Length = fea.get_Length();
	this->Number = fea.get_Number();
	this->FeatureData = new float[fea.get_size()];
	for (unsigned long i = 0; i < this->get_size(); i++)
		this->FeatureData[i] = fea.get_feature_data_1D(i);

}


void FeatrueVector::vector_copy_n_content(FeatrueVector & SourceVector, int n)
{
	if (n > this->VectorLength || n > SourceVector.get_VectorLength())
		return;
	for (int i = 0; i < n; i++)
	{
		
		Feature * TempCopyFeature = new Feature(*(SourceVector.get_feature_point(SourceVector.get_VectorLength() - n + i)));
		this->vector_shift(TempCopyFeature);
	}
}




FeatrueVector::~FeatrueVector()
{
	for (; VectorLength > 0; VectorLength--)
	{
		delete VectorData[VectorLength - 1];
		VectorData.pop_back();
	}
}
void FeatrueVector::vector_shift(Feature * fea)
{
	this->VectorData.insert(this->VectorData.end(), fea);
	delete VectorData[0];
	this->VectorData.erase(this->VectorData.begin());
}