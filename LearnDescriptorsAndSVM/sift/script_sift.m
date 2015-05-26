clear
clc
%确定视屏文件格式，根目录和所有种类
videoFileType='.mat';
videoLocation='E:/DIP/KTH_mat';
videoCategory={'boxing','handclapping','jogging','running','walking'};
%mat文件保存的目录
targetLocation='siftMat';

%提取出每个视屏文件的sift
for i=1:size(videoCategory,2)
    nowLocation=[videoLocation,'/',videoCategory{i}];
    %读取所有文件文件名称
    nowAllFileNameCell=fun_getAllFileName(nowLocation,videoFileType);
    fun_geneSIFT(nowLocation,nowAllFileNameCell,[targetLocation,'/',videoCategory{i}]);
end

%提取所有文件的sift，并全部集中在AllSIFT变量中，以准备做聚类
allSIFT=[];
for i=1:size(videoCategory,2)
    nowLocation=[targetLocation,'/',videoCategory{i}];
    nowAllFileNameCell=fun_getAllFileName(nowLocation,'.mat');
    for j=1:size(nowAllFileNameCell)
        allSIFT=[allSIFT,fun_readMat([nowLocation,'/',nowAllFileNameCell{j}])];
    end
end

%对所有的sift进行聚类
allSIFT=allSIFT';
[~,center]=kmeans(allSIFT,20);

%下面对每个类进行特征提取，所有的特征值存为一个二维矩阵，  没行为一个特征值，每一个特征值对应一个标签
%标签代表这个特征属于的类别
allFeature=[];
allLabel=[];

for i=1:size(videoCategory,2)
    nowLocation=[targetLocation,'/',videoCategory{i}];
    %读取所有文件文件名称
    nowAllFileNameCell=fun_getAllFileName(nowLocation,'.mat');
    
    %获取所有文件的特征信息
    nowFeature=fun_getFeature(nowLocation,nowAllFileNameCell,center);
    %顺便保存这个特征值
    %配上此类信息的标签
    nowTag=ones(size(nowFeature,1),1).*i;
    
    %保存
    allFeature=[allFeature;nowFeature];
    allLabel=[allLabel;nowTag];
end
%以防意外进行保存


%使用libSvm进行分类
libsvmOptions='-s 1 -t 2 -g 0.1';
model = svmtrain(allLabel, allFeature,libsvmOptions);

%对每组进行预测
%结果放在一个结构体数组中result(i)
for i=1:size(videoCategory,2)
    nowFeature=allFeature(allLabel==i,:);
    nowTag=ones(size(nowFeature,1),1).*i;
    
    [result(i).predictedLabel, result(i).accuracy, result(i).prob_estimates] = svmpredict(nowTag,nowFeature,model);
    
end
