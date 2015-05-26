function [ allFeature ] = fun_getFeature( fileLocation,fileNames,center )
%获取一组文件的所有特征值
%   Detailed explanation goes here
allFeature=[];

for i=1:size(fileNames,2)
    feature=zeros(1,size(center,1));
    load([fileLocation,'/',fileNames{i}]);
    for j=1:size(HOG,1)
        for k=1:size(HOG,2)
            disMat(:,k)=(center(:,k)-HOG(j,k) ).^2;
        end
        [~,minInd]=min(sum(disMat,2));
        feature(minInd)=feature(minInd)+1;
    end
    feature=feature./sum(feature,2);
    allFeature=[allFeature;feature];
end

end

