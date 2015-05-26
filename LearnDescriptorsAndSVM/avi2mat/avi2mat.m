clear
clc
%确定视屏文件格式，根目录和所有种类
videoFileType='.avi';
videoLocation='E:/DIP/KTH';
videoCategory={'boxing','handclapping','jogging','running','walking'};
outMatLocation='E:/DIP/KTH_mat';

%开始转换
for i=1:size(videoCategory,2)
    nowLocation=[videoLocation,'/',videoCategory{i}];
    %读取所有文件文件名称
    nowAllFileNameCell=fun_getAllFileName(nowLocation,videoFileType);
    fun_geneMat(nowLocation,nowAllFileNameCell,[outMatLocation,'/',videoCategory{i}]);
end
