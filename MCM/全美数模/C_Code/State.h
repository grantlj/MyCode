#ifndef STATE_H_
#define STATE_H_

#include"Container.h"
#include"People.h"
#include"Region.h"

#include<iostream>
#include<fstream>
#include<string>
#include<vector>

#include<cv.h>
#include<cxcore.h>

using std::cout;
using std::cin;
using std::endl;
using std::string;
using std::vector;
using std::ifstream;

class State
{

public:
	MatrixFloat SeriousnessMat;
	MatrixFloat P_s2p_Mat;
	MatrixFloat P_p2a_Mat;
	MatrixFloat NeedVaccine;
	MatrixFloat NeedCure;


	double P_p2a_Initial;
	double P_a2d;
	MatrixFloat Gaussian;
	MatrixFloat Mask;

	State();
	~State();


	//get
	MatrixFloat & get_SeriousnessMat(){ return SeriousnessMat; }
	MatrixFloat & get_P_s2p_Mat(){ return P_s2p_Mat; }
	MatrixFloat & get_P_p2a_Mat(){ return P_p2a_Mat; }
	MatrixFloat & get_NeedVaccine(){ return NeedVaccine; }
	MatrixFloat & get_NeedCure(){ return NeedCure; }

	float get_P_a2d(){ return float(P_a2d); }

private:

};


#endif