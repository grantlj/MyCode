#ifndef PEOPLE_H_
#define PEOPLE_H_


#include"Container.h"

#include<iostream>
#include<fstream>
#include<string>
#include<vector>




using std::cout;
using std::cin;
using std::endl;
using std::string;
using std::vector;
using std::ifstream;

class People
{
	struct City
	{
		unsigned int x, y;
		float num;
	};


	//Mat PeopleMat
	MatrixFloat AllPeopleMat;
	MatrixFloat Gauss2dFilter;

	//classify people 
	MatrixFloat sPeopleMat;
	MatrixFloat pPeopleMat;
	MatrixFloat aPeopleMat;
	MatrixFloat rPeopleMat;
	MatrixFloat dPeopleMat;

	unsigned long  PeopleNum;
public:
	People();
	People(const MatrixFloat & RegionMat, unsigned int MiniPeopleNum);
	~People();
	//get
	MatrixFloat & get_AllPeopleMat() { return AllPeopleMat; }
	MatrixFloat & get_sPeopleMat(){ return sPeopleMat; }
	MatrixFloat & get_pPeopleMat(){ return pPeopleMat; }
	MatrixFloat & get_aPeopleMat(){ return aPeopleMat; }
	MatrixFloat & get_rPeopleMat(){ return rPeopleMat; }
	MatrixFloat & get_dPeopleMat(){ return dPeopleMat; }

	unsigned long get_PeopleNum()const{ return PeopleNum; }

private:
	void add_gaussian(City NowCity, MatrixFloat & M);
};



#endif