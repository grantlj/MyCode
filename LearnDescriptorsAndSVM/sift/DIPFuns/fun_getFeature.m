function [ allFeature ] = fun_getFeature( fileLocation,fileNames,center )
%��ȡһ���ļ�����������ֵ
%   Detailed explanation goes here
allFeature=[];

for i=1:size(fileNames,2)
    feature=zeros(1,size(center,1));
    load([fileLocation,'/',fileNames{i}]);
    SIFT=SIFT';
    for j=1:size(SIFT,1)
        for k=1:size(SIFT,2)
            disMat(:,k)=(center(:,k)-SIFT(j,k) ).^2;
        end
        [~,minInd]=min(sum(disMat,2));
        feature(minInd)=feature(minInd)+1;
    end
    feature=feature./sum(feature,2);
    allFeature=[allFeature;feature];
end

end

