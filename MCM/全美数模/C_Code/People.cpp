#include"People.h"

People::People()
{

}


People::People(const MatrixFloat & RegionMat, unsigned int MiniPeopleNum)
{
	ifstream InFile;
	//-------initial city and contry people------
	//get 2d gaussian filter
	int FilterSize = 17;
	float Gauss1D[] = { 0.0221897922884478, 0.0299530865588433, 0.0388470591466680, 0.0484064164544147, 0.0579530022657306, 0.0666618200713834, 0.0736727048888844, 0.0782283705338685, 0.0798086884467622, 0.0782283705338685, 0.0736727048888844, 0.0666618200713834, 0.0579530022657306, 0.0484064164544147, 0.0388470591466680, 0.0299530865588433, 0.0221897922884478 };
	Gauss2dFilter = MatrixFloat(FilterSize, FilterSize);

	//get gaussian mask 2d
	for (int i = 0; i < FilterSize; i++)
	for (int j = 0; j < FilterSize; j++)
		Gauss2dFilter.set_value(i, j, Gauss1D[i] * Gauss1D[j]);

	//normalize gaussian mask, set the center element value to 1 ;
	float CenterValue = Gauss2dFilter.get_value((FilterSize - 1) / 2, (FilterSize - 1) / 2);
	double GaussGain = 1.0 / CenterValue;

	for (int i = 0; i < FilterSize; i++)
	for (int j = 0; j < FilterSize; j++)
	{
		Gauss2dFilter.set_value(i, j, Gauss2dFilter.get_value(i, j)*GaussGain);
	}
	Gauss2dFilter.set_value((FilterSize - 1) / 2, (FilterSize - 1) / 2, 1.0);



	//all zero
	AllPeopleMat = MatrixFloat::zeros(RegionMat.get_rows(), RegionMat.get_cols());

	InFile.open("city.txt");
	while (true)
	{
		City NowCity;
		InFile >> NowCity.x >> NowCity.y >> NowCity.num;
		//start from 1 to  from 0
		NowCity.x--;
		NowCity.y--;

		//add gaussian 

		if (!InFile)
			break;
		add_gaussian(NowCity, AllPeopleMat);
	}
	InFile.close();

	for (int i = 0; i < AllPeopleMat.get_rows()*AllPeopleMat.get_cols(); i++)
	if (AllPeopleMat.get_value(i) < MiniPeopleNum)
		AllPeopleMat.set_value(i, MiniPeopleNum);

	PeopleNum = 0;
	for (int i = 0; i < AllPeopleMat.get_rows()*AllPeopleMat.get_cols(); i++)
	{
		int ThePoint = MatrixFloat::Round(AllPeopleMat.get_value(i) * RegionMat.get_value(i));
		AllPeopleMat.set_value(i, ThePoint);
		PeopleNum += ThePoint;
	}
		


	//all mat give 0
	sPeopleMat = MatrixFloat::zeros(RegionMat.get_rows(), RegionMat.get_cols());
	pPeopleMat = MatrixFloat::zeros(RegionMat.get_rows(), RegionMat.get_cols());
	aPeopleMat = MatrixFloat::zeros(RegionMat.get_rows(), RegionMat.get_cols());
	rPeopleMat = MatrixFloat::zeros(RegionMat.get_rows(), RegionMat.get_cols());
	dPeopleMat = MatrixFloat::zeros(RegionMat.get_rows(), RegionMat.get_cols());

	//add initial case of disease
	InFile.open("initialCase.txt");
	while (true)
	{
		City NowCity;
		InFile >> NowCity.x >> NowCity.y >> NowCity.num;
		if (!InFile)
			break;
		add_gaussian(NowCity, pPeopleMat);
	}
	for (int i = 0; i < AllPeopleMat.get_rows()*AllPeopleMat.get_cols(); i++)
		pPeopleMat.set_value(i, pPeopleMat.get_value(i) * RegionMat.get_value(i));


	//sPeopleMat = AllPeopleMat - pPeopleMat;
	for (int i = 0; i < AllPeopleMat.get_rows()*AllPeopleMat.get_cols(); i++)
	{
		if (pPeopleMat.get_value(i) > AllPeopleMat.get_value(i))
		{
			sPeopleMat.set_value(i, 0);
			pPeopleMat.set_value(i, AllPeopleMat.get_value(i));
		}
		else
		{
			sPeopleMat.set_value(i, AllPeopleMat.get_value(i) - pPeopleMat.get_value(i));
		}
	}

}


void People::add_gaussian(City NowCity, MatrixFloat & M)
{
	int FilterSize = Gauss2dFilter.get_rows();
	int HalfSize = (FilterSize - 1) / 2;
	for (int r = -HalfSize; r <= HalfSize; r++)
	{
		if (NowCity.y + r < 0 || NowCity.y + r >= M.get_rows()) continue;
		for (int c = -HalfSize; c <= HalfSize; c++)
		{
			if (NowCity.x + c < 0 || NowCity.x + c >= M.get_cols())continue;

			M.set_value(NowCity.y + r,
				NowCity.x + c,
				MatrixFloat::Round(M.get_value(NowCity.y + r, NowCity.x + c) + Gauss2dFilter.get_value(HalfSize + r, HalfSize + c)*NowCity.num));
		}
	}
}


People::~People()
{

}
