clear
clc
%ȷ�������ļ���ʽ����Ŀ¼����������
videoFileType='.avi';
videoLocation='E:/DIP/KTH';
videoCategory={'boxing','handclapping','jogging','running','walking'};
outMatLocation='E:/DIP/KTH_mat';

%��ʼת��
for i=1:size(videoCategory,2)
    nowLocation=[videoLocation,'/',videoCategory{i}];
    %��ȡ�����ļ��ļ�����
    nowAllFileNameCell=fun_getAllFileName(nowLocation,videoFileType);
    fun_geneMat(nowLocation,nowAllFileNameCell,[outMatLocation,'/',videoCategory{i}]);
end
