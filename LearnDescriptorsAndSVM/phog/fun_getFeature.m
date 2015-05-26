function [ allFeature ] = fun_getFeature( fileLocation,fileNames,center,vedioLocation,catagory )
%获取一组文件的所有特征值
%   Detailed explanation goes here
allFeature=[];
L=2;
for i=1:size(fileNames,2)
    feature=zeros(1,size(center,1));
    load([fileLocation,'/',fileNames{i}]);
    
    %将 除掉后缀名 的文件名提取出
    fileName=fileNames{i};
    fileName=fileName(1:findstr(fileName,'.')-1);
    %加载视频文件
    load([vedioLocation,'/',catagory,'/',fileName,'.mat']);
    for j=1:size(HOG,1)
        for k=1:size(HOG,2)
            disMat(:,k)=(center(:,k)-HOG(j,k) ).^2;
        end
        [~,minInd]=min(sum(disMat,2));
        feature(minInd)=feature(minInd)+1;
    end
    feature=feature./sum(feature,2);
    
    %时间分维处理
    if L>0 %如果需要分维
        for l=1:L
             %每个块的大小
            perBlockLength=floor(size(vedio,3)./pow2(l));
            for n=1:pow2(l)
                nowHOG=fun_HOG(vedio(:,:,(1+(n-1)*perBlockLength):(n*perBlockLength)));
                nowFeature=zeros(1,size(center,1));
                for j=1:size(nowHOG,1)
                    for k=1:size(nowHOG,2)
                        disMat(:,k)=(center(:,k)-nowHOG(j,k) ).^2;
                    end
                    [~,minInd]=min(sum(disMat,2));
                    nowFeature(minInd)=nowFeature(minInd)+1;
                end
                script_phog=[feature,nowFeature];
            end
        end
    end
    allFeature=[allFeature;feature];
end
end


