function [ HOG ] = fun_HOG( vedioMat )
%���һ����Ƶ3ά���������ȡ����
%   Detailed explanation goes here
HOG=[];
for i=1:3:size(vedioMat,3)
    nowHOG=vl_hog(single(vedioMat(:,:,i)), 10, 'verbose') ;
    HOG=[HOG;reshape(nowHOG,numel(nowHOG)/31,31)];
end
end

