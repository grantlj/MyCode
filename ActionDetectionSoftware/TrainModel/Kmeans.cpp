#include"Kmeans.h"




KmeansClass::KmeansClass()
{
}


KmeansClass::KmeansClass(vector<VideoFile *> & VideoFilesVector, unsigned int ClassNumber,string FileName)
{

	//先检测有没有这个文件
	ifstream IFS;
	IFS.open(FileName);
	if (IFS.is_open())
	{
		IFS >> ClassNumber;
		IFS >> ClassLength;
		WordsData = new float[ClassNumber*ClassLength];
		for (unsigned long long i = 0; i < ClassNumber*ClassLength; i++)
			IFS >> WordsData[i];
	}
	else
	{
		this->ClassNumber = ClassNumber;
		this->ClassLength = VideoFilesVector[0]->get_VideoFeatrueVector().get_feature_point(0)->get_Length();
		//prepare data for k-means
		//cal needed space 
		unsigned long AllFeatureNumber = 0;
		for (int f = 0; f < VideoFilesVector.size(); f++)
		{
			for (int i = 0; i < VideoFilesVector[i]->get_VideoFeatrueVector().get_VectorLength(); i++)
			{
				AllFeatureNumber += VideoFilesVector[i]->get_VideoFeatrueVector().get_feature_point(i)->get_Number();
			}
		}
		float * KmeansData = new float[AllFeatureNumber*ClassLength];
		unsigned long long index = 0;

		//copy data
		for (int f = 0; f < VideoFilesVector.size(); f++)
		for (int i = 0; i < VideoFilesVector[i]->get_VideoFeatrueVector().get_VectorLength(); i++)
		for (int j = 0; j < VideoFilesVector[i]->get_VideoFeatrueVector().get_feature_point(i)->get_Number(); j++)
		for (int k = 0; k < VideoFilesVector[i]->get_VideoFeatrueVector().get_feature_point(i)->get_Length(); k++)
			KmeansData[index++] = VideoFilesVector[i]->get_VideoFeatrueVector().get_feature_point(i)->get_feature_data_2D(j, k);

		//初始化数据


		float * init_centers = new float[ClassNumber*ClassLength];
		for (int i = 0; i < ClassNumber*ClassLength; i++)
			init_centers[i] = KmeansData[i * 5];

		//创建一个聚类的对象，它包含了两个参数：数据类型和具体比较的相似度计算方法（距离函数）
		VlKMeans * fkmeans = vl_kmeans_new(VL_TYPE_FLOAT, VlDistanceL2);
		//设定需要使用的聚类方法（Lloyd、Elkan还是ANN）
		vl_kmeans_set_algorithm(fkmeans, VlKMeansElkan);

		vl_kmeans_set_centers(fkmeans, (void *)init_centers, ClassLength, ClassNumber);

		//利用 vl_kmeans_cluster() 进行聚类
		vl_kmeans_cluster(fkmeans, KmeansData, ClassLength, AllFeatureNumber, ClassNumber);


		const float * centers = (float *)vl_kmeans_get_centers(fkmeans);
		WordsData = new float[ClassNumber*ClassLength];

		for (int i = 0; i < ClassNumber*ClassLength; i++)
			WordsData[i] = centers[i];
		save_KmeansClass_to_txt(FileName);
	}
	IFS.close();
	
}

bool KmeansClass::save_KmeansClass_to_txt(string FileName)
{
	ofstream OFS;
	OFS.open(FileName);
	OFS << ClassNumber << " " << ClassLength << endl;
	for (int i = 0; i < ClassNumber; i++)
	{
		for (int j = 0; j < ClassLength; j++)
			OFS << WordsData[i*ClassLength + j]<<" ";
		OFS << endl;
	}
	
	OFS.close();
	return true;
}

void KmeansClass::calculate_BOWHistogram(VideoFile * vf)
{
	vf->create_BOWHistogram_space(ClassNumber);
	double * BOWHistogram = new double[ClassNumber];
	for (unsigned int i = 0; i < ClassNumber; i++)
		BOWHistogram[i] = 0;

	for (unsigned int v = 0; v < vf->get_VideoFeatrueVector().get_VectorLength(); v++)
	{
		Feature * NowFeature = vf->get_VideoFeatrueVector().get_feature_point(v);
		for (unsigned int i = 0; i < NowFeature->get_Number(); i++)
		{
			//与words找距离 (顺序按照table中数据来)
			//记录一个feat到所有words的距离,并初始化
			double * Distance = new double[ClassNumber];
			for (unsigned int n = 0; n < ClassNumber; n++)
				Distance[n] = 0;
			//当前feature开始的指针

			for (unsigned int n = 0; n < ClassNumber; n++)
			{
				float * NowWord = WordsData + n*ClassLength;

				//计算距离
				for (unsigned int j = 0; j < ClassLength; j++)
				{
					float featData = NowFeature->get_feature_data_2D(i, j);
					Distance[n] += (featData - NowWord[j])*(featData - NowWord[j]);
				}

			}
			//求出distance最小值的下标
			int MinIndex = 0;
			for (unsigned int n = 0; n < ClassNumber; n++)
			if (Distance[MinIndex]>Distance[n])
				MinIndex = n;
			BOWHistogram[MinIndex]++;
			delete[] Distance;
		}
	}
	//直方图归一化
	double Sum = 0;
	for (unsigned int n = 0; n < ClassNumber; n++)
		Sum += BOWHistogram[n];
	for (unsigned int n = 0; n < ClassNumber; n++)
		vf->set_BOWHistogram_val(n, BOWHistogram[n] / Sum);
	vf->prepare_node_data();

}

KmeansClass::~KmeansClass()
{
}