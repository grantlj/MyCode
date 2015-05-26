#ifndef MAP_H_
#define MAP_H_
#include"VideoFile.h"
#include"ReadFiles.h"

#include <iostream>
#include<fstream>
#include<vector>
#include<string>

using namespace std;


class Map
{
	struct MapNode
	{
		int label;
		string ActionName;
	};

	vector<MapNode> Maps;
public:
	Map();
	Map(vector<VideoFile *> & vfv,string OutFileName);
	void mark_label(vector<VideoFile *> & vfv);
	~Map();

private:
	bool is_Maps_already_have(string an);

};



#endif