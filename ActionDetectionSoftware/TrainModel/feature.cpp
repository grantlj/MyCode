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
	if (mod == HOG)
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
		delete[] ImageData;
		vl_hog_delete(hog);
	}
	else if (mod == DSIFT)
	{

		
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
		int imWidth = Image->width;
		int imHeight = Image->height;
		VlDsiftFilter* Dsift = NULL;
		int step = 16;
		int binsize = 8;
		Dsift = vl_dsift_new_basic(imWidth, imHeight, step, binsize);
		//VlDsiftFilter * Dsift = vl_dsift_new(imWidth, imHeight);
		vl_dsift_process(Dsift, ImageData);
		int KeypointNum = vl_dsift_get_keypoint_num(Dsift);
		int DescriptorSize = vl_dsift_get_descriptor_size(Dsift);
		const float* TempFeatureData = new float[vl_dsift_get_keypoint_num(Dsift)*vl_dsift_get_descriptor_size(Dsift)];
		TempFeatureData = vl_dsift_get_descriptors(Dsift);


		this->Length = vl_dsift_get_descriptor_size(Dsift);
		this->Number = vl_dsift_get_keypoint_num(Dsift);
		this->FeatureData = new float[this->Length*this->Number];
		for (unsigned long i = 0; i < this->Length*this->Number; i++)
			this->FeatureData[i] = TempFeatureData[i];

		delete[] TempFeatureData;
		vl_dsift_delete(Dsift);
		cvReleaseImage(&ImageGray);


	}
	

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
	if (n > this->VectorData.size() || n > SourceVector.get_VectorLength())
		return;
	for (int i = 0; i < n; i++)
	{
		
		Feature * TempCopyFeature = new Feature(*(SourceVector.get_feature_point(SourceVector.get_VectorLength() - n + i)));
		this->vector_shift(TempCopyFeature);
	}
}

bool FeatrueVector::readFeatrueVectorFile(string DirName,string FileName)
{
	//claer
	int veclen = VectorData.size();
	for (int i = 0; i < veclen; i++)
	{
		delete VectorData[VectorData.size() - 1];
		VectorData.pop_back();
	}

	ifstream IFS;
	IFS.open(DirName + FileName);
	if (!IFS.is_open()) return false;
	unsigned long AllFeatureNumber;
	int Length;
	IFS >> AllFeatureNumber >> Length;
	Feature * AllInOne = new Feature(AllFeatureNumber, Length);
	float val;
	for (unsigned long i = 0; i < AllFeatureNumber*Length; i++)
	{
		IFS >> val;
		AllInOne->set_feature_data_1D(i, val);
	}

	IFS.close();
	VectorData.push_back(AllInOne);
	return true;
}
bool FeatrueVector::writeFeatrueVectorFile(string DirName, string FileName)
{
	
	//开始保存	
	ofstream OFS;
	OFS.open(DirName+FileName);
	//计算所有特征的数量
	unsigned long AllFeatureNumber = 0;
	for (int vn = 0; vn < VectorData.size(); vn++)
		AllFeatureNumber += VectorData[vn]->get_Number();
	OFS << AllFeatureNumber << " " << VectorData[0]->get_Length() << endl;



	for (int vn = 0; vn < VectorData.size(); vn++)
	{
		for (int r = 0; r < VectorData[vn]->get_Number(); r++)
		{
			for (int c = 0; c < VectorData[vn]->get_Length(); c++)
			{
				OFS << VectorData[vn]->get_feature_data_2D(r, c)<<" ";
			}
			OFS << endl;
		}
	}
	OFS.close();
	return true;
}


FeatrueVector::~FeatrueVector()
{
	int VectorLength = VectorData.size();
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