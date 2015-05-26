#include"State.h"


State::State()
{
	ifstream inFile;
	P_a2d = 0.2;
	P_p2a_Initial = 0.2;
	//gaussian
	inFile.open("gaussian.txt");
	unsigned gaussianSize;
	inFile >> gaussianSize;
	Gaussian = MatrixFloat(gaussianSize, gaussianSize);
	for (int i = 0; i < gaussianSize*gaussianSize; i++)
	{
		float temp;
		inFile >> temp;
		Gaussian.set_value(i, temp);
	}
	inFile.close();

	//mask
	inFile.open("mask.txt");
	unsigned maskSize;
	inFile >> maskSize;
	Mask = MatrixFloat(maskSize, maskSize);
	for (int i = 0; i < maskSize*maskSize; i++)
	{
		float temp;
		inFile >> temp;
		Mask.set_value(i, temp);
	}
	inFile.close();
}



State::~State()
{

}
