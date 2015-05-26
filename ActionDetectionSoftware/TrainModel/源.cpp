#include"ReadFiles.h"
#include"VideoFile.h"
#include"Map.h"
#include"Kmeans.h"
#include"TrainModel.h"

#include<iostream>
#include<string>
#include<vector>
using namespace std;


int main()
{
	ReadFiles ReadVideoFiles =ReadFiles("D:/Video");
	ReadFiles ReadFeatureFiles = ReadFiles("D:/Feature");

	 
	vector<VideoFile *> VideoFilesVector;
	for (unsigned long i = 0; i < ReadVideoFiles.get_files_number(); i++)
	{
		VideoFile * NowVector = new VideoFile(ReadVideoFiles.get_index_string(i), ReadFeatureFiles);
		VideoFilesVector.push_back(NowVector);
		cout << i + 1 << "of" << ReadVideoFiles.get_files_number() << endl;
	}
	Map MyMap = Map(VideoFilesVector, "map.txt");

	KmeansClass MyKmeansClass = KmeansClass(VideoFilesVector, 30, "words.txt");
	for (int i = 0; i < VideoFilesVector.size(); i++)
	{
		MyKmeansClass.calculate_BOWHistogram(VideoFilesVector[i]);
	}

	//svm
	TrainModel MyTrain = TrainModel(VideoFilesVector);

	return 0; 
}