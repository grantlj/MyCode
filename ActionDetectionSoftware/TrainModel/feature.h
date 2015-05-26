#ifndef FEATURE_H_
#define FEATURE_H_


#include"ReadFiles.h"

#include<cv.h>
#include<vector>
#include<string>
#include<fstream>


using std::vector;
using std::string;
using std::ofstream;
using std::ifstream;
class Feature
{
	
	float *FeatureData;
	unsigned int Length;
	unsigned int Number;
	
public:
	enum MODE{ HOG, POOLING_HOG, DSIFT };

	Feature(){ this->FeatureData = nullptr; this->Length = this->Number = 0; } //默认构造函数
	Feature(unsigned long num, unsigned int len){ Number = num; Length = len; FeatureData = new float[num*len]; }
	~Feature() { delete[] FeatureData; } //析构函数
	Feature(const IplImage * Image,MODE mod = HOG);
	Feature(const Feature & fea );//复制构造函数
	float get_feature_data_1D(unsigned long index) const{ return  FeatureData[index];  }
	float get_feature_data_2D(unsigned int  num, unsigned int the) const{ return  FeatureData[num*Length + the]; }
	
	unsigned int get_Number() const{ return Number; }
	unsigned int get_Length() const{ return Length; }
	unsigned int get_size() const{ return Length*Number; }

	//set
	void set_feature_data_1D(unsigned long index, float val){ FeatureData[index] = val; }

private:

};


class FeatrueVector
{
	vector<Feature *> VectorData;
	
public:
	FeatrueVector(unsigned int len=0){ VectorData.resize(len);  }
	~FeatrueVector();
	unsigned int get_VectorLength() const{ return  (unsigned int)VectorData.size(); }
	Feature * get_feature_point(unsigned int index) { return  VectorData[index]; }
	void vector_shift(Feature * fea);
	void vector_copy_n_content(FeatrueVector & SourceVector, int n);
	vector<Feature *> & get_VectorData(){ return VectorData; }

	//file operation
	bool readFeatrueVectorFile(string DirName,string FileName);
	bool writeFeatrueVectorFile(string DirName,string FileName = "");

private:

};

#endif