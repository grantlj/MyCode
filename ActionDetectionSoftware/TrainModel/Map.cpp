#include"Map.h"



Map::Map()
{

}

Map::Map(vector<VideoFile *> & vfv,string OutFileName)
{
	unsigned int label = 1;
	for (int i = 0; i < vfv.size(); i++)
	{
		string act_name = vfv[i]->get_action_Name();
		if (!is_Maps_already_have(act_name))
		{
			MapNode NewNode;
			NewNode.label = label++;
			NewNode.ActionName = act_name;
			Maps.push_back(NewNode);
		}
	}
	//save Map
	ofstream OFS;
	OFS.open(OutFileName);
	for (int i = 0; i < Maps.size(); i++)
	{
		OFS << Maps[i].label << " " << Maps[i].ActionName << endl;
	}
	OFS.close();
	mark_label(vfv);
}

void Map::mark_label(vector<VideoFile *> & vfv)
{
	for (int i = 0; i < vfv.size(); i++)
	{
		vfv[i]->set_label(0);
		for (int j = 0; j < Maps.size(); j++)
		if (vfv[i]->get_action_Name() == Maps[j].ActionName)
		{
			vfv[i]->set_label(Maps[j].label);
			break;
		}
	}
}


bool Map::is_Maps_already_have(string an)
{
	for (int i = 0; i < Maps.size();i++)
	if (an == Maps[i].ActionName)
		return true;
	return false;
}



Map::~Map()
{

}