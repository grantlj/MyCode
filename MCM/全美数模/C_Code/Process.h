#ifndef PROCESS_H_
#define PROCESS_H_



#include"Container.h"
#include"People.h"
#include"Region.h"
#include"State.h"
#include"Medicine.h"


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
using std::ofstream; 
using std::ios;

int isFlag(MatrixFloat & Mat, int row, int col);
int RandDay();
string num2str(int num);

class Process
{
	ifstream inFile;
	ofstream outFile;
public:
	unsigned long AllPeopleNum;
	unsigned long SPeopleNum;

	unsigned long DeadPeople;
	unsigned long NewDeadPeople;

	unsigned long PrimerPeople;
	unsigned long NewPrimerPeople;

	unsigned long AdvancedPeople;
	unsigned long NewAdvancedPeople;
	
	unsigned long  ImmunePeople;
	unsigned long  NewImmunePeople;

	unsigned long	RecoverPeople;
	unsigned long  NewRecoverPeople;

	unsigned long long ProgramCounter;
public:
	Region MyRegion;
	People MyPeople;
	Medicine MyMedicine;
	State MyState;

public:
	Process();
	~Process();

	//important handle
	void update_State();
	void people_transfer();
	void update_delivery();
	void update_medicine();
	void drug_distribution();
	void eat_medicine();
	void save(string OutFileName, string dir);
	void save_color_image(string dir);

private:

};

#endif 