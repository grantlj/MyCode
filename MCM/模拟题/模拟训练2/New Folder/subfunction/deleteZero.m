function mat = deleteZero( mat )
%DELETEZERO Summary of this function goes here
%   Detailed explanation goes here
n=size(mat,1);
mat(mat==0)=[];
mat=reshape(mat,n,length(mat)/n);

end

