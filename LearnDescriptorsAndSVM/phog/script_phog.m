clear
clc

%Ϊ���ڷ�����������,��Ҫ��ӵļ��д���
addpath(genpath('/data/collegestudent/toolbox/libsvm-3.18'),'-begin');
addpath(genpath('/data/collegestudent/toolbox/VLFEATROOT'),'-end');
% cd /data/collegestudent/shentao/phog

%ȷ�������ļ���ʽ����Ŀ¼����������
videoFileType='.mat'; %�Ѿ�����Ƶ�ļ�תΪ��mat ������ַ��E:\DIP\KTH_mat ��������ַ�� /data/collegestudent/KTH_ma
videoLocation='/data/collegestudent/KTH_mat';
videoCategory={'boxing','handclapping','jogging','running','walking'};
%��ȡ����ֵҪ�����mat�ļ�������Ŀ¼��****Mat��
targetLocation='hogMat';



%��ȡ�����������ļ�������֡����������ֵ�����ļ�������****Mat�ļ�����
for i=1:size(videoCategory,2)
    %�õ�ĳ����Ƶ�ڵ��ļ���
    nowLocation=[videoLocation,'/',videoCategory{i}];
    %��ȡ��ǰ�ļ����������ļ�����
    nowAllFileNameCell=fun_getAllFileName(nowLocation,videoFileType);
    %��ȡ����������ֵ
    fun_geneHOG(nowLocation,nowAllFileNameCell,[targetLocation,'/',videoCategory{i}]);
end

%��ȡ�����ļ�����������ȫ��������All+��֤�������У���׼��������
allHOG=[];
for i=1:size(videoCategory,2)
    nowLocation=[targetLocation,'/',videoCategory{i}];
    nowAllFileNameCell=fun_getAllFileName(nowLocation,'.mat');
    for j=1:size(nowAllFileNameCell)
        allHOG=[allHOG;fun_readMat([nowLocation,'/',nowAllFileNameCell{j}])];
    end
end

%��ȡ����������һ���ֽ��о���
randNum=randperm(size(allHOG,1));
randNum=randNum(1: round(size(allHOG,1)*0.1) );
[~,center]=kmeans(allHOG(randNum,:),30);

%�����ÿ�������������ȡ�����е�����ֵ��Ϊһ����ά����  û��Ϊһ������ֵ��ÿһ������ֵ��Ӧһ����ǩ
%��ǩ��������������ڵ����
allFeature=[];
allLabel=[];
for i=1:size(videoCategory,2)
    nowLocation=[targetLocation,'/',videoCategory{i}];
    %��ȡ�����ļ��ļ�����
    nowAllFileNameCell=fun_getAllFileName(nowLocation,'.mat');
    
    %��ȡ�����ļ���������Ϣ
    nowFeature=fun_getFeature(nowLocation,nowAllFileNameCell,center,videoLocation,videoCategory{i});
    %˳�㱣���������ֵ
    %���ϴ�����Ϣ�ı�ǩ
    nowTag=ones(size(nowFeature,1),1).*i;
    
    %����
    allFeature=[allFeature;nowFeature];
    allLabel=[allLabel;nowTag];
end
%�Է�������б���

save('saveMat.mat')
disp('all done!')

%libsvm����Ѱ��
[bestCVaccuracy,bestc,bestg]=SVMcgForClass(allLabel,allFeature,-9,9,-9,9,size(allLabel,1),1,1,6);
%ʹ��libSvm���з���
libsvmOptions='-s 1 -t 2 -g 32';
model = svmtrain(allLabel, allFeature ,libsvmOptions);

%��ÿ�����Ԥ��
%�������һ���ṹ��������result(i)
for i=1:size(videoCategory,2)
    nowFeature=allFeature(allLabel==i,:);
    nowTag=ones(size(nowFeature,1),1).*i;
    
    [result(i).predictedLabel, result(i).accuracy, result(i).prob_estimates] = svmpredict(nowTag,nowFeature,model,nowFeature);
    
end
