function SIFT = fun_geneMat( fileLocation,fileNames,targetLocation )
%获取所用文件的所有SIFT,并且以相同的文件名保存(后缀不同)
%   Detailed explanation goes here
for i=1:size(fileNames,2)
    disp([fileLocation,'    ',num2str(i),'/',num2str(size(fileNames,2))]);
   
    %首先，读取此视频文件
    objVideo=VideoReader([fileLocation,'/',fileNames{i}]);
    allColorFrames=read(objVideo);
    numFrames=objVideo.numberOfFrames;
    %进行灰度化和直方图均衡
    for j=1:numFrames
        vedio(:,:,j)=rgb2gray(allColorFrames(:,:,:,j));
    end
    

    %首先将出去后缀名的文件名提取出
    fileName=fileNames{i};
    fileName=fileName(1:findstr(fileName,'.')-1);
    %将提取完成的sift进行保存
    save([targetLocation,'/',fileName,'.mat'],'vedio');
    
end

end

