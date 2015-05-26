#include"Process.h"


Process::Process()
{
	ProgramCounter = 0;

	MyRegion = Region();
	unsigned int rows = MyRegion.RegionMat.get_rows();
	unsigned int cols = MyRegion.RegionMat.get_cols();
	MyPeople = People(MyRegion.RegionMat, 100);
	MyState = State();
	//MyMedicine = Medicine();

	DeadPeople = 0;
	AdvancedPeople = 0;
	RecoverPeople = 0;
	ImmunePeople = 0;


	PrimerPeople = 0;
	for (int i = 0; i < rows*cols; i++)
		PrimerPeople += MatrixFloat::Round(MyPeople.get_pPeopleMat().get_value(i));


	AllPeopleNum = MyPeople.get_PeopleNum();
	SPeopleNum = AllPeopleNum - PrimerPeople;

	

}



//ok
void Process::update_State()
{
	ProgramCounter++;

	unsigned int row = MyPeople.get_AllPeopleMat().get_rows();
	unsigned int col = MyPeople.get_AllPeopleMat().get_cols();
	float Discount = float(1 - 0.3*(MyMedicine.get_holistic_warness() + MyMedicine.get_medical_level()));
	//update Seriousness;
	MyState.SeriousnessMat = MatrixFloat::zeros(row, col);
	for (int r = 0; r < row; r++)
	for (int c = 0; c < col; c++)
	{
		if (MyRegion.isPointValid(r, c) == 1)
		{
			int S = MyPeople.get_sPeopleMat().get_value(r, c);
			int P = MyPeople.get_pPeopleMat().get_value(r, c);
			int A = MyPeople.get_aPeopleMat().get_value(r, c);
			int R = MyPeople.get_rPeopleMat().get_value(r, c);

			int sp = S + R;
			if (sp == 0)
			{
				MyState.SeriousnessMat.set_value(r, c, 0);
			}
			else
			{
				float p = 1.0 / (S + R)*(P * 5 * 0.23 + A* 0.81)*Discount;
				//debug
				p = p ;
				if (p < 0.01)p = 0;
				if (p >= 0.1)p = 0.1;
				MyState.SeriousnessMat.set_value(r, c, p);
			}
		}
	}


	//update s->p
	MyState.P_s2p_Mat = MyState.SeriousnessMat.convolution(MyState.Gaussian);
	MyState.P_s2p_Mat = MyRegion.modify_matrix(MyState.P_s2p_Mat);
	for (int r = 0; r < row; r++)
	for (int c = 0; c < col; c++)
	if (MyRegion.isPointValid(r, c) == 1 && MyState.P_s2p_Mat.get_value(r, c) >= 1)
		MyState.P_s2p_Mat.set_value(r,c, 0.99);



	//update p->a
	MyState.P_p2a_Mat = MatrixFloat::zeros(row, col);
	for (int r = 0; r < row; r++)
	for (int c = 0; c < col; c++)
	{
		if (MyRegion.isPointValid(r, c) == 1)
		{
			MyState.P_p2a_Mat.set_value(r, c, MyState.P_p2a_Initial*Discount);
		}
	}

	//update NeedCure
	MyState.NeedCure = MatrixFloat::zeros(row, col);

	for (int r = 0; r < row; r++)
	for (int c = 0; c < col; c++)
	{
		if (MyRegion.isPointValid(r, c) == 1)
		{
			int S = MyPeople.get_sPeopleMat().get_value(r, c);
			int P = MyPeople.get_pPeopleMat().get_value(r, c);
			int A = MyPeople.get_aPeopleMat().get_value(r, c);
			int R = MyPeople.get_rPeopleMat().get_value(r, c);
			float ps2p = MyState.get_P_s2p_Mat().get_value(r, c);

			MyState.NeedCure.set_value(r, c, 1.0*S*ps2p*(1 + (1 - ps2p) + (1 - ps2p)*(1 - ps2p)));

		}
	}

	;
	//updata  NeedVaccine
	MatrixFloat Temp = MyState.P_s2p_Mat.convolution(MyState.Mask);
	MyState.NeedVaccine = MatrixFloat::zeros(row, col);
	for (int r = 0; r < row; r++)
	for (int c = 0; c < col; c++)
	if (MyRegion.isPointValid(r, c) == 1)
	{
		int S = MyPeople.get_sPeopleMat().get_value(r, c);
		MyState.NeedVaccine.set_value(r, c, MatrixFloat::Round(S*Temp.get_value(r, c)));
	}

	//debug
	if (0)//MyMedicine.ProgramCounter == 5
	{

		for (int r = row / 2; r < row; r++)
		for (int c = 0; c < col / 2; c++)
		{
			if (MyRegion.isPointValid(r, c) == 1) continue;
			cout << MyState.NeedVaccine.get_value(r, c) << " ";
		}
	}

}
//ok
void Process::people_transfer()
{
	NewDeadPeople = 0;
	NewPrimerPeople = 0;
	NewAdvancedPeople = 0;

	unsigned int row = MyRegion.RegionMat.get_rows();
	unsigned int col = MyRegion.RegionMat.get_cols();

	for (int r = 0; r < row; r++)
	for (int c = 0; c < col; c++)
	{
		if (MyRegion.isPointValid(r, c) == 0) continue;

		int S = MyPeople.get_sPeopleMat().get_value(r, c);
		int P = MyPeople.get_pPeopleMat().get_value(r, c);
		int A = MyPeople.get_aPeopleMat().get_value(r, c);
		int R = MyPeople.get_rPeopleMat().get_value(r, c);
		int D = MyPeople.get_dPeopleMat().get_value(r, c);

		float ps2p = MyState.get_P_s2p_Mat().get_value(r, c);
		float pp2a = MyState.get_P_p2a_Mat().get_value(r, c);
		float pa2d = MyState.get_P_a2d();
		int s2p = 0, p2a = 0, a2d = 0;

		//debug

		//s->p
		if (S > 0 && ps2p>0.01)
		{
			s2p = int(S*ps2p);
			if (s2p <= 0)
				s2p = 1;
		}

		//p->a
		if (P > 0 && pp2a>0.01)
		{
			p2a = P*pp2a;
			if (p2a <= 0)
				p2a = 1;
		}


		//a->d
		if (A > 0 && pa2d>0.01)
		{
			a2d = A*pa2d;
			if (a2d <= 0)
				a2d = 1;
		}

		NewPrimerPeople += s2p;
		NewAdvancedPeople += p2a;
		NewDeadPeople += a2d;

		MyPeople.get_sPeopleMat().set_value(r, c, S - s2p);
		MyPeople.get_pPeopleMat().set_value(r, c, P + s2p - p2a);
		MyPeople.get_aPeopleMat().set_value(r, c, A + p2a - a2d);
		MyPeople.get_dPeopleMat().set_value(r, c, D + a2d);
	}

}
//ok
void Process::update_delivery()
{
	MyRegion.update_DeliveryVector_isDeliveryFlagMat();
}
//ok
void Process::update_medicine()
{
	MyMedicine.updata_Medicine();
}
//ok
void Process::drug_distribution()
{

	unsigned int row = MyRegion.RegionMat.get_rows();
	unsigned int col = MyRegion.RegionMat.get_cols();

	//Vaccine Distribution
	while (MyMedicine.get_vaccine_inventory() > 0)
	{
		Region::Delivery dl;
		//find the point is max and not flag
		float MaxVal = -10000000;
		unsigned int rm, cm;
		bool notFind = true;
		for (int r = 0; r < row; r++)
		for (int c = 0; c < col; c++)
		{
			if (MyRegion.isPointValid(r, c) == 0 || MyRegion.get_isDeliveryVaccineFlagMat().get_value(r, c) >0.5) continue;

			if (MyState.get_NeedVaccine().get_value(r, c)> MaxVal)
			{
				MaxVal = MyState.get_NeedVaccine().get_value(r, c);
				rm = r;
				cm = c;
				notFind = false;
			}
		}
		if (notFind) break;

		dl.row = rm;
		dl.col = cm;
		dl.DaysRemaining = RandDay();
		dl.VaccineNum = MyMedicine.out_vaccine_inventory(MyPeople.get_sPeopleMat().get_value(rm, cm));
		dl.CureNum = 0;
		MyRegion.get_DeliveryVector().push_back(dl);
		//mark is delivery mat
		MyRegion.get_isDeliveryVaccineFlagMat().set_value(rm, cm, 1);

		

	}

	

	while (MyMedicine.get_cure_inventory() > 0)
	{
		Region::Delivery dl;
		float MaxVal = -10000000;
		unsigned int rm, cm;
		bool notFind = true;
		for (int r = 0; r < row; r++)
		for (int c = 0; c < col; c++)
		{
			if (MyRegion.isPointValid(r, c) == 0 || MyRegion.get_isDeliveryCureFlagMat().get_value(r, c) >0.5) continue;

			if (MyState.get_NeedCure().get_value(r, c)> MaxVal)
			{
				MaxVal = MyState.get_NeedCure().get_value(r, c);
				rm = r;
				cm = c;
				notFind = false;
			}
		}
		if (notFind)break;

		dl.row = rm;
		dl.col = cm;
		dl.DaysRemaining = RandDay();
		dl.VaccineNum = 0;
		dl.CureNum = MyMedicine.out_cure_inventory(MaxVal);
		MyRegion.get_DeliveryVector().push_back(dl);
		//mark is delivery mat
		MyRegion.get_isDeliveryCureFlagMat().set_value(rm, cm, 1);
	
			
		if (ProgramCounter == 60)
		{
			outFile.open("deli.txt", ios::app | ios::out);
			outFile << dl.col * 2 << '\t' << dl.row * 2 << '\t' << dl.CureNum << endl;
			outFile.close();
		}
	}
}
//ok
void Process::eat_medicine()
{
	NewRecoverPeople = 0;
	NewImmunePeople = 0;
	unsigned int row = MyRegion.get_RegionMat().get_rows();
	unsigned int col = MyRegion.get_RegionMat().get_cols();

	for (int r = 0; r < row; r++)
	for (int c = 0; c < col; c++)
	{
		if (MyRegion.isPointValid(r, c) == 0) continue;

		int S = MyPeople.get_sPeopleMat().get_value(r, c);
		int P = MyPeople.get_pPeopleMat().get_value(r, c);
		int R = MyPeople.get_rPeopleMat().get_value(r, c);
		int vn = MyRegion.get_VaccineDistribution().get_value(r, c);
		int cn = MyRegion.get_CureDistribution().get_value(r, c);
		double vp = MyMedicine.get_vaccine_efficiency();
		double cp = MyMedicine.get_cure_efficiency();

		//1.s->r
		if (S > 0 && vn> 0)
		{
			int usev = vn;
			if (usev > S)
				usev = S;

			int N_s2r = int(vp*usev);
			if (N_s2r <= 0)N_s2r = 1;
			MyPeople.get_sPeopleMat().set_value(r, c, S - N_s2r);
			MyPeople.get_rPeopleMat().set_value(r, c, R + N_s2r);

			MyRegion.get_VaccineDistribution().set_value(r, c, vn - usev);
			NewImmunePeople += N_s2r;
		}
		//1.p->r
		if (P > 0 && cn > 0)
		{
			int usec = cn;
			if (cn > P)
				usec = P;
			int N_p2r = int(cp*usec);
			if (N_p2r <= 0)N_p2r = 1;

			MyPeople.get_pPeopleMat().set_value(r, c, P - N_p2r);
			MyPeople.get_rPeopleMat().set_value(r, c, R + N_p2r);
			MyRegion.get_CureDistribution().set_value(r, c, cn - usec);
			NewRecoverPeople += N_p2r;
		}
	}
}

//save
void Process::save(string OutFileName, string dir)
{
	outFile.open(dir+OutFileName, ios::app | ios::out);
	//update data
	SPeopleNum = SPeopleNum - NewPrimerPeople - NewImmunePeople;
	PrimerPeople = PrimerPeople + NewPrimerPeople - NewAdvancedPeople - NewRecoverPeople;
	AdvancedPeople= AdvancedPeople + NewAdvancedPeople - NewDeadPeople;
	RecoverPeople += NewRecoverPeople;
	ImmunePeople += NewImmunePeople;
	DeadPeople += NewDeadPeople;


	//save data
	outFile << SPeopleNum << '\t' << PrimerPeople << '\t' << AdvancedPeople << '\t' << RecoverPeople <<'\t'<< ImmunePeople << '\t' << DeadPeople << endl;
	//cout << SPeopleNum << '\t' << PrimerPeople << '\t' << AdvancedPeople << '\t' << RecoverPeople << '\t' << ImmunePeople << '\t' << DeadPeople << endl;

	outFile.close();

	//save Image
	cvSaveImage((dir + "ebola-s" + num2str(ProgramCounter) + ".jpg").data(), MyPeople.get_sPeopleMat().create_iplimage());
	cvSaveImage((dir + "ebola-p" + num2str(ProgramCounter) + ".jpg").data(), MyPeople.get_pPeopleMat().create_iplimage());
	cvSaveImage((dir + "ebola-a" + num2str(ProgramCounter) + ".jpg").data(), MyPeople.get_aPeopleMat().create_iplimage());
	cvSaveImage((dir + "ebola-d" + num2str(ProgramCounter) + ".jpg").data(), MyPeople.get_dPeopleMat().create_iplimage());
	cvSaveImage((dir + "ebola-r" + num2str(ProgramCounter) + ".jpg").data(), MyPeople.get_rPeopleMat().create_iplimage());


}

#include<opencv2\highgui\highgui.hpp>
#include<opencv2\core\core.hpp>
#include<cv.h>
#include<math.h>
void Process::save_color_image(string dir)
{
	double MaxNumLog= log10(MyPeople.get_AllPeopleMat().cal_max_value());
	using namespace cv;
	int row = MyRegion.get_RegionMat().get_rows();
	int col = MyRegion.get_RegionMat().get_cols();
	Mat ColorImage = Mat(row, col, CV_8UC3);

	uchar sColor[3] = { 124, 179, 163 };
	uchar pColor[3] = { 200, 200, 50 };
	uchar aColor[3] = { 200, 50, 200 };
	uchar rColor[3] = { 50, 200, 50 };
	uchar dColor[3] = { 50, 50, 50 };
	for (int r = 0; r < row;r++)

	for (int c = 0; c < col; c++)
	{
		uchar red, green, blue;
		if (MyRegion.isPointValid(r,c) == 1)
		{
			
			unsigned int sNum = MatrixFloat::Round(MyPeople.get_sPeopleMat().get_value(r, c));
			unsigned int pNum = MatrixFloat::Round(MyPeople.get_pPeopleMat().get_value(r, c));
			unsigned int aNum = MatrixFloat::Round(MyPeople.get_aPeopleMat().get_value(r, c));
			unsigned int rNum = MatrixFloat::Round(MyPeople.get_rPeopleMat().get_value(r, c));
			unsigned int dNum = MatrixFloat::Round(MyPeople.get_dPeopleMat().get_value(r, c));

			if (sNum < 5)sNum = 0;
			if (pNum < 5)pNum = 0;
			if (aNum < 5)aNum = 0;
			if (rNum < 5)rNum = 0;
			if (dNum < 5)rNum = 0;
			int sumNum = sNum + pNum + aNum + rNum + dNum;

			double gain = log10(sumNum) / MaxNumLog;

			double sRatio = gain*sNum / sumNum;
			double pRatio = gain*pNum / sumNum;
			double aRatio = gain*aNum / sumNum;
			double rRatio = gain*rNum / sumNum;
			double dRatio = gain*dNum / sumNum;
			red = unsigned char(sRatio * sColor[0] + pRatio * pColor[0] + aRatio * aColor[0] + rRatio * rColor[0] + dRatio*dColor[0]);
			green = unsigned char(sRatio * sColor[1] + pRatio *pColor[1] + aRatio * aColor[1] + rRatio * rColor[1]+ dRatio*dColor[0]);
			blue = unsigned char(sRatio * aColor[2] + pRatio * pColor[2] + aRatio * aColor[2] + rRatio * rColor[2] + dRatio*dColor[0]);
			
		}
		else
		{
			blue = 200; red = 10; green = 10;
		}
		ColorImage.at<uchar>(r, 3 * c) = blue;
		ColorImage.at<uchar>(r, 3 * c + 1) = green;
		ColorImage.at<uchar>(r, 3 * c + 2) = red;
		
	}
	cv::imwrite(dir + "color" + num2str(ProgramCounter) + ".jpg", ColorImage);
	//imshow("hehe", ColorImage);
	//waitKey(100);
}
Process::~Process()
{
	
}




int RandDay()
{
	cv::RNG rng;
	return rng.uniform(1, 3);
}


string num2str(int num)
{
	int t = num;
	//ÅÐ¶ÏÎ»Êý
	int wei;
	for (int i = 1;; i++)
	{
		if (num / (int)pow(10, i) == 0)
		{
			wei = i;
			break;
		}
	}

	char * str = new char[wei + 1];
	str[wei] = '\0';
	for (int i = wei - 1; i >= 0; i--)
	{
		str[i] = t % 10 + 48;
		t /= 10;
	}

	return str;
}