#include"videoWriter.h"
#include"Camera.h"
#include"VideoController.h"

#include<cv.h>
#include<highgui.h>
#include<cxcore.h>
#include<iostream>
#include<cstdlib>
#include<ctime>
#include<Windows.h>

using namespace std;





int main()
{	
	VideoController MyVideoController = VideoController("map.txt", "folder.txt");
	//½¨Á¢Camera
	Camera MyCamera = Camera(0, 0.5);
	//size
	CvSize VideoSize = MyCamera.get_capture_size();
	VideoWriter * MyVideoWriter = nullptr;
	cvNamedWindow("SaveVideo");
	while (true)
	{
		MyCamera.updata_NowFrame();
		

		if (MyVideoController.get_isNeedRecord())
			MyVideoWriter->write_frame(MyCamera.get_NowFrame());


		MyVideoController.print_OutFileName(MyCamera.get_NowFrame());
		char c = MyCamera.show_NowFrame("SaveVideo", 1);

		MyVideoController.create_new_VideoWriter(c, VideoSize, MyVideoWriter);

		if (c == 27) 
			break;	
	}





	cvDestroyAllWindows();
	delete MyVideoWriter;
}