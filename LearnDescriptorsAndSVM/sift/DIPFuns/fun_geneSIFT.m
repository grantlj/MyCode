function SIFT = fun_geneSIFT( fileLocation,fileNames,targetLocation )
%��ȡ�����ļ�������SIFT,��������ͬ���ļ�������(��׺��ͬ)
%   Detailed explanation goes here
for i=1:size(fileNames,2)
    disp([fileLocation,'    ',num2str(i),'/',num2str(size(fileNames,2))]);
   
    %���ȣ���ȡ����Ƶ�ļ�
    load([fileLocation,'/',fileNames{i}]);
    numFrames=size(vedio,3);
    
    
    %��ʼ��ȡĳ���ļ���Ƶ�ļ���SIFT
    SIFT=[];
    for j=1:numFrames
        nowSIFT=vl_sift(single(vedio(:,:,j)));
        nowSIFT([1,2],:)=[];
        SIFT=[SIFT,nowSIFT];
    end
    %���Ƚ���ȥ��׺�����ļ�����ȡ��
    fileName=fileNames{i};
    fileName=fileName(1:findstr(fileName,'.')-1);
    %����ȡ��ɵ�sift���б���
    save([targetLocation,'/',fileName,'.mat'],'SIFT');
    
end

end

