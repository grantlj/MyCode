#ifndef VEDIO_CONTROLLER_H_
#define VEDIO_CONTROLLER_H_

#include"videoWriter.h"


#include<string>
#include<vector>
using std::string;
using std::vector;

class VideoController
{
	struct Map
	{
		char index;
		string ActionName;
	};

	vector<Map> MapVector;
	bool isNeedRecord;

	string OutFileFolder;

	//将正在录制的信息显示出
	CvFont * Font;
	string OutFileName;

public:
	VideoController(const char * MapFileName, const char * FolderFileName = "");
	~VideoController();

	//根据映射和大小建立新的MyVideoWriter
	void create_new_VideoWriter(char KeyIndex,CvSize VideoSize,VideoWriter * &Writer  );


	//将正在录制的信息显示下来
	void print_OutFileName(IplImage * Frame);

	//get
	bool get_isNeedRecord() const{ return isNeedRecord; }

private:

};

#endif

