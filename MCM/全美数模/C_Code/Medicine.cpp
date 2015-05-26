#include"Medicine.h"

Medicine::Medicine()
{
	//initial
	ProgramCounter = 0;
	VaccineInventory = 0;
	CureInventory = 0;

}

void Medicine::updata_Medicine()
{
	//medicine feature
	//1.efficiency
	update_vaccine_efficiency();
	update_cure_efficiency();
	//2.production rate
	update_vaccine_production_rate();
	update_cure_production_rate();
	//other
	update_medical_level();
	update_holistic_warness();
	//in inventory
	in_vaccine_inventory(VaccineProductionRate);
	in_cure_inventory(CureProductionRate);

	update_ProgramCounter();
}


//warehouse handle
unsigned int Medicine::in_vaccine_inventory(unsigned int in)
{
	if (VaccineInventory + in > 33000)
		VaccineInventory = 33000;
	else
		VaccineInventory += in;
	return VaccineInventory;
}
unsigned int Medicine::in_cure_inventory(unsigned int in)
{
	if (CureInventory + in > 33000)
		CureInventory = 33000;
	else
		CureInventory += in;
	return CureInventory;
}

unsigned int Medicine::out_vaccine_inventory(unsigned int out)
{
	unsigned int oo;
	if (VaccineInventory < out)
	{
		oo = VaccineInventory;
		VaccineInventory = 0;
	}
	else
	{
		VaccineInventory -= out;
		oo = out;
	}
	return oo;
}
unsigned int Medicine::out_cure_inventory(unsigned int out)
{
	unsigned int oo;
	if (CureInventory < out )
	{
		oo = CureInventory;
		CureInventory = 0;
	}
	else
	{
		CureInventory -= out;
		oo = out;
	}
	return oo;
}


// privata -------------------updata-----------------
void Medicine::update_vaccine_efficiency()
{
	//func1
	VaccineEfficiency = 0.5 + ProgramCounter* 0.5 / 60;
	if (VaccineEfficiency > 1)
		VaccineEfficiency = 1;
}
void Medicine::update_cure_efficiency()
{
	//func2
	CureEfficiency = 0.5 + ProgramCounter*0.5 / 60;
	if (CureEfficiency > 1)
		CureEfficiency = 1;
}


void Medicine::update_vaccine_production_rate()
{
	VaccineProductionRate = (ProgramCounter)* 1000;
}
void Medicine::update_cure_production_rate()
{
	CureProductionRate = (ProgramCounter)* 1000;
}

void Medicine::update_medical_level()
{
	MedicalLevel = ProgramCounter*0.5 / 60;
	if (MedicalLevel > 1)
		MedicalLevel = 1;
}
void Medicine::update_holistic_warness()
{
	HolisticAwarness = ProgramCounter*0.5 / 60;
	if (HolisticAwarness > 1)
		HolisticAwarness = 1;
}

Medicine::~Medicine()
{

}