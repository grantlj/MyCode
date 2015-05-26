#ifndef CONTAINER_H_
#define CONTAINER_H_

#include<cv.h>

class MatrixFloat
{
	float * data;
	unsigned int rows;
	unsigned int cols;

public:
	MatrixFloat();
	MatrixFloat(int r, int c);
	MatrixFloat::MatrixFloat(IplImage *Image);
	MatrixFloat(const MatrixFloat & MF);
	MatrixFloat & operator=(const MatrixFloat & MF);
	~MatrixFloat();

	IplImage * create_iplimage() const;
	MatrixFloat convolution(MatrixFloat & mask);
	//operators
	

	//get
	float * get_row_point(int row) const{ return data + cols*row; }
	float  get_value(int row, int col) const{ return data[cols*row + col]; }
	float  get_value(int index)const{ return data[index]; }
	unsigned int get_rows() const{ return rows; }
	unsigned int get_cols() const{ return cols; }

	//set
	void set_value(int r, int c, float v){ data[cols*r + c] = v; }
	void set_value(int index, float v){ data[index] = v; }

	//cal
	float cal_max_value() const;
	float cal_min_value() const;

	//static functions
	static  MatrixFloat zeros(int row, int col);
	static  MatrixFloat ones(int row, int col);

	static int Round(double d);
private:

};




#endif