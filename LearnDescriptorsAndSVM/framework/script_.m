
%ȷ�������ļ���ʽ����Ŀ¼����������
vedioFileType='.avi';
vedioLocation='E:/DIP/KTH/';
vedioCategory={'boxing','handclapping','jogging','runing','walking'};

%�����ÿ�������������ȡ�����е�����ֵ��Ϊһ����ά����  û��Ϊһ������ֵ��ÿһ������ֵ��Ӧһ����ǩ
%��ǩ��������������ڵ����
allFeature=[];
allLabel=[];

for i=1:size(vedioCategory,2)
    nowLocation=[vedioLocation,vedioCategory{i}];
    %��ȡ�����ļ��ļ�����
    nowAllFileNameCell=fun_getAllFileName(nowLocation,vedioFileType);
    
    %��ȡ�����ļ���������Ϣ
    nowFeature=fun_getFeature(nowLocation,nowAllFileNameCell);
    %˳�㱣���������ֵ
    %���ϴ�����Ϣ�ı�ǩ
    nowTag=ones(size(nowFeature,1),1).*i;
    
    %����
    allFeature=[allFeature;nowFeature];
    allLabel=[allLabel;nowTag];
end
%�Է�������б���


%ʹ��libSvm���з���
libsvmOptions='';
model = svmtrain(allLabel, allFeature ,libsvmOptions);

%��ÿ�����Ԥ��
%�������һ���ṹ��������result(i)
for i=1:size(vedioCategory,2)
    nowFeature=allFeature(allTag==i,:);
    nowTag=ones(size(nowFeature,1),1).*i;
    
    [result(i).predictedLabel, result(i).accuracy, result(i).prob_estimates] = svmpredict(nowTag,nowFeature,modelnowFeature,libsvmOptions );
    
end
