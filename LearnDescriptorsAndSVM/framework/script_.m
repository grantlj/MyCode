
%确定视屏文件格式，根目录和所有种类
vedioFileType='.avi';
vedioLocation='E:/DIP/KTH/';
vedioCategory={'boxing','handclapping','jogging','runing','walking'};

%下面对每个类进行特征提取，所有的特征值存为一个二维矩阵，  没行为一个特征值，每一个特征值对应一个标签
%标签代表这个特征属于的类别
allFeature=[];
allLabel=[];

for i=1:size(vedioCategory,2)
    nowLocation=[vedioLocation,vedioCategory{i}];
    %读取所有文件文件名称
    nowAllFileNameCell=fun_getAllFileName(nowLocation,vedioFileType);
    
    %获取所有文件的特征信息
    nowFeature=fun_getFeature(nowLocation,nowAllFileNameCell);
    %顺便保存这个特征值
    %配上此类信息的标签
    nowTag=ones(size(nowFeature,1),1).*i;
    
    %保存
    allFeature=[allFeature;nowFeature];
    allLabel=[allLabel;nowTag];
end
%以防意外进行保存


%使用libSvm进行分类
libsvmOptions='';
model = svmtrain(allLabel, allFeature ,libsvmOptions);

%对每组进行预测
%结果放在一个结构体数组中result(i)
for i=1:size(vedioCategory,2)
    nowFeature=allFeature(allTag==i,:);
    nowTag=ones(size(nowFeature,1),1).*i;
    
    [result(i).predictedLabel, result(i).accuracy, result(i).prob_estimates] = svmpredict(nowTag,nowFeature,modelnowFeature,libsvmOptions );
    
end
