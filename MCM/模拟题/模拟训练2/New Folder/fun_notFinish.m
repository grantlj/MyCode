function bool = fun_notFinish( nodeInfoMat )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
bool=1;
if sum(nodeInfoMat(2,:)==0)==size(nodeInfoMat,2)
    bool=0;
end
end

