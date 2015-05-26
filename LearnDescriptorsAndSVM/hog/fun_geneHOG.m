function HOG = fun_geneHOG( fileLocation,fileNames,targetLocation )
%��ȡ������Ƶ�ļ���������������ֵ,��������ͬ���ļ�������(��׺��ͬ)
%   Detailed explanation goes here

%���������ļ���
for i=1:size(fileNames,2)
    %��ʾ��ǰ����
    disp([fileLocation,'    ',num2str(i),'/',num2str(size(fileNames,2))]);
    %���Ƚ� ������׺�� ���ļ�����ȡ��
    fileName=fileNames{i};
    fileName=fileName(1:findstr(fileName,'.')-1);
    
    %��ȡ����Ƶ�ļ�
    load([fileLocation,'/',fileNames{i}]);
    numFrames=size(vedio,3); %֡��
    
    
     
    %��ʼ��ȡĳ���ļ���Ƶ�ļ�������
    HOG=[];
    
    %�������ֵ�ļ��Ƿ��Ѿ����ڣ�������ڴ��ļ���ֱ���Թ�
     if exist([targetLocation,'/',fileName,'.mat'],'file')>0
         continue
     end
    
    for j=1:3:numFrames  %�����趨һЩ���
        %��ȡ�����Ĺ���
        nowHOG=vl_hog(single(vedio(:,:,j)), 10) ;
        HOG=[HOG;reshape(nowHOG,numel(nowHOG)/31,31)];
    end
    
    %����ȡ��ɵ�����ֵ��������Ӧλ��
    save([targetLocation,'/',fileName,'.mat'],'HOG');
    
end

end

