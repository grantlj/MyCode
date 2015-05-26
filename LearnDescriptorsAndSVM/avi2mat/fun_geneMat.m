function SIFT = fun_geneMat( fileLocation,fileNames,targetLocation )
%��ȡ�����ļ�������SIFT,��������ͬ���ļ�������(��׺��ͬ)
%   Detailed explanation goes here
for i=1:size(fileNames,2)
    disp([fileLocation,'    ',num2str(i),'/',num2str(size(fileNames,2))]);
   
    %���ȣ���ȡ����Ƶ�ļ�
    objVideo=VideoReader([fileLocation,'/',fileNames{i}]);
    allColorFrames=read(objVideo);
    numFrames=objVideo.numberOfFrames;
    %���лҶȻ���ֱ��ͼ����
    for j=1:numFrames
        vedio(:,:,j)=rgb2gray(allColorFrames(:,:,:,j));
    end
    

    %���Ƚ���ȥ��׺�����ļ�����ȡ��
    fileName=fileNames{i};
    fileName=fileName(1:findstr(fileName,'.')-1);
    %����ȡ��ɵ�sift���б���
    save([targetLocation,'/',fileName,'.mat'],'vedio');
    
end

end

