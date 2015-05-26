#include"Region.h"




Region::Region()
{
	IplImage *Image = cvLoadImage("region.jpg");
	IplImage *ImageGray = cvCreateImage(cvSize(Image->width, Image->height), IPL_DEPTH_8U, 1);
	cvCvtColor(Image, ImageGray, CV_BGR2GRAY);
	MatrixFloat MatGray = MatrixFloat(ImageGray);
	int row = ImageGray->height;
	int col = ImageGray->width;
	//confirm Region Mat	
	RegionMat = MatrixFloat::ones(row, col);
	for (int r = 0; r <RegionMat.get_rows(); r++)
	for (int c = 0; c < RegionMat.get_cols(); c++)
	{
		RegionMat.set_value(r, c, 0);
		if (MatGray.get_value(r, c) < 50)
			break;
	}
	for (int c = 0; c <RegionMat.get_cols(); c++)
	for (int r = RegionMat.get_rows() - 1; r >= 0; r--)
	{
		RegionMat.set_value(r, c, 0);
		if (MatGray.get_value(r, c) < 10)
			break;
	}

	//drug distribution
	VaccineDistribution = MatrixFloat::zeros(row, col);
	CureDistribution = MatrixFloat::zeros(row, col);

	//
	isDeliveryVaccineFlagMat = MatrixFloat::zeros(row, col);
	isDeliveryCureFlagMat = MatrixFloat::zeros(row, col);

	cvReleaseImage(&Image);

}


void Region::update_DeliveryVector_isDeliveryFlagMat()
{
	for (int i = 0; i < DeliveryVector.size(); i++)
	{
		DeliveryVector[i].DaysRemaining--;
		if (DeliveryVector[i].DaysRemaining == 0)
		{
			if (DeliveryVector[i].VaccineNum >0)
			{
				VaccineDistribution.set_value(
					DeliveryVector[i].row,
					DeliveryVector[i].col,
					VaccineDistribution.get_value(DeliveryVector[i].row, DeliveryVector[i].col) + DeliveryVector[i].VaccineNum
					);
				isDeliveryVaccineFlagMat.set_value(DeliveryVector[i].row, DeliveryVector[i].col, 0);
			}
			if (DeliveryVector[i].CureNum > 0)
			{
				CureDistribution.set_value(
					DeliveryVector[i].row,
					DeliveryVector[i].col,
					CureDistribution.get_value(DeliveryVector[i].row, DeliveryVector[i].col) + DeliveryVector[i].CureNum
					);
				isDeliveryCureFlagMat.set_value(DeliveryVector[i].row, DeliveryVector[i].col, 0);
			}
			DeliveryVector.erase(DeliveryVector.begin() + i);
		}
	}
}


//---------modify--------------

int Region::isPointValid(unsigned int row, unsigned int col)
{
	if (RegionMat.get_value(row, col) > 0.5)
		return 1;
	else
		return 0;
}

MatrixFloat Region::modify_matrix(MatrixFloat  & M)
{
	
	int row = M.get_rows();
	int col = M.get_cols();
	MatrixFloat R = MatrixFloat(row, col);

	for (int r = 0; r < row; r++)
	for (int c = 0; c < col; c++)
	{
		R.set_value(r, c, M.get_value(r, c)* isPointValid(r, c));
	}
	return R;
}

Region::~Region()
{

}