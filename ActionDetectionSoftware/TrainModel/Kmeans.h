#ifndef KMEANS_H_
#define KMEANS_H_


#include"feature.h"
#include"VideoFile.h"

#include<iostream>
#include<vector>
#include<string>


#include <cv.h>
#include <cxcore.h>
#include <highgui.h>
#include "vl/kmeans.h"

using namespace std;


class KmeansClass
{
	unsigned int ClassNumber;
	unsigned int ClassLength;
	float * WordsData;

public:
	KmeansClass();
	KmeansClass(vector<VideoFile *> & VideoFilesVector, unsigned int ClassNumber, string FileName);

	bool save_KmeansClass_to_txt(string FileName);
	void calculate_BOWHistogram(VideoFile * vf);

	~KmeansClass();

private:

};






#endif