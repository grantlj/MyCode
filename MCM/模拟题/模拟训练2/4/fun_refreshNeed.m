function [ needMat ] = fun_refreshNeed( NodeInfoMat,needMat,storeNum )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
val=NodeInfoMat(1,:);
many=val>storeNum*0.9;
few=val<storeNum*0.2;



end

