
#include<string>
#include<ctime>
#include<cmath>
#include<cstdlib>
#include<Windows.h>
using namespace std;

//������ߺ���
void randSleep(int start, int end)
{

	srand((unsigned)time(NULL));
	unsigned int  sleepTime = rand() % (end - start) + start;
	Sleep(sleepTime);
}

string num2str(int num)
{
	int t = num;
	//�ж�λ��
	int wei;
	for (int i = 1;; i++)
	{
		if (num / (int)pow(10, i) == 0)
		{
			wei = i;
			break;
		}
	}

	char * str = new char[wei + 1];
	str[wei] = '\0';
	for (int i = wei - 1; i >= 0; i--)
	{
		str[i] = t % 10 + 48;
		t /= 10;
	}
	
	return str;
}