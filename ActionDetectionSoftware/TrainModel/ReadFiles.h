#ifndef READFILES_H_
#define READFILES_H_

#include <iostream>
#include <io.h>
#include<vector>
#include<string>

using namespace std;

class ReadFiles
{
	vector<string> FilesNameVector;
	unsigned int FileNumber;
public:
	ReadFiles();
	ReadFiles(string DirName);
	~ReadFiles();

	bool is_file_exist(string FileName);
	unsigned int get_files_number()const { return FileNumber; }
	string & get_index_string(unsigned ind){ return FilesNameVector[ind]; }

private:
	//迭代读取文件名
	void getFiles(string path, vector<string>& files);
	vector<string> & get_files_name_vector() { return FilesNameVector; }
};





#endif