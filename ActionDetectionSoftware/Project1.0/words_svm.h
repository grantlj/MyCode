#ifndef WORDS_SVM_H_
#define WORDS_SVM_H_


#include"svm.h"
#include"feature.h"
#include"other.h"
#include<string>
#include<vector>

using std::string;
using std::vector;

class Words_SVM
{
	struct Map
	{
		unsigned short index;
		string ActionName;
	};
	//words
	float *WordsData;
	unsigned int WordsLength;
	unsigned int WordsNum;
	//svm
	svm_model * Model;
	vector<Map> MapVector;
public:
	Words_SVM(){ WordsData = nullptr; WordsLength = 0; }
	~Words_SVM();
	Words_SVM(const char * WordsFile ,const char * ModelFile, const char *MapFile);
	unsigned int get_WordsLength() const{ return WordsLength; }
	unsigned int get_WordsNum() const{ return WordsNum; }
	float get_words_data(unsigned int num, unsigned int the) { return WordsData[num*WordsLength + the]; }

	//´¦Àíº¯Êý
	void bow_svm(FeatrueVector & ThreadVector,  AllResult & Result);
private:

};

#endif