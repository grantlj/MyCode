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

	//������¼�Ƶ���Ϣ��ʾ��
	CvFont * Font;
	string OutFileName;

public:
	VideoController(const char * MapFileName, const char * FolderFileName = "");
	~VideoController();

	//����ӳ��ʹ�С�����µ�MyVideoWriter
	void create_new_VideoWriter(char KeyIndex,CvSize VideoSize,VideoWriter * &Writer  );


	//������¼�Ƶ���Ϣ��ʾ����
	void print_OutFileName(IplImage * Frame);

	//get
	bool get_isNeedRecord() const{ return isNeedRecord; }

private:

};

#endif

