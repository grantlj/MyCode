function [ H ] = fun_interpUse( val )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[Xq Yq]=meshgrid(1:max(val(:,1)),1:max(val(:,2)));
H=griddata(val(:,1),val(:,2),val(:,3) ,Xq,Yq,'nearest' );
end

