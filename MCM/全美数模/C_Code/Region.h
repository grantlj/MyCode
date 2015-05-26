#ifndef REGION_H_
#define REGION_H_

#include"Container.h"


#include<iostream>
#include<string>
#include<vector>

#include<cv.h>
#include<highgui.h>

using std::cout;
using std::cin;
using std::endl;
using std::string;
using std::vector;

class Region
{

	//about delivery
public:
	struct Delivery
	{
		int row;
		int col;
		unsigned int VaccineNum;
		unsigned int CureNum;
		unsigned int  DaysRemaining;
	};

	//about Region
	//Mat RegionMat;
	MatrixFloat RegionMat;
private:
	//vector
	vector<Delivery> DeliveryVector;
	MatrixFloat isDeliveryVaccineFlagMat;
	MatrixFloat isDeliveryCureFlagMat;

	//drug distribution
	MatrixFloat VaccineDistribution;
	MatrixFloat CureDistribution;

	


public:

	Region();
	~Region();


	//get
	MatrixFloat & get_RegionMat() { return  RegionMat; }
	vector<Delivery> & get_DeliveryVector() { return DeliveryVector; }
	MatrixFloat & get_isDeliveryVaccineFlagMat(){ return isDeliveryVaccineFlagMat; }
	MatrixFloat & get_isDeliveryCureFlagMat(){ return isDeliveryCureFlagMat; }
	//drug distribution
	MatrixFloat & get_VaccineDistribution(){ return VaccineDistribution; }
	MatrixFloat & get_CureDistribution(){ return CureDistribution; }


	void update_DeliveryVector_isDeliveryFlagMat();
	


	// to modify matrix 
	int isPointValid(unsigned int row, unsigned int col);
	MatrixFloat  modify_matrix(MatrixFloat  & M);

private:

};





#endif