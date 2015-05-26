#include"Container.h"
#include"Process.h"

#include<iostream>
#include<string>
#include<vector>
#include<cv.h>
#include<cxcore.h>


using namespace cv;

using std::cout;
using std::cin;
using std::endl;
using std::string;
using std::vector;

int main()
{
	//-------------!!!!README
	cout << "input 0 or  not 0 to choose is having madicine" << endl;
	cout << "NoMedicine result correspond to ResultNoMedicine folder" << endl;
	cout << "Medicine result correspond to ResultNoMedicine folder" << endl;
	
	string dirNo = "ResultNoMedicine/";
	string dirYes = "ResultMedicine/";
	string dirSub = "color/";
	Process MyProcess = Process();

	for (int i = 0; i < 512 * 230; i++)
	if (MyProcess.MyPeople.get_pPeopleMat().get_value(i) < 0)
	{
		int a = 12;
	}
	
	cvSaveImage("RegionMat.jpg", MyProcess.MyRegion.RegionMat.create_iplimage());
	while (1)
	{
		int choose;
		cin >> choose;

		if (choose == 0)
		{
			cout << "day " << MyProcess.ProgramCounter + 1 << ":" << endl;
			
			cout << "   update_State" << endl; MyProcess.update_State();


			cout << "   people_transfer" << endl; MyProcess.people_transfer();

			MyProcess.save("text.txt", dirNo);
			MyProcess.save_color_image(dirNo + dirSub);
		}
		else
		{
			cout << "day " << MyProcess.ProgramCounter + 1 << ":" << endl;
			cout << "   update_medicine" << endl; MyProcess.update_medicine();
			cout << "   eat_medicine" << endl; MyProcess.eat_medicine();

			cout << "   update_State" << endl; MyProcess.update_State();

			cout << "   update_delivery" << endl; MyProcess.update_delivery();
			cout << "   drug_distribution" << endl; MyProcess.drug_distribution();

			cout << "   people_transfer" << endl; MyProcess.people_transfer();

			MyProcess.save("text.txt", dirNo);
			MyProcess.save_color_image(dirNo + dirSub);
		}
		
		//print
		cout << "    result:" <<" S:" <<MyProcess.SPeopleNum<<" P:" << MyProcess.PrimerPeople << " A:" << MyProcess.AdvancedPeople << " R:" << MyProcess.RecoverPeople << " D:" << MyProcess.DeadPeople << endl << endl;
		
	}


}