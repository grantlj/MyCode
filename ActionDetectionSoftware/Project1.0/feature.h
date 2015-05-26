#ifndef FEATURE_H_
#define FEATURE_H_


#include<cv.h>
#include<vector>

using std::vector;

class Feature
{
	enum MODE{ HOG,SIFT};
	float *FeatureData;
	unsigned int Length;
	unsigned int Number;
	
public:
	Feature(){ this->FeatureData = nullptr; this->Length = this->Number = 0; } //默认构造函数
	~Feature() { delete[] FeatureData; } //析构函数
	Feature(const IplImage * Image,MODE mod = HOG);
	Feature(const Feature & fea );//复制构造函数
	float get_feature_data_1D(unsigned long index) const{ return  FeatureData[index]; }
	float get_feature_data_2D(unsigned int  num, unsigned int the) const{ return  FeatureData[num*Length + the]; }
	
	unsigned int get_Number() const{ return Number; }
	unsigned int get_Length() const{ return Length; }
	unsigned int get_size() const{ return Length*Number; }
private:

};


class FeatrueVector
{
	vector<Feature *> VectorData;
	unsigned int VectorLength;
public:
	FeatrueVector(unsigned int len=0){ VectorData.resize(len); VectorLength = len; }
	~FeatrueVector();
	unsigned int get_VectorLength() const{ return VectorLength; }
	Feature * get_feature_point(unsigned int index) { return  VectorData[index]; }
	void vector_shift(Feature * fea);
	void vector_copy_n_content(FeatrueVector & SourceVector, int n);
private:

};

#endif