#ifndef MEDICINE_H_
#define MEDICINE_H_



#include<iostream>
#include<fstream>
#include<string>
#include<vector>
#include<opencv2\core\core.hpp>
#include<opencv2\highgui\highgui.hpp>
#include<cv.h>
#include<cxcore.h>

using namespace cv;

using std::cout;
using std::cin;
using std::endl;
using std::string;
using std::vector;
using std::ifstream;


class Medicine
{


	//Efficiency
	double VaccineEfficiency;
	double CureEfficiency;
	//ProductionRate
	unsigned int VaccineProductionRate;
	unsigned int CureProductionRate;
	//Inventory
	unsigned int VaccineInventory;
	unsigned int CureInventory;
	//medical level
	double MedicalLevel;
	double HolisticAwarness;




public:
	unsigned long long ProgramCounter;
public:
	Medicine();
	~Medicine();

	void updata_Medicine();

	//get
	double get_vaccine_efficiency()const { return VaccineEfficiency; }
	double get_cure_efficiency()const { return CureEfficiency; }

	unsigned int get_vaccine_production_rate()const{ return VaccineProductionRate; }
	unsigned int get_cure_production_rate() const{ return CureProductionRate; }

	unsigned int get_vaccine_inventory() const { return VaccineInventory; }
	unsigned int get_cure_inventory() const { return CureInventory; }

	double get_medical_level()const { return MedicalLevel; }
	double get_holistic_warness()const { return HolisticAwarness; }

	//warehouse handle
	//in return inventory
	unsigned int in_vaccine_inventory(unsigned int in);
	unsigned int in_cure_inventory(unsigned int in);
	//out reuturn out 
	unsigned int out_vaccine_inventory(unsigned int out);
	unsigned int out_cure_inventory(unsigned int out);
private:
	//functions of  VaccineEfficiency and CureEfficiency 
	void update_vaccine_efficiency();
	void update_cure_efficiency();
	void update_vaccine_production_rate();
	void update_cure_production_rate();
	void update_ProgramCounter(){ ProgramCounter++; }
	void update_medical_level();
	void update_holistic_warness();
};



#endif