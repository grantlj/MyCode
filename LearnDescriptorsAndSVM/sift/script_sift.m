clear
clc
%ȷ�������ļ���ʽ����Ŀ¼����������
videoFileType='.mat';
videoLocation='E:/DIP/KTH_mat';
videoCategory={'boxing','handclapping','jogging','running','walking'};
%mat�ļ������Ŀ¼
targetLocation='siftMat';

%��ȡ��ÿ�������ļ���sift
for i=1:size(videoCategory,2)
    nowLocation=[videoLocation,'/',videoCategory{i}];
    %��ȡ�����ļ��ļ�����
    nowAllFileNameCell=fun_getAllFileName(nowLocation,videoFileType);
    fun_geneSIFT(nowLocation,nowAllFileNameCell,[targetLocation,'/',videoCategory{i}]);
end

%��ȡ�����ļ���sift����ȫ��������AllSIFT�����У���׼��������
allSIFT=[];
for i=1:size(videoCategory,2)
    nowLocation=[targetLocation,'/',videoCategory{i}];
    nowAllFileNameCell=fun_getAllFileName(nowLocation,'.mat');
    for j=1:size(nowAllFileNameCell)
        allSIFT=[allSIFT,fun_readMat([nowLocation,'/',nowAllFileNameCell{j}])];
    end
end

%�����е�sift���о���
allSIFT=allSIFT';
[~,center]=kmeans(allSIFT,20);

%�����ÿ�������������ȡ�����е�����ֵ��Ϊһ����ά����  û��Ϊһ������ֵ��ÿһ������ֵ��Ӧһ����ǩ
%��ǩ��������������ڵ����
allFeature=[];
allLabel=[];

for i=1:size(videoCategory,2)
    nowLocation=[targetLocation,'/',videoCategory{i}];
    %��ȡ�����ļ��ļ�����
    nowAllFileNameCell=fun_getAllFileName(nowLocation,'.mat');
    
    %��ȡ�����ļ���������Ϣ
    nowFeature=fun_getFeature(nowLocation,nowAllFileNameCell,center);
    %˳�㱣���������ֵ
    %���ϴ�����Ϣ�ı�ǩ
    nowTag=ones(size(nowFeature,1),1).*i;
    
    %����
    allFeature=[allFeature;nowFeature];
    allLabel=[allLabel;nowTag];
end
%�Է�������б���


%ʹ��libSvm���з���
libsvmOptions='-s 1 -t 2 -g 0.1';
model = svmtrain(allLabel, allFeature,libsvmOptions);

%��ÿ�����Ԥ��
%�������һ���ṹ��������result(i)
for i=1:size(videoCategory,2)
    nowFeature=allFeature(allLabel==i,:);
    nowTag=ones(size(nowFeature,1),1).*i;
    
    [result(i).predictedLabel, result(i).accuracy, result(i).prob_estimates] = svmpredict(nowTag,nowFeature,model);
    
end
