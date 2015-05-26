#include"words_svm.h"

#include<iostream>
#include<fstream>
using namespace std;

Words_SVM::Words_SVM(const char * WordsFile,  const char * ModelFile, const char *MapFile)
{
	ifstream FileInStream;
	FileInStream.open(WordsFile);
	FileInStream >> WordsNum;
	FileInStream >> WordsLength;
	WordsData = new float[WordsNum*WordsLength];
	for (unsigned long long  i = 0; i < WordsNum*WordsLength; i++)
		FileInStream >> WordsData[i];
	FileInStream.close();

	//���ȶ���model
	Model = svm_load_model(ModelFile);
	//Ȼ���������ӳ���
	FileInStream.open(MapFile);
	//ѭ����ȡ
	while (true)
	{
		Map * NowMap = new Map;
		FileInStream >> NowMap->index;
		FileInStream >> NowMap->ActionName;
		if (FileInStream)
			MapVector.push_back(*NowMap);
		else
		{
			delete NowMap;
			break;
		}
	}
	FileInStream.close();
}



//����threadFeatureVectorʹ��bagOfWordsģ��
void Words_SVM::bow_svm(FeatrueVector & ThreadVector,AllResult & Result)
{
	
	//bag of words
	
	double * BOWHistogram = new double[WordsNum];
	for (unsigned int i = 0; i < WordsNum; i++)
		BOWHistogram[i] = 0;


	for (unsigned int v = 0; v < ThreadVector.get_VectorLength(); v++)
	{
		Feature * NowFeature = ThreadVector.get_feature_point(v);
		for (unsigned int i = 0; i < NowFeature->get_Number(); i++)
		{
			//��words�Ҿ��� (˳����table��������)
			//��¼һ��feat������words�ľ���,����ʼ��
			double * Distance = new double[WordsNum];
			for (unsigned int n = 0; n < WordsNum; n++)
				Distance[n] = 0;
			//��ǰfeature��ʼ��ָ��
			
			for (unsigned int n = 0; n < WordsNum; n++)
			{
				float * NowWord = WordsData + n*WordsLength;

				//�������
				for (unsigned int j = 0; j < WordsLength; j++)
				{
					float featData = NowFeature->get_feature_data_2D(i, j);
					Distance[n] += (featData - NowWord[j])*(featData - NowWord[j]);
				}

			}
			//���distance��Сֵ���±�
			int MinIndex = 0;
			for (unsigned int n = 0; n < WordsNum; n++)
			if (Distance[MinIndex]>Distance[n])
				MinIndex = n;
			BOWHistogram[MinIndex]++;
			delete [] Distance;
		}
	}
	//ֱ��ͼ��һ��
	double Sum = 0;
	for (unsigned int n = 0; n < WordsNum; n++)
		Sum += BOWHistogram[n];
	for (unsigned int n = 0; n < WordsNum; n++)
		BOWHistogram[n] /= Sum;
	//svm
	//����׼��
	svm_node * Nodes = new svm_node[WordsNum + 1];
	for (unsigned int n = 0; n < WordsNum; n++)
	{
		Nodes[n].value = BOWHistogram[n];
		Nodes[n].index = n + 1;
	}
	Nodes[WordsNum].index = -1;
	
	//svm�о�
	double   sp = svm_predict(Model, Nodes);
	int d = (int)sp;
	bool isNotHaveMap = true;
	for (int i = 0; i < MapVector.size(); i++)
	{
		if (d == MapVector[i].index)
		{
			isNotHaveMap = false;
			Result.set_ActionMessage(MapVector[i].ActionName);
		}
	}
	if (isNotHaveMap)
	{
		Result.set_ActionMessage("Unkown");
	}
	//delete[] BOWHistogram;
	delete[] Nodes;

}



Words_SVM::~Words_SVM()
{
	delete[] WordsData;
	int MapNum = (int)MapVector.size();
	for (; MapNum > 0; MapNum--)
	{
		delete &MapVector[MapNum - 1];
		MapVector.pop_back();
	}
}
