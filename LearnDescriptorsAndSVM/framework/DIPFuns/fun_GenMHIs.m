function [ MHIFrames ] = fun_GenMHIs( frames )
%FUN_GENMHIS Summary of this function goes here
%   Detailed explanation goes here
numFrames=size(frames,3);
%MHI中的 涛 和 衰减参数
tau=uint8(250);decay=uint8(10);
numUselessFrame=15;

%如果出错，改变numUselessFrame的值
if numUselessFrame>=numFrames
    numUselessFrame=numFrames-1;
end

MHIFrames=uint8(zeros(size(frames)));



for i=2:numFrames
    %后一张和前一张作差值
    nowFrame=frames(:,:,i)-frames(:,:,i-1);
    isObj=nowFrame>35;
    nowFrame(isObj)=tau;
    nowFrame(~isObj)=0;
    
    nowMHI=nowFrame;
    previousMHI=MHIFrames(:,:,i-1);
    nowMHI(~isObj)=previousMHI(~isObj)-decay;
    MHIFrames(:,:,i)=nowMHI;
end

MHIFrames(:,:,1:numUselessFrame)=[];

end

