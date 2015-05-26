clear
clc

%为了在服务器上运行,需要添加的几行代码
addpath(genpath('/data/collegestudent/toolbox/libsvm-3.18'),'-begin');
addpath(genpath('/data/collegestudent/toolbox/VLFEATROOT'),'-end');
% cd /data/collegestudent/shentao/phog

%确定视屏文件格式，根目录和所有种类
videoFileType='.mat'; %已经把视频文件转为了mat 本机地址：E:\DIP\KTH_mat 服务器地址： /data/collegestudent/KTH_ma
videoLocation='/data/collegestudent/KTH_mat';
videoCategory={'boxing','handclapping','jogging','running','walking'};
%提取特征值要保存的mat文件所到的目录（****Mat）
targetLocation='hogMat';



%提取出所有视屏文件的所有帧的所有特征值，按文件保存在****Mat文件夹下
for i=1:size(videoCategory,2)
    %得到某类视频在的文件夹
    nowLocation=[videoLocation,'/',videoCategory{i}];
    %读取当前文件夹下所有文件名称
    nowAllFileNameCell=fun_getAllFileName(nowLocation,videoFileType);
    %提取并保存特征值
    fun_geneHOG(nowLocation,nowAllFileNameCell,[targetLocation,'/',videoCategory{i}]);
end

%提取所有文件的特征，并全部集中在All+特证名变量中，以准备做聚类
allHOG=[];
for i=1:size(videoCategory,2)
    nowLocation=[targetLocation,'/',videoCategory{i}];
    nowAllFileNameCell=fun_getAllFileName(nowLocation,'.mat');
    for j=1:size(nowAllFileNameCell)
        allHOG=[allHOG;fun_readMat([nowLocation,'/',nowAllFileNameCell{j}])];
    end
end

%提取所有特征的一部分进行聚类
randNum=randperm(size(allHOG,1));
randNum=randNum(1: round(size(allHOG,1)*0.1) );
[~,center]=kmeans(allHOG(randNum,:),30);

%下面对每个类进行特征提取，所有的特征值存为一个二维矩阵，  没行为一个特征值，每一个特征值对应一个标签
%标签代表这个特征属于的类别
allFeature=[];
allLabel=[];
for i=1:size(videoCategory,2)
    nowLocation=[targetLocation,'/',videoCategory{i}];
    %读取所有文件文件名称
    nowAllFileNameCell=fun_getAllFileName(nowLocation,'.mat');
    
    %获取所有文件的特征信息
    nowFeature=fun_getFeature(nowLocation,nowAllFileNameCell,center,videoLocation,videoCategory{i});
    %顺便保存这个特征值
    %配上此类信息的标签
    nowTag=ones(size(nowFeature,1),1).*i;
    
    %保存
    allFeature=[allFeature;nowFeature];
    allLabel=[allLabel;nowTag];
end
%以防意外进行保存

save('saveMat.mat')
disp('all done!')

%libsvm参数寻优
[bestCVaccuracy,bestc,bestg]=SVMcgForClass(allLabel,allFeature,-9,9,-9,9,size(allLabel,1),1,1,6);
%使用libSvm进行分类
libsvmOptions='-s 1 -t 2 -g 32';
model = svmtrain(allLabel, allFeature ,libsvmOptions);

%对每组进行预测
%结果放在一个结构体数组中result(i)
for i=1:size(videoCategory,2)
    nowFeature=allFeature(allLabel==i,:);
    nowTag=ones(size(nowFeature,1),1).*i;
    
    [result(i).predictedLabel, result(i).accuracy, result(i).prob_estimates] = svmpredict(nowTag,nowFeature,model,nowFeature);
    
end
