#include"feature.h"
#include"words_svm.h"
#include"other.h"
#include"thread.h"
#include"Camera.h"
#include"people_detector.h"
#include"sub_thread_function.h"

#include<iostream>
#include<vector>
#include<string>

#include<cv.h>
#include<highgui.h>
#include<cxcore.h>

using std::cin;
using std::cout;
using std::endl;
using std::vector;
using std::string;


//ȫ�ֱ���

Parameter MyParameter = Parameter("parameter.txt");
AllResult MyAllResult = AllResult();
Words_SVM MyWord_SVM = Words_SVM("words.txt", "model.txt", "map.txt");
FeatrueVector MyFeatureVector = FeatrueVector(MyParameter.get_SlidingWindowLength());
FeatrueVector ThreadFeatureVector = FeatrueVector(MyParameter.get_SlidingWindowLength());
SubThread MyThread_Words_SVM = SubThread(ThreadProcess_Words_SVM);
SubThread MyThread_PeopleDetector = SubThread(ThreadProcess_PeopleDetector);
//Camera MyCamera = Camera("E:/DIP/KTH/walking/person01_walking_d4_uncomp.avi");
Camera MyCamera = Camera(0,0.5);
PeopleDector MyPeopleDector = PeopleDector();
int main()
{

	
	

	//�������
	for (unsigned int i = 0; i < MyParameter.get_SlidingWindowLength(); i++)
	{
		MyCamera.updata_NowFrame();
		if (!MyCamera.get_NowFrame()) break;
		Feature * NowFeature_ToMyFeatureVector = new Feature(MyCamera.get_NowFrame());
		Feature * NowFeature_ToThreadFeatureVector = new Feature(MyCamera.get_NowFrame());
		MyFeatureVector.vector_shift(NowFeature_ToMyFeatureVector);
		ThreadFeatureVector.vector_shift(NowFeature_ToThreadFeatureVector);
	}

	



	cvNamedWindow("camera");
	while (true)
	{
		int a = clock();
		MyAllResult.set_LoopStartTime();


		MyCamera.updata_NowFrame();
		if (!MyCamera.get_NowFrame()) break;
		//��ȡ����
		Feature * NowFeature = new Feature(MyCamera.get_NowFrame());
		//�ж��Ƿ���ҪΪ�˵ļ���ṩ����
		if (MyThread_PeopleDetector.get_isSubThreadBuzy() == false)
		{
			MyPeopleDector.prepare_Image(MyCamera.get_NowFrame());
			MyThread_PeopleDetector.set_isNeedHandle(true);
		}

		MyFeatureVector.vector_shift(NowFeature);
		MyAllResult.process_vedio_frame(MyCamera.get_NowFrame());
				
		//������ݣ����ݳ�����������ж��Ƿ���Ҫ׼������
		if (MyAllResult.get_ProgramCounter() % MyParameter.get_SlideDistance() == 0)
		{
			
			//�������߳�
			while (MyThread_Words_SVM.get_isSubThreadBuzy())
			{
				cout << "Main wating" << endl;
				Sleep(10);
			}
			//׼������
			ThreadFeatureVector.vector_copy_n_content(MyFeatureVector, MyParameter.get_SlideDistance());
			MyThread_Words_SVM.set_isNeedHandle(true);

		}
		//���㵽���ʱ����ȷ��Ҫ�ȶ��

		
		char key = MyCamera.show_NowFrame("camera", MyAllResult.calculate_need_wait(MyParameter.get_MinimumLoopTime()));
		if (key == 27)
			break;

		MyAllResult.set_LoopEndTime();
	}

	
}
