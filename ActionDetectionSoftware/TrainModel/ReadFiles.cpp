#include"ReadFiles.h"



ReadFiles::ReadFiles()
{

}

ReadFiles::ReadFiles(string DirName)
{
	getFiles(DirName, FilesNameVector);
}

void ReadFiles::getFiles(string path, vector<string>& files)
{
	//文件句柄
	__int64   hFile = 0;
	//文件信息
	struct _finddatai64_t fileinfo;
	string p;
	if ((hFile = _findfirsti64(p.assign(path).append("/*").c_str(), &fileinfo)) != -1)
	{
		do
		{
			//如果是目录,迭代之
			//如果不是,加入列表
			if ((fileinfo.attrib &  _A_SUBDIR))
			{
				if (strcmp(fileinfo.name, ".") != 0 && strcmp(fileinfo.name, "..") != 0)
					getFiles(p.assign(path).append("/").append(fileinfo.name), files);
			}
			else
			{
				files.push_back(p.assign(path).append("/").append(fileinfo.name));
			}
		} while (_findnexti64(hFile, &fileinfo) == 0);
		_findclose(hFile);
	}

	FileNumber = FilesNameVector.size();
}


bool ReadFiles::is_file_exist(string FileName)
{
	for (int i = 0; i < FilesNameVector.size(); i++)
	{
		if (FileName == FilesNameVector[i])
		{
			return true;
		}
	}
	return false;
}

ReadFiles::~ReadFiles()
{

}
