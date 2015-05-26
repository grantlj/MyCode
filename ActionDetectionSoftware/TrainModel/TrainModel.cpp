#include"TrainModel.h"


TrainModel::TrainModel()
{

}

TrainModel::TrainModel(vector<VideoFile *>& vfv)
{
	prob = new svm_problem;
	param = new svm_parameter;

	//prepare
	FeatureLength = vfv[0]->get_HistogramLength();
	TrainNumber = vfv.size();

	struct svm_node **AllData = new svm_node *[TrainNumber];
	double * AllLabel = new double[TrainNumber];

	for (int i = 0; i < TrainNumber; i++)
	{
		AllData[i] = vfv[i]->get_NodeData();
		AllLabel[i] = vfv[i]->get_label();
	}

	prob->l = TrainNumber;
	prob->y = AllLabel;
	prob->x = AllData;

	param->svm_type = C_SVC;
	param->kernel_type = RBF;
	param->degree = 3;
	param->gamma = 0.0001;
	param->coef0 = 0;
	param->nu = 0.5;
	param->cache_size = 100;
	param->C = 11;
	param->eps = 1e-5;
	param->p = 0.1;
	param->shrinking = 1;
	param->probability = 0;
	param->nr_weight = 0;
	param->weight_label = NULL;
	param->weight = NULL;

	svm_model* model = svm_train(prob, param);
	svm_save_model("model.txt", model);
	
}




TrainModel::~TrainModel()
{

}