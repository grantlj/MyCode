#ifndef VIDEOFILE_H_
#define VIDEOFILE_H_

#include"feature.h"
#include"svm.h"
#include <iostream>
#include<vector>
#include<string>
#include<cv.h>
#include<cxcore.h>
#include<highgui.h>

using namespace std;



class VideoFile
{
	string AllName;
	string FileName;
	string DirName;
	string FeatureName;
	string ActionName;
	FeatrueVector VideoFeatrueVector;


	float * BOWHistogram;
	unsigned int HistogramLength;

	struct svm_node * NodeData;
	unsigned int Label;

public:
	VideoFile();
	VideoFile(string FileName, ReadFiles & ReadFeatureFiles);

	FeatrueVector & get_VideoFeatrueVector(){ return VideoFeatrueVector; }

	void create_BOWHistogram_space(int len){ BOWHistogram = new float[len]; HistogramLength = len; }
	void set_BOWHistogram_val(int ind, float val){ BOWHistogram[ind] = val; }
	void set_label(unsigned int i){ Label = i; }

	float get_BOWHistogram_val(int ind)const{ return BOWHistogram[ind]; }
	unsigned int get_HistogramLength()const { return HistogramLength; }
	unsigned int get_label()const{ return Label; }
	string get_all_Name()const{ return AllName; }
	string get_file_Name()const{ return FileName; }
	string get_dir_Name()const{ return DirName; }
	string get_feature_Name()const{ return FeatureName; }
	string get_action_Name()const{ return ActionName; }

	void prepare_node_data();
	struct svm_node * get_NodeData(){ return NodeData; }



	~VideoFile();

private:

};



#endif