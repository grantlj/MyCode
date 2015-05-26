#include"VideoFile.h"



VideoFile::VideoFile()
{

}

VideoFile::VideoFile(string Name, ReadFiles & ReadFeatureFiles)
{
	BOWHistogram = nullptr;
	HistogramLength = 0;


	//各种名字
	AllName =Name;
	int last = AllName.find_last_of('/');
	FileName = AllName.substr(last + 1, AllName.size() - last);
	DirName = AllName.substr(0, last + 1);
	int lastpoint = FileName.find_last_of('.');
	FeatureName = FileName.substr(0, lastpoint) + "Feature.txt";

	int n;
	for (n = 0; n < FileName.find_last_of('.'); n++)
	if (FileName[n] >= '0'&& FileName[n] <= '9')
		break;
	ActionName = FileName.substr(0, n);


	
	//检查是否已经存在
	if (ReadFeatureFiles.is_file_exist("D:/Feature" + FeatureName))
	{
		//读出来
		VideoFeatrueVector.readFeatrueVectorFile("D:/Feature" ,FeatureName);
	}
	else
	{

		CvCapture * VideoCapture = cvCreateFileCapture(AllName.data());
		IplImage * NowFrame;

		while (true)
		{
			NowFrame = cvQueryFrame(VideoCapture);
			if (!NowFrame)
				break;
			Feature * NowFeature = new Feature(NowFrame,Feature::DSIFT);
			VideoFeatrueVector.get_VectorData().push_back(NowFeature);
		}
		//save 
		//VideoFeatrueVector.writeFeatrueVectorFile("D:/Feature",FeatureName);

		//pooling
		if (false)
		{
			//1.新建一个空间
			Feature  * PoolingFeature = new Feature(VideoFeatrueVector.get_VectorData()[1]->get_Number(), VideoFeatrueVector.get_VectorData()[1]->get_Length());
			for (unsigned long i = 0; i < PoolingFeature->get_size(); i++)
				PoolingFeature->set_feature_data_1D(i, VideoFeatrueVector.get_VectorData()[1]->get_feature_data_1D(i));

			//2.循环读，逐个比较
			int num = VideoFeatrueVector.get_VectorLength();
			for (int i = 0; i < num; i++)
			for (unsigned long j = 0; j < PoolingFeature->get_size(); j++)
			if (PoolingFeature->get_feature_data_1D(j) < VideoFeatrueVector.get_VectorData()[i]->get_feature_data_1D(j))
				PoolingFeature->set_feature_data_1D(j, VideoFeatrueVector.get_VectorData()[i]->get_feature_data_1D(j));
			//3.删除原来的，把新的加进去
			for (int i = num - 1; i >= 0; i--)
			{
				delete VideoFeatrueVector.get_VectorData()[i];
				VideoFeatrueVector.get_VectorData().pop_back();
			}
			VideoFeatrueVector.get_VectorData().push_back(PoolingFeature);
		}
		
	}

}


void VideoFile::prepare_node_data()
{
	NodeData = new svm_node[HistogramLength + 1];
	for (int i = 0; i < HistogramLength; i++)
	{
		NodeData[i].value = BOWHistogram[i];
		NodeData[i].index = i + 1;
	}
	NodeData[HistogramLength].index = -1;
}

VideoFile::~VideoFile()
{
	delete[] BOWHistogram;
}