#include"Container.h"

//-------------constructor-----------------
MatrixFloat::MatrixFloat()
{
	data = nullptr;
	rows = 0;
	cols = 0;
}
MatrixFloat::MatrixFloat(int r, int c)
{
	rows = r;
	cols = c;
	data = new float[rows* cols];
}

MatrixFloat::MatrixFloat(IplImage *ImageGray)
{
	rows = ImageGray->height;
	cols = ImageGray->width;

	data = new float[rows* cols];
	for (int r = 0; r < rows; r++)
	{
		uchar * p = (uchar *)ImageGray->imageData + r*ImageGray->widthStep;
		for (int c = 0; c < cols; c++)
		{
			data[r*cols + c] = p[c];
		}
	}

}

MatrixFloat::MatrixFloat(const MatrixFloat & MF)
{
	rows = MF.rows;
	cols = MF.cols;
	data = new float[rows* cols];
	for (int i = 0; i < rows* cols; i++)
		data[i] = MF.data[i];
}


//------------------operator---------------
MatrixFloat & MatrixFloat::operator=(const MatrixFloat & MF)
{
	rows = MF.rows;
	cols = MF.cols;
	data = new float[rows* cols];
	for (int i = 0; i < rows* cols; i++)
		data[i] = MF.data[i];
	return *this;
}


//--------------convolution-------------
MatrixFloat MatrixFloat::convolution(MatrixFloat & mask)
{

	unsigned int maskSize = mask.rows;
	int HalfSize = (maskSize - 1) / 2;

	MatrixFloat tempMat = MatrixFloat::zeros(rows, cols);

	for (int r = 0; r < rows; r++)
	for (int c = 0; c < cols; c++)
	{
		//to do every point 
		MatrixFloat MaskRegionVal = MatrixFloat::zeros(maskSize, maskSize);
		for (int i = -HalfSize; i <= HalfSize; i++)
		for (int j = -HalfSize; j <= HalfSize; j++)
		{
			if (r + i < 0 || r + i >= rows || c + j < 0 || c + j >= cols)
				continue;
			MaskRegionVal.set_value(HalfSize + i, HalfSize + j, this->get_value(r + i, c + j));
		}
		float sum = 0;
		for (int i = 0; i < maskSize*maskSize; i++)
		{
			sum += MaskRegionVal.get_value(i)*mask.get_value(i);
		}
		tempMat.set_value(r, c, sum);
	}
	return tempMat;

}



//--------------------get------------------
IplImage * MatrixFloat::create_iplimage() const
{
	//normalize 0~255
	float min = cal_min_value();
	float max = cal_max_value();



	IplImage * ImageGray = cvCreateImage(cvSize(cols, rows), IPL_DEPTH_8U, 1);
	for (int r = 0; r < rows; r++)
	{
		uchar * p = (uchar *)ImageGray->imageData + r*ImageGray->widthStep;
		for (int c = 0; c < cols; c++)
		{
			p[c] = int(255 * (data[r*cols + c] - min) / (max - min));
		}
	}
	return ImageGray;
}


float MatrixFloat::cal_max_value() const
{
	float max = data[0];
	for (int i = 1; i < rows*cols; i++)
	if (data[i]>max)
		max = data[i];
	return max;
}

float MatrixFloat::cal_min_value() const
{
	float min = data[0];
	for (int i = 1; i < rows*cols; i++)
	if (data[i]<min)
		min = data[i];
	return min;
}


MatrixFloat MatrixFloat::zeros(int row, int col)
{
	MatrixFloat Z = MatrixFloat(row, col);
	for (int i = 0; i < row*col; i++)
		Z.data[i] = 0;
	return Z;
}
MatrixFloat MatrixFloat::ones(int row, int col)
{
	MatrixFloat One = MatrixFloat(row, col);
	for (int i = 0; i < row*col; i++)
		One.data[i] = 1;
	return One;
}

int MatrixFloat::Round(double d)
{
	return int(d + 0.5);
}



MatrixFloat::~MatrixFloat()
{
	delete[] data;
}

