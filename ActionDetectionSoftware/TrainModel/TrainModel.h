#ifndef TRAIN_MODEL_H_
#define TRAIN_MODEL_H_



#include"svm.h"
#include"VideoFile.h"

#include <iostream>
#include<vector>
#include<string>

using namespace std;

class TrainModel
{
	int FeatureLength;
	int TrainNumber;
	struct svm_problem * prob;
	struct svm_parameter * param;
public:
	TrainModel();
	TrainModel(vector<VideoFile *>& vfv);
	~TrainModel();

	

private:

};




#endif