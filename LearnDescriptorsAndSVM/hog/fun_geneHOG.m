function HOG = fun_geneHOG( fileLocation,fileNames,targetLocation )
%获取所有视频文件的所有所需特征值,并且以相同的文件名保存(后缀不同)
%   Detailed explanation goes here

%遍历所有文件名
for i=1:size(fileNames,2)
    %显示当前进度
    disp([fileLocation,'    ',num2str(i),'/',num2str(size(fileNames,2))]);
    %首先将 除掉后缀名 的文件名提取出
    fileName=fileNames{i};
    fileName=fileName(1:findstr(fileName,'.')-1);
    
    %读取此视频文件
    load([fileLocation,'/',fileNames{i}]);
    numFrames=size(vedio,3); %帧数
    
    
     
    %开始提取某个文件视频文件的特征
    HOG=[];
    
    %检查特征值文件是否已经存在，如果存在此文件，直接略过
     if exist([targetLocation,'/',fileName,'.mat'],'file')>0
         continue
     end
    
    for j=1:3:numFrames  %可以设定一些间隔
        %提取特征的过程
        nowHOG=vl_hog(single(vedio(:,:,j)), 10) ;
        HOG=[HOG;reshape(nowHOG,numel(nowHOG)/31,31)];
    end
    
    %对提取完成的特征值保存至相应位置
    save([targetLocation,'/',fileName,'.mat'],'HOG');
    
end

end

